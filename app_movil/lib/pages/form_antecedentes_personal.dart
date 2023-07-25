import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'env.dart';
import 'package:app_salud/pages/ajustes.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define a custom Form widget.
class FormAntecedentesPersonales extends StatefulWidget {
  final pageName = 'form_antecedentes_personales';

  @override
  _FormpruebaState createState() => _FormpruebaState();
}

class _FormpruebaState extends State<FormAntecedentesPersonales> {
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

  @override
  Widget build(BuildContext context) {
    //Map parametros = ModalRoute.of(context).settings.arguments;
    //email = parametros["email"];
    //email = "fabricio@gmail.com";

    read_datos_paciente();

    return FutureBuilder(
        future: read_datos_paciente(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print(snapshot.connectionState);

          if (snapshot.hasData) {
            return Antecedentes();
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Center(
                  child: Text(
                    'Agregar \nAntecedentes Personales',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                    ),
                  ),
                ),
                backgroundColor: Theme.of(context).primaryColor,
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

var email;

getStringValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String email_prefer = prefs.getString("email");
  email = email_prefer;
  print(email);
}

guardar_datos(BuildContext context) async {
  String URL_base = Env.URL_API;
  var url = URL_base + "/save_antec_personales";
  var response = await http.post(url, body: {
    "email": email,
    "retraso": retraso.toString(),
    "desorden": desorden.toString(),
    "deficit": deficit.toString(),
    "lesiones_cabeza": lesiones_cabeza.toString(),
    "perdidas": perdidas.toString(),
    "accidentes_caidas": accidentes_caidas.toString(),
    "lesiones_espalda": lesiones_espalda.toString(),
    "infecciones": infecciones.toString(),
    "toxinas": toxinas.toString(),
    "acv": acv.toString(),
    "demencia": demencia.toString(),
    "parkinson": parkinson.toString(),
    "epilepsia": epilepsia.toString(),
    "esclerosis": esclerosis.toString(),
    "huntington": huntington.toString(),
    "depresion": depresion.toString(),
    "trastorno": trastorno.toString(),
    "esquizofrenia": esquizofrenia.toString(),
    "enfermedad_desorden": enfermedad_desorden.toString(),
    "intoxicaciones": intoxicaciones.toString(),
    "cod_event_retraso": cod_event_retraso,
    "cod_event_desorden": cod_event_desorden,
    "cod_event_deficit": cod_event_deficit,
    "cod_event_lesiones_cabeza": cod_event_lesiones_cabeza,
    "cod_event_perdidas": cod_event_perdidas,
    "cod_event_accidentes_caidas": cod_event_accidentes_caidas,
    "cod_event_lesiones_espalda": cod_event_lesiones_espalda,
    "cod_event_infecciones": cod_event_infecciones,
    "cod_event_toxinas": cod_event_toxinas,
    "cod_event_acv": cod_event_acv,
    "cod_event_demencia": cod_event_demencia,
    "cod_event_parkinson": cod_event_parkinson,
    "cod_event_epilepsia": cod_event_epilepsia,
    "cod_event_esclerosis": cod_event_esclerosis,
    "cod_event_huntington": cod_event_huntington,
    "cod_event_depresion": cod_event_depresion,
    "cod_event_trastorno": cod_event_trastorno,
    "cod_event_esquizofrenia": cod_event_esquizofrenia,
    "cod_event_enfermedad_desorden": cod_event_enfermedad_desorden,
    "cod_event_intoxicaciones": cod_event_intoxicaciones,
  });

  var responseDecoder = json.decode(response.body);
  if (response.statusCode == 200) {
    if (responseDecoder["status"] == "Success") {
      _alert_informe(context, "Antecedentes Guardados", 1);
      Navigator.of(context).pushReplacementNamed('/antecedentes_personales');
    }
  }
}

_alert_informe(context, message, colorNumber) {
  var color;
  colorNumber == 1 ? color = Colors.green[800] : color = Colors.red[600];

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: color,
    content: Text(message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white)),
  ));
}

