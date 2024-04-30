import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/avisos_model.dart';
import '../services/usuario_services.dart';
import 'env.dart';

class Avisos extends StatefulWidget {
  @override
  _AvisosState createState() => _AvisosState();
}

List<AvisosModel> avisos_items;
bool _isLoading = false;
var usuarioModel;
var id_paciente;

class _AvisosState extends State<Avisos> {
  http.Client _client; // Cliente HTTP para realizar las solicitudes

  @override
  void initState() {
    _client = http.Client(); // Inicializar el cliente HTTP
    super.initState();
  }

  @override
  void dispose() {
    _client.close(); // Cerrar el cliente HTTP cuando la página se destruye
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    usuarioModel = Provider.of<UsuarioServices>(context);
    id_paciente = usuarioModel.usuario.paciente.id_paciente;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(45, 175, 168, 1),
        leading: IconButton(
          icon: CircleAvatar(
            radius: MediaQuery.of(context).size.width / 30,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.arrow_back,
              color: Color.fromRGBO(45, 175, 168, 1),
            ),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/menu');
          },
        ),
        title: Text('Mis Avisos',
            style: TextStyle(
              fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
            )),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            read_avisos();
          });
        },
        child: FutureBuilder<List<AvisosModel>>(
            future: read_avisos(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: ListTile.divideTiles(
                    color: Colors.black,
                    tiles: snapshot.data
                        .map((data) => ListTile(
                              title: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        '/ver_aviso_general',
                                        arguments: {
                                          "id_aviso": data.id_aviso,
                                          "id_paciente": data.id_paciente,
                                          "descripcion": data.descripcion,
                                          "fecha_limite": fechaFormateada,
                                          "url_imagen": data.url_imagen,
                                          "rela_estado": data.estado_leido,
                                          "rela_creador": data.rela_creador,
                                          "rela_medico": data.rela_medico
                                        });
                                  },
                                  child: Aviso(data)),
                            ))
                        .toList(),
                  ).toList(),
                );
              } else {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ListTile(
                          title: Text(
                        'No tiene avisos',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontFamily: Theme.of(context)
                                .textTheme
                                .headline1
                                .fontFamily),
                      )),
                    ],
                  ));
                }
                return Center(
                  child: CircularProgressIndicator(
                    semanticsLabel: "Cargando",
                  ),
                );
              }
            }),
      ),
    );
  }

  String fechaFormateada;

  Widget Aviso(var data) {
    String fechaTexto = data.fecha_limite; // Formato "yyyy-MM-dd"
    DateFormat dateFormatEntrada = DateFormat("yyyy-MM-dd");
    DateTime fechaEntrada = dateFormatEntrada.parse(fechaTexto);

    DateFormat dateFormatSalida = DateFormat("dd-MM-yyyy");
    fechaFormateada = dateFormatSalida.format(fechaEntrada);

    return Card(
      child: ListTile(
        leading: Container(
          width: 90,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Text(
              fechaFormateada,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        // leading: Icon(
        //   Icons.calendar_today,
        //   color: Colors.blue,
        // ),
        title: Text(data.descripcion.toUpperCase(),
            maxLines: 2,
            style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily)),
        subtitle: Text(fechaFormateada,
            style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily)),
      ),
    );
  }

  var color;
  var font_bold;

  Widget CardDinamic(data) {
    if (data.rela_creador == 3) {
      if (data.estado_leido == 1) {
        color = Colors.grey[300];
        font_bold = FontWeight.normal;
      } else {
        font_bold = FontWeight.bold;
        color = Colors.grey[50];
      }

      return Card(
        color: color,
        child: ListTile(
          leading: Icon(
            Icons.insert_comment_sharp,
            color: Colors.yellow[700],
          ),
          title: Text(data.descripcion.toUpperCase(),
              maxLines: 2,
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
                fontWeight: font_bold,
              )),
          subtitle: Text(data.fecha_limite,
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
                fontWeight: font_bold,
              )),
        ),
      );
    } else {
      if (data.estado_leido == 1) {
        color = Colors.grey[300];
        font_bold = FontWeight.normal;
      } else {
        font_bold = FontWeight.bold;
        color = Colors.grey[50];
      }
      return Card(
        color: color,
        child: ListTile(
          leading: Icon(
            Icons.article_sharp,
            color: Colors.blue,
          ),
          title: Text(data.descripcion.toUpperCase(),
              maxLines: 2,
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
                fontWeight: font_bold,
              )),
          subtitle: Text(data.fecha_limite,
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
                fontWeight: font_bold,
              )),
        ),
      );
    }
  }

  Future<List<AvisosModel>> read_avisos() async {
    try {
      String URL_base = Env.URL_API;
      var url = URL_base + "/avisos_paciente";
      var response = await _client.post(url, body: {
        "id_paciente": id_paciente.toString(),
      });
      var responseDecode;

      if (response.statusCode == 200) {
        responseDecode = json.decode(response.body);

        if (responseDecode['status'] != 'Vacio') {
          final List<AvisosModel> avisos_items = [];

          for (var avisos in responseDecode['data']) {
            avisos_items.add(AvisosModel.fromJson(avisos));
          }

          return avisos_items;
        } else {
          _isLoading = true;
          return null;
        }
      } else {
        // Maneja casos donde el servidor devuelve un código de estado diferente de 200
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
}
