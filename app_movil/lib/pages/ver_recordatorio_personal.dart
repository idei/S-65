import 'package:flutter/material.dart';
import 'package:app_salud/pages/form_datos_generales.dart';
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

final _formKey = GlobalKey<FormState>();

var id_paciente;
var fecha_limite;
var rela_estado_recordatorio;
var descripcion;
var id_recordatorio;

class _VerRecordatorioState extends State<VerRecordatorioPersonal> {
  @override
  Widget build(BuildContext context) {
    Map parametros = ModalRoute.of(context).settings.arguments;
    id_recordatorio = parametros["id_recordatorio"];
    id_paciente = parametros["id_paciente"];
    rela_estado_recordatorio = parametros["estado_recordatorio"];
    descripcion = parametros["descripcion"];
    fecha_limite = parametros["fecha_limite"];

    return FutureBuilder(
        future: timer(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print(snapshot.connectionState);

          if (snapshot.hasData) {
            return Recordatorios(context);
          } else {
            return Scaffold(
              appBar: AppBar(
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
    return Scaffold(
        appBar: AppBar(
          title: Text('Recordatorio Personal',
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
              )),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: choiceAction,
              itemBuilder: (BuildContext context) {
                return Constants.choices.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            )
          ],
        ),
        body: Form(
            key: _formKey,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(children: <Widget>[
                  Text("$descripcion"),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Fecha: $fecha_limite "),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        //primary: Color.fromRGBO(157, 19, 34, 1),
                        ),
                    onPressed: () {
                      update_estado_recordartorio();
                      Navigator.of(context)
                          .pushReplacementNamed('/recordatorio');
                    },
                    child: Text('Hecho'),
                  ),
                ]))));
  }

  void choiceAction(String choice) {
    if (choice == Constants.Ajustes) {
      Navigator.pushNamed(context, '/ajustes');
    } else if (choice == Constants.Salir) {
      email_argument.remove();
      Navigator.pushNamed(context, '/');
    }
  }

  update_estado_recordartorio() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/update_recordatorio_personal.php";
    var response = await http.post(url, body: {
      "id_recordatorio": id_recordatorio.toString(),
    });

    print(response.body);
    var data = json.decode(response.body);
    print(data);
  }
}