read_datos_paciente() async {
  await getStringValuesSF();

  String URL_base = Env.URL_API;
  var url = URL_base + "/user_read_antc_personales";
  var response = await http.post(url, body: {
    "email": email,
    "cod_event_retraso": cod_event_retraso,
    "cod_event_desorden": cod_event_desorden,
    "cod_event_deficit": cod_event_deficit,
    "cod_event_lesiones_cabeza": cod_event_lesiones_cabeza,
    "cod_event_perdidas": cod_event_perdidas,
    "cod_event_accidentes_caidas": cod_event_accidentes_caidas,
    "cod_event_lesiones_espalda": cod_event_lesiones_espalda,
    "cod_event_infecciones": cod_event_infecciones,
    "cod_event_toxinas": cod_event_toxinas,
    "cod_event_acv": cod_event_acv,
    "cod_event_demencia": cod_event_demencia,
    "cod_event_parkinson": cod_event_parkinson,
    "cod_event_epilepsia": cod_event_epilepsia,
    "cod_event_esclerosis": cod_event_esclerosis,
    "cod_event_huntington": cod_event_huntington,
    "cod_event_depresion": cod_event_depresion,
    "cod_event_trastorno": cod_event_trastorno,
    "cod_event_esquizofrenia": cod_event_esquizofrenia,
    "cod_event_enfermedad_desorden": cod_event_enfermedad_desorden,
    "cod_event_intoxicaciones": cod_event_intoxicaciones,
  });

  //print(response.body);
  var responseData = json.decode(response.body);

  if (responseData["status"] == "Success") {
    var data = responseData['data'];

    retraso = data["retraso"] == "1" ? true : false;

    desorden = data["desorden"] == "1" ? true : false;

    deficit = data["deficit"] == "1" ? true : false;

    lesiones_cabeza = data["lesiones_cabeza"] == "1" ? true : false;

    perdidas = data["perdidas"] == "1" ? true : false;

    accidentes_caidas = data["accidentes_caidas"] == "1" ? true : false;

    lesiones_espalda = data["lesiones_espalda"] == "1" ? true : false;

    infecciones = data["infecciones"] == "1" ? true : false;

    toxinas = data["toxinas"] == "1" ? true : false;

    acv = data["acv"] == "1" ? true : false;

    demencia = data["demencia"] == "1" ? true : false;

    parkinson = data["parkinson"] == "1" ? true : false;

    epilepsia = data["epilepsia"] == "1" ? true : false;

    esclerosis = data["esclerosis"] == "1" ? true : false;

    huntington = data["huntington"] == "1" ? true : false;

    depresion = data["depresion"] == "1" ? true : false;

    trastorno = data["trastorno"] == "1" ? true : false;

    esquizofrenia = data["esquizofrenia"] == "1" ? true : false;

    enfermedad_desorden = data["enfermedad_desorden"] == "1" ? true : false;

    intoxicaciones = data["intoxicaciones"] == "1" ? true : false;
  } else {
    //loginToast(data);
  }

  //await new Future.delayed(new Duration(milliseconds: 1500));

  return true;
}

//----------------------------------------ANTECEDENTES PERSONALES ------------------------------------------

class Antecedentes extends StatefulWidget {
  Antecedentes({Key key}) : super(key: key);

