import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'env.dart';
import 'ajustes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

var id_paciente;
var id_medico;
var tipo_screening;
var id_recordatorio;
var screening_recordatorio;

// Define a custom Form widget.
class FormScreeningSintomas extends StatefulWidget {
  final pageName = 'screening_fisico';

  @override
  _FormpruebaState createState() => _FormpruebaState();
}

class _FormpruebaState extends State<FormScreeningSintomas> {
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
            return Antecedentes();
          } else {
            return Scaffold(
              appBar: AppBar(
                //backgroundColor: Color.fromRGBO(157, 19, 34, 1),
                title: Text('Chequeo Fisico',
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

var email;

guardar_datos(var cant_check) async {
  String URL_base = Env.URL_PREFIX;
  var url = URL_base + "/respuesta_screening_fisico.php";
  var response = await http.post(url, body: {
    "id_paciente": id_paciente.toString(),
    "id_medico": id_medico.toString(),
    "id_recordatorio": id_recordatorio.toString(),
    "tipo_screening": tipo_screening.toString(),
    "cantidad": cant_check.toString(),
    "dolor_cabeza": dolor_cabeza.toString().toString(),
    "mareos": mareos.toString(),
    "nauceas": nauceas.toString(),
    "vomito": vomito.toString(),
    "fatiga_excesiva": fatiga_excesiva.toString(),
    "urinaria": urinaria.toString(),
    "problemas_instestinales": problemas_instestinales.toString(),
    "debilidad_lado_cuerpo": debilidad_lado_cuerpo.toString(),
    "problemas_motricidad": problemas_motricidad.toString(),
    "temblores": temblores.toString(),
    "inestabilidad_marcha": inestabilidad_marcha.toString(),
    "tics_mov_extranos": tics_mov_extranos.toString(),
    "problemas_equilibrio": problemas_equilibrio.toString(),
    "choque_cosas": choque_cosas.toString(),
    "desmayo": desmayo.toString(),
    "caidas": caidas.toString(),
    "perdida_sensibilidad": perdida_sensibilidad.toString(),
    "cosquilleo_piel": cosquilleo_piel.toString(),
    "ojos_claridad": ojos_claridad.toString(),
    "perdida_audicion": perdida_audicion.toString(),
    "utiliza_audifonos": utiliza_audifonos.toString(),
    "zumbido": zumbido.toString(),
    "anteojo_cerca": anteojo_cerca.toString(),
    "anteojo_lejos": anteojo_lejos.toString(),
    "vision_lado": vision_lado.toString(),
    "vision_borrosa": vision_borrosa.toString(),
    "vision_doble": vision_doble.toString(),
    "cosas_no_existen": cosas_no_existen.toString(),
    "sensibilidad_cosas_brillantes": sensibilidad_cosas_brillantes.toString(),
    "periodos_ceguera": periodos_ceguera.toString(),
    "persibe_cosas_cuerpo": persibe_cosas_cuerpo.toString(),
    "dificultad_calor_frio": dificultad_calor_frio.toString(),
    "problemas_gusto": problemas_gusto.toString(),
    "problemas_olfato": problemas_olfato.toString(),
    "dolor": dolor.toString(),
    "cod_event_dolor_cabeza": cod_event_dolor_cabeza,
    "cod_event_mareos": cod_event_mareos,
    "cod_event_nauceas": cod_event_nauceas,
    "cod_event_vomito": cod_event_vomito,
    "cod_event_fatiga_excesiva": cod_event_fatiga_excesiva,
    "cod_event_urinaria": cod_event_urinaria,
    "cod_event_problemas_instestinales": cod_event_problemas_instestinales,
    "cod_event_debilidad_lado_cuerpo": cod_event_debilidad_lado_cuerpo,
    "cod_event_problemas_motricidad": cod_event_problemas_motricidad,
    "cod_event_temblores": cod_event_temblores,
    "cod_event_inestabilidad_marcha": cod_event_inestabilidad_marcha,
    "cod_event_tics_mov_extranos": cod_event_tics_mov_extranos,
    "cod_event_problemas_equilibrio": cod_event_problemas_equilibrio,
    "cod_event_choque_cosas": cod_event_choque_cosas,
    "cod_event_desmayo": cod_event_desmayo,
    "cod_event_caidas": cod_event_caidas,
    "cod_event_perdida_sensibilidad": cod_event_perdida_sensibilidad,
    "cod_event_cosquilleo_piel": cod_event_cosquilleo_piel,
    "cod_event_ojos_claridad": cod_event_ojos_claridad,
    "cod_event_perdida_audicion": cod_event_perdida_audicion,
    "cod_event_utiliza_audifonos": cod_event_utiliza_audifonos,
    "cod_event_zumbido": cod_event_zumbido,
    "cod_event_anteojo_cerca": cod_event_anteojo_cerca,
    "cod_event_anteojo_lejos": cod_event_anteojo_lejos,
    "cod_event_vision_lado": cod_event_vision_lado,
    "cod_event_vision_borrosa": cod_event_vision_borrosa,
    "cod_event_vision_doble": cod_event_vision_doble,
    "cod_event_cosas_no_existen": cod_event_cosas_no_existen,
    "cod_event_sensibilidad_cosas_brillantes":
        cod_event_sensibilidad_cosas_brillantes,
    "cod_event_periodos_ceguera": cod_event_periodos_ceguera,
    "cod_event_persibe_cosas_cuerpo": cod_event_persibe_cosas_cuerpo,
    "cod_event_dificultad_calor_frio": cod_event_dificultad_calor_frio,
    "cod_event_problemas_gusto": cod_event_problemas_gusto,
    "cod_event_problemas_olfato": cod_event_problemas_olfato,
    "cod_event_dolor": cod_event_dolor
  });

  print(response.body);
  var data = json.decode(response.body);
  print(data);
}

read_datos_paciente() async {
  await new Future.delayed(new Duration(milliseconds: 1500));

  return true;
}

//----------------------------------------Screening de Sintomas ------------------------------------------

class Antecedentes extends StatefulWidget {
  Antecedentes({Key key}) : super(key: key);

  @override
  AntecedentesWidgetState createState() => AntecedentesWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class AntecedentesWidgetState extends State<Antecedentes> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, '/screening', arguments: {
                "select_screening": "SFMS",
              });
            },
          ),
          //backgroundColor: Color.fromRGBO(157, 19, 34, 1),
          title: Text('Chequeo Fisico',
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
          child: Card(
            //padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: <Widget>[
                CheckDolorCabeza(),
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                ),
                new Divider(height: 3.0, color: Colors.black),
                CheckMareos(),
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                ),
                new Divider(height: 3.0, color: Colors.black),
                Nauseas(),
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                ),
                new Divider(height: 3.0, color: Colors.black),
                Vomitos(),
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                ),
                new Divider(height: 3.0, color: Colors.black),
                FatigaExcesiva(),
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                ),
                new Divider(height: 3.0, color: Colors.black),
                IncontinenciaUrinaria(),
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                ),
                new Divider(height: 3.0, color: Colors.black),
                ProblemasInstestinales(),
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                ),
                new Divider(height: 3.0, color: Colors.black),
                DebilidadLadoCuerpo(),
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                ),
                new Divider(height: 3.0, color: Colors.black),
                ProblemasMotricidadFina(),
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                ),
                new Divider(height: 3.0, color: Colors.black),
                Temblores(),
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                ),
                new Divider(height: 3.0, color: Colors.black),
                InestabilidadMarcha(),
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                ),
                new Divider(height: 3.0, color: Colors.black),
                TicsMovExtranos(),
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                ),
                new Divider(height: 3.0, color: Colors.black),
                ProblemaEquilibrio(),
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                ),
                new Divider(height: 3.0, color: Colors.black),
                ConFrecCosas(),
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                ),
                new Divider(height: 3.0, color: Colors.black),
                DesvanDesmayo(),
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                ),
                new Divider(height: 3.0, color: Colors.black),
                Caidas(),
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                ),
                new Divider(height: 3.0, color: Colors.black),
                PerdidaSensibilidad(),
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                ),
                new Divider(height: 3.0, color: Colors.black),
                CosqSensaPiel(),
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                ),
                new Divider(height: 3.0, color: Colors.black),
                NecesidadOjosClaridad(),
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                ),
                new Divider(height: 3.0, color: Colors.black),
                PerdidaAudicion(),
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                ),
                new Divider(height: 3.0, color: Colors.black),
                UtilizaAudifonos(),
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                ),
                new Divider(height: 3.0, color: Colors.black),
                Zumbido(),
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                ),
                new Divider(height: 3.0, color: Colors.black),
                UtilizaAnteojosCerca(),
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                ),
                new Divider(height: 3.0, color: Colors.black),
                UtilizaAnteojosLejos(),
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                ),
                new Divider(height: 3.0, color: Colors.black),
                ProblemaVisionLado(),
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                ),
                new Divider(height: 3.0, color: Colors.black),
                VisionBorrosa(),
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                ),
                new Divider(height: 3.0, color: Colors.black),
                VisionDoble(),
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                ),
                new Divider(height: 3.0, color: Colors.black),
                VeCosasNoExisten(),
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                ),
                new Divider(height: 3.0, color: Colors.black),
                SensiLucesBrillantes(),
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                ),
                new Divider(height: 3.0, color: Colors.black),
                PeriodosCortosCeguera(),
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                ),
                new Divider(height: 3.0, color: Colors.black),
                CosasPasanCuerpo(),
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                ),
                new Divider(height: 3.0, color: Colors.black),
                DistinguirCalorFrio(),
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                ),
                new Divider(height: 3.0, color: Colors.black),
                ProblemasGusto(),
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                ),
                new Divider(height: 3.0, color: Colors.black),
                ProblemasOlfato(),
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                ),
                new Divider(height: 3.0, color: Colors.black),
                Dolor(),
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      if (cant_check > 3) {
                        _alert_informe(
                          context,
                          "Para tener en cuenta",
                          "Le sugerimos que consulte con su medico clínico sobre estos síntomas.",
                        );
                      } else {
                        Navigator.pushNamed(context, '/screening', arguments: {
                          "select_screening": "SFMS",
                        });
                      }

                      guardar_datos(cant_check);
                    }
                  },
                  child: Text('GUARDAR',
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily,
                      )),
                ),
              ],
            ),
          ),
        ));
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
                "select_screening": "SFMS",
              });
            }
          },
          width: 120,
        )
      ],
    ).show();
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

  void choiceAction(String choice) {
    if (choice == Constants.Ajustes) {
      Navigator.pushNamed(context, '/ajustes');
    } else if (choice == Constants.Salir) {
      Navigator.pushNamed(context, '/');
    }
  }
}

