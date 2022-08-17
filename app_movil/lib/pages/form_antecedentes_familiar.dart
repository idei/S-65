import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'env.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define a custom Form widget.
class FormAntecedentesFamiliares extends StatefulWidget {
  final pageName = 'form_antecedentes_familiares';

  @override
  _FormpruebaState createState() => _FormpruebaState();
}

// Define a corresponding State class.
// This class holds data related to the Form.
class _FormpruebaState extends State<FormAntecedentesFamiliares> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getStringValuesSF();
    myController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    myController.dispose();
    super.dispose();
  }

  _printLatestValue() {
    print("Second text field: ${myController.text}");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: read_datos_paciente(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print(snapshot.connectionState);

          if (snapshot.hasData) {
            return AntecedentesFam();
          } else {
            var email_prefer;
            Map parametros = ModalRoute.of(context).settings.arguments;
            if (parametros != null) {
              email_prefer = parametros['email'];
            } else {
              getStringValuesSF();
            }
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Antecedentes Familiares',
                  style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 19.0),
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

var email;

getStringValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String email_prefer = prefs.getString("email_prefer");
  //var estado_clinico_prefer = prefs.getString("estado_clinico");
  email = email_prefer;
  print(email);
}

var response = null;

guardar_datos(BuildContext context) async {
  String URL_base = Env.URL_PREFIX;
  var url = URL_base + "/user_antec_familiares.php";
  response = await http.post(url, body: {
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
    "cancer": cancer.toString(),
    "cirujia": cirujia.toString(),
    "trasplante": trasplante.toString(),
    "hipotiroidismo": hipotiroidismo.toString(),
    "cardiologico": cardiologico.toString(),
    "diabetes": diabetes.toString(),
    "hipertension": hipertension.toString(),
    "colesterol": colesterol.toString(),
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
    "cod_event_cancer": cod_event_cancer,
    "cod_event_cirujia": cod_event_cirujia,
    "cod_event_trasplante": cod_event_trasplante,
    "cod_event_hipotiroidismo": cod_event_hipotiroidismo,
    "cod_event_cardiologico": cod_event_cardiologico,
    "cod_event_diabetes": cod_event_diabetes,
    "cod_event_hipertension": cod_event_hipertension,
    "cod_event_colesterol": cod_event_colesterol,
  });

  print(response.body);
  if (response.body == '"Success"') {
    _alert_informe(context, "Antecedentes Guardados", 1);
    Navigator.pushNamed(context, '/antecedentes_familiares');
  }
}

Future read_datos_paciente() async {
  await getStringValuesSF();
  String URL_base = Env.URL_PREFIX;
  var url = URL_base + "/user_read_antc_familiares.php";
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
    "cod_event_cancer": cod_event_cancer,
    "cod_event_cirujia": cod_event_cirujia,
    "cod_event_trasplante": cod_event_trasplante,
    "cod_event_hipotiroidismo": cod_event_hipotiroidismo,
    "cod_event_cardiologico": cod_event_cardiologico,
    "cod_event_diabetes": cod_event_diabetes,
    "cod_event_hipertension": cod_event_hipertension,
    "cod_event_colesterol": cod_event_colesterol,
  });

  var data = json.decode(response.body);

  if (data["estado"] == "Success") {
    if (data["retraso"] == 1) {
      retraso = true;
    } else {
      retraso = false;
    }

    if (data["desorden"] == 1) {
      desorden = true;
    } else {
      desorden = false;
    }

    if (data["deficit"] == 1) {
      deficit = true;
    } else {
      deficit = false;
    }

    if (data["lesiones_cabeza"] == 1) {
      lesiones_cabeza = true;
    } else {
      lesiones_cabeza = false;
    }

    if (data["perdidas"] == 1) {
      perdidas = true;
    } else {
      perdidas = false;
    }

    if (data["accidentes_caidas"] == 1) {
      accidentes_caidas = true;
    } else {
      accidentes_caidas = false;
    }

    if (data["lesiones_espalda"] == 1) {
      lesiones_espalda = true;
    } else {
      lesiones_espalda = false;
    }

    if (data["infecciones"] == 1) {
      infecciones = true;
    } else {
      infecciones = false;
    }

    if (data["toxinas"] == 1) {
      toxinas = true;
    } else {
      toxinas = false;
    }

    if (data["acv"] == 1) {
      acv = true;
    } else {
      acv = false;
    }

    if (data["demencia"] == 1) {
      demencia = true;
    } else {
      demencia = false;
    }

    if (data["parkinson"] == 1) {
      parkinson = true;
    } else {
      parkinson = false;
    }

    if (data["epilepsia"] == 1) {
      epilepsia = true;
    } else {
      epilepsia = false;
    }

    if (data["esclerosis"] == 1) {
      esclerosis = true;
    } else {
      esclerosis = false;
    }

    if (data["huntington"] == 1) {
      huntington = true;
    } else {
      huntington = false;
    }

    if (data["depresion"] == 1) {
      depresion = true;
    } else {
      depresion = false;
    }

    if (data["trastorno"] == 1) {
      trastorno = true;
    } else {
      trastorno = false;
    }

    if (data["esquizofrenia"] == 1) {
      esquizofrenia = true;
    } else {
      esquizofrenia = false;
    }

    if (data["enfermedad_desorden"] == 1) {
      enfermedad_desorden = true;
    } else {
      enfermedad_desorden = false;
    }

    if (data["intoxicaciones"] == 1) {
      intoxicaciones = true;
    } else {
      intoxicaciones = false;
    }

    if (data["cancer"] == 1) {
      cancer = true;
    } else {
      cancer = false;
    }

    if (data["cirujia"] == 1) {
      cirujia = true;
    } else {
      cirujia = false;
    }

    if (data["trasplante"] == 1) {
      trasplante = true;
    } else {
      trasplante = false;
    }

    if (data["hipotiroidismo"] == 1) {
      hipotiroidismo = true;
    } else {
      hipotiroidismo = false;
    }

    if (data["cardiologico"] == 1) {
      cardiologico = true;
    } else {
      cardiologico = false;
    }

    if (data["diabetes"] == 1) {
      diabetes = true;
    } else {
      diabetes = false;
    }

    if (data["hipertension"] == 1) {
      hipertension = true;
    } else {
      hipertension = false;
    }

    if (data["colesterol"] == 1) {
      colesterol = true;
    } else {
      colesterol = false;
    }

    await new Future.delayed(new Duration(milliseconds: 500));
  } else {
    //loginToast(data);
  }
  return true;
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

