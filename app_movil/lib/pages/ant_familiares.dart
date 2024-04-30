import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../models/antecedentes_familiares_model.dart';
import '../services/usuario_services.dart';
import 'env.dart';

class AntecedentesFamiliarPage extends StatefulWidget {
  @override
  _AntecedentesFamiliarState createState() => _AntecedentesFamiliarState();
}

String id_paciente;
var usuarioModel;

class _AntecedentesFamiliarState extends State<AntecedentesFamiliarPage> {
  bool _isLoading = false;
  List<AntecedenteFamiliaresModel> listAntecFamiliares = [];
  final isTablet = Device.get().isTablet;
  http.Client _client; // Cliente HTTP para realizar las solicitudes

  @override
  void initState() {
    _client = http.Client(); // Inicializar el cliente HTTP
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    usuarioModel = Provider.of<UsuarioServices>(context);

    id_paciente = usuarioModel.usuario.paciente.id_paciente.toString();

    final size = MediaQuery.of(context).size;
    var sizeCircle;

    if (isTablet) {
      sizeCircle = MediaQuery.of(context).size.width / 13.3;
    } else {
      sizeCircle = MediaQuery.of(context).size.width / 9.3;
    }

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: CircleAvatar(
              radius: MediaQuery.of(context).size.width / 30,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.arrow_back,
                color: Colors.blue,
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/menu');
            },
          ),
          title: Text(
            'Mis Antecedentes Familiares',
            style: TextStyle(
              fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child: FutureBuilder<List<AntecedenteFamiliaresModel>>(
            future: fetchAntecedentesFamiliares(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    semanticsLabel: "Cargando",
                  ),
                );
              } else if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    children: ListTile.divideTiles(
                      color: Colors.black26,
                      tiles: snapshot.data
                          .map((data) => ListTile(
                                title: GestureDetector(
                                  onTap: () {},
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.circle,
                                      color: Colors.blue,
                                      size: 8.0,
                                    ),
                                    title: Text(data.antecedenteDescripcion,
                                        style: TextStyle(
                                            fontFamily: Theme.of(context)
                                                .textTheme
                                                .headline1
                                                .fontFamily)),
                                  ),
                                ),
                              ))
                          .toList(),
                    ).toList(),
                  ),
                );
              } else {
                return Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListTile(
                        title: Text(
                      'No tiene antecedentes familiares',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontFamily:
                              Theme.of(context).textTheme.headline1.fontFamily),
                    )),
                  ],
                ));
              }
            },
          ),
        ),
      ),
      floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/form_antecedentes_familiares',
                    arguments: {});
              },
              child: CircleAvatar(
                radius: sizeCircle,
                child: Center(
                  child: Column(children: <Widget>[
                    SizedBox(height: 20.0),
                    Icon(Icons.edit, color: Colors.white, size: 30.0),
                    SizedBox(height: 6.0),
                    Text(
                      'Editar',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily,
                      ),
                    )
                  ]),
                ),
              ),
            )
          ]),
    );
  }

  Future<List<AntecedenteFamiliaresModel>> fetchAntecedentesFamiliares() async {
    try {
      String URL_base = Env.URL_API;
      var url = URL_base + "/antecedentes_paciente";
      var responseDecode;

      var response = await _client.post(
        url,
        body: {"id_paciente": id_paciente, "tipo_antecedente": "2"},
      );

      if (response.statusCode == 200) {
        responseDecode = jsonDecode(response.body);

        if (responseDecode['status'] != "Vacio") {
          final List<AntecedenteFamiliaresModel> listAntecFamiliares = [];

          for (var antecedentes in responseDecode['data']) {
            listAntecFamiliares
                .add(AntecedenteFamiliaresModel.fromJson(antecedentes));
          }

          return listAntecFamiliares;
        } else {
          _isLoading = true;
          return null;
        }
      } else {
        // Manejar casos donde el servidor devuelve un código de estado diferente de 200
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      // Manejar cualquier excepción que pueda ocurrir durante la llamada a la API
      print('Error: $e');
      return [];
    }
  }

  @override
  void dispose() {
    _client.close(); // Cerrar el cliente HTTP cuando la página se destruye
    super.dispose();
  }
}

// class _isLoadingIcon extends StatelessWidget {
//   const _isLoadingIcon({
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(10),
//       height: 60,
//       width: 60,
//       decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
//       child: const CircularProgressIndicator(color: Colors.blue),
//     );
//   }
// }