//----------------------------------------VARIABLES CHECKBOX -----------------------------------------------
// Contador
var cant_check = 0;
// FISICO

bool dolor_cabeza = false;
bool mareos = false;
bool nauceas = false;
bool vomito = false;
bool fatiga_excesiva = false;
bool urinaria = false;
bool problemas_instestinales = false;

// MOTOR

bool debilidad_lado_cuerpo = false;
bool problemas_motricidad = false;
bool temblores = false;
bool inestabilidad_marcha = false;
bool tics_mov_extranos = false;
bool problemas_equilibrio = false;
bool choque_cosas = false;
bool desmayo = false;
bool caidas = false;

// Sensibilidad

bool perdida_sensibilidad = false;
bool cosquilleo_piel = false;
bool ojos_claridad = false;
bool perdida_audicion = false;

bool utiliza_audifonos = false;
bool zumbido = false;
bool anteojo_cerca = false;
bool anteojo_lejos = false;
bool vision_lado = false;
bool vision_borrosa = false;
bool vision_doble = false;
bool cosas_no_existen = false;
bool sensibilidad_cosas_brillantes = false;
bool periodos_ceguera = false;
bool persibe_cosas_cuerpo = false;
bool dificultad_calor_frio = false;
bool problemas_gusto = false;
bool problemas_olfato = false;
bool dolor = false;

