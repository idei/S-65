import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_salud/pages/env.dart';
import 'package:app_salud/pages/ajustes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

var id_paciente;
var id_medico;
var tipo_screening;
var id_recordatorio;
var email;
var screening_recordatorio;

// Define a custom Form widget.
class FormScreeningNutricional extends StatefulWidget {
  final pageName = 'screening_nutricional';

  @override
  _ForNutricionalState createState() => _ForNutricionalState();
}

class _ForNutricionalState extends State<FormScreeningNutricional> {
  final myController = TextEditingController();

  @override
  void initState() {
    myController.addListener(_printLatestValue);
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
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pushNamed(context, '/screening', arguments: {
                      "select_screening": "RNUTRI",
                    });
                  },
                ),
                //backgroundColor: Color.fromRGBO(157, 19, 34, 1),
                title: Text('Riesgo Nutricional',
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

read_recordatorios() async {
  await new Future.delayed(new Duration(milliseconds: 500));
  return true;
}

Widget texto(String entrada) {
  return Text(
    entrada,
    style: new TextStyle(
        fontSize: 12.0,
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontFamily: "Roboto"),
  );
}

guardar_datos(BuildContext context) async {
  String URL_base = Env.URL_PREFIX;
  var url = URL_base + "/respuesta_screening_nutricional.php";
  var response = await http.post(url, body: {
    "id_paciente": id_paciente.toString(),
    "id_medico": id_medico.toString(),
    "id_recordatorio": id_recordatorio.toString(),
    "tipo_screening": tipo_screening.toString(),
    "nutri1": nutri1.toString().toString(),
    "nutri2": nutri2.toString(),
    "nutri3": nutri3.toString(),
    "nutri4": nutri4.toString(),
    "nutri5": nutri5.toString(),
    "nutri6": nutri6.toString(),
    "nutri7": nutri7.toString(),
    "nutri8": nutri8.toString(),
    "nutri9": nutri9.toString(),
    "nutri10": nutri10.toString(),
    "cod_event_nutri1": cod_event_nutri1,
    "cod_event_nutri2": cod_event_nutri2,
    "cod_event_nutri3": cod_event_nutri3,
    "cod_event_nutri4": cod_event_nutri4,
    "cod_event_nutri5": cod_event_nutri5,
    "cod_event_nutri6": cod_event_nutri6,
    "cod_event_nutri7": cod_event_nutri7,
    "cod_event_nutri8": cod_event_nutri8,
    "cod_event_nutri9": cod_event_nutri9,
    "cod_event_nutri10": cod_event_nutri10,
  });

  print(response.body);
  var data = json.decode(response.body);

  if (data != "Error") {
    _alert_informe(
      context,
      "Para tener en cuenta",
      data,
    );
  } else {
    if (screening_recordatorio == true) {
      Navigator.pushNamed(context, '/recordatorio');
    } else {
      Navigator.pushNamed(context, '/screening', arguments: {
        "select_screening": "RNUTRI",
      });
    }
  }

  print(data);
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
              "select_screening": "RNUTRI",
            });
          }
        },
        width: 120,
      )
    ],
  ).show();
}

read_datos_paciente() async {
  await new Future.delayed(new Duration(milliseconds: 1500));

  return true;
}

//----------------------------------------Screening de Sintomas ------------------------------------------

class ScreeningAnimo extends StatefulWidget {
  ScreeningAnimo({Key key}) : super(key: key);

