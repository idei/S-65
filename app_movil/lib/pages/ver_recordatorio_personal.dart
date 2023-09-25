import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_salud/pages/env.dart';

TextEditingController email = TextEditingController();
TextEditingController email_nuevo = TextEditingController();
TextEditingController password = TextEditingController();
TextEditingController password_nuevo = TextEditingController();
String email_set_shared;

class VerRecordatorioPersonal extends StatefulWidget {
  @override
  _VerRecordatorioState createState() => _VerRecordatorioState();
}

final _formKey_ver_recordatorio = GlobalKey<FormState>();

var id_paciente;
var fecha_limite;
var rela_estado_recordatorio;
var descripcion;
var id_recordatorio;
var estado_text;
var estado_recordatorio;

class _VerRecordatorioState extends State<VerRecordatorioPersonal> {
  @override
  Widget build(BuildContext context) {
    Map parametros = ModalRoute.of(context).settings.arguments;
    id_recordatorio = parametros["id_recordatorio"];
    id_paciente = parametros["id_paciente"];
    rela_estado_recordatorio = parametros["estado_recordatorio"];
    descripcion = parametros["descripcion"];
    fecha_limite = parametros["fecha_limite"];
    estado_recordatorio = parametros["estado"];

    return FutureBuilder(
        future: timer(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Recordatorios(context);
          } else {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Color.fromRGBO(45, 175, 168, 1),
                title: Text('Recordatorio Personal',
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                    )),
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

    String formatter = now.year.toString() + "-" + mes + "-" + dia;
    print(formatter);
    DateTime fecha_limite1 = DateTime.parse(formatter);
    DateTime fecha_limite2 = DateTime.parse(fecha_limite);

    final difference = fecha_limite2.difference(fecha_limite1).inDays;
    print(difference);

    if (difference < 0) {
      estado_text = "Vencido";
    } else if (difference == 1) {
      estado_text = "Próximo a vencer";
    } else if (difference > 1) {
      estado_text = "Vigente";
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(45, 175, 168, 1),
        title: Text('Recordatorio Personal',
            style: TextStyle(
              fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
            )),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity, // Ancho igual al ancho de la pantalla
            child: Card(
              shadowColor: Color.fromRGBO(45, 175, 168, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.all(15),
              elevation: 10,
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("$descripcion"),
                        SizedBox(
                          height: 20,
                        ),
                        Text("Fecha: $fecha_limite "),
                        SizedBox(
                          height: 20,
                        ),
                        Text("Estado : $estado_text "),
                      ])),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          // Center(
          //   child: ElevatedButton(
          //     style: ElevatedButton.styleFrom(
          //       primary: Color.fromRGBO(45, 175, 168, 1),
          //       padding: EdgeInsets.all(10),
          //     ),
          //     onPressed: () {
          //       update_estado_recordartorio();
          //       Navigator.of(context).pushReplacementNamed('/recordatorio');
          //     },
          //     child: Text(
          //       'Hecho',
          //       style: TextStyle(
          //         fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  update_estado_recordartorio() async {
    String URL_base = Env.URL_API;
    var url = URL_base + "/update_recordatorio_personal";
    var response = await http.post(url, body: {
      "id_recordatorio": id_recordatorio.toString(),
    });

    print(response.body);
    var data = json.decode(response.body);
    print(data);
  }
}