String cod_event_dolor_cabeza = "DOLCA";
String cod_event_mareos = 'MAREO';
String cod_event_nauceas = 'NAUS';
String cod_event_vomito = 'VOM';
String cod_event_fatiga_excesiva = 'FATEX';
String cod_event_urinaria = 'INCUR';
String cod_event_problemas_instestinales = 'PROMI';
String cod_event_debilidad_lado_cuerpo = 'DEBCU';
String cod_event_problemas_motricidad = "PROMF";
String cod_event_temblores = 'TEMBL';
String cod_event_inestabilidad_marcha = 'INMAR';
String cod_event_tics_mov_extranos = 'TICS';
String cod_event_problemas_equilibrio = 'PEQUI';
String cod_event_choque_cosas = 'FRECC';
String cod_event_desmayo = 'DESMA';
String cod_event_caidas = 'CAIDA';
String cod_event_perdida_sensibilidad = 'PESEN';
String cod_event_cosquilleo_piel = 'COSQP';
String cod_event_ojos_claridad = 'NECCL';
String cod_event_perdida_audicion = 'PERAU';
String cod_event_utiliza_audifonos = 'UTAUD';

String cod_event_zumbido = 'ZUMB';
String cod_event_anteojo_cerca = 'UTICE';
String cod_event_anteojo_lejos = 'UTILE';
String cod_event_vision_lado = 'VISLA';
String cod_event_vision_borrosa = 'VISBO';
String cod_event_vision_doble = 'VISDO';
String cod_event_cosas_no_existen = 'COSEX';
String cod_event_sensibilidad_cosas_brillantes = 'LUCBR';
String cod_event_periodos_ceguera = 'PERCO';
String cod_event_persibe_cosas_cuerpo = 'PERCU';
String cod_event_dificultad_calor_frio = 'DIFFR';
String cod_event_problemas_gusto = 'PROGU';
String cod_event_problemas_olfato = 'PROOL';
String cod_event_dolor = 'DOLOR';