//--------------------------------- Antecedentes Familiares --------------------------

class AntecedentesFam extends StatefulWidget {
  AntecedentesFam({Key key}) : super(key: key);

  @override
  AntecedentesFamWidgetState createState() => AntecedentesFamWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class AntecedentesFamWidgetState extends State<AntecedentesFam> {
  final _formKey_antecedentes_familiares = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var email_prefer;
    Map parametros = ModalRoute.of(context).settings.arguments;
    if (parametros != null) {
      email_prefer = parametros['email'];
    } else {
      getStringValuesSF();
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Antecedentes Familiares',
            style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
                fontSize: 19.0),
          ),
          //backgroundColor: Color.fromRGBO(157, 19, 34, 1),
          backgroundColor: Theme.of(context).primaryColor,
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
          key: _formKey_antecedentes_familiares,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: <Widget>[
                CheckRetrasoMental(),
                SizedBox(height: 10),
                CheckDesorHabla(),
                SizedBox(height: 10),
                DeficitAtencion(),
                SizedBox(height: 10),
                LesionCabeza(),
                SizedBox(height: 10),
                PerdidaConocimiento(),
                SizedBox(height: 10),
                AccidentesCaidasGolpes(),
                SizedBox(height: 10),
                Lesiones(),
                SizedBox(height: 10),
                Infecciones(),
                SizedBox(height: 10),
                Acv(),
                SizedBox(height: 10),
                Demencia(),
                SizedBox(height: 10),
                Parkinzon(),
                SizedBox(height: 10),
                Epilepsia(),
                SizedBox(height: 10),
                Esclerosis(),
                SizedBox(height: 10),
                Huntington(),
                SizedBox(height: 10),
                Depresion(),
                SizedBox(height: 10),
                TrastornoBipolar(),
                SizedBox(height: 10),
                Esquizofrenia(),
                SizedBox(height: 10),
                EnfermedadDesordenGrave(),
                SizedBox(height: 10),
                Intoxicaciones(),
                SizedBox(height: 30),
                Cancer(),
                SizedBox(height: 30),
                Cirujias(),
                SizedBox(height: 30),
                TransplanteCornea(),
                SizedBox(height: 30),
                Hipotiroidismo(),
                SizedBox(height: 30),
                EnfermedadesCardiologicas(),
                SizedBox(height: 30),
                Diabetes(),
                SizedBox(height: 30),
                HipertensionArterial(),
                SizedBox(height: 30),
                Colesterol(),
                SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    guardar_datos(context);
                  },
                  child: Text(
                    'Guardar Antecedentes',
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
      print('Salir');
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
bool cancer = false;
bool cirujia = false;
bool trasplante = false;
bool hipotiroidismo = false;
bool cardiologico = false;
bool diabetes = false;
bool hipertension = false;
bool colesterol = false;

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
String cod_event_cancer = 'CAN';
String cod_event_cirujia = 'CIR';
String cod_event_trasplante = 'TRAS';
String cod_event_hipotiroidismo = 'HIPO';
String cod_event_cardiologico = 'CARD';
String cod_event_diabetes = 'DIAB';
String cod_event_hipertension = 'HIPER';
String cod_event_colesterol = 'COL';

//--------------------------------------Consultar eventos -----------------------------------------

getAllEventos() async {
  String URL_base = Env.URL_PREFIX;
  var url = URL_base + "/eventos.php";
  var response = await http.post(url, body: {});
  print(response);
  var jsonBody = response.body;
  var data_evento = json.decode(jsonBody);
}

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
                child: Text(label, style: TextStyle(fontFamily: 'NunitoR'))),
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
                child: Text(label, style: TextStyle(fontFamily: 'NunitoR'))),
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
                child: Text(label, style: TextStyle(fontFamily: 'NunitoR'))),
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
                child: Text(label, style: TextStyle(fontFamily: 'NunitoR'))),
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
                child: Text(label, style: TextStyle(fontFamily: 'NunitoR'))),
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
                child: Text(label, style: TextStyle(fontFamily: 'NunitoR'))),
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
                child: Text(label, style: TextStyle(fontFamily: 'NunitoR'))),
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
                child: Text(label, style: TextStyle(fontFamily: 'NunitoR'))),
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
                child: Text(label, style: TextStyle(fontFamily: 'NunitoR'))),
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
                child: Text(label, style: TextStyle(fontFamily: 'NunitoR'))),
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
                child: Text(label, style: TextStyle(fontFamily: 'NunitoR'))),
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
                child: Text(label, style: TextStyle(fontFamily: 'NunitoR'))),
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
                child: Text(label, style: TextStyle(fontFamily: 'NunitoR'))),
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
                child: Text(label, style: TextStyle(fontFamily: 'NunitoR'))),
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
                child: Text(label, style: TextStyle(fontFamily: 'NunitoR'))),
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
                child: Text(label, style: TextStyle(fontFamily: 'NunitoR'))),
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
                child: Text(label, style: TextStyle(fontFamily: 'NunitoR'))),
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
                child: Text(label, style: TextStyle(fontFamily: 'NunitoR'))),
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
                child: Text(label, style: TextStyle(fontFamily: 'NunitoR'))),
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
                child: Text(label, style: TextStyle(fontFamily: 'NunitoR'))),
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

