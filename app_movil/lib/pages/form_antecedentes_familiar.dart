import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../services/usuario_services.dart';
import 'env.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormAntecedentesFamiliares extends StatefulWidget {
  final pageName = 'form_antecedentes_familiares';

  @override
  _FormpruebaState createState() => _FormpruebaState();
}

class _FormpruebaState extends State<FormAntecedentesFamiliares> {
  final myController = TextEditingController();
  var usuarioModel;

  @override
  void initState() {
    super.initState();
    getStringValuesSF();
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    usuarioModel = Provider.of<UsuarioServices>(context);

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
            Navigator.pushNamed(context, '/antecedentes_familiares');
          },
        ),
        title: Center(
          child: Text(
            'Agregar \nAntecedentes Familiares',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
            ),
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder(
          future: read_datos_paciente(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return AntecedentesFam();
            } else {
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(snapshot.error),
                    ],
                  ),
                );
              }
              return Center(
                child: CircularProgressIndicator(
                  semanticsLabel: "Cargando",
                ),
              );
            }
          }),
    );
  }
}

var email;

getStringValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String email_prefer = prefs.getString("email");
  //var estado_clinico_prefer = prefs.getString("estado_clinico");
  email = email_prefer;
  print(email);
}

var response = null;

guardar_datos(BuildContext context) async {
  String URL_base = Env.URL_API;
  var url = URL_base + "/save_antec_familiares";
  response = await http.post(url, body: {
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
    "cancer": valueNotifierCancer.value.toString(),
    "cirujia": valueNotifierCirujia.value.toString(),
    "trasplante": valueNotifierTrasplante.value.toString(),
    "hipotiroidismo": valueNotifierHipotiroidismo.value.toString(),
    "cardiologico": valueNotifierCardiologico.value.toString(),
    "diabetes": valueNotifierDiabetes.value.toString(),
    "hipertension": valueNotifierHipertension.value.toString(),
    "colesterol": valueNotifierColesterol.value.toString(),
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

  var responseDecoder = json.decode(response.body);
  if (response.statusCode == 200) {
    if (responseDecoder["status"] == "Success") {
      _alert_informe(context, "Antecedentes Guardados", 1);
      Navigator.pushNamed(context, '/antecedentes_familiares');
    }
  }
}

read_datos_paciente() async {
  await getStringValuesSF();

  final completer = Completer<dynamic>();

  String URL_base = Env.URL_API;
  var url = URL_base + "/user_read_antc_familiares";
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

  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);

    if (responseData["status"] == "Success") {
      var data = responseData['data'];

      valueNotifierRetrasoMental.value = data["retraso"] == "1" ? true : false;

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

      valueNotifierEsclerosis.value = data["esclerosis"] == "1" ? true : false;

      valueNotifierHuntington.value = data["huntington"] == "1" ? true : false;

      valueNotifierDepresion.value = data["depresion"] == "1" ? true : false;

      valueNotifierTrastorno.value = data["trastorno"] == "1" ? true : false;

      valueNotifierEsquizofrenia.value =
          data["esquizofrenia"] == "1" ? true : false;

      valueNotifierEnfermedad_desorden.value =
          data["enfermedad_desorden"] == "1" ? true : false;

      valueNotifierIntoxicaciones.value =
          data["intoxicaciones"] == "1" ? true : false;

      valueNotifierCancer.value = data["cancer"] == "1" ? true : false;

      valueNotifierCirujia.value = data["cirujia"] == "1" ? true : false;

      valueNotifierTrasplante.value = data["trasplante"] == "1" ? true : false;

      valueNotifierHipotiroidismo.value =
          data["hipotiroidismo"] == "1" ? true : false;

      valueNotifierCardiologico.value =
          data["cardiologico"] == "1" ? true : false;

      valueNotifierDiabetes.value = data["diabetes"] == "1" ? true : false;

      valueNotifierHipertension.value =
          data["hipertension"] == "1" ? true : false;

      valueNotifierColesterol.value = data["colesterol"] == "1" ? true : false;

      completer.complete(true);
    } else {
      if (responseData["status"] == "Vacio") {
        completer.complete(true);
      } else {
        completer.completeError("Error en la respuesta");
      }
    }
  } else {
    completer.completeError("Error en la solicitud");
  }

  return completer.future;
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

    return Form(
      key: _formKey_antecedentes_familiares,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
            SizedBox(height: 50),
            Center(
              child: ElevatedButton(
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
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
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
ValueNotifier<bool> valueNotifierCancer = ValueNotifier<bool>(false);
ValueNotifier<bool> valueNotifierCirujia = ValueNotifier<bool>(false);
ValueNotifier<bool> valueNotifierTrasplante = ValueNotifier<bool>(false);
ValueNotifier<bool> valueNotifierHipotiroidismo = ValueNotifier<bool>(false);
ValueNotifier<bool> valueNotifierCardiologico = ValueNotifier<bool>(false);
ValueNotifier<bool> valueNotifierDiabetes = ValueNotifier<bool>(false);
ValueNotifier<bool> valueNotifierHipertension = ValueNotifier<bool>(false);
ValueNotifier<bool> valueNotifierColesterol = ValueNotifier<bool>(false);

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
// --------------------------------- CANCER ----------------------------------------------------

class Cancer extends StatefulWidget {
  Cancer({Key key}) : super(key: key);

  @override
  CancerWidgetState createState() => CancerWidgetState();
}

class CancerWidgetState extends State<Cancer> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckbox(
      label: 'Cáncer',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      valueNotifier: valueNotifierCancer,
    );
  }
}

// --------------------------------- CIRUJIAS ----------------------------------------------------

class Cirujias extends StatefulWidget {
  Cirujias({Key key}) : super(key: key);

  @override
  CirujiasWidgetState createState() => CirujiasWidgetState();
}

class CirujiasWidgetState extends State<Cirujias> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckbox(
      label: 'Cirujías',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      valueNotifier: valueNotifierCirujia,
    );
  }
}

