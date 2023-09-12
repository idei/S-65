import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'env.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormAntecedentesPersonales extends StatefulWidget {
  final pageName = 'form_antecedentes_personales';

  @override
  _FormpruebaState createState() => _FormpruebaState();
}

var email;

class _FormpruebaState extends State<FormAntecedentesPersonales> {
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

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
            Navigator.pushNamed(context, '/antecedentes_personales');
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
      body: Container(
        height: MediaQuery.of(context)
            .size
            .height, // Ocupa todo el espacio vertical
        child: FutureBuilder(
          future: read_datos_paciente(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Antecedentes();
            } else {
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Esto centra verticalmente
                    children: [
                      Text(snapshot.error),
                    ],
                  ),
                );
                //_alert_informe(context, "No se pudieron leer los datos", 2);
              }
              return Center(
                child: CircularProgressIndicator(
                  semanticsLabel: "Cargando",
                ),
              );
            }
          },
        ),
      ),
    );
  }

  read_datos_paciente() async {
    await getStringValuesSF();

    final completer = Completer<dynamic>();

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

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      if (responseData["status"] == "Success") {
        var data = responseData['data'];

        valueNotifierRetrasoMental.value =
            data["retraso"] == "1" ? true : false;

        valueNotifierDesorden.value = data["desorden"] == "1" ? true : false;

        valueNotifierDeficit.value = data["deficit"] == "1" ? true : false;

        valueNotifierLesiones_cabeza.value =
            data["lesiones_cabeza"] == "1" ? true : false;

        valueNotifierPerdidas.value = data["perdidas"] == "1" ? true : false;

        valueNotifierAccidentes_caidas.value =
            data["accidentes_caidas"] == "1" ? true : false;

        valueNotifierLesiones_espalda.value =
            data["lesiones_espalda"] == "1" ? true : false;

        valueNotifierInfecciones.value =
            data["infecciones"] == "1" ? true : false;

        valueNotifierToxinas.value = data["toxinas"] == "1" ? true : false;

        valueNotifierAcv.value = data["acv"] == "1" ? true : false;

        valueNotifierDemencia.value = data["demencia"] == "1" ? true : false;

        valueNotifierParkinson.value = data["parkinson"] == "1" ? true : false;

        valueNotifierEpilepsia.value = data["epilepsia"] == "1" ? true : false;

        valueNotifierEsclerosis.value =
            data["esclerosis"] == "1" ? true : false;

        valueNotifierHuntington.value =
            data["huntington"] == "1" ? true : false;

        valueNotifierDepresion.value = data["depresion"] == "1" ? true : false;

        valueNotifierTrastorno.value = data["trastorno"] == "1" ? true : false;

        valueNotifierEsquizofrenia.value =
            data["esquizofrenia"] == "1" ? true : false;

        valueNotifierEnfermedad_desorden.value =
            data["enfermedad_desorden"] == "1" ? true : false;

        valueNotifierIntoxicaciones.value =
            data["intoxicaciones"] == "1" ? true : false;

        completer.complete(true);
      } else {
        completer.completeError("Error en la respuesta");
      }
    } else {
      completer.completeError("Error en la solicitud");
    }
    //return true;
    return completer.future;
  }

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email_prefer = prefs.getString("email");
    email = email_prefer;
    print(email);
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

//----------------------------------------ANTECEDENTES PERSONALES ------------------------------------------

class Antecedentes extends StatefulWidget {
  Antecedentes({Key key}) : super(key: key);

  @override
  AntecedentesWidgetState createState() => AntecedentesWidgetState();
}