//--------------------------------------Consultar eventos -----------------------------------------

getAllEventos() async {
  String URL_base = Env.URL_PREFIX;
  var url = URL_base + "/eventos.php";
  var response = await http.post(url, body: {});
  print(response);
  var jsonBody = response.body;
  var data_evento = json.decode(jsonBody);
}

//-------------------------------------- DOLOR DE CABEZA -----------------------------------------------------

class LabeledCheckboxDC extends StatelessWidget {
  const LabeledCheckboxDC({
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
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
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

class CheckDolorCabeza extends StatefulWidget {
  CheckDolorCabeza({Key key}) : super(key: key);

  @override
  CheckCheckDolorCabezaWidgetState createState() =>
      CheckCheckDolorCabezaWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class CheckCheckDolorCabezaWidgetState extends State<CheckDolorCabeza> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxDC(
      label: 'Dolores de Cabeza',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: dolor_cabeza,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          debugPrint("cant_check: $cant_check");

          dolor_cabeza = newValue;
        });
      },
    );
  }
}

//-----------------------------------------------------------------------------------------------------------

// --------------------------------- MAREOS ----------------------------------------------------

class LabeledCheckboxMareos extends StatelessWidget {
  const LabeledCheckboxMareos({
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
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
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

class CheckMareos extends StatefulWidget {
  CheckMareos({Key key}) : super(key: key);

  @override
  CheckCheckMareosWidgetState createState() => CheckCheckMareosWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class CheckCheckMareosWidgetState extends State<CheckMareos> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxMareos(
      label: 'Mareos',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: mareos,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          mareos = newValue;
        });
      },
    );
  }
}

//-------------------------------------------Nauseas--------------------------------------------

class LabeledCheckboxNauseas extends StatelessWidget {
  const LabeledCheckboxNauseas({
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
    return LabeledCheckboxNauseas(
      label: 'Nauseas',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: nauceas,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          nauceas = newValue;
        });
      },
    );
  }
}

//------------------------------------------ VOMITOS -------------------------------------------

class LabeledCheckboxVom extends StatelessWidget {
  const LabeledCheckboxVom({
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

class Vomitos extends StatefulWidget {
  Vomitos({Key key}) : super(key: key);

  @override
  VomitosWidgetState createState() => VomitosWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class VomitosWidgetState extends State<Vomitos> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxVom(
      label: 'Vómitos',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: vomito,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          vomito = newValue;
        });
      },
    );
  }
}

//------------------------------------------Fatiga excesiva ---------------------------------------

class LabeledCheckboxFatExc extends StatelessWidget {
  const LabeledCheckboxFatExc({
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

class FatigaExcesiva extends StatefulWidget {
  FatigaExcesiva({Key key}) : super(key: key);

  @override
  FatigaExcesivaWidgetState createState() => FatigaExcesivaWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class FatigaExcesivaWidgetState extends State<FatigaExcesiva> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxFatExc(
      label: 'Fatiga excesiva',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: fatiga_excesiva,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          fatiga_excesiva = newValue;
        });
      },
    );
  }
}

// ----------------------------------------Incontinencia urinaria---------------------------------------

class LabeledCheckboxIU extends StatelessWidget {
  const LabeledCheckboxIU({
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

class IncontinenciaUrinaria extends StatefulWidget {
  IncontinenciaUrinaria({Key key}) : super(key: key);

  @override
  IncontinenciaUrinariaWidgetState createState() =>
      IncontinenciaUrinariaWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class IncontinenciaUrinariaWidgetState extends State<IncontinenciaUrinaria> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxIU(
      label: 'Incontinencia urinaria',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: urinaria,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          urinaria = newValue;
        });
      },
    );
  }
}

// ----------------------------------------Problemas intestinales -----------------------------------

class LabeledCheckboxProblemasIns extends StatelessWidget {
  const LabeledCheckboxProblemasIns({
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

class ProblemasInstestinales extends StatefulWidget {
  ProblemasInstestinales({Key key}) : super(key: key);

  @override
  ProblemasInstestinalesWidgetState createState() =>
      ProblemasInstestinalesWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class ProblemasInstestinalesWidgetState extends State<ProblemasInstestinales> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxProblemasIns(
      label: 'Problemas intestinales',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: problemas_instestinales,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          problemas_instestinales = newValue;
        });
      },
    );
  }
}

