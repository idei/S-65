import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'env.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ScreeningCDR extends StatefulWidget {
  @override
  _ScreeningCDRState createState() => _ScreeningCDRState();
}

final _formKey = GlobalKey<_ScreeningCDRState>();
var id_paciente;
var id_medico;
var tipo_screening;
var id_recordatorio;
var email;
var screening_recordatorio;

class _ScreeningCDRState extends State<ScreeningCDR> {
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
    WidgetsBinding.instance.addPostFrameCallback((_) => _alert_clinicos(
        context,
        "Cuestionario CDR",
        "El CDR es un cuestionario que idealmente debe completaro junto a una persona cercana (usualmente el cónyuge, hijo/a o un cuidador primario) para confirmar las habilidades cognitivas, es decir cómo esta funcionando por ejemplo su memoria y orientación en la vida cotidiana, además de algunos posibles cambios sociales, conductuales y funcionales. "));
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
                "select_screening": "CDR",
              });
            },
          ),
          //backgroundColor: Color.fromRGBO(157, 19, 34, 1),
          title: Text('Actividades de la vida diaria - CDR',
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
                                    'Memoria',
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
                                Memoria(),
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
                                    'Orientación',
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
                                Orientacion(),
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
                                    'Vida Social',
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
                                VidaSocial(),
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
                                    'Hogar y Aficiones',
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
                                Hogar(),
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
                                    'Cuidado Personal',
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
                                CuidadoPersonal(),
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
                            //primary: Color.fromRGBO(157, 19, 34, 1),
                            ),
                        onPressed: () {
                          guardar_datos(context);
                        },
                        child: Text('GUARDAR'),
                      ),
                      ElevatedButton(
                        //onPressed: validateAnswers,
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
  if (memoria == null) {
    loginToast("Debe responder si los item de atención");
  } else {
    if (orientacion == null) {
      loginToast("Debe responder si los item de atención");
    } else {
      if (juicio_res_problema == null) {
        loginToast("Debe responder si los item de atención");
      } else {
        if (vida_social == null) {
          loginToast("Debe responder si los item de atención");
        } else {
          if (hogar == null) {
            loginToast("Debe responder si los item de Orientación");
          } else {
            if (cuid_personal == null) {
              loginToast("Debe responder si los item de Orientación");
            } else {
              String URL_base = Env.URL_PREFIX;
              var url = URL_base + "/respuesta_screening_cdr.php";
              var response = await http.post(url, body: {
                "id_paciente": id_paciente.toString(),
                "id_medico": id_medico.toString(),
                "id_recordatorio": id_recordatorio.toString(),
                "tipo_screening": tipo_screening.toString(),
                "memoria": memoria,
                "orientacion": orientacion,
                "juicio_res_problema": juicio_res_problema,
                "vida_social": vida_social,
                "hogar": hogar,
                "cuid_personal": cuid_personal,
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
                    "select_screening": "CDR",
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

//----------------------------------------MEMORIA------------------------------------------------------------------------------------------
var memoria = null;
var orientacion = null;
var juicio_res_problema = null;
var vida_social = null;
var hogar = null;
var cuid_personal = null;

class Memoria extends StatefulWidget {
  @override
  MemoriaWidgetState createState() => MemoriaWidgetState();
}

class MemoriaWidgetState extends State<Memoria> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_cdr.php";
    var response = await http.post(url, body: {
      "estado": "M",
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
      height: 420,
      // width: 350,
      child: ListView(
        key: list_view_alcohol,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: data
            .map((list) => RadioListTile(
                  groupValue: memoria,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      memoria = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class Orientacion extends StatefulWidget {
  @override
  OrientacionWidgetState createState() => OrientacionWidgetState();
}

class OrientacionWidgetState extends State<Orientacion> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_cdr.php";
    var response = await http.post(url, body: {
      "estado": "O",
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
      height: 270,
      // width: 350,
      child: ListView(
        key: list_view_alcohol,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: data
            .map((list) => RadioListTile(
                  groupValue: orientacion,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      orientacion = val;
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
              "select_screening": "CDR",
            });
          }
        },
        width: 120,
      )
    ],
  ).show();
}

class JuicioResoProblema extends StatefulWidget {
  @override
  JuicioResoProblemaWidgetState createState() =>
      JuicioResoProblemaWidgetState();
}

class JuicioResoProblemaWidgetState extends State<JuicioResoProblema> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_cdr.php";
    var response = await http.post(url, body: {
      "estado": "Q",
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
      height: 330,
      // width: 350,
      child: ListView(
        key: list_view_alcohol,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: data
            .map((list) => RadioListTile(
                  groupValue: juicio_res_problema,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      juicio_res_problema = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class VidaSocial extends StatefulWidget {
  @override
  VidaSocialWidgetState createState() => VidaSocialWidgetState();
}

class VidaSocialWidgetState extends State<VidaSocial> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_cdr.php";
    var response = await http.post(url, body: {
      "estado": "V",
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
      height: 380,
      // width: 350,
      child: ListView(
        key: list_view_alcohol,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: data
            .map((list) => RadioListTile(
                  groupValue: vida_social,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      vida_social = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class Hogar extends StatefulWidget {
  @override
  HogarWidgetState createState() => HogarWidgetState();
}

class HogarWidgetState extends State<Hogar> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_cdr.php";
    var response = await http.post(url, body: {
      "estado": "H",
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
      height: 340,
      // width: 350,
      child: ListView(
        key: list_view_alcohol,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: data
            .map((list) => RadioListTile(
                  groupValue: hogar,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      hogar = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class CuidadoPersonal extends StatefulWidget {
  @override
  CuidadoPersonalWidgetState createState() => CuidadoPersonalWidgetState();
}

class CuidadoPersonalWidgetState extends State<CuidadoPersonal> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_cdr.php";
    var response = await http.post(url, body: {
      "estado": "CP",
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
      height: 270,
      // width: 350,
      child: ListView(
        key: list_view_alcohol,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: data
            .map((list) => RadioListTile(
                  groupValue: cuid_personal,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      cuid_personal = val;
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