// --------------------------------- TRASPLANTE DE CORNEA ----------------------------------------------------

class TransplanteCornea extends StatefulWidget {
  TransplanteCornea({Key key}) : super(key: key);

  @override
  TransplanteCorneaWidgetState createState() => TransplanteCorneaWidgetState();
}

class TransplanteCorneaWidgetState extends State<TransplanteCornea> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckbox(
      label: 'Trasplante de córnea',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      valueNotifier: valueNotifierTrasplante,
    );
  }
}

// --------------------------------- Hipotiroidismo ----------------------------------------------------

class Hipotiroidismo extends StatefulWidget {
  Hipotiroidismo({Key key}) : super(key: key);

  @override
  HipotiroidismoWidgetState createState() => HipotiroidismoWidgetState();
}

class HipotiroidismoWidgetState extends State<Hipotiroidismo> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckbox(
      label: 'Hipotiroidismo/Hipertiroidismo',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      valueNotifier: valueNotifierHipotiroidismo,
    );
  }
}

// --------------------------------- Enfermedades Cardiológicas ----------------------------------------------------

class EnfermedadesCardiologicas extends StatefulWidget {
  EnfermedadesCardiologicas({Key key}) : super(key: key);

  @override
  EnfermedadesCardiologicasWidgetState createState() =>
      EnfermedadesCardiologicasWidgetState();
}

class EnfermedadesCardiologicasWidgetState
    extends State<EnfermedadesCardiologicas> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return LabeledCheckbox(
      label: 'Enfermedades Cardiológicas',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      valueNotifier: valueNotifierCardiologico,
    );
  }
}

// --------------------------------- Diabetes ----------------------------------------------------

class Diabetes extends StatefulWidget {
  Diabetes({Key key}) : super(key: key);

  @override
  DiabetesWidgetState createState() => DiabetesWidgetState();
}

class DiabetesWidgetState extends State<Diabetes> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return LabeledCheckbox(
      label: 'Diabetes',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      valueNotifier: valueNotifierDiabetes,
    );
  }
}

// --------------------------------- Hipertensión arterial ----------------------------------------------------

class HipertensionArterial extends StatefulWidget {
  HipertensionArterial({Key key}) : super(key: key);

  @override
  HipertensionArterialWidgetState createState() =>
      HipertensionArterialWidgetState();
}

class HipertensionArterialWidgetState extends State<HipertensionArterial> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckbox(
      label: 'Hipertensión arterial',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      valueNotifier: valueNotifierHipertension,
    );
  }
}

// --------------------------------- Colesterol ----------------------------------------------------

class Colesterol extends StatefulWidget {
  Colesterol({Key key}) : super(key: key);

  @override
  ColesterolWidgetState createState() => ColesterolWidgetState();
}

class ColesterolWidgetState extends State<Colesterol> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckbox(
      label: 'Colesterol',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      valueNotifier: valueNotifierColesterol,
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