// --------------------------------- CANCER ----------------------------------------------------

class LabeledCheckboxCancer extends StatelessWidget {
  const LabeledCheckboxCancer({
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
                child: Text(label, style: TextStyle(fontFamily: 'NunitoR'))),
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

class Cancer extends StatefulWidget {
  Cancer({Key key}) : super(key: key);

  @override
  CancerWidgetState createState() => CancerWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class CancerWidgetState extends State<Cancer> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxCancer(
      label: 'Cáncer',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: cancer,
      onChanged: (bool newValue) {
        setState(() {
          cancer = newValue;
        });
      },
    );
  }
}

// --------------------------------- CIRUJIAS ----------------------------------------------------

class LabeledCheckboxCirujias extends StatelessWidget {
  const LabeledCheckboxCirujias({
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
                child: Text(label, style: TextStyle(fontFamily: 'NunitoR'))),
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

class Cirujias extends StatefulWidget {
  Cirujias({Key key}) : super(key: key);

  @override
  CirujiasWidgetState createState() => CirujiasWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class CirujiasWidgetState extends State<Cirujias> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxCirujias(
      label: 'Cirujías',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: cirujia,
      onChanged: (bool newValue) {
        setState(() {
          cirujia = newValue;
        });
      },
    );
  }
}

// --------------------------------- TRASPLANTE DE CORNEA ----------------------------------------------------

class LabeledCheckboxTrasplante extends StatelessWidget {
  const LabeledCheckboxTrasplante({
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
                child: Text(label, style: TextStyle(fontFamily: 'NunitoR'))),
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

class TransplanteCornea extends StatefulWidget {
  TransplanteCornea({Key key}) : super(key: key);

  @override
  TransplanteCorneaWidgetState createState() => TransplanteCorneaWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class TransplanteCorneaWidgetState extends State<TransplanteCornea> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxTrasplante(
      label: 'Trasplante de córnea',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: trasplante,
      onChanged: (bool newValue) {
        setState(() {
          trasplante = newValue;
        });
      },
    );
  }
}

// --------------------------------- Hipotiroidismo ----------------------------------------------------

class LabeledCheckboxHipotiroidismo extends StatelessWidget {
  const LabeledCheckboxHipotiroidismo({
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
                child: Text(label, style: TextStyle(fontFamily: 'NunitoR'))),
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

class Hipotiroidismo extends StatefulWidget {
  Hipotiroidismo({Key key}) : super(key: key);

  @override
  HipotiroidismoWidgetState createState() => HipotiroidismoWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class HipotiroidismoWidgetState extends State<Hipotiroidismo> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxHipotiroidismo(
      label: 'Hipotiroidismo/Hipertiroidismo',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: hipotiroidismo,
      onChanged: (bool newValue) {
        setState(() {
          hipotiroidismo = newValue;
        });
      },
    );
  }
}

// --------------------------------- Enfermedades Cardiológicas ----------------------------------------------------

class LabeledCheckboxCardiologica extends StatelessWidget {
  const LabeledCheckboxCardiologica({
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
                child: Text(label, style: TextStyle(fontFamily: 'NunitoR'))),
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

class EnfermedadesCardiologicas extends StatefulWidget {
  EnfermedadesCardiologicas({Key key}) : super(key: key);

  @override
  EnfermedadesCardiologicasWidgetState createState() =>
      EnfermedadesCardiologicasWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class EnfermedadesCardiologicasWidgetState
    extends State<EnfermedadesCardiologicas> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxCardiologica(
      label: 'Enfermedades Cardiológicas',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: cardiologico,
      onChanged: (bool newValue) {
        setState(() {
          cardiologico = newValue;
        });
      },
    );
  }
}

// --------------------------------- Diabetes ----------------------------------------------------

class LabeledCheckboxDiabetes extends StatelessWidget {
  const LabeledCheckboxDiabetes({
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
                child: Text(label, style: TextStyle(fontFamily: 'NunitoR'))),
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

class Diabetes extends StatefulWidget {
  Diabetes({Key key}) : super(key: key);

  @override
  DiabetesWidgetState createState() => DiabetesWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class DiabetesWidgetState extends State<Diabetes> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxDiabetes(
      label: 'Diabetes',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: diabetes,
      onChanged: (bool newValue) {
        setState(() {
          diabetes = newValue;
        });
      },
    );
  }
}

// --------------------------------- Hipertensión arterial ----------------------------------------------------

class LabeledCheckboxHipertension extends StatelessWidget {
  const LabeledCheckboxHipertension({
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
                child: Text(label, style: TextStyle(fontFamily: 'NunitoR'))),
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

class HipertensionArterial extends StatefulWidget {
  HipertensionArterial({Key key}) : super(key: key);

  @override
  HipertensionArterialWidgetState createState() =>
      HipertensionArterialWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class HipertensionArterialWidgetState extends State<HipertensionArterial> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxHipertension(
      label: 'Hipertensión arterial',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: hipertension,
      onChanged: (bool newValue) {
        setState(() {
          hipertension = newValue;
        });
      },
    );
  }
}

// --------------------------------- Colesterol ----------------------------------------------------

class LabeledCheckboxColesterol extends StatelessWidget {
  const LabeledCheckboxColesterol({
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
                child: Text(label, style: TextStyle(fontFamily: 'NunitoR'))),
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

class Colesterol extends StatefulWidget {
  Colesterol({Key key}) : super(key: key);

  @override
  ColesterolWidgetState createState() => ColesterolWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class ColesterolWidgetState extends State<Colesterol> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxColesterol(
      label: 'Colesterol',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: colesterol,
      onChanged: (bool newValue) {
        setState(() {
          colesterol = newValue;
        });
      },
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