class AntecedentesWidgetState extends State<Antecedentes> {
  final _formKey_antecedentes_familiares = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey_antecedentes_familiares,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
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
            SizedBox(height: 50),
            Center(
              child: ElevatedButton(
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
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  guardar_datos(BuildContext context) async {
    String URL_base = Env.URL_API;
    var url = URL_base + "/save_antec_personales";
    var response = await http.post(url, body: {
      "email": email,
      "retraso": valueNotifierRetrasoMental.value.toString(),
      "desorden": valueNotifierDesorden.value.toString(),
      "deficit": valueNotifierDeficit.value.toString(),
      "lesiones_cabeza": valueNotifierLesiones_cabeza.value.toString(),
      "perdidas": valueNotifierPerdidas.value.toString(),
      "accidentes_caidas": valueNotifierAccidentes_caidas.value.toString(),
      "lesiones_espalda": valueNotifierLesiones_espalda.value.toString(),
      "infecciones": valueNotifierInfecciones.value.toString(),
      "toxinas": valueNotifierToxinas.value.toString(),
      "acv": valueNotifierAcv.value.toString(),
      "demencia": valueNotifierDemencia.value.toString(),
      "parkinson": valueNotifierParkinson.value.toString(),
      "epilepsia": valueNotifierEpilepsia.value.toString(),
      "esclerosis": valueNotifierEsclerosis.value.toString(),
      "huntington": valueNotifierHuntington.value.toString(),
      "depresion": valueNotifierDepresion.value.toString(),
      "trastorno": valueNotifierTrastorno.value.toString(),
      "esquizofrenia": valueNotifierEsquizofrenia.value.toString(),
      "enfermedad_desorden": valueNotifierEnfermedad_desorden.value.toString(),
      "intoxicaciones": valueNotifierIntoxicaciones.value.toString(),
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
    } else {
      _alert_informe(context, "Error al guardar Antecendentes", 2);
    }
  }
}

//----------------------------------------VARIABLES CHECKBOX -----------------------------------------------

ValueNotifier<bool> valueNotifierRetrasoMental = ValueNotifier<bool>(false);
ValueNotifier<bool> valueNotifierDesorden = ValueNotifier<bool>(false);
ValueNotifier<bool> valueNotifierDeficit = ValueNotifier<bool>(false);
ValueNotifier<bool> valueNotifierLesiones_cabeza = ValueNotifier<bool>(false);
ValueNotifier<bool> valueNotifierPerdidas = ValueNotifier<bool>(false);
ValueNotifier<bool> valueNotifierAccidentes_caidas = ValueNotifier<bool>(false);
ValueNotifier<bool> valueNotifierLesiones_espalda = ValueNotifier<bool>(false);
ValueNotifier<bool> valueNotifierInfecciones = ValueNotifier<bool>(false);
ValueNotifier<bool> valueNotifierToxinas = ValueNotifier<bool>(false);
ValueNotifier<bool> valueNotifierAcv = ValueNotifier<bool>(false);
ValueNotifier<bool> valueNotifierDemencia = ValueNotifier<bool>(false);
ValueNotifier<bool> valueNotifierParkinson = ValueNotifier<bool>(false);
ValueNotifier<bool> valueNotifierEpilepsia = ValueNotifier<bool>(false);
ValueNotifier<bool> valueNotifierEsclerosis = ValueNotifier<bool>(false);
ValueNotifier<bool> valueNotifierHuntington = ValueNotifier<bool>(false);
ValueNotifier<bool> valueNotifierDepresion = ValueNotifier<bool>(false);
ValueNotifier<bool> valueNotifierTrastorno = ValueNotifier<bool>(false);
ValueNotifier<bool> valueNotifierEsquizofrenia = ValueNotifier<bool>(false);
ValueNotifier<bool> valueNotifierEnfermedad_desorden =
    ValueNotifier<bool>(false);
ValueNotifier<bool> valueNotifierIntoxicaciones = ValueNotifier<bool>(false);

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

//-------------------------------------- LabeledCheckbox -----------------------------------------------------

class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    this.label,
    this.padding,
    this.valueNotifier,
  });

  final String label;
  final EdgeInsets padding;
  final ValueNotifier<bool> valueNotifier;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        valueNotifier.value = !valueNotifier.value;
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
                ),
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: valueNotifier,
              builder: (context, value, child) {
                return Checkbox(
                  value: value,
                  onChanged: (newValue) {
                    valueNotifier.value = newValue ?? false;
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

//-------------------------------------------------------------------------------------------

//-------------------------------------- RETRASO MENTAL -----------------------------------------------------

class CheckRetrasoMental extends StatefulWidget {
  CheckRetrasoMental({Key key}) : super(key: key);

  @override
  CheckRetrasoMentalWidgetState createState() =>
      CheckRetrasoMentalWidgetState();
}

class CheckRetrasoMentalWidgetState extends State<CheckRetrasoMental> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckbox(
      label: 'Retraso Mental',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      valueNotifier: valueNotifierRetrasoMental,
    );
  }
}

//-----------------------------------------------------------------------------------------------------------

// --------------------------------- DESORDEN DEL HABLA ----------------------------------------------------

class CheckDesorHabla extends StatefulWidget {
  CheckDesorHabla({Key key}) : super(key: key);

  @override
  CheckDesorHablaWidgetState createState() => CheckDesorHablaWidgetState();
}

class CheckDesorHablaWidgetState extends State<CheckDesorHabla> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckbox(
      label: 'Desorden del habla',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      valueNotifier: valueNotifierDesorden,
    );
  }
}