  @override
  ScreeningAnimoWidgetState createState() => ScreeningAnimoWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class ScreeningAnimoWidgetState extends State<ScreeningAnimo> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //backgroundColor: Color.fromRGBO(157, 19, 34, 1),
          title: Text('Riesgo Nutricional',
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
            child: ListView(
              children: <Widget>[
                Nutri1(),
                new Padding(
                  padding: new EdgeInsets.all(8.0),
                ),
                new Divider(height: 5.0, color: Colors.black),
                Nutri2(),
                new Padding(
                  padding: new EdgeInsets.all(8.0),
                ),
                new Divider(height: 5.0, color: Colors.black),
                Nutri3(),
                new Padding(
                  padding: new EdgeInsets.all(8.0),
                ),
                new Divider(height: 5.0, color: Colors.black),
                Nutri4(),
                new Padding(
                  padding: new EdgeInsets.all(8.0),
                ),
                new Divider(height: 5.0, color: Colors.black),
                Nutri5(),
                new Padding(
                  padding: new EdgeInsets.all(8.0),
                ),
                new Divider(height: 5.0, color: Colors.black),
                Nutri6(),
                new Padding(
                  padding: new EdgeInsets.all(8.0),
                ),
                new Divider(height: 5.0, color: Colors.black),
                Nutri7(),
                new Padding(
                  padding: new EdgeInsets.all(8.0),
                ),
                new Divider(height: 5.0, color: Colors.black),
                Nutri8(),
                new Padding(
                  padding: new EdgeInsets.all(8.0),
                ),
                new Divider(height: 5.0, color: Colors.black),
                Nutri9(),
                new Padding(
                  padding: new EdgeInsets.all(8.0),
                ),
                new Divider(height: 5.0, color: Colors.black),
                Nutri10(),
                Padding(
                    padding: const EdgeInsets.fromLTRB(7.0, 17.0, 22.0, 30.0)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      //primary: Color.fromRGBO(157, 19, 34, 1),
                      ),
                  onPressed: () {
                    guardar_datos(context);
                  },
                  child: Text(
                    'GUARDAR',
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                    ),
                  ),
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

bool nutri1 = false;
bool nutri2 = false;
bool nutri3 = false;
bool nutri4 = false;
bool nutri5 = false;
bool nutri6 = false;
bool nutri7 = false;

bool nutri8 = false;
bool nutri9 = false;
bool nutri10 = false;

String cod_event_nutri1 = "NUTRI1";
String cod_event_nutri2 = 'NUTRI2';
String cod_event_nutri3 = 'NUTRI3';
String cod_event_nutri4 = 'NUTRI4';
String cod_event_nutri5 = 'NUTRI5';
String cod_event_nutri6 = 'NUTRI6';
String cod_event_nutri7 = 'NUTRI7';
String cod_event_nutri8 = 'NUTRI8';
String cod_event_nutri9 = "NUTRI9";
String cod_event_nutri10 = 'NUTRI10';

//--------------------------------------Consultar eventos -----------------------------------------

getAllEventos() async {
  String URL_base = Env.URL_PREFIX;
  var url = URL_base + "/eventos.php";
  var response = await http.post(url, body: {});
  print(response);
  var jsonBody = response.body;
  var data_evento = json.decode(jsonBody);
}

//-------------------------------------- NUTRICIONAL 1 -----------------------------------------------------

class LabeledCheckboxNutri1 extends StatelessWidget {
  const LabeledCheckboxNutri1({
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
                child: Text(
              label,
              style: TextStyle(
                fontFamily: 'NunitoR',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )),
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

class Nutri1 extends StatefulWidget {
  Nutri1({Key key}) : super(key: key);

  @override
  CheckNutri1WidgetState createState() => CheckNutri1WidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class CheckNutri1WidgetState extends State<Nutri1> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxNutri1(
      label:
          '??Tiene una enfermedad o malestar que le ha hecho cambiar el tipo y/o cantidad de alimento que come?',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: nutri1,
      onChanged: (bool newValue) {
        setState(() {
          nutri1 = newValue;
        });
      },
    );
  }
}

//-----------------------------------------------------------------------------------------------------------

// --------------------------------- NUTRI 2 ----------------------------------------------------

class LabeledCheckboxNutri2 extends StatelessWidget {
  const LabeledCheckboxNutri2({
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
                child: Text(
              label,
              style: TextStyle(
                fontFamily: 'NunitoR',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )),
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

class Nutri2 extends StatefulWidget {
  Nutri2({Key key}) : super(key: key);

  @override
  CheckNutri2WidgetState createState() => CheckNutri2WidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class CheckNutri2WidgetState extends State<Nutri2> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxNutri2(
      label: '??Realiza menos de dos comidas al d??a?',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: nutri2,
      onChanged: (bool newValue) {
        setState(() {
          nutri2 = newValue;
        });
      },
    );
  }
}

//-------------------------------------------NUTRI 3--------------------------------------------

class LabeledCheckboxNutri3 extends StatelessWidget {
  const LabeledCheckboxNutri3({
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
                child: Text(
              label,
              style: TextStyle(
                fontFamily: 'NunitoR',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )),
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

class Nutri3 extends StatefulWidget {
  Nutri3({Key key}) : super(key: key);

  @override
  Nutri3WidgetState createState() => Nutri3WidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class Nutri3WidgetState extends State<Nutri3> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxNutri3(
      label: '??Come poca fruta, verduras o productos l??cteos?',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: nutri3,
      onChanged: (bool newValue) {
        setState(() {
          nutri3 = newValue;
        });
      },
    );
  }
}

//------------------------------------------ NUTRI 4 -------------------------------------------

class LabeledCheckboxNutri4 extends StatelessWidget {
  const LabeledCheckboxNutri4({
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
                child: Text(
              label,
              style: TextStyle(
                fontFamily: 'NunitoR',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )),
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

class Nutri4 extends StatefulWidget {
  Nutri4({Key key}) : super(key: key);

  @override
  Nutri4WidgetState createState() => Nutri4WidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class Nutri4WidgetState extends State<Nutri4> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxNutri4(
      label: '??Toma tres vasos o m??s de vino, cerveza o licor al d??a?',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: nutri4,
      onChanged: (bool newValue) {
        setState(() {
          nutri4 = newValue;
        });
      },
    );
  }
}

//------------------------------------------NUTRI 5 ---------------------------------------

class LabeledCheckboxNutri5 extends StatelessWidget {
  const LabeledCheckboxNutri5({
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
                child: Text(
              label,
              style: TextStyle(
                fontFamily: 'NunitoR',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )),
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

class Nutri5 extends StatefulWidget {
  Nutri5({Key key}) : super(key: key);

  @override
  Nutri5WidgetState createState() => Nutri5WidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class Nutri5WidgetState extends State<Nutri5> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxNutri5(
      label:
          '??Tiene problemas en la boca o dentadura que le causan dificultad o molestias al comer ?',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: nutri5,
      onChanged: (bool newValue) {
        setState(() {
          nutri5 = newValue;
        });
      },
    );
  }
}

// ----------------------------------------NUTRI 6---------------------------------------

class LabeledCheckboxNutri6 extends StatelessWidget {
  const LabeledCheckboxNutri6({
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
                child: Text(
              label,
              style: TextStyle(
                fontFamily: 'NunitoR',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )),
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

class Nutri6 extends StatefulWidget {
  Nutri6({Key key}) : super(key: key);

  @override
  Nutri6WidgetState createState() => Nutri6WidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class Nutri6WidgetState extends State<Nutri6> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxNutri6(
      label:
          '??En  ocasiones, le falta dinero para comprar la comida que necesita?',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: nutri6,
      onChanged: (bool newValue) {
        setState(() {
          nutri6 = newValue;
        });
      },
    );
  }
}

// ---------------------------------------- NUTRI 7 -----------------------------------

class LabeledCheckboxNutri7 extends StatelessWidget {
  const LabeledCheckboxNutri7({
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
                child: Text(
              label,
              style: TextStyle(
                fontFamily: 'NunitoR',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )),
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

class Nutri7 extends StatefulWidget {
  Nutri7({Key key}) : super(key: key);

  @override
  Nutri7WidgetState createState() => Nutri7WidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class Nutri7WidgetState extends State<Nutri7> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxNutri7(
      label: '??Come s??lo la mayor??a de las veces?',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: nutri7,
      onChanged: (bool newValue) {
        setState(() {
          nutri7 = newValue;
        });
      },
    );
  }
}

// -----------------------------------------NUTRI 8 -----------------------------------------------------
class LabeledCheckboxNutri8 extends StatelessWidget {
  const LabeledCheckboxNutri8({
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
                child: Text(
              label,
              style: TextStyle(
                fontFamily: 'NunitoR',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )),
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

class Nutri8 extends StatefulWidget {
  Nutri8({Key key}) : super(key: key);

  @override
  Nutri8WidgetState createState() => Nutri8WidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class Nutri8WidgetState extends State<Nutri8> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxNutri8(
      label: '??Toma 2 vasos o menos de agua o l??quido por d??a?',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: nutri8,
      onChanged: (bool newValue) {
        setState(() {
          nutri8 = newValue;
        });
      },
    );
  }
}

//-------------------------------------------- NUTRI 9 -----------------------------------------------------------

class LabeledCheckboxNutri9 extends StatelessWidget {
  const LabeledCheckboxNutri9({
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
                child: Text(
              label,
              style: TextStyle(
                fontFamily: 'NunitoR',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )),
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

class Nutri9 extends StatefulWidget {
  Nutri9({Key key}) : super(key: key);

  @override
  Nutri9WidgetState createState() => Nutri9WidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class Nutri9WidgetState extends State<Nutri9> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxNutri9(
      label:
          '??Ha perdido o ganado (sin querer)  5 kg de peso en los ??ltimos  seis meses?',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: nutri9,
      onChanged: (bool newValue) {
        setState(() {
          nutri9 = newValue;
        });
      },
    );
  }
}

// -------------------------------------------NUTRI 10 --------------------------------------------
class LabeledCheckboxNutri10 extends StatelessWidget {
  const LabeledCheckboxNutri10({
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
                child: Text(
              label,
              style: TextStyle(
                fontFamily: 'NunitoR',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )),
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

class Nutri10 extends StatefulWidget {
  Nutri10({Key key}) : super(key: key);

  @override
  Nutri10WidgetState createState() => Nutri10WidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class Nutri10WidgetState extends State<Nutri10> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxNutri10(
      label:
          '??Cree que tiene m??s problemas de nutri10 que la mayor??a de la gente?',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: nutri10,
      onChanged: (bool newValue) {
        setState(() {
          nutri10 = newValue;
        });
      },
    );
  }
}
