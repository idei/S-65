import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'env.dart';
import 'ajustes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

var id_paciente;
var id_medico;
var tipo_screening;
var id_recordatorio;
var screening_recordatorio;
var email;

// Define a custom Form widget.
class FormScreeningAnimo extends StatefulWidget {
  final pageName = 'screening_animo';

  @override
  _FormpruebaState createState() => _FormpruebaState();
}

class _FormpruebaState extends State<FormScreeningAnimo> {
  final myController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _alert_clinicos(
        context,
        "Cuestionario de Ánimo",
        "Este cuestionario valora cómo está su ánimo actualmente . Por favor responda sinceramente a cada una de las preguntas.  "));
  }

  loginToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  _printLatestValue() {
    print("Second text field: ${myController.text}");
  }

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
  Widget build(BuildContext context) {
    getStringValuesSF();

    return FutureBuilder(
        future: read_recordatorios(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print(snapshot.connectionState);

          if (snapshot.hasData) {
            return ScreeningAnimo();
          } else {
            return Scaffold(
              appBar: AppBar(
                //backgroundColor: Color.fromRGBO(157, 19, 34, 1),
                title: Text('Chequeo de Animo',
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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

read_recordatorios() async {
  await Future.delayed(Duration(milliseconds: 500));
  return true;
}

Widget texto(String entrada) {
  return Text(
    entrada,
    style: TextStyle(
        fontSize: 12.0,
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontFamily: "Roboto"),
  );
}

var resultado;

guardar_datos(BuildContext context) async {
  String URL_base = Env.URL_PREFIX;
  var url = URL_base + "/respuesta_screening_animo.php";
  var response = await http.post(url, body: {
    "id_paciente": id_paciente.toString(),
    "id_medico": id_medico.toString(),
    "id_recordatorio": id_recordatorio.toString(),
    "tipo_screening": tipo_screening.toString(),
    "satisfecho": satisfecho.toString().toString(),
    "abandonado": abandonado.toString(),
    "vacia": vacia.toString(),
    "aburrida": aburrida.toString(),
    "humor": humor.toString(),
    "temor": temor.toString(),
    "feliz": feliz.toString(),
    "desamparado": desamparado.toString(),
    "prefiere": prefiere.toString(),
    "memoria": memoria.toString(),
    "estar_vivo": estar_vivo.toString(),
    "inutil": inutil.toString(),
    "energia": energia.toString(),
    "situacion": situacion.toString(),
    "situacion_mejor": situacion_mejor.toString(),
    "cod_event_satisfecho": cod_event_satisfecho,
    "cod_event_abandonado": cod_event_abandonado,
    "cod_event_vacia": cod_event_vacia,
    "cod_event_aburrida": cod_event_aburrida,
    "cod_event_humor": cod_event_humor,
    "cod_event_temor": cod_event_temor,
    "cod_event_feliz": cod_event_feliz,
    "cod_event_desamparado": cod_event_desamparado,
    "cod_event_prefiere": cod_event_prefiere,
    "cod_event_memoria": cod_event_memoria,
    "cod_event_estar_vivo": cod_event_estar_vivo,
    "cod_event_inutil": cod_event_inutil,
    "cod_event_energia": cod_event_energia,
    "cod_event_situacion": cod_event_situacion,
    "cod_event_situacion_mejor": cod_event_situacion_mejor,
  });

  print(response.body);
  resultado = json.decode(response.body);

  if (int.parse(resultado) > 9) {
    _alert_informe(
      context,
      "Para tener en cuenta",
      "Usted tiene algunos síntomas del estado del ánimo de los cuales ocuparse, le sugerimos que realice una consulta psiquiátrica o que converse sobre estos síntomas con su médico de cabecera. ",
    );
  } else {
    if (screening_recordatorio == true) {
      Navigator.pushNamed(context, '/recordatorio');
    } else {
      Navigator.pushNamed(context, '/screening', arguments: {
        "select_screening": "ANIMO",
      });
    }
  }
}

read_datos_paciente() async {
  await Future.delayed(Duration(milliseconds: 1500));

  return true;
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
              "select_screening": "ANIMO",
            });
          }
        },
        width: 120,
      )
    ],
  ).show();
}

//----------------------------------------Chequeo de Sintomas ------------------------------------------