  @override
  AntecedentesWidgetState createState() => AntecedentesWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class AntecedentesWidgetState extends State<Antecedentes> {
  final _formKey_antecedentes_familiares = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
              Navigator.pushNamed(context, '/menu');
            },
          ),
          backgroundColor: Theme.of(context).primaryColor,
          title: Center(
            child: Text(
              'Agregar \nAntecedentes Personales',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
              ),
            ),
          ),
        ),
        body: Form(
          key: _formKey_antecedentes_familiares,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: <Widget>[
                CheckRetrasoMental(),
                CheckDesorHabla(),
                DeficitAtencion(),
                LesionCabeza(),
                PerdidaConocimiento(),
                AccidentesCaidasGolpes(),
                Lesiones(),
                Infecciones(),
                Acv(),
                Demencia(),
                Parkinzon(),
                Epilepsia(),
                Esclerosis(),
                Huntington(),
                Depresion(),
                TrastornoBipolar(),
                Esquizofrenia(),
                EnfermedadDesordenGrave(),
                Intoxicaciones(),
                SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    guardar_datos(context);
                  },
                  child: Text('Guardar Antecedentes',
                      style: TextStyle(
                          fontFamily:
                              Theme.of(context).textTheme.headline1.fontFamily,
                          fontWeight: FontWeight.bold)),
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

bool retraso = false;
bool desorden = false;
bool deficit = false;
bool lesiones_cabeza = false;
bool perdidas = false;
bool accidentes_caidas = false;
bool lesiones_espalda = false;
bool infecciones = false;
bool toxinas = false;
bool acv = false;
bool demencia = false;
bool parkinson = false;
bool epilepsia = false;
bool esclerosis = false;
bool huntington = false;
bool depresion = false;
bool trastorno = false;
bool esquizofrenia = false;
bool enfermedad_desorden = false;
bool intoxicaciones = false;

String cod_event_retraso = "RM";
String cod_event_desorden = 'DH';
String cod_event_deficit = 'DA';
String cod_event_lesiones_cabeza = 'LC';
String cod_event_perdidas = 'PC';
String cod_event_accidentes_caidas = 'ACG';
String cod_event_lesiones_espalda = 'LEC';
String cod_event_infecciones = "IPO";
String cod_event_toxinas = 'ETOX';
String cod_event_acv = 'ACV';
String cod_event_demencia = 'DEM';
String cod_event_parkinson = 'PARK';
String cod_event_epilepsia = 'EPIL';
String cod_event_esclerosis = 'EM';
String cod_event_huntington = 'HUNG';
String cod_event_depresion = 'DEPRE';
String cod_event_trastorno = 'TB';
String cod_event_esquizofrenia = 'ESQ';
String cod_event_enfermedad_desorden = 'EDG';
String cod_event_intoxicaciones = 'INTOX';

//-------------------------------------- RETRASO MENTAL -----------------------------------------------------

class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
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
                            Theme.of(context).textTheme.headline1.fontFamily))),
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

class CheckRetrasoMental extends StatefulWidget {
  CheckRetrasoMental({Key key}) : super(key: key);

  @override
  CheckRetrasoMentalWidgetState createState() =>
      CheckRetrasoMentalWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class CheckRetrasoMentalWidgetState extends State<CheckRetrasoMental> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckbox(
      label: 'Retraso Mental',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: retraso,
      onChanged: (bool newValue) {
        setState(() {
          retraso = newValue;
        });
      },
    );
  }
}

//-----------------------------------------------------------------------------------------------------------

// --------------------------------- DESORDEN DEL HABLA ----------------------------------------------------

class LabeledCheckboxHabla extends StatelessWidget {
  const LabeledCheckboxHabla({
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
                            Theme.of(context).textTheme.headline1.fontFamily))),
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

class CheckDesorHabla extends StatefulWidget {
  CheckDesorHabla({Key key}) : super(key: key);

  @override
  CheckDesorHablaWidgetState createState() => CheckDesorHablaWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class CheckDesorHablaWidgetState extends State<CheckDesorHabla> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxHabla(
      label: 'Desorden del habla',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: desorden,
      onChanged: (bool newValue) {
        setState(() {
          desorden = newValue;
        });
      },
    );
  }
}

//-------------------------------------------DEFICIT DE ATENCION--------------------------------------------

class LabeledCheckboxDeficit extends StatelessWidget {
  const LabeledCheckboxDeficit({
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
                            Theme.of(context).textTheme.headline1.fontFamily))),
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

class DeficitAtencion extends StatefulWidget {
  DeficitAtencion({Key key}) : super(key: key);

  @override
  DeficitAtencionWidgetState createState() => DeficitAtencionWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class DeficitAtencionWidgetState extends State<DeficitAtencion> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxDeficit(
      label: 'Déficit de atención',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: deficit,
      onChanged: (bool newValue) {
        setState(() {
          deficit = newValue;
        });
      },
    );
  }
}

