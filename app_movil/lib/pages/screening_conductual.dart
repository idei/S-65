import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_salud/pages/env.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../models/opciones_navbar.dart';

class ScreeningConductualPage extends StatefulWidget {
  @override
  _ScreeningConductualState createState() => _ScreeningConductualState();
}

final _formKey_screening_conductual = GlobalKey<_ScreeningConductualState>();

TextEditingController otro = TextEditingController();

var id_paciente;
var id_medico;
var tipo_screening;
var id_recordatorio;
var observaciones;
var email;
var screening_recordatorio;
List itemsConductual;
List itemsConductualOtro;
bool otroVisible = false;

class _ScreeningConductualState extends State<ScreeningConductualPage> {
  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email_prefer = prefs.getString("email_prefer");
    email = email_prefer;
    id_paciente = prefs.getInt("id_paciente");

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
      }
    }
  }

  get_tiposcreening(var codigo_screening) async {
    String URL_base = Env.URL_API;
    var url = URL_base + "/read_tipo_screening";
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
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _alert_clinicos(
        context, "Cuestionario Conductual", " Texto Introductivo "));
  }

  @override
  Widget build(BuildContext context) {
    getStringValuesSF();

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
            Navigator.pushNamed(context, '/screening', arguments: {
              "select_screening": "CONDUC",
            });
          },
        ),
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
        child: FutureBuilder(
          future: getAllRespuesta(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ColumnWidgetConductual();
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  void choiceAction(String choice) {
    if (choice == Constants.Ajustes) {
      Navigator.pushNamed(context, '/ajustes');
    } else if (choice == Constants.Salir) {
      Navigator.pushNamed(context, '/');
    }
  }
}

class ColumnWidgetConductual extends StatefulWidget {
  const ColumnWidgetConductual({
    Key key,
  }) : super(key: key);

  @override
  State<ColumnWidgetConductual> createState() => _ColumnWidgetConductualState();
}

class _ColumnWidgetConductualState extends State<ColumnWidgetConductual> {
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: <
        Widget>[
      Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                      '  ¿Qué parentesco tiene con (nombre del usuario)?  ',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: Theme.of(context)
                              .textTheme
                              .headline1
                              .fontFamily)),
                ),

                Conductual1(),

                // Usamos Container para el contenedor de la descripción
              ],
            ),
          )),
      Divider(height: 5.0, color: Colors.black),
      Padding(
        padding: EdgeInsets.all(8.0),
      ),
      Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                //espacio entre el texto y el radio button
                SizedBox(
                  height: 10,
                ),
                Conductual2(),
              ],
            ),
          )),
      Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Conductual3(),
              ],
            ),
          )),
      Divider(height: 5.0, color: Colors.black),
      Padding(
        padding: EdgeInsets.all(8.0),
      ),
      Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Conductual4(),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          )),
      Divider(height: 5.0, color: Colors.black),
      Padding(
        padding: EdgeInsets.all(8.0),
      ),
      Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Conductual5(),
              ],
            ),
          )),
      Divider(height: 5.0, color: Colors.black),
      Padding(
        padding: EdgeInsets.all(8.0),
      ),
      Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                    '¿Se molesta el paciente cuando se separa de usted? ¿Muestra otras señales de nerviosismo, como falta de aire, suspiros, incapacidad de relajarse o se siente excesivamente tenso?',
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Conductual6(),
              ],
            ),
          )),
      Divider(height: 5.0, color: Colors.black),
      Padding(
        padding: EdgeInsets.all(8.0),
      ),
      Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Conductual7(),
              ],
            ),
          )),
      Divider(
        height: 5.0,
        color: Colors.black,
      ),
      Padding(
        padding: EdgeInsets.all(8.0),
      ),
      Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Conductual8(),
              ],
            ),
          )),
      Divider(
        height: 5.0,
        color: Colors.black,
      ),
      Padding(
        padding: EdgeInsets.all(8.0),
      ),
      Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Conductual9(),
              ],
            ),
          )),
      Divider(
        height: 5.0,
        color: Colors.black,
      ),
      Padding(
        padding: EdgeInsets.all(8.0),
      ),
      Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Conductual10(),
              ],
            ),
          )),
      Divider(
        height: 5.0,
        color: Colors.black,
      ),
      Padding(
        padding: EdgeInsets.all(8.0),
      ),
      Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Conductual11(),
              ],
            ),
          )),
      Divider(
        height: 5.0,
        color: Colors.black,
      ),
      Padding(
        padding: EdgeInsets.all(8.0),
      ),
      Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    '¿Le despierta el paciente durante la noche, se levanta muy temprano por la mañana o toma siestas excesivas durante el día?',
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Conductual12(),
              ],
            ),
          )),
      Divider(
        height: 5.0,
        color: Colors.black,
      ),
      Padding(
        padding: EdgeInsets.all(8.0),
      ),
      Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Conductual13(),
              ],
            ),
          )),
      Divider(
        height: 5.0,
        color: Colors.black,
      ),
      Padding(
        padding: EdgeInsets.all(8.0),
      ),
      ElevatedButton.icon(
        icon: _isLoading
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: const CircularProgressIndicator(),
              )
            : const Icon(Icons.save_alt),
        style: ElevatedButton.styleFrom(
          textStyle: TextStyle(
              fontFamily: Theme.of(context).textTheme.headline1.fontFamily),
        ),
        onPressed: () => !_isLoading ? _startLoading() : null,
        label: Text('GUARDAR',
            style: TextStyle(
              fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
              fontWeight: FontWeight.bold,
            )),
      ),
      Padding(
        padding: EdgeInsets.all(4.0),
      ),
    ]);
  }

  bool _isLoading = false;
  void _startLoading() async {
    setState(() {
      _isLoading = true;
    });

    await guardarDatosConductual(context);

    setState(() {
      _isLoading = false;
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

showDialogMessage(context) async {
  await Future.delayed(Duration(microseconds: 1));
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 80,
            width: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Guardando Información",
                  style: TextStyle(
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily,
                  ),
                )
              ],
            ),
          ),
        );
      });
}