class ScreeningAnimo extends StatefulWidget {
  ScreeningAnimo({Key key}) : super(key: key);

  @override
  ScreeningAnimoWidgetState createState() => ScreeningAnimoWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class ScreeningAnimoWidgetState extends State<ScreeningAnimo> {
  final _formKey_screening_animo = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, '/screening', arguments: {
                "select_screening": "ANIMO",
              });
            },
          ),
          //backgroundColor: Color.fromRGBO(157, 19, 34, 1),
          title: Text('Chequeo de Animo',
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
                fontSize: 16,
                fontWeight: FontWeight.bold,
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
          key: _formKey_screening_animo,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: <Widget>[
                SatisfechoVida(),
                Padding(
                  padding: EdgeInsets.all(5.0),
                ),
                Divider(height: 3.0, color: Colors.black),
                Abandonado(),
                Padding(
                  padding: EdgeInsets.all(5.0),
                ),
                Divider(height: 3.0, color: Colors.black),
                Nauseas(),
                Padding(
                  padding: EdgeInsets.all(5.0),
                ),
                Divider(height: 3.0, color: Colors.black),
                Aburrida(),
                Padding(
                  padding: EdgeInsets.all(5.0),
                ),
                Divider(height: 3.0, color: Colors.black),
                Humor(),
                Padding(
                  padding: EdgeInsets.all(5.0),
                ),
                Divider(height: 3.0, color: Colors.black),
                Temor(),
                Padding(
                  padding: EdgeInsets.all(5.0),
                ),
                Divider(height: 3.0, color: Colors.black),
                Feliz(),
                Padding(
                  padding: EdgeInsets.all(5.0),
                ),
                Divider(height: 3.0, color: Colors.black),
                Desamparados(),
                Padding(
                  padding: EdgeInsets.all(5.0),
                ),
                Divider(height: 3.0, color: Colors.black),
                Prefiere(),
                Padding(
                  padding: EdgeInsets.all(5.0),
                ),
                Divider(height: 3.0, color: Colors.black),
                Memoria(),
                Padding(
                  padding: EdgeInsets.all(5.0),
                ),
                Divider(height: 3.0, color: Colors.black),
                EstarVivo(),
                Padding(
                  padding: EdgeInsets.all(5.0),
                ),
                Divider(height: 3.0, color: Colors.black),
                Inutil(),
                Padding(
                  padding: EdgeInsets.all(5.0),
                ),
                Divider(height: 3.0, color: Colors.black),
                Energia(),
                Padding(
                  padding: EdgeInsets.all(5.0),
                ),
                Divider(height: 3.0, color: Colors.black),
                Situacion(),
                Padding(
                  padding: EdgeInsets.all(5.0),
                ),
                Divider(height: 3.0, color: Colors.black),
                MejorUsted(),
                Padding(
                  padding: EdgeInsets.all(5.0),
                ),
                SizedBox(
                  width: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    guardar_datos(context);
                  },
                  child: Text('GUARDAR',
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ],
            ),
          ),
        ));
  }

  void choiceAction(String choice) {
    if (choice == Constants.Ajustes) {
      Navigator.pushNamed(context, '/ajustes');
    } else if (choice == Constants.Salir) {
      Navigator.pushNamed(context, '/');
    }
  }
}

//----------------------------------------VARIABLES CHECKBOX -----------------------------------------------

bool satisfecho = false;
bool abandonado = false;
bool vacia = false;
bool aburrida = false;
bool humor = false;
bool temor = false;
bool feliz = false;

bool desamparado = false;
bool prefiere = false;
bool memoria = false;
bool estar_vivo = false;
bool inutil = false;
bool energia = false;
bool situacion = false;
bool situacion_mejor = false;

String cod_event_satisfecho = "ANI1";
String cod_event_abandonado = 'ANI2';
String cod_event_vacia = 'ANI3';
String cod_event_aburrida = 'ANI4';
String cod_event_humor = 'ANI5';
String cod_event_temor = 'ANI6';
String cod_event_feliz = 'ANI7';
String cod_event_desamparado = 'ANI8';
String cod_event_prefiere = "ANI9";
String cod_event_memoria = 'ANI10';
String cod_event_estar_vivo = 'ANI11';
String cod_event_inutil = 'ANI12';
String cod_event_energia = 'ANI13';
String cod_event_situacion = 'ANI14';
String cod_event_situacion_mejor = 'ANI15';