//------------------------------------------LESIONES EN LA CABEZA -------------------------------------------

class LabeledCheckboxLesCab extends StatelessWidget {
  const LabeledCheckboxLesCab({
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
                            Theme.of(context).textTheme.headline1.fontFamily))),
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

class LesionCabeza extends StatefulWidget {
  LesionCabeza({Key key}) : super(key: key);

  @override
  LesionCabezaWidgetState createState() => LesionCabezaWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class LesionCabezaWidgetState extends State<LesionCabeza> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxLesCab(
      label: 'Lesiones en la cabeza',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: lesiones_cabeza,
      onChanged: (bool newValue) {
        setState(() {
          lesiones_cabeza = newValue;
        });
      },
    );
  }
}

//------------------------------------------PERDIDAS DE CONOCIMIENTO ---------------------------------------

class LabeledCheckboxPerdCon extends StatelessWidget {
  const LabeledCheckboxPerdCon({
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
                            Theme.of(context).textTheme.headline1.fontFamily))),
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

class PerdidaConocimiento extends StatefulWidget {
  PerdidaConocimiento({Key key}) : super(key: key);

  @override
  PerdidaConocimientoWidgetState createState() =>
      PerdidaConocimientoWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class PerdidaConocimientoWidgetState extends State<PerdidaConocimiento> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxPerdCon(
      label: 'Perdida del conocimiento',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: perdidas,
      onChanged: (bool newValue) {
        setState(() {
          perdidas = newValue;
        });
      },
    );
  }
}

// ----------------------------------------ACCIDENTES, CAIDAS Y GOLPES ---------------------------------------

class LabeledCheckboxAccCaiGol extends StatelessWidget {
  const LabeledCheckboxAccCaiGol({
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
                            Theme.of(context).textTheme.headline1.fontFamily))),
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

class AccidentesCaidasGolpes extends StatefulWidget {
  AccidentesCaidasGolpes({Key key}) : super(key: key);

  @override
  AccidentesCaidasGolpesWidgetState createState() =>
      AccidentesCaidasGolpesWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class AccidentesCaidasGolpesWidgetState extends State<AccidentesCaidasGolpes> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxAccCaiGol(
      label: 'Accidentes, Caidas y Golpes',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: accidentes_caidas,
      onChanged: (bool newValue) {
        setState(() {
          accidentes_caidas = newValue;
        });
      },
    );
  }
}

// ----------------------------------------LESIONES EN LA ESPALDA O CUELLO -----------------------------------

class LabeledCheckboxLesEspalCuello extends StatelessWidget {
  const LabeledCheckboxLesEspalCuello({
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
                            Theme.of(context).textTheme.headline1.fontFamily))),
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

class Lesiones extends StatefulWidget {
  Lesiones({Key key}) : super(key: key);

  @override
  LesionesWidgetState createState() => LesionesWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class LesionesWidgetState extends State<Lesiones> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxLesEspalCuello(
      label: 'Lesiones en la espalda o cuello',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: lesiones_espalda,
      onChanged: (bool newValue) {
        setState(() {
          lesiones_espalda = newValue;
        });
      },
    );
  }
}

// -----------------------------------------INFECCIONES -----------------------------------------------------
class LabeledCheckboxInfecciones extends StatelessWidget {
  const LabeledCheckboxInfecciones({
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
                            Theme.of(context).textTheme.headline1.fontFamily))),
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

class Infecciones extends StatefulWidget {
  Infecciones({Key key}) : super(key: key);

  @override
  InfeccionesWidgetState createState() => InfeccionesWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class InfeccionesWidgetState extends State<Infecciones> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxInfecciones(
      label: 'Infecciones(meningitis,encefalitis)/privación de oxígeno',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: infecciones,
      onChanged: (bool newValue) {
        setState(() {
          infecciones = newValue;
        });
      },
    );
  }
}

//--------------------------------------------ACV -----------------------------------------------------------

class LabeledCheckboxAcv extends StatelessWidget {
  const LabeledCheckboxAcv({
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
                            Theme.of(context).textTheme.headline1.fontFamily))),
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

