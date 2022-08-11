import 'package:flutter/material.dart';
import 'package:app_salud/pages/form_datos_generales.dart';
import 'package:app_salud/pages/screening_fisico.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_salud/pages/env.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

TextEditingController email = TextEditingController();
TextEditingController email_nuevo = TextEditingController();
TextEditingController password = TextEditingController();
TextEditingController password_nuevo = TextEditingController();
String email_set_shared;

class VerAvisoGeneral extends StatefulWidget {
  @override
  _VerAvisoGeneralState createState() => _VerAvisoGeneralState();
}

var fecha_limite;
var descripcion;
var id_aviso;
var url_imagen;
var estado_aviso;
var rela_creador;
var rela_medico;
var nombre_medico;
var apellido_medico;
var especialidad;
var matricula;
var id_pacientes;

class _VerAvisoGeneralState extends State<VerAvisoGeneral> {
  @override
  Widget build(BuildContext context) {
    Map parametros = ModalRoute.of(context).settings.arguments;
    id_aviso = parametros["id_aviso"];
    url_imagen = parametros["url_imagen"];
    estado_aviso = parametros["rela_estado"];

    descripcion = parametros["descripcion"];
    fecha_limite = parametros["fecha_limite"];
    rela_creador = parametros["rela_creador"];
    rela_medico = parametros["rela_medico"];

    return FutureBuilder(
        future: timer(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print(snapshot.connectionState);

          if (snapshot.hasData) {
            if (rela_creador == 3) {
              return AvisoMedicoAsignado(context);
            } else {
              return Avisos(context);
            }
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text('Aviso General',
                    style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily)),
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

  bool estado_visible_aviso;
  timer() async {
    await new Future.delayed(new Duration(milliseconds: 500));
    await getStringValuesSF();

    if (rela_creador == 3) {
      await read_medico();

      if (estado_aviso == 1) {
        estado_visible_aviso = false;
      } else {
        estado_visible_aviso = true;
      }
    }

    return true;
  }

  read_medico() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/read_medico.php";
    var response = await http.post(url, body: {
      "rela_paciente": id_paciente.toString(),
    });

    print(response.body);
    var data = json.decode(response.body);
    print(data['nombre']);
    if (data.length == 0) {
      print("No hay datos");
    } else {
      nombre_medico = data["nombre"];
      apellido_medico = data["apellido"];
      especialidad = data["especialidad"];
      matricula = data["matricula"];
      print(data);
    }
  }

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id_paciente = prefs.getInt("id_paciente");
  }

  Widget Avisos(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, '/avisos');
            },
          ),
          //backgroundColor: Color.fromRGBO(157, 19, 34, 1),

          title: Text('Avisos Generales',
              style: TextStyle(
                  fontFamily:
                      Theme.of(context).textTheme.headline1.fontFamily)),
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
            ),
          ],
        ),
        body: Form(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(children: <Widget>[
                  Text("$descripcion".toUpperCase(),
                      style: TextStyle(fontFamily: 'NunitoR')),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Fecha: $fecha_limite ",
                      style: TextStyle(fontFamily: 'NunitoR')),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    child: Text('Leído',
                        style: TextStyle(
                            fontFamily: Theme.of(context)
                                .textTheme
                                .headline1
                                .fontFamily)),
                    style: ElevatedButton.styleFrom(
                        //primary: Color.fromRGBO(157, 19, 34, 1),
                        ),
                    onPressed: () {
                      update_estado_recordartorio();
                      Navigator.of(context).pushReplacementNamed('/avisos');
                    },
                  ),
                ]))));
  }

  Widget AvisoMedicoAsignado(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, '/avisos');
            },
          ),
          //backgroundColor: Color.fromRGBO(157, 19, 34, 1),
          //backgroundColor: Color.fromRGBO(157, 19, 34, 1),
          title: Text('Avisos Generales',
              style: TextStyle(
                  fontFamily:
                      Theme.of(context).textTheme.headline1.fontFamily)),
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
            ),
          ],
        ),
        body: Form(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(children: <Widget>[
                  Text("$descripcion".toUpperCase(),
                      style: TextStyle(fontFamily: 'NunitoR')),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Fecha: $fecha_limite ",
                      style: TextStyle(fontFamily: 'NunitoR')),
                  SizedBox(
                    height: 20,
                  ),
                  MyStatelessWidget(),
                  SizedBox(
                    height: 30,
                  ),
                  Visibility(
                      visible: estado_visible_aviso,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                //primary: Color.fromRGBO(157, 19, 34, 1),
                                ),
                            onPressed: () {
                              update_estado_aviso(id_aviso, context);
                              //generate_vinculation();
                            },
                            child: Text('Acepto',
                                style: TextStyle(
                                    fontFamily: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .fontFamily)),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                //primary: Color.fromRGBO(157, 19, 34, 1),
                                ),
                            onPressed: () {
                              update_estado_aviso(id_aviso, context);
                              _alert_clinicos(
                                  context,
                                  "Gracias",
                                  "Pronto se le notificará de un nuevo médico",
                                  2);
                            },
                            child: Text('No Acepto',
                                style: TextStyle(
                                    fontFamily: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .fontFamily)),
                          ),
                        ],
                      )),
                ]))));
  }

  void choiceAction(String choice) {
    if (choice == Constants.Ajustes) {
      Navigator.pushNamed(context, '/ajustes');
    } else if (choice == Constants.Salir) {
      email_argument.remove();
      Navigator.pushNamed(context, '/avisos');
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

class MyStatelessWidget extends StatelessWidget {
  //const MyStatelessWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.person),
              title: Text("$nombre_medico $apellido_medico",
                  style: TextStyle(fontFamily: 'NunitoR')),
              subtitle: Text(
                  'Matricula: $matricula \n Especialidad: $especialidad',
                  style: TextStyle(fontFamily: 'NunitoR')),
            ),
          ],
        ),
      ),
    );
  }
}

_alert_clinicos(context, title, descripcion, number) async {
  Alert(
    context: context,
    title: title,
    desc: descripcion,
    alertAnimation: FadeAlertAnimation,
    buttons: [
      DialogButton(
        child: Text(
          "Entendido",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () {
          if (number == 1) {
            //update_estado_aviso();
            Navigator.of(context).pushReplacementNamed('/avisos');
          } else {
            Navigator.of(context).pushReplacementNamed('/avisos');
          }
        },
        width: 120,
      )
    ],
  ).show();
}

update_estado_aviso(var id_aviso, BuildContext context) async {
  await generate_vinculation(context);

  String URL_base = Env.URL_PREFIX;
  var url = URL_base + "/update_estado_aviso.php";
  var response = await http.post(url, body: {
    "id_aviso": id_aviso.toString(),
    "id_paciente": id_paciente.toString(),
  });

  print(response.body);
  var data = json.decode(response.body);
  print(data);
}

var data_vinculation;

generate_vinculation(BuildContext context) async {
  String URL_base = Env.URL_PREFIX;
  var url = URL_base + "/generate_vinculation.php";
  var response = await http.post(url, body: {
    "rela_medico": rela_medico.toString(),
    "id_paciente": id_paciente.toString(),
  });

  print(response.body);
  data_vinculation = json.decode(response.body);
  print(data_vinculation);

  if (data_vinculation['estado'] == "Success") {
    _alert_clinicos(
      context,
      "Gracias",
      "Pronto se estara comunicando con usted el médico",
      1,
    );
  }
}

Widget FadeAlertAnimation(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  return Align(
    child: FadeTransition(
      opacity: animation,
      child: child,
    ),
  );
}