// -----------------------------------------Debilidad de un lado del cuerpo -----------------------------------------------------
class LabeledCheckboxDebilCuerpo extends StatelessWidget {
  const LabeledCheckboxDebilCuerpo({
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

class DebilidadLadoCuerpo extends StatefulWidget {
  DebilidadLadoCuerpo({Key key}) : super(key: key);

  @override
  DebilidadLadoCuerpoWidgetState createState() =>
      DebilidadLadoCuerpoWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class DebilidadLadoCuerpoWidgetState extends State<DebilidadLadoCuerpo> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxDebilCuerpo(
      label: 'Debilidad de un lado del cuerpo',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: debilidad_lado_cuerpo,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          debilidad_lado_cuerpo = newValue;
        });
      },
    );
  }
}

//-------------------------------------------- Problemas en la motricidad fina -----------------------------------------------------------

class LabeledCheckboxPMF extends StatelessWidget {
  const LabeledCheckboxPMF({
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

class ProblemasMotricidadFina extends StatefulWidget {
  ProblemasMotricidadFina({Key key}) : super(key: key);

  @override
  ProblemasMotricidadFinaWidgetState createState() =>
      ProblemasMotricidadFinaWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class ProblemasMotricidadFinaWidgetState
    extends State<ProblemasMotricidadFina> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxPMF(
      label: 'Problemas en la motricidad fina',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: problemas_motricidad,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          problemas_motricidad = newValue;
        });
      },
    );
  }
}

// -------------------------------------------Temblores --------------------------------------------
class LabeledCheckboxTemblores extends StatelessWidget {
  const LabeledCheckboxTemblores({
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

class Temblores extends StatefulWidget {
  Temblores({Key key}) : super(key: key);

  @override
  TembloresWidgetState createState() => TembloresWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class TembloresWidgetState extends State<Temblores> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxTemblores(
      label: 'Temblores',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: temblores,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          temblores = newValue;
        });
      },
    );
  }
}

// ------------------------------------------Inestabilidad en la marcha ---------------------------------------------------
class LabeledCheckboxInestabilidadMarcha extends StatelessWidget {
  const LabeledCheckboxInestabilidadMarcha({
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

class InestabilidadMarcha extends StatefulWidget {
  InestabilidadMarcha({Key key}) : super(key: key);

  @override
  InestabilidadMarchaWidgetState createState() =>
      InestabilidadMarchaWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class InestabilidadMarchaWidgetState extends State<InestabilidadMarcha> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxInestabilidadMarcha(
      label: 'Inestabilidad en la marcha',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: inestabilidad_marcha,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          inestabilidad_marcha = newValue;
        });
      },
    );
  }
}
//-------------------------------------------- Tics o movimientos extraños---------------------------------------------------

class LabeledCheckboxTicsMovEx extends StatelessWidget {
  const LabeledCheckboxTicsMovEx({
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

class TicsMovExtranos extends StatefulWidget {
  TicsMovExtranos({Key key}) : super(key: key);

  @override
  TicsMovExtranosWidgetState createState() => TicsMovExtranosWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class TicsMovExtranosWidgetState extends State<TicsMovExtranos> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxTicsMovEx(
      label: 'Tics o movimientos extraños',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: tics_mov_extranos,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          tics_mov_extranos = newValue;
        });
      },
    );
  }
}
//------------------------------------------Problemas de equilibrio --------------------------------------------------

class LabeledCheckboxProblemaEq extends StatelessWidget {
  const LabeledCheckboxProblemaEq({
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

class ProblemaEquilibrio extends StatefulWidget {
  ProblemaEquilibrio({Key key}) : super(key: key);

  @override
  ProblemaEquiWidgetState createState() => ProblemaEquiWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class ProblemaEquiWidgetState extends State<ProblemaEquilibrio> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxProblemaEq(
      label: 'Problemas de equilibrio',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: problemas_equilibrio,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          problemas_equilibrio = newValue;
        });
      },
    );
  }
}
//-------------------------------------------- Con frecuencia se choca las cosas -------------------------------------------------

class LabeledCheckboxFrecCosas extends StatelessWidget {
  const LabeledCheckboxFrecCosas({
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

class ConFrecCosas extends StatefulWidget {
  ConFrecCosas({Key key}) : super(key: key);

  @override
  ConFrecWidgetState createState() => ConFrecWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class ConFrecWidgetState extends State<ConFrecCosas> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxFrecCosas(
      label: 'Con frecuencia se choca las cosas',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: choque_cosas,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          choque_cosas = newValue;
        });
      },
    );
  }
}

