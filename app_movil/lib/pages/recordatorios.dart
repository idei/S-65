import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/recordatorio_model.dart';
import '../services/usuario_services.dart';
import 'env.dart';

class RecordatorioPage extends StatefulWidget {
  @override
  _RecordatorioState createState() => _RecordatorioState();
}

List<RecordatoriosModel> recordatorios_items;
bool _isLoading = false;
var email_argument;
var usuarioModel;
var id_paciente;

class _RecordatorioState extends State<RecordatorioPage> {
  var data_error;
  @override
  Widget build(BuildContext context) {
    usuarioModel = Provider.of<UsuarioServices>(context);
    email_argument = usuarioModel.usuario.emailUser;
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
        title: Text('Mis Recordatorios',
            style: TextStyle(
              fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
            )),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Aquí puedes realizar la lógica de actualización de datos, como volver a cargar los recordatorios desde la base de datos o la API.
          // Luego, llama a setState() para reconstruir la UI con los nuevos datos.
          setState(() {
            read_recordatorios();
            // Tu lógica de actualización de datos aquí
          });
        },
        child: FutureBuilder<List<RecordatoriosModel>>(
            future: read_recordatorios(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: ListTile.divideTiles(
                    color: Colors.black,
                    tiles: snapshot.data
                        .map((data) => ListTile(
                              title: GestureDetector(
                                  onTap: () {
                                    if (data.estado_recordatorio == "4") {
                                      Navigator.of(context).pushNamed(
                                          '/ver_recordatorio_personal',
                                          arguments: {
                                            "id_recordatorio":
                                                data.id_recordatorio,
                                            "id_paciente": data.id_paciente,
                                            "descripcion": data.descripcion,
                                            "fecha_limite": data.fecha_limite,
                                            "estado_recordatorio":
                                                data.estado_recordatorio,
                                            "estado": estado,
                                          });
                                    } else {
                                      Navigator.of(context).pushNamed(
                                          '/ver_recordatorio_screening',
                                          arguments: {
                                            "id_recordatorio":
                                                data.id_recordatorio,
                                            "id_paciente": data.id_paciente,
                                            "descripcion": data.descripcion,
                                            "fecha_limite": data.fecha_limite,
                                            "estado_recordatorio":
                                                data.estado_recordatorio,
                                          });
                                    }
                                  },
                                  child: CardDinamic(data)),
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
                        'No tiene recordatorios',
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
            }
            //}
            ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(45, 175, 168, 1),
        onPressed: () {},
        child: IconButton(
          icon: Icon(Icons.add, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, '/new_recordatorio_personal');
          },
        ),
      ),
    );
  }

  var color;
  var font_bold;
  var estado;
  String fechaFormateada;

  Widget CardDinamic(data) {
    final now = DateTime.now();
    var dia;
    var mes;

    if (now.day < 10) {
      dia = '0' + now.day.toString();
    } else {
      dia = now.day.toString();
    }

    if (now.month < 10) {
      mes = '0' + now.month.toString();
    } else {
      mes = now.month.toString();
    }

    DateFormat dateFormatActual = DateFormat("yyyy-MM-dd");

    String fechaTexto = now.year.toString() + "-" + mes + "-" + dia;
    DateTime fecha_actual = dateFormatActual.parse(fechaTexto);

    String fechabasedatos = data.fecha_limite; // Formato "yyyy-MM-dd"
    DateFormat dateFormatEntrada = DateFormat("yyyy-MM-dd");
    DateTime fechaEntrada = dateFormatEntrada.parse(fechabasedatos);

    final difference = fechaEntrada.difference(fecha_actual).inDays;
    print(difference);

    DateFormat dateFormatSalida = DateFormat("dd-MM-yyyy");
    fechaFormateada = dateFormatSalida.format(fechaEntrada);

    if (difference < 0) {
      color = Colors.red;
      font_bold = FontWeight.bold;
    } else if (difference == 1) {
      color = Colors.yellow;
      font_bold = FontWeight.bold;
    } else if (difference > 1) {
      color = Colors.green;
      font_bold = FontWeight.bold;
    }

    return Card(
      child: ListTile(
        leading: Container(
          width: 90,
          height: 30,
          decoration: BoxDecoration(
            color: color,
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
        title: Text(data.descripcion.toUpperCase(),
            maxLines: 4,
            style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily)),
        subtitle: Text(fechaFormateada,
            style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily)),
      ),
    );
  }

  Future<List<RecordatoriosModel>> read_recordatorios() async {
    var responseDecode;
    String URL_base = Env.URL_API;
    var url = URL_base + "/recordatorios";
    var response = await http.post(url, body: {
      "id_paciente": id_paciente.toString(),
    });
    responseDecode = json.decode(response.body);

    if (response.statusCode == 200 && responseDecode['status'] != "Vacio") {
      final List<RecordatoriosModel> recordatorios_item = [];

      for (var recordatorio in responseDecode['data']) {
        recordatorios_item.add(RecordatoriosModel.fromJson(recordatorio));
      }

      return recordatorios_item;
    } else {
      _isLoading = true;
      return null;
    }
  }
}
