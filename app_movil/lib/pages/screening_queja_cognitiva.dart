import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_salud/pages/env.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ScreeningBPage extends StatefulWidget {
  @override
  _ScreeningBState createState() => _ScreeningBState();
}

final _formKey = GlobalKey<_ScreeningBState>();
var id_paciente;
var id_medico;
var tipo_screening;
var id_recordatorio;

var email;
var screening_recordatorio;

class _ScreeningBState extends State<ScreeningBPage> {
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
        "Cuestionario de Quejas Cognitivas",
        "Este cuestionario explora sobre posibles y actuales quejas cognitivas, por ejemplo que ultimamente hay a notado que se olvida más que antes o que está mnás disperso. Deberà elegir la opción que describa la frecuencia en que dicha queja aparece en su rutina."));
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    getStringValuesSF();

    return FutureBuilder(
        future: read_recordatorios(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print(snapshot.connectionState);

          if (snapshot.hasData) {
            return ScreeningQCQ();
          } else {
            return Scaffold(
              appBar: AppBar(
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pushNamed(context, '/screening', arguments: {
                      "select_screening": "QCQ",
                    });
                  },
                ),
                //backgroundColor: Color.fromRGBO(157, 19, 34, 1),
                title: Text('Cuestionario de Quejas Cognitivas - QCQ',
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
              "select_screening": "QCQ",
            });
          }
        },
        width: 120,
      )
    ],
  ).show();
}

read_recordatorios() async {
  await new Future.delayed(new Duration(milliseconds: 500));
  return true;
}

//----------------------------------------Screening de Quejas Cognitivas ------------------------------------------

class ScreeningQCQ extends StatefulWidget {
  ScreeningQCQ({Key key}) : super(key: key);

