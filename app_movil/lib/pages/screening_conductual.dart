import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_salud/pages/env.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rflutter_alert/rflutter_alert.dart';

class ScreeningConductualPage extends StatefulWidget {
  @override
  _ScreeningConductualState createState() => _ScreeningConductualState();
}

final _formKey = GlobalKey<_ScreeningConductualState>();

TextEditingController otro = TextEditingController();

var id_paciente;
var id_medico;
var tipo_screening;
var id_recordatorio;
var observaciones;
var email;
var screening_recordatorio;

class _ScreeningConductualState extends State<ScreeningConductualPage> {
  double _animatedHeight = 0.0;

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email_prefer = prefs.getString("email_prefer");
    email = email_prefer;
    id_paciente = prefs.getInt("id_paciente");
    print(email);

    Map parametros = ModalRoute.of(context).settings.arguments;

    get_tiposcreening(parametros["tipo_screening"]);

    if (parametros["bandera"] == "recordatorio") {
      screening_recordatorio = true;
      id_recordatorio = parametros["id_recordatorio"];
      id_paciente = id_paciente;
      id_medico = parametros["id_medico"];
      tipo_screening = parametros["tipo_screening"];
    } else {
      if (parametros["bandera"] == "screening_nuevo") {
        screening_recordatorio = false;
        id_paciente = id_paciente;
        id_recordatorio = null;
        id_medico = null;
        //tipo_screening = parametros["tipo_screening"];
      }
    }
  }

  get_tiposcreening(var codigo_screening) async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/read_tipo_screening.php";
    var response = await http.post(url, body: {
      "codigo_screening": codigo_screening,
    });
    print(response);
    var jsonDate = json.decode(response.body);
    print(jsonDate);
    tipo_screening = jsonDate;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        _alert_clinicos(context, "Cuestionario NPI", " npiiiiiiiiiiiiii"));
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    getStringValuesSF();

    return Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, '/screening', arguments: {
                "select_screening": "CONDUC",
              });
            },
          ),
          //backgroundColor: Color.fromRGBO(157, 19, 34, 1),
          title: Text('Chequeo de Conducta',
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
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: new Container(
                padding: EdgeInsets.all(8.0),
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          margin: EdgeInsets.all(15),
                          elevation: 10,
                          child: ClipRRect(
                            // Los bordes del contenido del card se cortan usando BorderRadius
                            borderRadius: BorderRadius.circular(15),

                            // EL widget hijo que será recortado segun la propiedad anterior
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                      '  ¿Qué parentesco tiene con (nombre del usuario)?  ',
                                      style: new TextStyle(
                                          fontSize: 18.0,
                                          fontFamily: 'NunitoR')),
                                ),

                                Conductual1(),

                                // Usamos Container para el contenedor de la descripción
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: TextFormField(
                                    style: TextStyle(fontFamily: 'NunitoR'),
                                    controller: otro,
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                        labelText: "Si es otro, especifique"),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      new Divider(height: 5.0, color: Colors.black),
                      new Padding(
                        padding: new EdgeInsets.all(8.0),
                      ),
                      Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          margin: EdgeInsets.all(15),
                          elevation: 10,
                          child: ClipRRect(
                            // Los bordes del contenido del card se cortan usando BorderRadius
                            borderRadius: BorderRadius.circular(15),

                            // EL widget hijo que será recortado segun la propiedad anterior
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    '¿Tiene el paciente creencias falsas, como creer que otras personas le están robando o que planean hacerle daño de alguna manera?',
                                    style: new TextStyle(
                                      fontFamily: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .fontFamily,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                //espacio entre el texto y el radio button
                                SizedBox(
                                  height: 30,
                                ),
                                Conductual2(),
                              ],
                            ),
                          )),
                      Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          margin: EdgeInsets.all(15),
                          elevation: 10,
                          child: ClipRRect(
                            // Los bordes del contenido del card se cortan usando BorderRadius
                            borderRadius: BorderRadius.circular(15),

                            // EL widget hijo que será recortado segun la propiedad anterior
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    '¿Tiene el paciente alucinaciones como visiones falsas o voces? ¿Actúa el paciente como si oyera o viera cosas que no están presentes?',
                                    style: new TextStyle(
                                      fontFamily: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .fontFamily,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Conductual3(),
                              ],
                            ),
                          )),
                      new Divider(height: 5.0, color: Colors.black),
                      new Padding(
                        padding: new EdgeInsets.all(8.0),
                      ),
                      Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          margin: EdgeInsets.all(15),
                          elevation: 10,
                          child: ClipRRect(
                            // Los bordes del contenido del card se cortan usando BorderRadius
                            borderRadius: BorderRadius.circular(15),

                            // EL widget hijo que será recortado segun la propiedad anterior
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    '¿Se resiste el paciente a la ayuda de otros o es difícil de manejar?',
                                    style: new TextStyle(
                                      fontFamily: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .fontFamily,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Conductual4(),
                                SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                          )),
                      new Divider(height: 5.0, color: Colors.black),
                      new Padding(
                        padding: new EdgeInsets.all(8.0),
                      ),
                      Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          margin: EdgeInsets.all(15),
                          elevation: 10,
                          child: ClipRRect(
                            // Los bordes del contenido del card se cortan usando BorderRadius
                            borderRadius: BorderRadius.circular(15),

                            // EL widget hijo que será recortado segun la propiedad anterior
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    '¿Actúa el paciente como si estuviera triste o dice que está deprimido?',
                                    style: new TextStyle(
                                      fontFamily: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .fontFamily,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Conductual5(),
                              ],
                            ),
                          )),
                      new Divider(height: 5.0, color: Colors.black),
                      new Padding(
                        padding: new EdgeInsets.all(8.0),
                      ),
                      Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          margin: EdgeInsets.all(15),
                          elevation: 10,
                          child: ClipRRect(
                            // Los bordes del contenido del card se cortan usando BorderRadius
                            borderRadius: BorderRadius.circular(15),

                            // EL widget hijo que será recortado segun la propiedad anterior
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    '¿Actúa el paciente como si estuviera triste o dice que está deprimido?',
                                    style: new TextStyle(
                                      fontFamily: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .fontFamily,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Conductual6(),
                              ],
                            ),
                          )),
                      new Divider(height: 5.0, color: Colors.black),
                      new Padding(
                        padding: new EdgeInsets.all(8.0),
                      ),
                      Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          margin: EdgeInsets.all(15),
                          elevation: 10,
                          child: ClipRRect(
                            // Los bordes del contenido del card se cortan usando BorderRadius
                            borderRadius: BorderRadius.circular(15),

                            // EL widget hijo que será recortado segun la propiedad anterior
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    '¿Parece que el paciente se siente demasiado bien o actúa excesivamente alegre?',
                                    style: new TextStyle(
                                      fontFamily: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .fontFamily,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Conductual7(),
                              ],
                            ),
                          )),
                      new Divider(
                        height: 5.0,
                        color: Colors.black,
                      ),
                      new Padding(
                        padding: new EdgeInsets.all(8.0),
                      ),
                      Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          margin: EdgeInsets.all(15),
                          elevation: 10,
                          child: ClipRRect(
                            // Los bordes del contenido del card se cortan usando BorderRadius
                            borderRadius: BorderRadius.circular(15),

                            // EL widget hijo que será recortado segun la propiedad anterior
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    '¿Parece el paciente menos interesado en sus actividades habituales o en las actividades y planes de los demás?',
                                    style: new TextStyle(
                                      fontFamily: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .fontFamily,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Conductual8(),
                              ],
                            ),
                          )),
                      new Divider(
                        height: 5.0,
                        color: Colors.black,
                      ),
                      new Padding(
                        padding: new EdgeInsets.all(8.0),
                      ),
                      Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          margin: EdgeInsets.all(15),
                          elevation: 10,
                          child: ClipRRect(
                            // Los bordes del contenido del card se cortan usando BorderRadius
                            borderRadius: BorderRadius.circular(15),

                            // EL widget hijo que será recortado segun la propiedad anterior
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    '¿Parece que el paciente actúa impulsivamente? Por ejemplo, habla el paciente con extraños como si los conociera o dice cosas que podrían herir los sentimientos de los demás?',
                                    style: new TextStyle(
                                      fontFamily: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .fontFamily,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Conductual9(),
                              ],
                            ),
                          )),
                      new Divider(
                        height: 5.0,
                        color: Colors.black,
                      ),
                      new Padding(
                        padding: new EdgeInsets.all(8.0),
                      ),
                      Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          margin: EdgeInsets.all(15),
                          elevation: 10,
                          child: ClipRRect(
                            // Los bordes del contenido del card se cortan usando BorderRadius
                            borderRadius: BorderRadius.circular(15),

                            // EL widget hijo que será recortado segun la propiedad anterior
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    '¿Se muestra el paciente irritable o impaciente? ¿Tiene dificultad para lidiar con retrasos o para esperar actividades planeadas?',
                                    style: new TextStyle(
                                      fontFamily: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .fontFamily,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Conductual10(),
                              ],
                            ),
                          )),
                      new Divider(
                        height: 5.0,
                        color: Colors.black,
                      ),
                      new Padding(
                        padding: new EdgeInsets.all(8.0),
                      ),
                      Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          margin: EdgeInsets.all(15),
                          elevation: 10,
                          child: ClipRRect(
                            // Los bordes del contenido del card se cortan usando BorderRadius
                            borderRadius: BorderRadius.circular(15),

                            // EL widget hijo que será recortado segun la propiedad anterior
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    '¿Lleva a cabo el paciente actividades repetitivas, como dar vueltas por la casa, jugar con botones, enrollar hilos o hacer otras cosas repetitivamente?',
                                    style: new TextStyle(
                                      fontFamily: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .fontFamily,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Conductual11(),
                              ],
                            ),
                          )),
                      new Divider(
                        height: 5.0,
                        color: Colors.black,
                      ),
                      new Padding(
                        padding: new EdgeInsets.all(8.0),
                      ),
                      Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          margin: EdgeInsets.all(15),
                          elevation: 10,
                          child: ClipRRect(
                            // Los bordes del contenido del card se cortan usando BorderRadius
                            borderRadius: BorderRadius.circular(15),

                            // EL widget hijo que será recortado segun la propiedad anterior
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    '¿Le despierta el paciente durante la noche, se levanta muy temprano por la mañana o toma siestas excesivas durante el día?',
                                    style: new TextStyle(
                                      fontFamily: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .fontFamily,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Conductual12(),
                              ],
                            ),
                          )),
                      new Divider(
                        height: 5.0,
                        color: Colors.black,
                      ),
                      new Padding(
                        padding: new EdgeInsets.all(8.0),
                      ),
                      Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          margin: EdgeInsets.all(15),
                          elevation: 10,
                          child: ClipRRect(
                            // Los bordes del contenido del card se cortan usando BorderRadius
                            borderRadius: BorderRadius.circular(15),

                            // EL widget hijo que será recortado segun la propiedad anterior
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    '¿El paciente ha perdido o aumentado de peso o ha tenido algún cambio en la comida que le gusta?',
                                    style: new TextStyle(
                                      fontFamily: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .fontFamily,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Conductual13(),
                              ],
                            ),
                          )),
                      new Divider(
                        height: 5.0,
                        color: Colors.black,
                      ),
                      new Padding(
                        padding: new EdgeInsets.all(8.0),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            //primary: Color.fromRGBO(157, 19, 34, 1),
                            ),
                        onPressed: () {
                          guardar_datos(context);
                        },
                        child: Text('GUARDAR'),
                      ),
                      new RaisedButton(
                        //onPressed: validateAnswers,
                        child: new Text(
                          'GUARDAR',
                          style: new TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal,
                              color: Colors.white),
                        ),
                        color: Theme.of(context).accentColor,
                      ),
                      new Padding(
                        padding: EdgeInsets.all(4.0),
                      ),
                    ]))));
  }

  Widget checkbox1() {
    return new Column(children: <Widget>[
      new Row(children: <Widget>[
        new Radio(
          value: 0,
        ),
        new Text(
          'Si, leve.',
          style: new TextStyle(fontSize: 16.0),
        ),
      ]),
      new Row(children: <Widget>[
        new Radio(
          value: 0,
        ),
        new Text(
          'Si, moderado.',
          style: new TextStyle(fontSize: 16.0),
        ),
      ]),
      new Row(children: <Widget>[
        new Radio(
          value: 0,
        ),
        new Text(
          'Si, severo.',
          style: new TextStyle(fontSize: 16.0),
        ),
      ]),
      new Row(children: <Widget>[
        new Radio(
          value: 0,
        ),
        new Text(
          'No',
          style: new TextStyle(fontSize: 16.0),
        ),
      ]),
      new Row(children: <Widget>[
        new Radio(
          value: 0,
        ),
        new Text(
          'No sabe',
          style: new TextStyle(fontSize: 16.0),
        ),
      ]),
    ]);
  }

  void choiceAction(String choice) {
    if (choice == Constants.Ajustes) {
      Navigator.pushNamed(context, '/ajustes');
    } else if (choice == Constants.Salir) {
      Navigator.pushNamed(context, '/');
    }
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

_alert_clinicos(context, title, descripcion) {
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
        onPressed: () => Navigator.pop(context),
        width: 120,
      )
    ],
  ).show();
}