Future<List> getAllRespuesta({
  bool otro = false,
}) async {
  var response;
  var responseOtro;

  String URL_base = Env.URL_API;
  var url = URL_base + "/tipo_respuesta_conductual";

  responseOtro = await http.post(url, body: {"otro": "otro"});

  response = await http.post(url, body: {});

  var jsonData = json.decode(response.body);
  var jsonDataOtro = json.decode(responseOtro.body);

  if (response.statusCode == 200 && (responseOtro.statusCode == 200)) {
    itemsConductualOtro = jsonDataOtro['data'];
    return itemsConductual = jsonData['data'];
  } else {
    return null;
  }
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

guardarDatosConductual(BuildContext context) async {
  if (id_conductual1 == null) loginToast("Debe responder todas las preguntas");

  if (id_conductual2 == null) loginToast("Debe responder todas las preguntas");

  if (id_conductual3 == null) loginToast("Debe responder todas las preguntas");

  if (id_conductual4 == null) loginToast("Debe responder todas las preguntas");

  if (id_conductual5 == null) loginToast("Debe responder todas las preguntas");

  if (id_conductual6 == null) loginToast("Debe responder todas las preguntas");

  if (id_conductual7 == null) loginToast("Debe responder todas las preguntas");

  if (id_conductual8 == null) loginToast("Debe responder todas las preguntas");

  if (id_conductual9 == null) loginToast("Debe responder todas las preguntas");

  if (id_conductual10 == null) loginToast("Debe responder todas las preguntas");

  if (id_conductual11 == null) loginToast("Debe responder todas las preguntas");

  if (id_conductual12 == null) loginToast("Debe responder todas las preguntas");

  if (id_conductual13 == null) loginToast("Debe responder todas las preguntas");

  if (id_conductual1 != null &&
      id_conductual2 != null &&
      id_conductual3 != null &&
      id_conductual4 != null &&
      id_conductual5 != null &&
      id_conductual6 != null &&
      id_conductual7 != null &&
      id_conductual8 != null &&
      id_conductual9 != null &&
      id_conductual10 != null &&
      id_conductual11 != null &&
      id_conductual12 != null &&
      id_conductual13 != null) {
    showDialogMessage(context);
    String URL_base = Env.URL_API;
    var url = URL_base + "/respuesta_screening_conductual";
    var response = await http.post(url, body: {
      "id_paciente": id_paciente.toString(),
      "id_medico": id_medico.toString(),
      "id_recordatorio": id_recordatorio.toString(),
      "tipo_screening": tipo_screening['data'].toString(),
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

    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      if (data['data'] == "alert") {
        _alert_informe(
          context,
          "Para tener en cuenta",
          "Sería bueno que consulte con su médico clínico o neurologo sobre lo informado con respecto a su funcionamiento en la vida cotidiana. Es posible que el especialista le solicite una evaluación cognitiva para explorar màs en detalle su funcionamiento cognitivo y posible impacto sobre su rutina.",
        );
      } else {
        if (data['status'] == "Success") {
          if (screening_recordatorio == true) {
            Navigator.pushNamed(context, '/recordatorio');
          } else {
            Navigator.pushNamed(context, '/screening', arguments: {
              "select_screening": "CONDUC",
            });
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
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      child: Column(
        children: [
          ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(8.0),
            children: itemsConductualOtro
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
                          if (id_conductual1 == "48") {
                            otroVisible = true;
                          } else {
                            otroVisible = false;
                          }
                        });
                      },
                    ))
                .toList(),
          ),
          Visibility(
            visible: otroVisible,
            child: Container(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                style: TextStyle(
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily),
                controller: otro,
                keyboardType: TextInputType.name,
                decoration:
                    InputDecoration(labelText: "Si es otro, especifique"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Conductual2 extends StatefulWidget {
  @override
  Conductual2WidgetState createState() => Conductual2WidgetState();
}

class Conductual2WidgetState extends State<Conductual2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsConductual
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
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsConductual
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
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsConductual
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
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsConductual
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
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsConductual
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
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsConductual
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
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsConductual
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
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsConductual
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
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsConductual
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
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsConductual
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
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsConductual
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
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsConductual
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
