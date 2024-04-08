import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:intl/intl.dart';
import 'env.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

TextEditingController email = TextEditingController();
TextEditingController email_nuevo = TextEditingController();
TextEditingController password = TextEditingController();
TextEditingController password_nuevo = TextEditingController();
var id_paciente;
var id_medico;
var nombre_medico;
var apellido_medico;
var rela_estado_recordatorio;
var tipo_screening;
var nombre_screening;
var id_recordatorio;
var recordatorioModel;
var descripcion;
var widget_boton;
final isTablet = Device.get().isTablet;
var radiusAvatar;
var fecha_limite;
var fechaFormateada;

class VerRecordatorio extends StatefulWidget {
  @override
  _VerRecordatorioState createState() => _VerRecordatorioState();
}

class _VerRecordatorioState extends State<VerRecordatorio> {
  @override
  Widget build(BuildContext context) {
    Map parametros = ModalRoute.of(context).settings.arguments;
    id_recordatorio = parametros["id_recordatorio"];
    id_paciente = parametros["id_paciente"];
    rela_estado_recordatorio = parametros["estado_recordatorio"];
    tipo_screening = parametros["tipo_screening"];
    descripcion = parametros["descripcion"];
    fecha_limite = parametros["fecha_limite"];

    DateFormat dateFormatEntrada = DateFormat("yyyy-MM-dd");
    DateTime fechaEntrada = dateFormatEntrada.parse(fecha_limite);

    DateFormat dateFormatSalida = DateFormat("dd-MM-yyyy");
    fechaFormateada = dateFormatSalida.format(fechaEntrada);

    if (isTablet) {
      radiusAvatar = 15.3;
    } else {
      radiusAvatar = 10.3;
    }

    return FutureBuilder(
        future: getRecordatorioMedico(id_recordatorio),
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
          child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: ListView(children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                        backgroundColor: Color.fromRGBO(45, 175, 168, 1),
                        radius:
                            MediaQuery.of(context).size.width / radiusAvatar,
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
                  "Estimado paciente le envio para que complete el siguiente Chequeo de $nombre_screening ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Fecha Límite: $fechaFormateada ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                if (rela_estado_recordatorio != "3")
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(100, 50),
                            primary: Color.fromRGBO(45, 175, 168, 1)),
                        onPressed: () {
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
                        },
                        child: Text('Ir a Chequeo'),
                      ),
                    ],
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(100, 50), primary: Colors.red),
                        onPressed: () {},
                        child: Text(
                          "Este Screening ya lo realizaste",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Cambia este color a rojo
                            // Otros estilos de texto como fontSize, fontWeight, etc., si es necesario.
                          ),
                        ),
                      ),
                    ],
                  ),
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
              ])),
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
      "id_recordatorio": id_recordatorio.toString(),
    });

    var jsonDate = json.decode(response.body);
    if (response.statusCode == 200) {
      if (jsonDate['status'] == 'Success') {
        id_medico = jsonDate['data']['id_medico'];
        nombre_medico = jsonDate['data']['nombre'];
        apellido_medico = jsonDate['data']['apellido'];
        nombre_screening = jsonDate['data']['nombre_screening'];
        tipo_screening = jsonDate['data']['codigo_screening'];
        return true;
      } else {
        print(jsonDate['status']);
        id_medico = "";

        return id_medico;
      }
    }
  }
}
