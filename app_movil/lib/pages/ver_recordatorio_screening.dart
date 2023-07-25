import 'package:app_salud/pages/list_medicos.dart';
import 'package:flutter/material.dart';
import 'package:app_salud/pages/form_datos_generales.dart';

import 'env.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

TextEditingController email = TextEditingController();
TextEditingController email_nuevo = TextEditingController();
TextEditingController password = TextEditingController();
TextEditingController password_nuevo = TextEditingController();
String email_set_shared;

class VerRecordatorio extends StatefulWidget {
  @override
  _VerRecordatorioState createState() => _VerRecordatorioState();
}

final _formKey_ver_recordatorio_screening = GlobalKey<FormState>();
var id_paciente;
var id_medico;
var rela_estado_recordatorio;
var tipo_screening;
var nombre_screening;
var id_recordatorio;
var recordatorioModel;
var descripcion;
var widget_boton;

class _VerRecordatorioState extends State<VerRecordatorio> {
  @override
  Widget build(BuildContext context) {
    Map parametros = ModalRoute.of(context).settings.arguments;
    id_recordatorio = parametros["id_recordatorio"];
    id_paciente = parametros["id_paciente"];
    rela_estado_recordatorio = parametros["estado_recordatorio"];
    tipo_screening = parametros["tipo_screening"];
    descripcion = parametros["descripcion"];

    getRecordatorioMedico(id_recordatorio);

    return FutureBuilder(
        future: timer(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Recordatorios(context);
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text('Recordatorio'),
                backgroundColor: Color.fromRGBO(45, 175, 168, 1),
              ),
              body: Center(
                child: CircularProgressIndicator(
                  semanticsLabel: "Cargando",
                ),
              ),
            );
          }
        });
  }

  timer() async {
    await new Future.delayed(new Duration(milliseconds: 500));
    return true;
  }

  Widget Recordatorios(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(45, 175, 168, 1),
          title: Text('Recordatorio'),
        ),
        body: Card(
          child: Form(
              key: _formKey_ver_recordatorio_screening,
              child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: ListView(children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                            backgroundColor: Color.fromRGBO(45, 175, 168, 1),
                            radius: MediaQuery.of(context).size.width / 9.3,
                            child: Icon(
                              Icons.event_note,
                              color: Colors.white,
                              size: 60.0,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("El Doctor/a $nombre_medico $apellido_medico" +
                        " le ha enviado el siguiente mensaje:"),
                    // Text("El Doctor/a $id_medico" +
                    //" le ha enviado el siguiente mensaje:"),
                    SizedBox(
                      height: 20,
                    ),
                    //Text("Screening $tipo_screening: "),
                    Text(
                      "Estimado paciente le envio para que complete el siguiente Screening de $nombre_screening ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(100, 50),
                              primary: Color.fromRGBO(45, 175, 168, 1)),
                          onPressed: () {
                            if (rela_estado_recordatorio != "3") {
                              if (tipo_screening == "SFMS") {
                                Navigator.of(context).pushReplacementNamed(
                                    '/screening_fisico',
                                    arguments: {
                                      "id_recordatorio": id_recordatorio,
                                      "id_paciente": id_paciente,
                                      "estado_recordatorio":
                                          rela_estado_recordatorio,
                                      "id_medico": id_medico,
                                      "tipo_screening": tipo_screening,
                                      "bandera": "recordatorio"
                                    });
                              }
                              if (tipo_screening == "CONDUC") {
                                Navigator.of(context).pushReplacementNamed(
                                    '/screening_conductual',
                                    arguments: {
                                      "id_recordatorio": id_recordatorio,
                                      "id_paciente": id_paciente,
                                      "estado_recordatorio":
                                          rela_estado_recordatorio,
                                      "id_medico": id_medico,
                                      "tipo_screening": tipo_screening,
                                      "bandera": "recordatorio"
                                    });
                              }
                              if (tipo_screening == "ANIMO") {
                                Navigator.of(context).pushReplacementNamed(
                                    '/screening_animo',
                                    arguments: {
                                      "id_recordatorio": id_recordatorio,
                                      "id_paciente": id_paciente,
                                      "estado_recordatorio":
                                          rela_estado_recordatorio,
                                      "id_medico": id_medico,
                                      "tipo_screening": tipo_screening,
                                      "bandera": "recordatorio"
                                    });
                              }
                              if (tipo_screening == "QCQ") {
                                Navigator.of(context).pushReplacementNamed(
                                    '/screening_queja_cognitiva',
                                    arguments: {
                                      "id_recordatorio": id_recordatorio,
                                      "id_paciente": id_paciente,
                                      "estado_recordatorio":
                                          rela_estado_recordatorio,
                                      "id_medico": id_medico,
                                      "tipo_screening": tipo_screening,
                                      "bandera": "recordatorio"
                                    });
                              }
                              if (tipo_screening == "CDR") {
                                Navigator.of(context).pushReplacementNamed(
                                    '/screening_cdr',
                                    arguments: {
                                      "id_recordatorio": id_recordatorio,
                                      "id_paciente": id_paciente,
                                      "estado_recordatorio":
                                          rela_estado_recordatorio,
                                      "id_medico": id_medico,
                                      "tipo_screening": tipo_screening,
                                      "bandera": "recordatorio"
                                    });
                              }
                              if (tipo_screening == "RNUTRI") {
                                Navigator.of(context).pushReplacementNamed(
                                    '/screening_nutricional',
                                    arguments: {
                                      "id_recordatorio": id_recordatorio,
                                      "id_paciente": id_paciente,
                                      "estado_recordatorio":
                                          rela_estado_recordatorio,
                                      "id_medico": id_medico,
                                      "tipo_screening": tipo_screening,
                                      "bandera": "recordatorio"
                                    });
                              }
                              if (tipo_screening == "DIAB") {
                                Navigator.of(context).pushReplacementNamed(
                                    '/screening_diabetes',
                                    arguments: {
                                      "id_recordatorio": id_recordatorio,
                                      "id_paciente": id_paciente,
                                      "estado_recordatorio":
                                          rela_estado_recordatorio,
                                      "id_medico": id_medico,
                                      "tipo_screening": tipo_screening,
                                      "bandera": "recordatorio"
                                    });
                              }
                              if (tipo_screening == "ENCRO") {
                                Navigator.of(context).pushReplacementNamed(
                                    '/screening_encro',
                                    arguments: {
                                      "id_recordatorio": id_recordatorio,
                                      "id_paciente": id_paciente,
                                      "estado_recordatorio":
                                          rela_estado_recordatorio,
                                      "id_medico": id_medico,
                                      "tipo_screening": tipo_screening,
                                      "bandera": "recordatorio"
                                    });
                              }
                            } else {
                              _alert_informe(context,
                                  "Este Screening ya fue respondido", 1);
                            }
                          },
                          child: Text('Ir a Screening'),
                        ),
                      ],
                    )
                    // : Container(
                    //     width: 50, // Ancho del contenedor
                    //     height: 40, // Alto del contenedor
                    //     decoration: BoxDecoration(
                    //       color:
                    //           Colors.green, // Color de fondo del contenedor
                    //       borderRadius: BorderRadius.circular(
                    //           10), // Borde redondeado del contenedor
                    //     ),
                    //     child: Center(
                    //       child: Text(
                    //         'Este Screening ya fue respondido',
                    //         style: TextStyle(
                    //           color: Colors.white, // Color del texto
                    //           fontSize: 20, // Tamaño del texto
                    //         ),
                    //       ),
                    //     ),
                    //   )
                  ]))),
        ));
  }

  _alert_informe(context, message, colorNumber) {
    var color;
    colorNumber == 1 ? color = Colors.green[800] : color = Colors.red[600];

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: color,
      content: Text(message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white)),
    ));
  }

  getRecordatorioMedico(var codigo_screening) async {
    String URL_base = Env.URL_API;
    var url = URL_base + "/read_recordatorio_medicos";
    var response = await http.post(url, body: {
      "id_recordatorio": id_recordatorio,
    });

    var jsonDate = json.decode(response.body);
    if (response.statusCode == 200) {
      if (jsonDate['status'] == 'Success') {
        id_medico = jsonDate['data']['id_medico'];
        nombre_medico = jsonDate['data']['nombre'];
        apellido_medico = jsonDate['data']['apellido'];
        nombre_screening = jsonDate['data']['nombre_screening'];
        tipo_screening = jsonDate['data']['codigo_screening'];
      } else {
        print(jsonDate['status']);
        id_medico = "";
      }
    }
  }

  void choiceAction(String choice) {
    if (choice == Constants.Ajustes) {
      Navigator.pushNamed(context, '/ajustes');
    } else if (choice == Constants.Salir) {
      email_argument.remove();
      Navigator.pushNamed(context, '/');
    }
  }
}