//-------------------------------------------DEFICIT DE ATENCION--------------------------------------------

class DeficitAtencion extends StatefulWidget {
  DeficitAtencion({Key key}) : super(key: key);

  @override
  DeficitAtencionWidgetState createState() => DeficitAtencionWidgetState();
}

class DeficitAtencionWidgetState extends State<DeficitAtencion> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckbox(
      label: 'Déficit de atención',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      valueNotifier: valueNotifierDeficit,
    );
  }
}

//------------------------------------------LESIONES EN LA CABEZA -------------------------------------------

class LesionCabeza extends StatefulWidget {
  LesionCabeza({Key key}) : super(key: key);

  @override
  LesionCabezaWidgetState createState() => LesionCabezaWidgetState();
}

class LesionCabezaWidgetState extends State<LesionCabeza> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckbox(
      label: 'Lesiones en la cabeza',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      valueNotifier: valueNotifierLesiones_cabeza,
    );
  }
}

//------------------------------------------PERDIDAS DE CONOCIMIENTO ---------------------------------------

class PerdidaConocimiento extends StatefulWidget {
  PerdidaConocimiento({Key key}) : super(key: key);

  @override
  PerdidaConocimientoWidgetState createState() =>
      PerdidaConocimientoWidgetState();
}

class PerdidaConocimientoWidgetState extends State<PerdidaConocimiento> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckbox(
      label: 'Perdida del conocimiento',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      valueNotifier: valueNotifierPerdidas,
    );
  }
}

// ----------------------------------------ACCIDENTES, CAIDAS Y GOLPES ---------------------------------------

class AccidentesCaidasGolpes extends StatefulWidget {
  AccidentesCaidasGolpes({Key key}) : super(key: key);

  @override
  AccidentesCaidasGolpesWidgetState createState() =>
      AccidentesCaidasGolpesWidgetState();
}

class AccidentesCaidasGolpesWidgetState extends State<AccidentesCaidasGolpes> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckbox(
      label: 'Accidentes, Caidas y Golpes',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      valueNotifier: valueNotifierAccidentes_caidas,
    );
  }
}

// ----------------------------------------LESIONES EN LA ESPALDA O CUELLO -----------------------------------

class Lesiones extends StatefulWidget {
  Lesiones({Key key}) : super(key: key);

  @override
  LesionesWidgetState createState() => LesionesWidgetState();
}

class LesionesWidgetState extends State<Lesiones> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckbox(
      label: 'Lesiones en la espalda o cuello',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      valueNotifier: valueNotifierLesiones_espalda,
    );
  }
}

// -----------------------------------------INFECCIONES -----------------------------------------------------

class Infecciones extends StatefulWidget {
  Infecciones({Key key}) : super(key: key);

  @override
  InfeccionesWidgetState createState() => InfeccionesWidgetState();
}

class InfeccionesWidgetState extends State<Infecciones> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckbox(
      label: 'Infecciones(meningitis,encefalitis)/privación de oxígeno',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      valueNotifier: valueNotifierInfecciones,
    );
  }
}

//--------------------------------------------ACV -----------------------------------------------------------

class Acv extends StatefulWidget {
  Acv({Key key}) : super(key: key);

  @override
  AcvWidgetState createState() => AcvWidgetState();
}

class AcvWidgetState extends State<Acv> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckbox(
      label: 'Accidente Cerebrovascular (ACV)',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      valueNotifier: valueNotifierAcv,
    );
  }
}

// -------------------------------------------EXPOSICION A TOXINAS --------------------------------------------

class Exposicion extends StatefulWidget {
  Exposicion({Key key}) : super(key: key);

  @override
  ExposicionWidgetState createState() => ExposicionWidgetState();
}

class ExposicionWidgetState extends State<Exposicion> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckbox(
      label: 'Exposición a toxinas (plomo, solventes, químicos, etc.)',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      valueNotifier: valueNotifierToxinas,
    );
  }
}

// ------------------------------------------DEMENCIAS ---------------------------------------------------

class Demencia extends StatefulWidget {
  Demencia({Key key}) : super(key: key);

  @override
  DemenciaWidgetState createState() => DemenciaWidgetState();
}