class Acv extends StatefulWidget {
  Acv({Key key}) : super(key: key);

  @override
  AcvWidgetState createState() => AcvWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class AcvWidgetState extends State<Acv> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxAcv(
      label: 'Accidente Cerebrovascular (ACV)',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: acv,
      onChanged: (bool newValue) {
        setState(() {
          acv = newValue;
        });
      },
    );
  }
}

// -------------------------------------------EXPOSICION A TOXINAS --------------------------------------------
class LabeledCheckboxTox extends StatelessWidget {
  const LabeledCheckboxTox({
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
                            Theme.of(context).textTheme.headline1.fontFamily))),
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

class Exposicion extends StatefulWidget {
  Exposicion({Key key}) : super(key: key);

  @override
  ExposicionWidgetState createState() => ExposicionWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class ExposicionWidgetState extends State<Exposicion> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxTox(
      label: 'Exposición a toxinas (plomo, solventes, químicos, etc.)',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: toxinas,
      onChanged: (bool newValue) {
        setState(() {
          toxinas = newValue;
        });
      },
    );
  }
}

// ------------------------------------------DEMENCIAS ---------------------------------------------------
class LabeledCheckboxDemencia extends StatelessWidget {
  const LabeledCheckboxDemencia({
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
                            Theme.of(context).textTheme.headline1.fontFamily))),
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

class Demencia extends StatefulWidget {
  Demencia({Key key}) : super(key: key);

  @override
  DemenciaWidgetState createState() => DemenciaWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class DemenciaWidgetState extends State<Demencia> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxDemencia(
      label: 'Demencias (ejemplo Alzheimer)',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: demencia,
      onChanged: (bool newValue) {
        setState(() {
          demencia = newValue;
        });
      },
    );
  }
}
//-------------------------------------------- PARKINSON---------------------------------------------------

class LabeledCheckboxParkinson extends StatelessWidget {
  const LabeledCheckboxParkinson({
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
                            Theme.of(context).textTheme.headline1.fontFamily))),
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

class Parkinzon extends StatefulWidget {
  Parkinzon({Key key}) : super(key: key);

  @override
  ParkinzonWidgetState createState() => ParkinzonWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class ParkinzonWidgetState extends State<Parkinzon> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxParkinson(
      label: 'Parkinson',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: parkinson,
      onChanged: (bool newValue) {
        setState(() {
          parkinson = newValue;
        });
      },
    );
  }
}
//------------------------------------------EPILEPSIA --------------------------------------------------

class LabeledCheckboxEpilepsia extends StatelessWidget {
  const LabeledCheckboxEpilepsia({
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
                            Theme.of(context).textTheme.headline1.fontFamily))),
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

class Epilepsia extends StatefulWidget {
  Epilepsia({Key key}) : super(key: key);

  @override
  EpilepsiaWidgetState createState() => EpilepsiaWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class EpilepsiaWidgetState extends State<Epilepsia> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxEpilepsia(
      label: 'Epilepsia',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: epilepsia,
      onChanged: (bool newValue) {
        setState(() {
          epilepsia = newValue;
        });
      },
    );
  }
}
//-------------------------------------------- ESCLEROSIS -------------------------------------------------

class LabeledCheckboxEsclerosis extends StatelessWidget {
  const LabeledCheckboxEsclerosis({
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
                            Theme.of(context).textTheme.headline1.fontFamily))),
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

class Esclerosis extends StatefulWidget {
  Esclerosis({Key key}) : super(key: key);

  @override
  EsclerosisWidgetState createState() => EsclerosisWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class EsclerosisWidgetState extends State<Esclerosis> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxEsclerosis(
      label: 'Esclerosis múltiple',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: esclerosis,
      onChanged: (bool newValue) {
        setState(() {
          esclerosis = newValue;
        });
      },
    );
  }
}

// --------------------------------------------HUNTINGTON ------------------------------------------------
class LabeledCheckboxHun extends StatelessWidget {
  const LabeledCheckboxHun({
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
                            Theme.of(context).textTheme.headline1.fontFamily))),
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