// --------------------------------------------Desvanecimiento o desmayo ------------------------------------------------
class LabeledCheckboxDesoDes extends StatelessWidget {
  const LabeledCheckboxDesoDes({
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

class DesvanDesmayo extends StatefulWidget {
  DesvanDesmayo({Key key}) : super(key: key);

  @override
  DesvanDesWidgetState createState() => DesvanDesWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class DesvanDesWidgetState extends State<DesvanDesmayo> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxDesoDes(
      label: 'Desvanecimiento o desmayo',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: desmayo,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          desmayo = newValue;
        });
      },
    );
  }
}
// --------------------------------------------Caídas -------------------------------------------------

class LabeledCheckboxCaidas extends StatelessWidget {
  const LabeledCheckboxCaidas({
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

class Caidas extends StatefulWidget {
  Caidas({Key key}) : super(key: key);

  @override
  CaidasWidgetState createState() => CaidasWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class CaidasWidgetState extends State<Caidas> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxCaidas(
      label: 'Caídas',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: caidas,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          caidas = newValue;
        });
      },
    );
  }
}
// --------------------------------------------Pérdida de sensibilidad -----------------------------------------

class LabeledCheckboxPerdidaSensibilidad extends StatelessWidget {
  const LabeledCheckboxPerdidaSensibilidad({
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

class PerdidaSensibilidad extends StatefulWidget {
  PerdidaSensibilidad({Key key}) : super(key: key);

  @override
  PerdidaSensibilidadWidgetState createState() =>
      PerdidaSensibilidadWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class PerdidaSensibilidadWidgetState extends State<PerdidaSensibilidad> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxPerdidaSensibilidad(
      label: 'Pérdida de sensibilidad',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: perdida_sensibilidad,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          perdida_sensibilidad = newValue;
        });
      },
    );
  }
}
// --------------------------------------------Cosquilleo o sensaciones extrañas en la piel ---------------------------------------------

class LabeledCheckboxCosqSensaPiel extends StatelessWidget {
  const LabeledCheckboxCosqSensaPiel({
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

class CosqSensaPiel extends StatefulWidget {
  CosqSensaPiel({Key key}) : super(key: key);

  @override
  EsquizofreniaWidgetState createState() => EsquizofreniaWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class EsquizofreniaWidgetState extends State<CosqSensaPiel> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxCosqSensaPiel(
      label: 'Cosquilleo o sensaciones extrañas en la piel',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: cosquilleo_piel,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          cosquilleo_piel = newValue;
        });
      },
    );
  }
}

//---------------------------------------------Necesidad de entrecerrar los ojos o acercarse para ver con claridad ----------------------------
class LabeledCheckboxEntreojos extends StatelessWidget {
  const LabeledCheckboxEntreojos({
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

class NecesidadOjosClaridad extends StatefulWidget {
  NecesidadOjosClaridad({Key key}) : super(key: key);

  @override
  NecesidadOjosClaridadWidgetState createState() =>
      NecesidadOjosClaridadWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class NecesidadOjosClaridadWidgetState extends State<NecesidadOjosClaridad> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxEntreojos(
      label:
          'Necesidad de entrecerrar los ojos o acercarse para ver con claridad.',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: ojos_claridad,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          ojos_claridad = newValue;
        });
      },
    );
  }
}
//---------------------------------------------Pérdida de audición ---------------------------------------------

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

class PerdidaAudicion extends StatefulWidget {
  PerdidaAudicion({Key key}) : super(key: key);

  @override
  PerdidaAudicionWidgetState createState() => PerdidaAudicionWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class PerdidaAudicionWidgetState extends State<PerdidaAudicion> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxIntox(
      label: 'Pérdida de audición',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: perdida_audicion,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          perdida_audicion = newValue;
        });
      },
    );
  }
}

//---------------------------------------------Utiliza audífonos ---------------------------------------------

class LabeledCheckboxUtilizaAuidi extends StatelessWidget {
  const LabeledCheckboxUtilizaAuidi({
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

class UtilizaAudifonos extends StatefulWidget {
  UtilizaAudifonos({Key key}) : super(key: key);

  @override
  UtilizaAudiWidgetState createState() => UtilizaAudiWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class UtilizaAudiWidgetState extends State<UtilizaAudifonos> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxUtilizaAuidi(
      label: 'Utiliza audífonos',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: utiliza_audifonos,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          utiliza_audifonos = newValue;
        });
      },
    );
  }
}

//---------------------------------------------Zumbido ---------------------------------------------