//--------------------------------------Consultar eventos -----------------------------------------

getAllEventos() async {
  String URL_base = Env.URL_PREFIX;
  var url = URL_base + "/eventos.php";
  var response = await http.post(url, body: {});
  print(response);
  var jsonBody = response.body;
  var data_evento = json.decode(jsonBody);
}

//-------------------------------------- ÄNIMO 1 -----------------------------------------------------

class LabeledCheckboxANI1 extends StatelessWidget {
  const LabeledCheckboxANI1({
    this.label,
    this.padding,
    this.value,
    this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Expanded(
                child: Text(label,
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ))),
            Checkbox(
              value: value,
              onChanged: (bool newValue) {
                onChanged(newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SatisfechoVida extends StatefulWidget {
  SatisfechoVida({Key key}) : super(key: key);

  @override
  CheckSatisfechoVidaWidgetState createState() =>
      CheckSatisfechoVidaWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class CheckSatisfechoVidaWidgetState extends State<SatisfechoVida> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxANI1(
      label: 'En general ¿Está satisfecho con su vida?',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: satisfecho,
      onChanged: (bool newValue) {
        setState(() {
          satisfecho = newValue;
        });
      },
    );
  }
}

//-----------------------------------------------------------------------------------------------------------

// --------------------------------- ANIMO 2 ----------------------------------------------------

class LabeledCheckboxANI2 extends StatelessWidget {
  const LabeledCheckboxANI2({
    this.label,
    this.padding,
    this.value,
    this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Expanded(
                child: Text(label,
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ))),
            Checkbox(
              value: value,
              onChanged: (bool newValue) {
                onChanged(newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Abandonado extends StatefulWidget {
  Abandonado({Key key}) : super(key: key);

  @override
  CheckAbandonadoWidgetState createState() => CheckAbandonadoWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class CheckAbandonadoWidgetState extends State<Abandonado> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxANI2(
      label: '¿Ha abandonado muchas de sus tareas habituales y aficiones?',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: abandonado,
      onChanged: (bool newValue) {
        setState(() {
          abandonado = newValue;
        });
      },
    );
  }
}

//-------------------------------------------ANIMO 3--------------------------------------------

class LabeledCheckboxVacia extends StatelessWidget {
  const LabeledCheckboxVacia({
    this.label,
    this.padding,
    this.value,
    this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Expanded(
                child: Text(label,
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ))),
            Checkbox(
              value: value,
              onChanged: (bool newValue) {
                onChanged(newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Nauseas extends StatefulWidget {
  Nauseas({Key key}) : super(key: key);

  @override
  NauseasWidgetState createState() => NauseasWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class NauseasWidgetState extends State<Nauseas> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxVacia(
      label: '¿Siente que su vida está vacía?',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: vacia,
      onChanged: (bool newValue) {
        setState(() {
          vacia = newValue;
        });
      },
    );
  }
}

//------------------------------------------ ANIMO 4 -------------------------------------------

class LabeledCheckboxANIMO4 extends StatelessWidget {
  const LabeledCheckboxANIMO4({
    this.label,
    this.padding,
    this.value,
    this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Expanded(
                child: Text(label,
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ))),
            Checkbox(
              value: value,
              onChanged: (bool newValue) {
                onChanged(newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Aburrida extends StatefulWidget {
  Aburrida({Key key}) : super(key: key);

  @override
  AburridaWidgetState createState() => AburridaWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class AburridaWidgetState extends State<Aburrida> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxANIMO4(
      label: '¿Se siente con frecuencia aburrido/a?',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: aburrida,
      onChanged: (bool newValue) {
        setState(() {
          aburrida = newValue;
        });
      },
    );
  }
}

//------------------------------------------ANIMO 5 ---------------------------------------

class LabeledCheckboxAnimo5 extends StatelessWidget {
  const LabeledCheckboxAnimo5({
    this.label,
    this.padding,
    this.value,
    this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Expanded(
                child: Text(label,
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ))),
            Checkbox(
              value: value,
              onChanged: (bool newValue) {
                onChanged(newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Humor extends StatefulWidget {
  Humor({Key key}) : super(key: key);

  @override
  HumorWidgetState createState() => HumorWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class HumorWidgetState extends State<Humor> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxAnimo5(
      label: '¿Se encuentra de buen humor la mayor parte del tiempo?',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: humor,
      onChanged: (bool newValue) {
        setState(() {
          humor = newValue;
        });
      },
    );
  }
}

// ----------------------------------------ANIMO 6---------------------------------------

class LabeledCheckboxAnimo6 extends StatelessWidget {
  const LabeledCheckboxAnimo6({
    this.label,
    this.padding,
    this.value,
    this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Expanded(
                child: Text(label,
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ))),
            Checkbox(
              value: value,
              onChanged: (bool newValue) {
                onChanged(newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Temor extends StatefulWidget {
  Temor({Key key}) : super(key: key);

  @override
  TemorWidgetState createState() => TemorWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class TemorWidgetState extends State<Temor> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxAnimo6(
      label: '¿Teme que algo malo pueda ocurrirle?',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: temor,
      onChanged: (bool newValue) {
        setState(() {
          temor = newValue;
        });
      },
    );
  }
}

// ---------------------------------------- ANIMO 7 -----------------------------------

class LabeledCheckboxFeliz extends StatelessWidget {
  const LabeledCheckboxFeliz({
    this.label,
    this.padding,
    this.value,
    this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Expanded(
                child: Text(label,
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ))),
            Checkbox(
              value: value,
              onChanged: (bool newValue) {
                onChanged(newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Feliz extends StatefulWidget {
  Feliz({Key key}) : super(key: key);

  @override
  FelizWidgetState createState() => FelizWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class FelizWidgetState extends State<Feliz> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxFeliz(
      label: '¿Se siente feliz la mayor parte del tiempo?',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: feliz,
      onChanged: (bool newValue) {
        setState(() {
          feliz = newValue;
        });
      },
    );
  }
}

// -----------------------------------------ANIMO 8 -----------------------------------------------------
class LabeledCheckboxAnimo8 extends StatelessWidget {
  const LabeledCheckboxAnimo8({
    this.label,
    this.padding,
    this.value,
    this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Expanded(
                child: Text(label,
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ))),
            Checkbox(
              value: value,
              onChanged: (bool newValue) {
                onChanged(newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Desamparados extends StatefulWidget {
  Desamparados({Key key}) : super(key: key);

  @override
  DesamparadosWidgetState createState() => DesamparadosWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class DesamparadosWidgetState extends State<Desamparados> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxAnimo8(
      label:
          '¿Con frecuencia se siente desamparado/a, desprotegido, abandonado?',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: desamparado,
      onChanged: (bool newValue) {
        setState(() {
          desamparado = newValue;
        });
      },
    );
  }
}

//-------------------------------------------- ANIMO 9 -----------------------------------------------------------

class LabeledCheckboxAnimo9 extends StatelessWidget {
  const LabeledCheckboxAnimo9({
    this.label,
    this.padding,
    this.value,
    this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Expanded(
                child: Text(label,
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ))),
            Checkbox(
              value: value,
              onChanged: (bool newValue) {
                onChanged(newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Prefiere extends StatefulWidget {
  Prefiere({Key key}) : super(key: key);

  @override
  PrefiereWidgetState createState() => PrefiereWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class PrefiereWidgetState extends State<Prefiere> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxAnimo9(
      label:
          '¿Prefiere usted quedarse en casa, más que salir y hacer cosas nuevas?',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: prefiere,
      onChanged: (bool newValue) {
        setState(() {
          prefiere = newValue;
        });
      },
    );
  }
}

// -------------------------------------------ANIMO 10 --------------------------------------------
class LabeledCheckboxAnimo10 extends StatelessWidget {
  const LabeledCheckboxAnimo10({
    this.label,
    this.padding,
    this.value,
    this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Expanded(
                child: Text(label,
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ))),
            Checkbox(
              value: value,
              onChanged: (bool newValue) {
                onChanged(newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Memoria extends StatefulWidget {
  Memoria({Key key}) : super(key: key);

  @override
  MemoriaWidgetState createState() => MemoriaWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class MemoriaWidgetState extends State<Memoria> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxAnimo10(
      label:
          '¿Cree que tiene más problemas de memoria que la mayoría de la gente?',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: memoria,
      onChanged: (bool newValue) {
        setState(() {
          memoria = newValue;
        });
      },
    );
  }
}

// ------------------------------------------ANIMO 11 ---------------------------------------------------
class LabeledCheckboxVivo extends StatelessWidget {
  const LabeledCheckboxVivo({
    this.label,
    this.padding,
    this.value,
    this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Expanded(
                child: Text(label,
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ))),
            Checkbox(
              value: value,
              onChanged: (bool newValue) {
                onChanged(newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class EstarVivo extends StatefulWidget {
  EstarVivo({Key key}) : super(key: key);

  @override
  EstarVivoWidgetState createState() => EstarVivoWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class EstarVivoWidgetState extends State<EstarVivo> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxVivo(
      label: 'En estos momentos, ¿piensa que es estupendo estar vivo?',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: estar_vivo,
      onChanged: (bool newValue) {
        setState(() {
          estar_vivo = newValue;
        });
      },
    );
  }
}
//-------------------------------------------- ANIMO 12---------------------------------------------------

class LabeledCheckboxAnimo12 extends StatelessWidget {
  const LabeledCheckboxAnimo12({
    this.label,
    this.padding,
    this.value,
    this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Expanded(
                child: Text(label,
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ))),
            Checkbox(
              value: value,
              onChanged: (bool newValue) {
                onChanged(newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Inutil extends StatefulWidget {
  Inutil({Key key}) : super(key: key);

  @override
  InutilWidgetState createState() => InutilWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class InutilWidgetState extends State<Inutil> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxAnimo12(
      label: '¿Actualmente se siente un/a inútil?',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: inutil,
      onChanged: (bool newValue) {
        setState(() {
          inutil = newValue;
        });
      },
    );
  }
}
//------------------------------------------ANIMO 13 --------------------------------------------------

class LabeledCheckboxANIMO13 extends StatelessWidget {
  const LabeledCheckboxANIMO13({
    this.label,
    this.padding,
    this.value,
    this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Expanded(
                child: Text(label,
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ))),
            Checkbox(
              value: value,
              onChanged: (bool newValue) {
                onChanged(newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Energia extends StatefulWidget {
  Energia({Key key}) : super(key: key);

  @override
  EnergiaWidgetState createState() => EnergiaWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class EnergiaWidgetState extends State<Energia> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxANIMO13(
      label: '¿Se siente lleno/a de energía?',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: energia,
      onChanged: (bool newValue) {
        setState(() {
          energia = newValue;
        });
      },
    );
  }
}
//-------------------------------------------- ANIMO 14 -------------------------------------------------

class LabeledCheckboxAnimo14 extends StatelessWidget {
  const LabeledCheckboxAnimo14({
    this.label,
    this.padding,
    this.value,
    this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Expanded(
                child: Text(label,
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ))),
            Checkbox(
              value: value,
              onChanged: (bool newValue) {
                onChanged(newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Situacion extends StatefulWidget {
  Situacion({Key key}) : super(key: key);

  @override
  ConFrecWidgetState createState() => ConFrecWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class ConFrecWidgetState extends State<Situacion> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxAnimo14(
      label: '¿Siente que su situación actual es desesperada?',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: situacion,
      onChanged: (bool newValue) {
        setState(() {
          situacion = newValue;
        });
      },
    );
  }
}

// --------------------------------------------ANIMO 15 ------------------------------------------------
class LabeledCheckboxAnimo15 extends StatelessWidget {
  const LabeledCheckboxAnimo15({
    this.label,
    this.padding,
    this.value,
    this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Expanded(
                child: Text(label,
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ))),
            Checkbox(
              value: value,
              onChanged: (bool newValue) {
                onChanged(newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MejorUsted extends StatefulWidget {
  MejorUsted({Key key}) : super(key: key);

  @override
  MejorUstedWidgetState createState() => MejorUstedWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class MejorUstedWidgetState extends State<MejorUsted> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxAnimo15(
      label:
          '¿Piensa que la mayoría de la gente está en mejor situación que usted?',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: situacion_mejor,
      onChanged: (bool newValue) {
        setState(() {
          situacion_mejor = newValue;
        });
      },
    );
  }
}