class Huntington extends StatefulWidget {
  Huntington({Key key}) : super(key: key);

  @override
  HuntingtonWidgetState createState() => HuntingtonWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class HuntingtonWidgetState extends State<Huntington> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxHun(
      label: 'Huntington',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: huntington,
      onChanged: (bool newValue) {
        setState(() {
          huntington = newValue;
        });
      },
    );
  }
}
// --------------------------------------------DEPRESION -------------------------------------------------

class LabeledCheckboxDepresion extends StatelessWidget {
  const LabeledCheckboxDepresion({
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
                            Theme.of(context).textTheme.headline1.fontFamily))),
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

class Depresion extends StatefulWidget {
  Depresion({Key key}) : super(key: key);

  @override
  DepresionWidgetState createState() => DepresionWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class DepresionWidgetState extends State<Depresion> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxDepresion(
      label: 'Depresión',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: depresion,
      onChanged: (bool newValue) {
        setState(() {
          depresion = newValue;
        });
      },
    );
  }
}
// --------------------------------------------TRASTORNO BIPOLAR -----------------------------------------

class LabeledCheckboxBipolar extends StatelessWidget {
  const LabeledCheckboxBipolar({
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
                            Theme.of(context).textTheme.headline1.fontFamily))),
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

class TrastornoBipolar extends StatefulWidget {
  TrastornoBipolar({Key key}) : super(key: key);

  @override
  TrastornoBipolarWidgetState createState() => TrastornoBipolarWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class TrastornoBipolarWidgetState extends State<TrastornoBipolar> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxBipolar(
      label: 'Trastorno bipolar',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: trastorno,
      onChanged: (bool newValue) {
        setState(() {
          trastorno = newValue;
        });
      },
    );
  }
}
// --------------------------------------------ESQUISOFRENIA ---------------------------------------------

class LabeledCheckboxEsqui extends StatelessWidget {
  const LabeledCheckboxEsqui({
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
                            Theme.of(context).textTheme.headline1.fontFamily))),
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

class Esquizofrenia extends StatefulWidget {
  Esquizofrenia({Key key}) : super(key: key);

  @override
  EsquizofreniaWidgetState createState() => EsquizofreniaWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class EsquizofreniaWidgetState extends State<Esquizofrenia> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckbox(
      label: 'Esquizofrenia',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: esquizofrenia,
      onChanged: (bool newValue) {
        setState(() {
          esquizofrenia = newValue;
        });
      },
    );
  }
}

//---------------------------------------------ENFERMEDAD O DESORDEN DEL GRAVE ----------------------------
class LabeledCheckboxEnfDeso extends StatelessWidget {
  const LabeledCheckboxEnfDeso({
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
                            Theme.of(context).textTheme.headline1.fontFamily))),
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

class EnfermedadDesordenGrave extends StatefulWidget {
  EnfermedadDesordenGrave({Key key}) : super(key: key);

  @override
  EnfermedadDesordenGraveWidgetState createState() =>
      EnfermedadDesordenGraveWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class EnfermedadDesordenGraveWidgetState
    extends State<EnfermedadDesordenGrave> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxEnfDeso(
      label:
          'Enfermedad o desorden grave (inmunológico, parálisis cerebral, polio, pulmones, etc.)',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: enfermedad_desorden,
      onChanged: (bool newValue) {
        setState(() {
          enfermedad_desorden = newValue;
        });
      },
    );
  }
}
//---------------------------------------------INTOXICACIONES ---------------------------------------------

class LabeledCheckboxIntox extends StatelessWidget {
  const LabeledCheckboxIntox({
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
                            Theme.of(context).textTheme.headline1.fontFamily))),
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

class Intoxicaciones extends StatefulWidget {
  Intoxicaciones({Key key}) : super(key: key);

  @override
  IntoxicacionesWidgetState createState() => IntoxicacionesWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class IntoxicacionesWidgetState extends State<Intoxicaciones> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxIntox(
      label: 'Intoxicaciones',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: intoxicaciones,
      onChanged: (bool newValue) {
        setState(() {
          intoxicaciones = newValue;
        });
      },
    );
  }
}