class LabeledCheckboxZumbido extends StatelessWidget {
  const LabeledCheckboxZumbido({
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

class Zumbido extends StatefulWidget {
  Zumbido({Key key}) : super(key: key);

  @override
  ZumbidoWidgetState createState() => ZumbidoWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class ZumbidoWidgetState extends State<Zumbido> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxZumbido(
      label: 'Zumbido',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: zumbido,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          zumbido = newValue;
        });
      },
    );
  }
}

//---------------------------------------------Utiliza anteojos para ver de cerca ---------------------------------------------

class LabeledCheckboxUtilizaAnteojosCerca extends StatelessWidget {
  const LabeledCheckboxUtilizaAnteojosCerca({
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

class UtilizaAnteojosCerca extends StatefulWidget {
  UtilizaAnteojosCerca({Key key}) : super(key: key);

  @override
  UtilizaAnteojosCercaWidgetState createState() =>
      UtilizaAnteojosCercaWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class UtilizaAnteojosCercaWidgetState extends State<UtilizaAnteojosCerca> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxUtilizaAnteojosCerca(
      label: 'Utiliza anteojos para ver de cerca',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: anteojo_cerca,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          anteojo_cerca = newValue;
        });
      },
    );
  }
}

//---------------------------------------------Utiliza anteojos para ver de cerca ---------------------------------------------

class LabeledCheckboxUtilizaAnteojosLejos extends StatelessWidget {
  const LabeledCheckboxUtilizaAnteojosLejos({
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

class UtilizaAnteojosLejos extends StatefulWidget {
  UtilizaAnteojosLejos({Key key}) : super(key: key);

  @override
  UtilizaAnteojosLejosWidgetState createState() =>
      UtilizaAnteojosLejosWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class UtilizaAnteojosLejosWidgetState extends State<UtilizaAnteojosLejos> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxUtilizaAnteojosLejos(
      label: 'Utiliza anteojos para ver de lejos',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: anteojo_lejos,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          anteojo_lejos = newValue;
        });
      },
    );
  }
}

//---------------------------------------------Problemas de visión de un lado ---------------------------------------------

class LabeledCheckboxProbVisLado extends StatelessWidget {
  const LabeledCheckboxProbVisLado({
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

class ProblemaVisionLado extends StatefulWidget {
  ProblemaVisionLado({Key key}) : super(key: key);

  @override
  ProblemaVisionLadoWidgetState createState() =>
      ProblemaVisionLadoWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class ProblemaVisionLadoWidgetState extends State<ProblemaVisionLado> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxProbVisLado(
      label: 'Problemas de visión de un lado',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: vision_lado,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          vision_lado = newValue;
        });
      },
    );
  }
}

//---------------------------------------------Visión borrosa ---------------------------------------------

class LabeledCheckboxVisionBorrosa extends StatelessWidget {
  const LabeledCheckboxVisionBorrosa({
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

class VisionBorrosa extends StatefulWidget {
  VisionBorrosa({Key key}) : super(key: key);

  @override
  VisionBorrosaWidgetState createState() => VisionBorrosaWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class VisionBorrosaWidgetState extends State<VisionBorrosa> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxVisionBorrosa(
      label: 'Visión borrosa',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: vision_borrosa,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          vision_borrosa = newValue;
        });
      },
    );
  }
}

//---------------------------------------------Visión doble ---------------------------------------------

class LabeledCheckboxVisionDoble extends StatelessWidget {
  const LabeledCheckboxVisionDoble({
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

class VisionDoble extends StatefulWidget {
  VisionDoble({Key key}) : super(key: key);

  @override
  VisionDobleWidgetState createState() => VisionDobleWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class VisionDobleWidgetState extends State<VisionDoble> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxVisionDoble(
      label: 'Utiliza anteojos para ver de cerca',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: vision_doble,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          vision_doble = newValue;
        });
      },
    );
  }
}

//---------------------------------------------Ve cosas que no existen ---------------------------------------------

class LabeledCheckboxVeCosasNoExisten extends StatelessWidget {
  const LabeledCheckboxVeCosasNoExisten({
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

class VeCosasNoExisten extends StatefulWidget {
  VeCosasNoExisten({Key key}) : super(key: key);

  @override
  VeCosasNoExistenWidgetState createState() => VeCosasNoExistenWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class VeCosasNoExistenWidgetState extends State<VeCosasNoExisten> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxVeCosasNoExisten(
      label: 'Ve cosas que no existen',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: cosas_no_existen,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          cosas_no_existen = newValue;
        });
      },
    );
  }
}

//---------------------------------------------Sensibilidad a las luces brillantes ---------------------------------------------