  @override
  ScreeningQCQWidgetState createState() => ScreeningQCQWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class ScreeningQCQWidgetState extends State<ScreeningQCQ> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //backgroundColor: Color.fromRGBO(157, 19, 34, 1),
          title: Text('Cuestionario de Quejas Cognitivas - QCQ',
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
                                Text(
                                  'Atención',
                                  style: new TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                new Divider(height: 5.0, color: Colors.black),
                                new Padding(
                                  padding: new EdgeInsets.all(8.0),
                                ),
                                Container(
                                  width: 320,
                                  child: Text(
                                    'Se distrae con facilidad, por ejemplo cuando lee, mira una película o conversa con alguien:',
                                    textAlign: TextAlign.justify,
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Atencion1(),
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
                                new Divider(height: 5.0, color: Colors.black),
                                new Padding(
                                  padding: new EdgeInsets.all(8.0),
                                ),
                                Container(
                                  width: 320,
                                  child: Text(
                                    'Necesita prestar más atención que antes o hacer más esfuerzos que otros para realizar las tareas.',
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Atencion2(),
                                SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                          )),

                      //-------------------------------------------------------AAAAAAAAAAAAAAAACAAAAAAAAAAAAAAAAAAAAAAAAAA

                      Card(
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
                                new Divider(height: 5.0, color: Colors.black),
                                new Padding(
                                  padding: new EdgeInsets.all(8.0),
                                ),
                                Container(
                                  width: 320,
                                  child: Text(
                                    'Pierde el hilo del pensamiento, por ejemplo cuando está conversando con alguien cambia de tema en tema.',
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Atencion3(),
                                SizedBox(
                                  height: 30,
                                ),
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
                                new Divider(height: 5.0, color: Colors.black),
                                new Padding(
                                  padding: new EdgeInsets.all(8.0),
                                ),
                                Container(
                                  width: 320,
                                  child: Text(
                                    'Le resulta difícil hacer más de una cosa a la vez.',
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Atencion4(),
                                SizedBox(
                                  height: 30,
                                ),
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
                      new Text(
                        'Orientación',
                        style: new TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),

                      new Padding(
                        padding: new EdgeInsets.all(8.0),
                      ),

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
                                new Divider(height: 5.0, color: Colors.black),
                                new Padding(
                                  padding: new EdgeInsets.all(8.0),
                                ),
                                Container(
                                  width: 320,
                                  child: Text(
                                    'Tiene problemas para orientarse en lugares conocidos (por ejemplo, su barrio).',
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Orientacion1(),
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
                                new Divider(height: 5.0, color: Colors.black),
                                new Padding(
                                  padding: new EdgeInsets.all(8.0),
                                ),
                                Container(
                                  width: 320,
                                  child: Text(
                                    'Tiene problemas para encontrar alguna habitación dentro de su propia casa o institución que frecuenta (por ejemplo, baño).',
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Orientacion2(),
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
                                new Divider(height: 5.0, color: Colors.black),
                                new Padding(
                                  padding: new EdgeInsets.all(8.0),
                                ),
                                Container(
                                  width: 320,
                                  child: Text(
                                    'Se equivoca o no está seguro de la fecha (día, mes y año).',
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Orientacion3(),
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
                                new Divider(height: 5.0, color: Colors.black),
                                new Padding(
                                  padding: new EdgeInsets.all(8.0),
                                ),
                                Container(
                                  width: 320,
                                  child: Text(
                                    'Tiene dificultades para decir con precisión su edad actual.',
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Orientacion4(),
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
                                new Divider(height: 5.0, color: Colors.black),
                                new Padding(
                                  padding: new EdgeInsets.all(8.0),
                                ),
                                Container(
                                  width: 320,
                                  child: Text(
                                    'Tiene dificultades para decir con precisión su edad actual.',
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Orientacion4(),
                                SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                          )),

                      new Text(
                        'Funciones Ejecutivas',
                        style: new TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),

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
                                new Divider(height: 5.0, color: Colors.black),
                                new Padding(
                                  padding: new EdgeInsets.all(8.0),
                                ),
                                Container(
                                  width: 320,
                                  child: Text(
                                    'Le cuesta tomar decisiones o decidir qué hacer.',
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                FunEjec1(),
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
                                new Divider(height: 5.0, color: Colors.black),
                                new Padding(
                                  padding: new EdgeInsets.all(8.0),
                                ),
                                Container(
                                  width: 320,
                                  child: Text(
                                    'Tiene dificultades para organizar planes, por ejemplo una salida con amigos.',
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                FunEjec2(),
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
                                new Divider(height: 5.0, color: Colors.black),
                                new Padding(
                                  padding: new EdgeInsets.all(8.0),
                                ),
                                Container(
                                  width: 320,
                                  child: Text(
                                    'Presenta dificultades para hacer cambios de planes o cambiar la actividad cuando es necesario, por ejemplo no hacer las compras como todos los viernes porque el domingo se irá de viaje por unas semanas.',
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                FunEjec3(),
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
                                new Divider(height: 5.0, color: Colors.black),
                                new Padding(
                                  padding: new EdgeInsets.all(8.0),
                                ),
                                Container(
                                  width: 320,
                                  child: Text(
                                    'Dificultad para seguir el orden de pasos necesario para realizar una tarea (ejemplo, cocinar, vestirse) o deja cosas sin terminar.',
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                FunEjec4(),
                                SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                          )),

                      new Text(
                        'Memoria',
                        style: new TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      new Padding(
                        padding: new EdgeInsets.all(8.0),
                      ),
                      new Divider(height: 5.0, color: Colors.black),
                      new Padding(
                        padding: new EdgeInsets.all(8.0),
                      ),

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
                                new Divider(height: 5.0, color: Colors.black),
                                new Padding(
                                  padding: new EdgeInsets.all(8.0),
                                ),
                                Container(
                                  width: 320,
                                  child: Text(
                                    'Olvida o confunde los nombres de personas conocidas (por ejemplo, nombres de nietos o amigos. ',
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Memoria1(),
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
                                new Divider(height: 5.0, color: Colors.black),
                                new Padding(
                                  padding: new EdgeInsets.all(8.0),
                                ),
                                Container(
                                  width: 320,
                                  child: Text(
                                    'Olvida citas o planes previamente pautados. ',
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Memoria2(),
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
                                new Divider(height: 5.0, color: Colors.black),
                                new Padding(
                                  padding: new EdgeInsets.all(8.0),
                                ),
                                Container(
                                  width: 320,
                                  child: Text(
                                    'Olvida el lugar donde dejo objetos de uso cotidiano (por ejemplo, llaves, anteojos, celular). ',
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Memoria3(),
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
                                new Divider(height: 5.0, color: Colors.black),
                                new Padding(
                                  padding: new EdgeInsets.all(8.0),
                                ),
                                Container(
                                  width: 320,
                                  child: Text(
                                    'Algunas veces no recuerda hechos recientes (por ejemplo, que almorzó ayer, que le regalaron para su cumpleaños, quien llamó por teléfono). ',
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Memoria4(),
                                SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                          )),

                      new Text(
                        'Praxias y gnosias',
                        style: new TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),

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
                                new Divider(height: 5.0, color: Colors.black),
                                new Padding(
                                  padding: new EdgeInsets.all(8.0),
                                ),
                                Container(
                                  width: 320,
                                  child: Text(
                                    'Tiene dificultades para vestirse (no por problemas motrices, por ejemplo, prender los botones de la camisa).',
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                PraxiaGnosia1(),
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
                                new Divider(height: 5.0, color: Colors.black),
                                new Padding(
                                  padding: new EdgeInsets.all(8.0),
                                ),
                                Container(
                                  width: 320,
                                  child: Text(
                                    'Le cuesta hacer o copiar dibujos.',
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                PraxiaGnosia2(),
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
                                new Divider(height: 5.0, color: Colors.black),
                                new Padding(
                                  padding: new EdgeInsets.all(8.0),
                                ),
                                Container(
                                  width: 320,
                                  child: Text(
                                    'Tiene dificultades para reconocer objetos o personas que conoce.',
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                PraxiaGnosia3(),
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
                                new Divider(height: 5.0, color: Colors.black),
                                new Padding(
                                  padding: new EdgeInsets.all(8.0),
                                ),
                                Container(
                                  width: 320,
                                  child: Text(
                                    'Le cuesta encontrar objetos, particularmente cuando no están en la posición habitual.',
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                PraxiaGnosia4(),
                                SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                          )),

                      new Text(
                        'Lenguaje',
                        style: new TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),

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
                                new Divider(height: 5.0, color: Colors.black),
                                new Padding(
                                  padding: new EdgeInsets.all(8.0),
                                ),
                                Container(
                                  width: 320,
                                  child: Text(
                                    'Tiene dificultades para encontrar la palabra correcta',
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Lenguaje1(),
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
                                new Divider(height: 5.0, color: Colors.black),
                                new Padding(
                                  padding: new EdgeInsets.all(8.0),
                                ),
                                Container(
                                  width: 320,
                                  child: Text(
                                    'Le cuesta escribir, su letra empeoró en el último tiempo',
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Lenguaje2(),
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
                                new Divider(height: 5.0, color: Colors.black),
                                new Padding(
                                  padding: new EdgeInsets.all(8.0),
                                ),
                                Container(
                                  width: 320,
                                  child: Text(
                                    'Le resulta difícil entender lo que otros dicen',
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Lenguaje3(),
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
                                new Divider(height: 5.0, color: Colors.black),
                                new Padding(
                                  padding: new EdgeInsets.all(8.0),
                                ),
                                Container(
                                  width: 320,
                                  child: Text(
                                    'Le cuesta entender lo que lee',
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Lenguaje4(),
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
                          // Validate returns true if the form is valid, or false
                          // otherwise.

                          // If the form is valid, display a Snackbar.
                          //Scaffold.of(context).showSnackBar(
                          //  SnackBar(content: Text('Procesando información')));

                          guardar_datos(context);
                        },
                        child: Text('GUARDAR',
                            style: TextStyle(
                              fontFamily: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  .fontFamily,
                            )),
                      ),
                      ElevatedButton(
                        //  onPressed: validateAnswers,
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

guardar_datos(BuildContext context) async {
  if (id_ate1 == null) {
    loginToast("Debe responder si los item de atención");
  } else {
    if (id_ate2 == null) {
      loginToast("Debe responder si los item de atención");
    } else {
      if (id_ate3 == null) {
        loginToast("Debe responder si los item de atención");
      } else {
        if (id_ate4 == null) {
          loginToast("Debe responder si los item de atención");
        } else {
          if (id_funejec1 == null) {
            loginToast("Debe responder si los item de Funciones Ejecutivas");
          } else {
            if (id_funejec2 == null) {
              loginToast("Debe responder si los item de Funciones Ejecutivas");
            } else {
              if (id_funejec3 == null) {
                loginToast(
                    "Debe responder si los item de Funciones Ejecutivas");
              } else {
                if (id_funejec4 == null) {
                  loginToast(
                      "Debe responder si los item de Funciones Ejecutivas");
                } else {
                  if (id_ori1 == null) {
                    loginToast("Debe responder si los item de Orientación");
                  } else {
                    if (id_ori2 == null) {
                      loginToast("Debe responder si los item de Orientación");
                    } else {
                      if (id_ori3 == null) {
                        loginToast("Debe responder si los item de Orientación");
                      } else {
                        if (id_ori4 == null) {
                          loginToast(
                              "Debe responder si los item de Orientación");
                        } else {
                          if (id_memoria1 == null) {
                            loginToast("Debe responder si los item de Memoria");
                          } else {
                            if (id_memoria2 == null) {
                              loginToast(
                                  "Debe responder si los item de Memoria");
                            } else {
                              if (id_memoria3 == null) {
                                loginToast(
                                    "Debe responder si los item de Memoria");
                              } else {
                                if (id_memoria4 == null) {
                                  loginToast(
                                      "Debe responder si los item de Memoria");
                                } else {
                                  if (id_prexgnosia1 == null) {
                                    loginToast(
                                        "Debe responder si los item de Praxias y Gnosias");
                                  } else {
                                    if (id_prexgnosia2 == null) {
                                      loginToast(
                                          "Debe responder si los item de Praxias y Gnosias");
                                    } else {
                                      if (id_prexgnosia3 == null) {
                                        loginToast(
                                            "Debe responder si los item de Praxias y Gnosias");
                                      } else {
                                        if (id_prexgnosia4 == null) {
                                          loginToast(
                                              "Debe responder si los item de Praxias y Gnosias");
                                        } else {
                                          if (id_leng1 == null) {
                                            loginToast(
                                                "Debe responder si los item de Lenguajes");
                                          } else {
                                            if (id_leng2 == null) {
                                              loginToast(
                                                  "Debe responder si los item de Lenguajes");
                                            } else {
                                              if (id_leng3 == null) {
                                                loginToast(
                                                    "Debe responder si los item de Lenguajes");
                                              } else {
                                                if (id_leng4 == null) {
                                                  loginToast(
                                                      "Debe responder si los item de Lenguajes");
                                                } else {
                                                  String URL_base =
                                                      Env.URL_PREFIX;
                                                  var url = URL_base +
                                                      "/respuesta_screening_quejas.php";
                                                  var response = await http
                                                      .post(url, body: {
                                                    "id_paciente":
                                                        id_paciente.toString(),
                                                    "id_medico":
                                                        id_medico.toString(),
                                                    "id_recordatorio":
                                                        id_recordatorio
                                                            .toString(),
                                                    "tipo_screening":
                                                        tipo_screening
                                                            .toString(),
                                                    "id_ate1": id_ate1,
                                                    "id_ate2": id_ate2,
                                                    "id_ate3": id_ate3,
                                                    "id_ate4": id_ate4,
                                                    "id_ori1": id_ori1,
                                                    "id_ori2": id_ori2,
                                                    "id_ori3": id_ori3,
                                                    "id_ori4": id_ori4,
                                                    "id_funejec1": id_funejec1,
                                                    "id_funejec2": id_funejec2,
                                                    "id_funejec3": id_funejec3,
                                                    "id_funejec4": id_funejec4,
                                                    "id_memoria1": id_memoria1,
                                                    "id_memoria2": id_memoria2,
                                                    "id_memoria3": id_memoria3,
                                                    "id_memoria4": id_memoria4,
                                                    "id_prexgnosia1":
                                                        id_prexgnosia1,
                                                    "id_prexgnosia2":
                                                        id_prexgnosia2,
                                                    "id_prexgnosia3":
                                                        id_prexgnosia3,
                                                    "id_prexgnosia4":
                                                        id_prexgnosia4,
                                                    "id_leng1": id_leng1,
                                                    "id_leng2": id_leng2,
                                                    "id_leng3": id_leng3,
                                                    "id_leng4": id_leng4,
                                                  });
                                                  print(response.body);
                                                  var data = json
                                                      .decode(response.body);
                                                  print(data);
                                                  if (data == "alert") {
                                                    _alert_informe(
                                                      context,
                                                      "Para tener en cuenta",
                                                      "Sería bueno que consulte con su médico clínico o neurologo sobre los síntomas cognitivos, probablemente le solicite una evaluación cognitiva para explorar su funcionamiento cognitivo.",
                                                    );
                                                  } else {
                                                    if (screening_recordatorio ==
                                                        true) {
                                                      Navigator.pushNamed(
                                                          context,
                                                          '/recordatorio');
                                                    } else {
                                                      Navigator.pushNamed(
                                                          context, '/screening',
                                                          arguments: {
                                                            "select_screening":
                                                                "QCQ",
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

//----------------------------------------ATENCION 1------------------------------------------------------------------------------------------
var id_ate1 = null;
var id_ate2 = null;
var id_ate3 = null;
var id_ate4 = null;

class Atencion1 extends StatefulWidget {
  @override
  Atencion1WidgetState createState() => Atencion1WidgetState();
}

class Atencion1WidgetState extends State<Atencion1> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_quejas.php";
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
                  groupValue: id_ate1,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_ate1 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class Atencion2 extends StatefulWidget {
  @override
  Atencion2WidgetState createState() => Atencion2WidgetState();
}

class Atencion2WidgetState extends State<Atencion2> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_quejas.php";
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
                  groupValue: id_ate2,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_ate2 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class Atencion3 extends StatefulWidget {
  @override
  Atencion3WidgetState createState() => Atencion3WidgetState();
}

class Atencion3WidgetState extends State<Atencion3> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_quejas.php";
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
                  groupValue: id_ate3,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_ate3 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class Atencion4 extends StatefulWidget {
  @override
  Atencion4WidgetState createState() => Atencion4WidgetState();
}

class Atencion4WidgetState extends State<Atencion4> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_quejas.php";
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
                  groupValue: id_ate4,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_ate4 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//--------------------------------------------------------------------------------------------
////----------------------------------------ORIENTACION ------------------------------------------------------------------------------------------
var id_ori1 = null;
var id_ori2 = null;
var id_ori3 = null;
var id_ori4 = null;

class Orientacion1 extends StatefulWidget {
  @override
  Orientacion1WidgetState createState() => Orientacion1WidgetState();
}

class Orientacion1WidgetState extends State<Orientacion1> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_quejas.php";
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
                  groupValue: id_ori1,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_ori1 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class Orientacion2 extends StatefulWidget {
  @override
  Orientacion2WidgetState createState() => Orientacion2WidgetState();
}

class Orientacion2WidgetState extends State<Orientacion2> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_quejas.php";
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
                  groupValue: id_ori2,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_ori2 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class Orientacion3 extends StatefulWidget {
  @override
  Orientacion3WidgetState createState() => Orientacion3WidgetState();
}

class Orientacion3WidgetState extends State<Orientacion3> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_quejas.php";
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
                  groupValue: id_ori3,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_ori3 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class Orientacion4 extends StatefulWidget {
  @override
  Orientacion4WidgetState createState() => Orientacion4WidgetState();
}

class Orientacion4WidgetState extends State<Orientacion4> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_quejas.php";
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
                  groupValue: id_ori4,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_ori4 = val;
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
var id_funejec1 = null;
var id_funejec2 = null;
var id_funejec3 = null;
var id_funejec4 = null;

class FunEjec1 extends StatefulWidget {
  @override
  FunEjec1WidgetState createState() => FunEjec1WidgetState();
}

class FunEjec1WidgetState extends State<FunEjec1> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_quejas.php";
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
                  groupValue: id_funejec1,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_funejec1 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class FunEjec2 extends StatefulWidget {
  @override
  FunEjec2WidgetState createState() => FunEjec2WidgetState();
}

class FunEjec2WidgetState extends State<FunEjec2> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_quejas.php";
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
                  groupValue: id_funejec2,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_funejec2 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class FunEjec3 extends StatefulWidget {
  @override
  FunEjec3WidgetState createState() => FunEjec3WidgetState();
}

class FunEjec3WidgetState extends State<FunEjec3> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_quejas.php";
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
                  groupValue: id_funejec3,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_funejec3 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class FunEjec4 extends StatefulWidget {
  @override
  FunEjec4WidgetState createState() => FunEjec4WidgetState();
}

class FunEjec4WidgetState extends State<FunEjec4> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_quejas.php";
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
                  groupValue: id_funejec4,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_funejec4 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//-----------------------------------------------------------------
//
////----------------------------------------MEMORIA ------------------------------------------------------------------------------------------
var id_memoria1 = null;
var id_memoria2 = null;
var id_memoria3 = null;
var id_memoria4 = null;

class Memoria1 extends StatefulWidget {
  @override
  Memoria1WidgetState createState() => Memoria1WidgetState();
}

class Memoria1WidgetState extends State<Memoria1> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_quejas.php";
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
                  groupValue: id_memoria1,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_memoria1 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class Memoria2 extends StatefulWidget {
  @override
  Memoria2WidgetState createState() => Memoria2WidgetState();
}

class Memoria2WidgetState extends State<Memoria2> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_quejas.php";
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
                  groupValue: id_memoria2,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_memoria2 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class Memoria3 extends StatefulWidget {
  @override
  Memoria3WidgetState createState() => Memoria3WidgetState();
}

class Memoria3WidgetState extends State<Memoria3> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_quejas.php";
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
                  groupValue: id_memoria3,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_memoria3 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class Memoria4 extends StatefulWidget {
  @override
  Memoria4WidgetState createState() => Memoria4WidgetState();
}

class Memoria4WidgetState extends State<Memoria4> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_quejas.php";
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
                  groupValue: id_memoria4,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_memoria4 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//-------------------------------------------------------------------------
//////----------------------------------------MEMORIA ------------------------------------------------------------------------------------------
var id_prexgnosia1 = null;
var id_prexgnosia2 = null;
var id_prexgnosia3 = null;
var id_prexgnosia4 = null;

class PraxiaGnosia1 extends StatefulWidget {
  @override
  PraxiaGnosia1WidgetState createState() => PraxiaGnosia1WidgetState();
}

class PraxiaGnosia1WidgetState extends State<PraxiaGnosia1> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_quejas.php";
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
                  groupValue: id_prexgnosia1,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_prexgnosia1 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class PraxiaGnosia2 extends StatefulWidget {
  @override
  PraxiaGnosia2WidgetState createState() => PraxiaGnosia2WidgetState();
}

class PraxiaGnosia2WidgetState extends State<PraxiaGnosia2> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_quejas.php";
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
                  groupValue: id_prexgnosia2,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_prexgnosia2 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class PraxiaGnosia3 extends StatefulWidget {
  @override
  PraxiaGnosia3WidgetState createState() => PraxiaGnosia3WidgetState();
}

class PraxiaGnosia3WidgetState extends State<PraxiaGnosia3> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_quejas.php";
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
                  groupValue: id_prexgnosia3,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_prexgnosia3 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class PraxiaGnosia4 extends StatefulWidget {
  @override
  PraxiaGnosia4WidgetState createState() => PraxiaGnosia4WidgetState();
}

class PraxiaGnosia4WidgetState extends State<PraxiaGnosia4> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_quejas.php";
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
                  groupValue: id_prexgnosia4,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_prexgnosia4 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//-----------------------------------------------------------------------
//----------------------------------------LENGUAJE------------------------------------------------------------------------------------------
var id_leng1 = null;
var id_leng2 = null;
var id_leng3 = null;
var id_leng4 = null;

class Lenguaje1 extends StatefulWidget {
  @override
  Lenguaje1WidgetState createState() => Lenguaje1WidgetState();
}

class Lenguaje1WidgetState extends State<Lenguaje1> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_quejas.php";
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
                  groupValue: id_leng1,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_leng1 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class Lenguaje2 extends StatefulWidget {
  @override
  Lenguaje2WidgetState createState() => Lenguaje2WidgetState();
}

class Lenguaje2WidgetState extends State<Lenguaje2> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_quejas.php";
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
                  groupValue: id_leng2,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_leng2 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class Lenguaje3 extends StatefulWidget {
  @override
  Lenguaje3WidgetState createState() => Lenguaje3WidgetState();
}

class Lenguaje3WidgetState extends State<Lenguaje3> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_quejas.php";
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
                  groupValue: id_leng3,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_leng3 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class Lenguaje4 extends StatefulWidget {
  @override
  Lenguaje4WidgetState createState() => Lenguaje4WidgetState();
}

class Lenguaje4WidgetState extends State<Lenguaje4> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/tipo_respuesta_quejas.php";
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
                  groupValue: id_leng4,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_leng4 = val;
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