_alert_informe(context, title, descripcion) async {
  Alert(
    context: context,
    title: title,
    desc: descripcion,
    alertAnimation: FadeAlertAnimation,
    buttons: [
      DialogButton(
        child: Text(
          "Entendido",
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        onPressed: () {
          if (screening_recordatorio == true) {
            Navigator.pushNamed(context, '/recordatorio');
          } else {
            Navigator.pushNamed(context, '/screening', arguments: {
              "select_screening": "CONDUC",
            });
          }
        },
        width: 120,
      )
    ],
  ).show();
}

guardar_datos(BuildContext context) async {
  if (id_conductual1 == null) {
    loginToast("Debe responder todas las preguntas");
  } else {
    if (id_conductual2 == null) {
      loginToast("Debe responder todas las preguntas");
    } else {
      if (id_conductual3 == null) {
        loginToast("Debe responder todas las preguntas");
      } else {
        if (id_conductual4 == null) {
          loginToast("Debe responder todas las preguntas");
        } else {
          if (id_conductual5 == null) {
            loginToast("Debe responder todas las preguntas");
          } else {
            if (id_conductual6 == null) {
              loginToast("Debe responder todas las preguntas");
            } else {
              if (id_conductual7 == null) {
                loginToast("Debe responder todas las preguntas");
              } else {
                if (id_conductual8 == null) {
                  loginToast("Debe responder todas las preguntas");
                } else {
                  if (id_conductual9 == null) {
                    loginToast("Debe responder todas las preguntas");
                  } else {
                    if (id_conductual10 == null) {
                      loginToast("Debe responder todas las preguntas");
                    } else {
                      if (id_conductual11 == null) {
                        loginToast("Debe responder todas las preguntas");
                      } else {
                        if (id_conductual12 == null) {
                          loginToast("Debe responder todas las preguntas");
                        } else {
                          String URL_base = Env.URL_PREFIX;
                          var url =
                              URL_base + "/respuesta_screening_conductual.php";
                          var response = await http.post(url, body: {
                            "id_paciente": id_paciente.toString(),
                            "id_medico": id_medico.toString(),
                            "id_recordatorio": id_recordatorio.toString(),
                            "tipo_screening": tipo_screening.toString(),
                            "id_conductual1": id_conductual1,
                            "observaciones": otro.text,
                            "id_conductual2": id_conductual2,
                            "id_conductual3": id_conductual3,
                            "id_conductual4": id_conductual4,
                            "id_conductual5": id_conductual5,
                            "id_conductual6": id_conductual6,
                            "id_conductual7": id_conductual7,
                            "id_conductual8": id_conductual8,
                            "id_conductual9": id_conductual9,
                            "id_conductual10": id_conductual10,
                            "id_conductual11": id_conductual11,
                            "id_conductual12": id_conductual12,
                            "id_conductual13": id_conductual13,
                          });
                          print(response.body);
                          var data = json.decode(response.body);
                          print(data);

                          if (data == "alert") {
                            _alert_informe(
                              context,
                              "Para tener en cuenta",
                              "Sería bueno que consulte con su médico clínico o neurologo sobre lo informado con respecto a su funcionamiento en la vida cotidiana. Es posible que el especialista le solicite una evaluación cognitiva para explorar màs en detalle su funcionamiento cognitivo y posible impacto sobre su rutina.",
                            );
                          } else {
                            if (data == "Success") {
                              if (screening_recordatorio == true) {
                                Navigator.pushNamed(context, '/recordatorio');
                              } else {
                                Navigator.pushNamed(context, '/screening',
                                    arguments: {
                                      "select_screening": "CONDUC",
                                    });
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

loginToast(String toast) {
  return Fluttertoast.showToast(
      msg: toast,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white);
}

//----------------------------------------Conductual ------------------------------------------------------------------------------------------
var id_conductual1 = null;
var id_conductual2 = null;
var id_conductual3 = null;
var id_conductual4 = null;

class Conductual1 extends StatefulWidget {
  @override
  Conductual1WidgetState createState() => Conductual1WidgetState();
}

class Conductual1WidgetState extends State<Conductual1> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_conductual.php";
    var response = await http.post(url, body: {"otro": "otro"});
    print(response);
    var jsonBody = response.body;
    var jsonDate = json.decode(jsonBody);
    setState(() {
      data = jsonDate;
    });
    print(jsonDate);
  }

  @override
  void initState() {
    getAllRespuesta();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      // width: 350,
      child: ListView(
        key: list_view_alcohol,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: data
            .map((list) => RadioListTile(
                  groupValue: id_conductual1,
                  title: Text(
                    list['respuesta'],
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                    ),
                  ),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_conductual1 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class Conductual2 extends StatefulWidget {
  @override
  Conductual2WidgetState createState() => Conductual2WidgetState();
}

class Conductual2WidgetState extends State<Conductual2> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_conductual.php";
    var response = await http.post(url, body: {});
    print(response);
    var jsonBody = response.body;
    var jsonDate = json.decode(jsonBody);
    setState(() {
      data = jsonDate;
    });
    print(jsonDate);
  }

  @override
  void initState() {
    getAllRespuesta();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      // width: 350,
      child: ListView(
        key: list_view_alcohol,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: data
            .map((list) => RadioListTile(
                  groupValue: id_conductual2,
                  title: Text(
                    list['respuesta'],
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                    ),
                  ),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_conductual2 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class Conductual3 extends StatefulWidget {
  @override
  Conductual3WidgetState createState() => Conductual3WidgetState();
}

class Conductual3WidgetState extends State<Conductual3> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_conductual.php";
    var response = await http.post(url, body: {});
    print(response);
    var jsonBody = response.body;
    var jsonDate = json.decode(jsonBody);
    setState(() {
      data = jsonDate;
    });
    print(jsonDate);
  }

  @override
  void initState() {
    getAllRespuesta();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      // width: 350,
      child: ListView(
        key: list_view_alcohol,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: data
            .map((list) => RadioListTile(
                  groupValue: id_conductual3,
                  title: Text(
                    list['respuesta'],
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                    ),
                  ),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_conductual3 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class Conductual4 extends StatefulWidget {
  @override
  Conductual4WidgetState createState() => Conductual4WidgetState();
}

class Conductual4WidgetState extends State<Conductual4> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_conductual.php";
    var response = await http.post(url, body: {});
    print(response);
    var jsonBody = response.body;
    var jsonDate = json.decode(jsonBody);
    setState(() {
      data = jsonDate;
    });
    print(jsonDate);
  }

  @override
  void initState() {
    getAllRespuesta();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      // width: 350,
      child: ListView(
        key: list_view_alcohol,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: data
            .map((list) => RadioListTile(
                  groupValue: id_conductual4,
                  title: Text(
                    list['respuesta'],
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                    ),
                  ),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_conductual4 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//--------------------------------------------------------------------------------------------
////----------------------------------------CONDUCTUAL ------------------------------------------------------------------------------------------
var id_conductual5 = null;
var id_conductual6 = null;
var id_conductual7 = null;
var id_conductual8 = null;

class Conductual5 extends StatefulWidget {
  @override
  Conductual5WidgetState createState() => Conductual5WidgetState();
}

class Conductual5WidgetState extends State<Conductual5> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_conductual.php";
    var response = await http.post(url, body: {});
    print(response);
    var jsonBody = response.body;
    var jsonDate = json.decode(jsonBody);
    setState(() {
      data = jsonDate;
    });
    print(jsonDate);
  }

  @override
  void initState() {
    getAllRespuesta();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      // width: 350,
      child: ListView(
        key: list_view_alcohol,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: data
            .map((list) => RadioListTile(
                  groupValue: id_conductual5,
                  title: Text(
                    list['respuesta'],
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                    ),
                  ),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_conductual5 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class Conductual6 extends StatefulWidget {
  @override
  Conductual6WidgetState createState() => Conductual6WidgetState();
}

class Conductual6WidgetState extends State<Conductual6> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_conductual.php";
    var response = await http.post(url, body: {});
    print(response);
    var jsonBody = response.body;
    var jsonDate = json.decode(jsonBody);
    setState(() {
      data = jsonDate;
    });
    print(jsonDate);
  }

  @override
  void initState() {
    getAllRespuesta();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      // width: 350,
      child: ListView(
        key: list_view_alcohol,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: data
            .map((list) => RadioListTile(
                  groupValue: id_conductual6,
                  title: Text(
                    list['respuesta'],
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                    ),
                  ),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_conductual6 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class Conductual7 extends StatefulWidget {
  @override
  Conductual7WidgetState createState() => Conductual7WidgetState();
}

class Conductual7WidgetState extends State<Conductual7> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_conductual.php";
    var response = await http.post(url, body: {});
    print(response);
    var jsonBody = response.body;
    var jsonDate = json.decode(jsonBody);
    setState(() {
      data = jsonDate;
    });
    print(jsonDate);
  }

  @override
  void initState() {
    getAllRespuesta();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      // width: 350,
      child: ListView(
        key: list_view_alcohol,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: data
            .map((list) => RadioListTile(
                  groupValue: id_conductual7,
                  title: Text(
                    list['respuesta'],
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                    ),
                  ),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_conductual7 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class Conductual8 extends StatefulWidget {
  @override
  Conductual8WidgetState createState() => Conductual8WidgetState();
}

class Conductual8WidgetState extends State<Conductual8> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_conductual.php";
    var response = await http.post(url, body: {});
    print(response);
    var jsonBody = response.body;
    var jsonDate = json.decode(jsonBody);
    setState(() {
      data = jsonDate;
    });
    print(jsonDate);
  }

  @override
  void initState() {
    getAllRespuesta();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      // width: 350,
      child: ListView(
        key: list_view_alcohol,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: data
            .map((list) => RadioListTile(
                  groupValue: id_conductual8,
                  title: Text(
                    list['respuesta'],
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                    ),
                  ),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_conductual8 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//-----------------------------------------------------------------------------
//
////----------------------------------------ATENCION 1------------------------------------------------------------------------------------------
var id_conductual9 = null;
var id_conductual10 = null;
var id_conductual11 = null;
var id_conductual12 = null;
var id_conductual13 = null;

class Conductual9 extends StatefulWidget {
  @override
  Conductual9WidgetState createState() => Conductual9WidgetState();
}

class Conductual9WidgetState extends State<Conductual9> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_conductual.php";
    var response = await http.post(url, body: {});
    print(response);
    var jsonBody = response.body;
    var jsonDate = json.decode(jsonBody);
    setState(() {
      data = jsonDate;
    });
    print(jsonDate);
  }

  @override
  void initState() {
    getAllRespuesta();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      // width: 350,
      child: ListView(
        key: list_view_alcohol,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: data
            .map((list) => RadioListTile(
                  groupValue: id_conductual9,
                  title: Text(
                    list['respuesta'],
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                    ),
                  ),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_conductual9 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class Conductual10 extends StatefulWidget {
  @override
  Conductual10WidgetState createState() => Conductual10WidgetState();
}

class Conductual10WidgetState extends State<Conductual10> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_conductual.php";
    var response = await http.post(url, body: {});
    print(response);
    var jsonBody = response.body;
    var jsonDate = json.decode(jsonBody);
    setState(() {
      data = jsonDate;
    });
    print(jsonDate);
  }

  @override
  void initState() {
    getAllRespuesta();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      // width: 350,
      child: ListView(
        key: list_view_alcohol,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: data
            .map((list) => RadioListTile(
                  groupValue: id_conductual10,
                  title: Text(
                    list['respuesta'],
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                    ),
                  ),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_conductual10 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class Conductual11 extends StatefulWidget {
  @override
  Conductual11WidgetState createState() => Conductual11WidgetState();
}

class Conductual11WidgetState extends State<Conductual11> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_conductual.php";
    var response = await http.post(url, body: {});
    print(response);
    var jsonBody = response.body;
    var jsonDate = json.decode(jsonBody);
    setState(() {
      data = jsonDate;
    });
    print(jsonDate);
  }

  @override
  void initState() {
    getAllRespuesta();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      // width: 350,
      child: ListView(
        key: list_view_alcohol,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: data
            .map((list) => RadioListTile(
                  groupValue: id_conductual11,
                  title: Text(
                    list['respuesta'],
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                    ),
                  ),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_conductual11 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class Conductual12 extends StatefulWidget {
  @override
  Conductual12WidgetState createState() => Conductual12WidgetState();
}

class Conductual12WidgetState extends State<Conductual12> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_conductual.php";
    var response = await http.post(url, body: {});
    print(response);
    var jsonBody = response.body;
    var jsonDate = json.decode(jsonBody);
    setState(() {
      data = jsonDate;
    });
    print(jsonDate);
  }

  @override
  void initState() {
    getAllRespuesta();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      // width: 350,
      child: ListView(
        key: list_view_alcohol,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: data
            .map((list) => RadioListTile(
                  groupValue: id_conductual12,
                  title: Text(
                    list['respuesta'],
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                    ),
                  ),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_conductual12 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class Conductual13 extends StatefulWidget {
  @override
  Conductual13WidgetState createState() => Conductual13WidgetState();
}

class Conductual13WidgetState extends State<Conductual13> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_conductual.php";
    var response = await http.post(url, body: {});
    print(response);
    var jsonBody = response.body;
    var jsonDate = json.decode(jsonBody);
    setState(() {
      data = jsonDate;
    });
    print(jsonDate);
  }

  @override
  void initState() {
    getAllRespuesta();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      // width: 350,
      child: ListView(
        key: list_view_alcohol,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: data
            .map((list) => RadioListTile(
                  groupValue: id_conductual13,
                  title: Text(
                    list['respuesta'],
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                    ),
                  ),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_conductual13 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class Constants {
  static const String Ajustes = 'Ajustes';
  static const String Salir = 'Salir';
  static const List<String> choices = <String>[
    Ajustes,
    Salir,
  ];
}