class LabeledCheckboxSensiLucesBrillantes extends StatelessWidget {
  const LabeledCheckboxSensiLucesBrillantes({
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

class SensiLucesBrillantes extends StatefulWidget {
  SensiLucesBrillantes({Key key}) : super(key: key);

  @override
  SensiLucesBrillantesWidgetState createState() =>
      SensiLucesBrillantesWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class SensiLucesBrillantesWidgetState extends State<SensiLucesBrillantes> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxSensiLucesBrillantes(
      label: 'Sensibilidad a las luces brillantes',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: sensibilidad_cosas_brillantes,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          sensibilidad_cosas_brillantes = newValue;
        });
      },
    );
  }
}

//---------------------------------------------Periodos cortos de ceguera ---------------------------------------------

class LabeledCheckboxPeriodosCortosCeguera extends StatelessWidget {
  const LabeledCheckboxPeriodosCortosCeguera({
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

class PeriodosCortosCeguera extends StatefulWidget {
  PeriodosCortosCeguera({Key key}) : super(key: key);

  @override
  PeriodosCortosCegueraWidgetState createState() =>
      PeriodosCortosCegueraWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class PeriodosCortosCegueraWidgetState extends State<PeriodosCortosCeguera> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxPeriodosCortosCeguera(
      label: 'Periodos cortos de ceguera',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: periodos_ceguera,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          periodos_ceguera = newValue;
        });
      },
    );
  }
}

//---------------------------------------------No percibe cosas que pasan al lado de su cuerpo ---------------------------------------------

class LabeledCheckboxCosasPasanCuerpo extends StatelessWidget {
  const LabeledCheckboxCosasPasanCuerpo({
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

class CosasPasanCuerpo extends StatefulWidget {
  CosasPasanCuerpo({Key key}) : super(key: key);

  @override
  CosasPasanCuerpoWidgetState createState() => CosasPasanCuerpoWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class CosasPasanCuerpoWidgetState extends State<CosasPasanCuerpo> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxCosasPasanCuerpo(
      label: 'No percibe cosas que pasan al lado de su cuerpo',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: persibe_cosas_cuerpo,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          persibe_cosas_cuerpo = newValue;
        });
      },
    );
  }
}

//---------------------------------------------Dificultad para distinguir el calor del frío ---------------------------------------------

class LabeledCheckboxDistinguirCalorFrio extends StatelessWidget {
  const LabeledCheckboxDistinguirCalorFrio({
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

class DistinguirCalorFrio extends StatefulWidget {
  DistinguirCalorFrio({Key key}) : super(key: key);

  @override
  DistinguirCalorFrioWidgetState createState() =>
      DistinguirCalorFrioWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class DistinguirCalorFrioWidgetState extends State<DistinguirCalorFrio> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxDistinguirCalorFrio(
      label: 'Dificultad para distinguir el calor del frío',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: dificultad_calor_frio,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          dificultad_calor_frio = newValue;
        });
      },
    );
  }
}

//---------------------------------------------Problemas de gusto ---------------------------------------------

class LabeledCheckboxProblemasGusto extends StatelessWidget {
  const LabeledCheckboxProblemasGusto({
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

class ProblemasGusto extends StatefulWidget {
  ProblemasGusto({Key key}) : super(key: key);

  @override
  ProblemasGustoWidgetState createState() => ProblemasGustoWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class ProblemasGustoWidgetState extends State<ProblemasGusto> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxProblemasGusto(
      label: 'Problemas de gusto',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: problemas_gusto,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          problemas_gusto = newValue;
        });
      },
    );
  }
}

//---------------------------------------------Problemas de olfato ---------------------------------------------

class LabeledCheckboxProblemasOlfato extends StatelessWidget {
  const LabeledCheckboxProblemasOlfato({
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

class ProblemasOlfato extends StatefulWidget {
  ProblemasOlfato({Key key}) : super(key: key);

  @override
  ProblemasOlfatoWidgetState createState() => ProblemasOlfatoWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class ProblemasOlfatoWidgetState extends State<ProblemasOlfato> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxProblemasOlfato(
      label: 'Problemas de olfato',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: problemas_olfato,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          problemas_olfato = newValue;
        });
      },
    );
  }
}

//---------------------------------------------Dolor ---------------------------------------------

class LabeledCheckboxDolor extends StatelessWidget {
  const LabeledCheckboxDolor({
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

class Dolor extends StatefulWidget {
  Dolor({Key key}) : super(key: key);

  @override
  DolorWidgetState createState() => DolorWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class DolorWidgetState extends State<Dolor> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxDolor(
      label: 'Dolor',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: dolor,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          dolor = newValue;
        });
      },
    );
  }
}
