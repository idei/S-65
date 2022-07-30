import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'env.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ScreeningDiabetes extends StatefulWidget {
  @override
  _ScreeningDiabetesState createState() => _ScreeningDiabetesState();
}

final _formKey = GlobalKey<_ScreeningDiabetesState>();
var id_paciente;
var id_medico;
var tipo_screening;
var id_recordatorio;
var email;
var screening_recordatorio;

class _ScreeningDiabetesState extends State<ScreeningDiabetes> {
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
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => _alert_clinicos(context, "Chequeo de Diabetes", " Descripcion"));
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
                "select_screening": "DIAB",
              });
            },
          ),
          //backgroundColor: Color.fromRGBO(157, 19, 34, 1),
          title: Text('Diabetes',
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
                          color: Colors.blue[50],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          margin: EdgeInsets.all(10),
                          elevation: 10,
                          child: ClipRRect(
                            // Los bordes del contenido del card se cortan usando BorderRadius
                            borderRadius: BorderRadius.circular(15),

                            // EL widget hijo que será recortado segun la propiedad anterior
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Padding(
                                  padding: new EdgeInsets.all(8.0),
                                ),
                                Container(
                                  width: 320,
                                  child: Text(
                                    '¿Considera que durante este ultimo año aumento de peso?',
                                    textAlign: TextAlign.center,
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                                new Divider(height: 5.0, color: Colors.black),
                                new Padding(
                                  padding: new EdgeInsets.all(8.0),
                                ),
                                AumentoPeso(),
                                SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                          )),
                      Card(
                          color: Colors.blue[50],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          margin: EdgeInsets.all(10),
                          elevation: 10,
                          child: ClipRRect(
                            // Los bordes del contenido del card se cortan usando BorderRadius
                            borderRadius: BorderRadius.circular(15),

                            // EL widget hijo que será recortado segun la propiedad anterior
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Padding(
                                  padding: new EdgeInsets.all(8.0),
                                ),
                                Container(
                                  width: 320,
                                  child: Text(
                                    '¿Le han encontrado alguna vez valores de glucosa (azúcar) altos?',
                                    textAlign: TextAlign.center,
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                                new Divider(height: 5.0, color: Colors.black),
                                new Padding(
                                  padding: new EdgeInsets.all(8.0),
                                ),
                                Glucosa(),
                                SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                          )),
                      Card(
                          color: Colors.blue[50],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          margin: EdgeInsets.all(10),
                          elevation: 10,
                          child: ClipRRect(
                            // Los bordes del contenido del card se cortan usando BorderRadius
                            borderRadius: BorderRadius.circular(15),

                            // EL widget hijo que será recortado segun la propiedad anterior
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Padding(
                                  padding: new EdgeInsets.all(8.0),
                                ),
                                Container(
                                  width: 320,
                                  child: Text(
                                    '¿Algunos de sus familiares allegados u otros parientes han sido diagnosticados con diabetes?',
                                    textAlign: TextAlign.center,
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                                new Divider(height: 5.0, color: Colors.black),
                                new Padding(
                                  padding: new EdgeInsets.all(8.0),
                                ),
                                FamiliarDiabetes(),
                                SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                          )),
                      new Padding(
                        padding: new EdgeInsets.all(8.0),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            // primary: Color.fromRGBO(157, 19, 34, 1),
                            ),
                        onPressed: () {
                          guardar_datos(context);
                        },
                        child: Text('GUARDAR'),
                      ),
                      ElevatedButton(
                        // onPressed: validateAnswers,
                        child: new Text(
                          'GUARDAR',
                          style: new TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal,
                              color: Colors.white),
                        ),
                        //color: Theme.of(context).accentColor,
                      ),
                      new Padding(
                        padding: EdgeInsets.all(4.0),
                      ),
                    ]))));
  }

  void choiceAction(String choice) {
    if (choice == Constants.Ajustes) {
      Navigator.pushNamed(context, '/ajustes');
    } else if (choice == Constants.Salir) {
      Navigator.pushNamed(context, '/');
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

var data;

guardar_datos(BuildContext context) async {
  if (peso == null) {
    loginToast("Debe responder si aumento de peso");
  } else {
    if (glucosa == null) {
      loginToast(
          "Debe responder si le han encontrado alguna vez valores de glucosa (azúcar) altos");
    } else {
      if (fam_diabetes == null) {
        loginToast(
            "Debe responder si algunos de sus familiares allegados u otros parientes han sido diagnosticados con diabetes");
      } else {
        String URL_base = Env.URL_PREFIX;
        var url = URL_base + "/respuesta_screening_diabetes.php";
        var response = await http.post(url, body: {
          "id_paciente": id_paciente.toString(),
          "id_medico": id_medico.toString(),
          "id_recordatorio": id_recordatorio.toString(),
          "tipo_screening": tipo_screening.toString(),
          "peso": peso,
          "glucosa": glucosa,
          "fam_diabetes": fam_diabetes,
        });
        print(response.body);
        data = json.decode(response.body);
        print(data);

        if (data == "alert") {
          _alert_informe(
            context,
            "Para tener en cuenta",
            "Sería bueno que consulte con su médico clínico o neurologo sobre lo informado con respecto a su funcionamiento en la vida cotidiana. Es posible que el especialista le solicite una evaluación cognitiva para explorar màs en detalle su funcionamiento cognitivo y posible impacto sobre su rutina.",
          );
        } else {
          if (screening_recordatorio == true) {
            Navigator.pushNamed(context, '/recordatorio');
          } else {
            Navigator.pushNamed(context, '/screening', arguments: {
              "select_screening": "DIAB",
            });
          }
        }
      }
    }
  }
}

//----------------------------------------AUMENTO PESO------------------------------------------------------------------------------------------
var peso = null;
var glucosa = null;
var fam_diabetes = null;

class AumentoPeso extends StatefulWidget {
  @override
  AumentoPesoWidgetState createState() => AumentoPesoWidgetState();
}

class AumentoPesoWidgetState extends State<AumentoPeso> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_diabetes.php";
    var response = await http.post(url, body: {
      "estado": "AP",
    });
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
      height: 120,
      // width: 350,
      child: ListView(
        key: list_view_alcohol,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: data
            .map((list) => RadioListTile(
                  groupValue: peso,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      peso = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class Glucosa extends StatefulWidget {
  @override
  GlucosaWidgetState createState() => GlucosaWidgetState();
}

class GlucosaWidgetState extends State<Glucosa> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_diabetes.php";
    var response = await http.post(url, body: {
      "estado": "G",
    });
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
      height: 120,
      // width: 350,
      child: ListView(
        key: list_view_alcohol,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: data
            .map((list) => RadioListTile(
                  groupValue: glucosa,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      glucosa = val;
                    });
                  },
                ))
            .toList(),
      ),
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

_alert_informe(context, title, descripcion) {
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
          if (screening_recordatorio == true) {
            Navigator.pushNamed(context, '/recordatorio');
          } else {
            Navigator.pushNamed(context, '/screening', arguments: {
              "select_screening": "DIAB",
            });
          }
        },
        width: 120,
      )
    ],
  ).show();
}

class FamiliarDiabetes extends StatefulWidget {
  @override
  FamiliarDiabetesWidgetState createState() => FamiliarDiabetesWidgetState();
}

class FamiliarDiabetesWidgetState extends State<FamiliarDiabetes> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_diabetes.php";
    var response = await http.post(url, body: {
      "estado": "FD",
    });
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
      height: 220,
      // width: 350,
      child: ListView(
        key: list_view_alcohol,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: data
            .map((list) => RadioListTile(
                  groupValue: fam_diabetes,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      fam_diabetes = val;
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