class DemenciaWidgetState extends State<Demencia> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckbox(
      label: 'Demencias (ejemplo Alzheimer)',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      valueNotifier: valueNotifierDemencia,
    );
  }
}
//-------------------------------------------- PARKINSON---------------------------------------------------

class Parkinzon extends StatefulWidget {
  Parkinzon({Key key}) : super(key: key);

  @override
  ParkinzonWidgetState createState() => ParkinzonWidgetState();
}

class ParkinzonWidgetState extends State<Parkinzon> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckbox(
      label: 'Parkinson',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      valueNotifier: valueNotifierParkinson,
    );
  }
}
//------------------------------------------EPILEPSIA --------------------------------------------------

class Epilepsia extends StatefulWidget {
  Epilepsia({Key key}) : super(key: key);

  @override
  EpilepsiaWidgetState createState() => EpilepsiaWidgetState();
}

class EpilepsiaWidgetState extends State<Epilepsia> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckbox(
      label: 'Epilepsia',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      valueNotifier: valueNotifierEpilepsia,
    );
  }
}
//-------------------------------------------- ESCLEROSIS -------------------------------------------------

class Esclerosis extends StatefulWidget {
  Esclerosis({Key key}) : super(key: key);

  @override
  EsclerosisWidgetState createState() => EsclerosisWidgetState();
}

class EsclerosisWidgetState extends State<Esclerosis> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckbox(
      label: 'Esclerosis múltiple',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      valueNotifier: valueNotifierEsclerosis,
    );
  }
}

// --------------------------------------------HUNTINGTON ------------------------------------------------

class Huntington extends StatefulWidget {
  Huntington({Key key}) : super(key: key);

  @override
  HuntingtonWidgetState createState() => HuntingtonWidgetState();
}

class HuntingtonWidgetState extends State<Huntington> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckbox(
      label: 'Huntington',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      valueNotifier: valueNotifierHuntington,
    );
  }
}
// --------------------------------------------DEPRESION -------------------------------------------------

class Depresion extends StatefulWidget {
  Depresion({Key key}) : super(key: key);

  @override
  DepresionWidgetState createState() => DepresionWidgetState();
}

class DepresionWidgetState extends State<Depresion> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckbox(
      label: 'Depresión',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      valueNotifier: valueNotifierDepresion,
    );
  }
}
// --------------------------------------------TRASTORNO BIPOLAR -----------------------------------------

class TrastornoBipolar extends StatefulWidget {
  TrastornoBipolar({Key key}) : super(key: key);

  @override
  TrastornoBipolarWidgetState createState() => TrastornoBipolarWidgetState();
}

class TrastornoBipolarWidgetState extends State<TrastornoBipolar> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckbox(
      label: 'Trastorno bipolar',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      valueNotifier: valueNotifierTrastorno,
    );
  }
}
// --------------------------------------------ESQUISOFRENIA ---------------------------------------------

class Esquizofrenia extends StatefulWidget {
  Esquizofrenia({Key key}) : super(key: key);

  @override
  EsquizofreniaWidgetState createState() => EsquizofreniaWidgetState();
}

class EsquizofreniaWidgetState extends State<Esquizofrenia> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckbox(
      label: 'Esquizofrenia',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      valueNotifier: valueNotifierEsquizofrenia,
    );
  }
}

//---------------------------------------------ENFERMEDAD O DESORDEN DEL GRAVE ----------------------------

class EnfermedadDesordenGrave extends StatefulWidget {
  EnfermedadDesordenGrave({Key key}) : super(key: key);

  @override
  EnfermedadDesordenGraveWidgetState createState() =>
      EnfermedadDesordenGraveWidgetState();
}

class EnfermedadDesordenGraveWidgetState
    extends State<EnfermedadDesordenGrave> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckbox(
      label:
          'Enfermedad o desorden grave (inmunológico, parálisis cerebral, polio, pulmones, etc.)',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      valueNotifier: valueNotifierEnfermedad_desorden,
    );
  }
}
//---------------------------------------------INTOXICACIONES ---------------------------------------------

class Intoxicaciones extends StatefulWidget {
  Intoxicaciones({Key key}) : super(key: key);

  @override
  IntoxicacionesWidgetState createState() => IntoxicacionesWidgetState();
}

class IntoxicacionesWidgetState extends State<Intoxicaciones> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckbox(
      label: 'Intoxicaciones',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      valueNotifier: valueNotifierIntoxicaciones,
    );
  }
}
