import 'package:app_salud/widgets/LabeledCheckboxGeneric.dart';
import 'package:app_salud/widgets/alert_informe.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../services/usuario_services.dart';
import 'env.dart';
import 'ajustes.dart';

var id_paciente;
var id_medico;
var tipo_screening;
var id_recordatorio;
var screening_recordatorio;
var email;
var usuarioModel;

class FormScreeningSintomas extends StatefulWidget {
  final pageName = 'screening_fisico';

  @override
  _FormpruebaState createState() => _FormpruebaState();
}

class _FormpruebaState extends State<FormScreeningSintomas> {
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getStringValuesSF();

    return WillPopScope(
      onWillPop: () async {
        // Navegar a la ruta deseada, por ejemplo, la ruta '/inicio':
        Navigator.pushNamed(context, '/screening', arguments: {
          "select_screening": "SFMS",
        });
        // Devuelve 'true' para permitir la navegación hacia atrás.
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, '/screening', arguments: {
                "select_screening": "SFMS",
              });
            },
          ),
          title: Text('Chequeo Físico',
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
        body: FutureBuilder(
            future: getAllRespuestaFisico(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ScreeningFisico();
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    semanticsLabel: "Cargando",
                  ),
                );
              }
            }),
      ),
    );
  }

  getStringValuesSF() async {
    usuarioModel = Provider.of<UsuarioServices>(context);
    id_paciente = usuarioModel.usuario.paciente.id_paciente;
    email = usuarioModel.usuario.emailUser;

    Map parametros = ModalRoute.of(context).settings.arguments;

    getTipoScreening(parametros["tipo_screening"]);

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

  getTipoScreening(var codigo_screening) async {
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

  void choiceAction(String choice) {
    if (choice == Constants.Ajustes) {
      Navigator.pushNamed(context, '/ajustes');
    } else if (choice == Constants.Salir) {
      Navigator.pushNamed(context, '/');
    }
  }
}

List respuestaFisico;

Future<List> getAllRespuestaFisico() async {
  var response;

  String URL_base = Env.URL_API;
  var url = URL_base + "/tipo_eventos_fisico";

  response = await http.post(url, body: {});

  var jsonData = json.decode(response.body);

  if (response.statusCode == 200) {
    return respuestaFisico = jsonData['data'];
  } else {
    return null;
  }
}

//----------------------------------------Screening de Sintomas ------------------------------------------

class ScreeningFisico extends StatefulWidget {
  ScreeningFisico({Key key}) : super(key: key);

  @override
  FisicoWidgetState createState() => FisicoWidgetState();
}

class FisicoWidgetState extends State<ScreeningFisico> {
  final _formKey_screening_fisico = GlobalKey<FormState>();

// FISICO

  ValueNotifier<bool> valueNotifierDolorCabeza = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierMareos = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierNauceas = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierVomito = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierFatigaExcesiva = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierUrinaria = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierProblemasInstestinales =
      ValueNotifier<bool>(false);

// MOTOR

  ValueNotifier<bool> valueNotifierDebilidadLadoCuerpo =
      ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierProblemasMotricidad =
      ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierTemblores = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierInestabilidadMarcha =
      ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierTicsMovExtranos = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierProblemasEquilibrio =
      ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierChoqueCosas = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierDesmayo = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierCaidas = ValueNotifier<bool>(false);

// Sensibilidad

  ValueNotifier<bool> valueNotifierPerdidaSensibilidad =
      ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierCosquilleoPiel = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierOjosClaridad = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierPerdidaAudicion = ValueNotifier<bool>(false);

  ValueNotifier<bool> valueNotifierUtilizaAudifonos =
      ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierZumbido = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierAnteojoCerca = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierAnteojoLejos = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierVisionLado = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierVisionBorrosa = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierVisionDoble = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierCosasNoExisten = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierSensibilidadCosasBrillantes =
      ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierPeriodosCeguera = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierPersibeCosasCuerpo =
      ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierDificultadCalorFrio =
      ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierProblemasGusto = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierProblemasOlfato = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierDolor = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey_screening_fisico,
      child: Card(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            CheckDolorCabeza(
                valueNotifierDolorCabeza: valueNotifierDolorCabeza),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Divider(height: 3.0, color: Colors.black),
            CheckMareos(valueNotifierMareos: valueNotifierMareos),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Divider(height: 3.0, color: Colors.black),
            Nauseas(valueNotifierNauceas: valueNotifierNauceas),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Divider(height: 3.0, color: Colors.black),
            Vomitos(valueNotifierVomito: valueNotifierVomito),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Divider(height: 3.0, color: Colors.black),
            FatigaExcesiva(
                valueNotifierFatigaExcesiva: valueNotifierFatigaExcesiva),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Divider(height: 3.0, color: Colors.black),
            IncontinenciaUrinaria(valueNotifierUrinaria: valueNotifierUrinaria),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Divider(height: 3.0, color: Colors.black),
            ProblemasInstestinales(
                valueNotifierProblemasInstestinales:
                    valueNotifierProblemasInstestinales),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Divider(height: 3.0, color: Colors.black),
            DebilidadLadoCuerpo(
                valueNotifierDebilidadLadoCuerpo:
                    valueNotifierDebilidadLadoCuerpo),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Divider(height: 3.0, color: Colors.black),
            ProblemasMotricidadFina(
                valueNotifierProblemasMotricidad:
                    valueNotifierProblemasMotricidad),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Divider(height: 3.0, color: Colors.black),
            Temblores(valueNotifierTemblores: valueNotifierTemblores),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Divider(height: 3.0, color: Colors.black),
            InestabilidadMarcha(
                valueNotifierInestabilidadMarcha:
                    valueNotifierInestabilidadMarcha),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Divider(height: 3.0, color: Colors.black),
            TicsMovExtranos(
                valueNotifierTicsMovExtranos: valueNotifierTicsMovExtranos),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Divider(height: 3.0, color: Colors.black),
            ProblemaEquilibrio(
                valueNotifierProblemasEquilibrio:
                    valueNotifierProblemasEquilibrio),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Divider(height: 3.0, color: Colors.black),
            ConFrecCosas(valueNotifierChoqueCosas: valueNotifierChoqueCosas),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Divider(height: 3.0, color: Colors.black),
            DesvanDesmayo(valueNotifierDesmayo: valueNotifierDesmayo),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Divider(height: 3.0, color: Colors.black),
            Caidas(valueNotifierCaidas: valueNotifierCaidas),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Divider(height: 3.0, color: Colors.black),
            PerdidaSensibilidad(
                valueNotifierPerdidaSensibilidad:
                    valueNotifierPerdidaSensibilidad),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Divider(height: 3.0, color: Colors.black),
            CosqSensaPiel(
                valueNotifierCosquilleoPiel: valueNotifierCosquilleoPiel),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Divider(height: 3.0, color: Colors.black),
            NecesidadOjosClaridad(
                valueNotifierOjosClaridad: valueNotifierOjosClaridad),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Divider(height: 3.0, color: Colors.black),
            PerdidaAudicion(
                valueNotifierPerdidaAudicion: valueNotifierPerdidaAudicion),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Divider(height: 3.0, color: Colors.black),
            UtilizaAudifonos(
                valueNotifierUtilizaAudifonos: valueNotifierUtilizaAudifonos),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Divider(height: 3.0, color: Colors.black),
            Zumbido(valueNotifierZumbido: valueNotifierZumbido),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Divider(height: 3.0, color: Colors.black),
            UtilizaAnteojosCerca(
                valueNotifierAnteojoCerca: valueNotifierAnteojoCerca),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Divider(height: 3.0, color: Colors.black),
            UtilizaAnteojosLejos(
                valueNotifierAnteojoLejos: valueNotifierAnteojoLejos),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Divider(height: 3.0, color: Colors.black),
            ProblemaVisionLado(
                valueNotifierVisionLado: valueNotifierVisionLado),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Divider(height: 3.0, color: Colors.black),
            VisionBorrosa(
                valueNotifierVisionBorrosa: valueNotifierVisionBorrosa),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Divider(height: 3.0, color: Colors.black),
            VisionDoble(valueNotifierVisionDoble: valueNotifierVisionDoble),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Divider(height: 3.0, color: Colors.black),
            VeCosasNoExisten(
                valueNotifierCosasNoExisten: valueNotifierCosasNoExisten),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Divider(height: 3.0, color: Colors.black),
            SensiLucesBrillantes(
                valueNotifierSensibilidadCosasBrillantes:
                    valueNotifierSensibilidadCosasBrillantes),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Divider(height: 3.0, color: Colors.black),
            PeriodosCortosCeguera(
                valueNotifierPeriodosCeguera: valueNotifierPeriodosCeguera),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Divider(height: 3.0, color: Colors.black),
            CosasPasanCuerpo(
                valueNotifierPersibeCosasCuerpo:
                    valueNotifierPersibeCosasCuerpo),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Divider(height: 3.0, color: Colors.black),
            DistinguirCalorFrio(
                valueNotifierDificultadCalorFrio:
                    valueNotifierDificultadCalorFrio),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Divider(height: 3.0, color: Colors.black),
            ProblemasGusto(
                valueNotifierProblemasGusto: valueNotifierProblemasGusto),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Divider(height: 3.0, color: Colors.black),
            ProblemasOlfato(
                valueNotifierProblemasOlfato: valueNotifierProblemasOlfato),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Divider(height: 3.0, color: Colors.black),
            Dolor(valueNotifierDolor: valueNotifierDolor),
            Divider(height: 3.0, color: Colors.black),
            Padding(
              padding: EdgeInsets.all(18.0),
            ),
            Center(
              child: ElevatedButton.icon(
                icon: _isLoading
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: const CircularProgressIndicator(),
                      )
                    : const Icon(Icons.save_alt),
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily),
                ),
                onPressed: () => !_isLoading ? _startLoading() : null,
                label: Text('GUARDAR',
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
          ],
        ),
      ),
    );
  }

  bool _isLoading = false;
  void _startLoading() async {
    setState(() {
      _isLoading = true;
    });

    showDialogMessage();

    await guardarDatosFisicos(cant_check, context);

    setState(() {
      _isLoading = false;
    });
  }

  guardarDatosFisicos(var cant_check, BuildContext context) async {
    String URL_base = Env.URL_API;
    var url = URL_base + "/respuesta_screening_fisico";
    var response = await http.post(url, body: {
      "id_paciente": id_paciente.toString(),
      "id_medico": id_medico.toString(),
      "id_recordatorio": id_recordatorio.toString(),
      "tipo_screening": tipo_screening['data'].toString(),
      "cantidad": cant_check.toString(),
      "dolor_cabeza": valueNotifierDolorCabeza.value.toString(),
      "mareos": valueNotifierMareos.value.toString(),
      "nauceas": valueNotifierNauceas.value.toString(),
      "vomito": valueNotifierVomito.value.toString(),
      "fatiga_excesiva": valueNotifierFatigaExcesiva.value.toString(),
      "urinaria": valueNotifierUrinaria.value.toString(),
      "problemas_instestinales":
          valueNotifierProblemasInstestinales.value.toString(),
      "debilidad_lado_cuerpo":
          valueNotifierDebilidadLadoCuerpo.value.toString(),
      "problemas_motricidad": valueNotifierProblemasMotricidad.value.toString(),
      "temblores": valueNotifierTemblores.value.toString(),
      "inestabilidad_marcha": valueNotifierInestabilidadMarcha.value.toString(),
      "tics_mov_extranos": valueNotifierTicsMovExtranos.value.toString(),
      "problemas_equilibrio": valueNotifierProblemasEquilibrio.value.toString(),
      "choque_cosas": valueNotifierChoqueCosas.value.toString(),
      "desmayo": valueNotifierDesmayo.value.toString(),
      "caidas": valueNotifierCaidas.value.toString(),
      "perdida_sensibilidad": valueNotifierPerdidaSensibilidad.value.toString(),
      "cosquilleo_piel": valueNotifierCosquilleoPiel.value.toString(),
      "ojos_claridad": valueNotifierOjosClaridad.value.toString(),
      "perdida_audicion": valueNotifierPerdidaAudicion.value.toString(),
      "utiliza_audifonos": valueNotifierUtilizaAudifonos.value.toString(),
      "zumbido": valueNotifierZumbido.value.toString(),
      "anteojo_cerca": valueNotifierAnteojoCerca.value.toString(),
      "anteojo_lejos": valueNotifierAnteojoLejos.value.toString(),
      "vision_lado": valueNotifierVisionLado.value.toString(),
      "vision_borrosa": valueNotifierVisionBorrosa.value.toString(),
      "vision_doble": valueNotifierVisionDoble.value.toString(),
      "cosas_no_existen": valueNotifierCosasNoExisten.value.toString(),
      "sensibilidad_cosas_brillantes":
          valueNotifierSensibilidadCosasBrillantes.value.toString(),
      "periodos_ceguera": valueNotifierPeriodosCeguera.value.toString(),
      "persibe_cosas_cuerpo": valueNotifierPersibeCosasCuerpo.value.toString(),
      "dificultad_calor_frio":
          valueNotifierDificultadCalorFrio.value.toString(),
      "problemas_gusto": valueNotifierProblemasGusto.value.toString(),
      "problemas_olfato": valueNotifierProblemasOlfato.value.toString(),
      "dolor": valueNotifierDolor.value.toString(),
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

    var responseDecoder = json.decode(response.body);

    if (responseDecoder['status'] == "Success" && response.statusCode == 200) {
      if (cant_check > 3) {
        showCustomAlert(
          context,
          "Para tener en cuenta",
          "Le sugerimos que consulte con su medico clínico sobre estos síntomas.",
          true,
          () {
            if (screening_recordatorio == true) {
              Navigator.pushNamed(context, '/recordatorio');
              _scaffold_messenger(
                  context, "Screening del Médico Respondido", 1);
            } else {
              Navigator.pushNamed(context, '/screening', arguments: {
                "select_screening": "SFMS",
              });
              _scaffold_messenger(context, "Screening Registrado", 1);
            }
          },
        );
      } else {
        Navigator.pushNamed(context, '/screening', arguments: {
          "select_screening": "SFMS",
        });
        _scaffold_messenger(context, "Screening Registrado", 1);
      }
    } else {
      showCustomAlert(
          context, "Error detectado", '${response.body}', true, () {});
    }
  }

  showDialogMessage() async {
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
}

_scaffold_messenger(context, message, colorNumber) {
  var color;
  colorNumber == 1 ? color = Colors.green[800] : color = Colors.red[600];

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: color,
    content: Text(message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white)),
  ));
}

//----------------------------------------VARIABLES CHECKBOX -----------------------------------------------
// Contador
var cant_check = 0;

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

//

//-------------------------------------- DOLOR DE CABEZA -----------------------------------------------------

class CheckDolorCabeza extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierDolorCabeza;

  CheckDolorCabeza({this.valueNotifierDolorCabeza});

  @override
  CheckCheckDolorCabezaWidgetState createState() =>
      CheckCheckDolorCabezaWidgetState();
}

class CheckCheckDolorCabezaWidgetState extends State<CheckDolorCabeza> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: respuestaFisico[0]['nombre_evento'],
      //'Dolor de Cabeza',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierDolorCabeza.value,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          widget.valueNotifierDolorCabeza.value = newValue;
        });
      },
      textStyle: TextStyle(
        fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      checkboxScale: 1.5,
    );
  }
}

//-----------------------------------------------------------------------------------------------------------

// --------------------------------- MAREOS ----------------------------------------------------

class CheckMareos extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierMareos;

  CheckMareos({this.valueNotifierMareos});

  @override
  CheckCheckMareosWidgetState createState() => CheckCheckMareosWidgetState();
}

class CheckCheckMareosWidgetState extends State<CheckMareos> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: respuestaFisico[1]['nombre_evento'],
      //'Mareos',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierMareos.value,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          widget.valueNotifierMareos.value = newValue;
        });
      },
      textStyle: TextStyle(
        fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      checkboxScale: 1.5,
    );
  }
}

//-------------------------------------------Nauseas--------------------------------------------

class Nauseas extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierNauceas;

  Nauseas({this.valueNotifierNauceas});

  @override
  NauseasWidgetState createState() => NauseasWidgetState();
}

class NauseasWidgetState extends State<Nauseas> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      //label: 'Nauseas',
      label: respuestaFisico[2]['nombre_evento'],
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierNauceas.value,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          widget.valueNotifierNauceas.value = newValue;
        });
      },
      textStyle: TextStyle(
        fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      checkboxScale: 1.5,
    );
  }
}

//------------------------------------------ VOMITOS -------------------------------------------

class Vomitos extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierVomito;

  Vomitos({this.valueNotifierVomito});

  @override
  VomitosWidgetState createState() => VomitosWidgetState();
}

class VomitosWidgetState extends State<Vomitos> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: 'Vómitos',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierVomito.value,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          widget.valueNotifierVomito.value = newValue;
        });
      },
      textStyle: TextStyle(
        fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      checkboxScale: 1.5,
    );
  }
}

//------------------------------------------Fatiga excesiva ---------------------------------------

class FatigaExcesiva extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierFatigaExcesiva;

  FatigaExcesiva({this.valueNotifierFatigaExcesiva});

  @override
  FatigaExcesivaWidgetState createState() => FatigaExcesivaWidgetState();
}

class FatigaExcesivaWidgetState extends State<FatigaExcesiva> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: 'Fatiga excesiva',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierFatigaExcesiva.value,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          widget.valueNotifierFatigaExcesiva.value = newValue;
        });
      },
      textStyle: TextStyle(
        fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      checkboxScale: 1.5,
    );
  }
}

// ----------------------------------------Incontinencia urinaria---------------------------------------

class IncontinenciaUrinaria extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierUrinaria;

  IncontinenciaUrinaria({this.valueNotifierUrinaria});

  @override
  IncontinenciaUrinariaWidgetState createState() =>
      IncontinenciaUrinariaWidgetState();
}

class IncontinenciaUrinariaWidgetState extends State<IncontinenciaUrinaria> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: 'Incontinencia urinaria',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierUrinaria.value,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          widget.valueNotifierUrinaria.value = newValue;
        });
      },
      textStyle: TextStyle(
        fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      checkboxScale: 1.5,
    );
  }
}

// ----------------------------------------Problemas intestinales -----------------------------------

class ProblemasInstestinales extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierProblemasInstestinales;

  ProblemasInstestinales({this.valueNotifierProblemasInstestinales});

  @override
  ProblemasInstestinalesWidgetState createState() =>
      ProblemasInstestinalesWidgetState();
}

class ProblemasInstestinalesWidgetState extends State<ProblemasInstestinales> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: 'Problemas intestinales',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierProblemasInstestinales.value,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          widget.valueNotifierProblemasInstestinales.value = newValue;
        });
      },
      textStyle: TextStyle(
        fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      checkboxScale: 1.5,
    );
  }
}

// -----------------------------------------Debilidad de un lado del cuerpo -----------------------------------------------------

class DebilidadLadoCuerpo extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierDebilidadLadoCuerpo;

  DebilidadLadoCuerpo({this.valueNotifierDebilidadLadoCuerpo});

  @override
  DebilidadLadoCuerpoWidgetState createState() =>
      DebilidadLadoCuerpoWidgetState();
}

class DebilidadLadoCuerpoWidgetState extends State<DebilidadLadoCuerpo> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: 'Debilidad de un lado del cuerpo',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierDebilidadLadoCuerpo.value,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          widget.valueNotifierDebilidadLadoCuerpo.value = newValue;
        });
      },
      textStyle: TextStyle(
        fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      checkboxScale: 1.5,
    );
  }
}

//-------------------------------------------- Problemas en la motricidad fina -----------------------------------------------------------

class ProblemasMotricidadFina extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierProblemasMotricidad;

  ProblemasMotricidadFina({this.valueNotifierProblemasMotricidad});

  @override
  ProblemasMotricidadFinaWidgetState createState() =>
      ProblemasMotricidadFinaWidgetState();
}

class ProblemasMotricidadFinaWidgetState
    extends State<ProblemasMotricidadFina> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: 'Problemas en la motricidad fina',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierProblemasMotricidad.value,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          widget.valueNotifierProblemasMotricidad.value = newValue;
        });
      },
      textStyle: TextStyle(
        fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      checkboxScale: 1.5,
    );
  }
}

// -------------------------------------------Temblores --------------------------------------------

class Temblores extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierTemblores;

  Temblores({this.valueNotifierTemblores});

  @override
  TembloresWidgetState createState() => TembloresWidgetState();
}

class TembloresWidgetState extends State<Temblores> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: 'Temblores',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierTemblores.value,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          widget.valueNotifierTemblores.value = newValue;
        });
      },
      textStyle: TextStyle(
        fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      checkboxScale: 1.5,
    );
  }
}

// ------------------------------------------Inestabilidad en la marcha ---------------------------------------------------

class InestabilidadMarcha extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierInestabilidadMarcha;

  InestabilidadMarcha({this.valueNotifierInestabilidadMarcha});

  @override
  InestabilidadMarchaWidgetState createState() =>
      InestabilidadMarchaWidgetState();
}

class InestabilidadMarchaWidgetState extends State<InestabilidadMarcha> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: 'Inestabilidad en la marcha',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierInestabilidadMarcha.value,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          widget.valueNotifierInestabilidadMarcha.value = newValue;
        });
      },
      textStyle: TextStyle(
        fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      checkboxScale: 1.5,
    );
  }
}
//-------------------------------------------- Tics o movimientos extraños---------------------------------------------------

class TicsMovExtranos extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierTicsMovExtranos;

  TicsMovExtranos({this.valueNotifierTicsMovExtranos});

  @override
  TicsMovExtranosWidgetState createState() => TicsMovExtranosWidgetState();
}

class TicsMovExtranosWidgetState extends State<TicsMovExtranos> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: 'Tics o movimientos extraños',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierTicsMovExtranos.value,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          widget.valueNotifierTicsMovExtranos.value = newValue;
        });
      },
      textStyle: TextStyle(
        fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      checkboxScale: 1.5,
    );
  }
}
//------------------------------------------Problemas de equilibrio --------------------------------------------------

class ProblemaEquilibrio extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierProblemasEquilibrio;

  ProblemaEquilibrio({this.valueNotifierProblemasEquilibrio});

  @override
  ProblemaEquiWidgetState createState() => ProblemaEquiWidgetState();
}

class ProblemaEquiWidgetState extends State<ProblemaEquilibrio> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: 'Problemas de equilibrio',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierProblemasEquilibrio.value,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          widget.valueNotifierProblemasEquilibrio.value = newValue;
        });
      },
      textStyle: TextStyle(
        fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      checkboxScale: 1.5,
    );
  }
}
//-------------------------------------------- Con frecuencia se choca las cosas -------------------------------------------------

class ConFrecCosas extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierChoqueCosas;

  ConFrecCosas({this.valueNotifierChoqueCosas});

  @override
  ConFrecWidgetState createState() => ConFrecWidgetState();
}

class ConFrecWidgetState extends State<ConFrecCosas> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: 'Con frecuencia se choca las cosas',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierChoqueCosas.value,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          widget.valueNotifierChoqueCosas.value = newValue;
        });
      },
      textStyle: TextStyle(
        fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      checkboxScale: 1.5,
    );
  }
}

// --------------------------------------------Desvanecimiento o desmayo ------------------------------------------------

class DesvanDesmayo extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierDesmayo;

  DesvanDesmayo({this.valueNotifierDesmayo});

  @override
  DesvanDesWidgetState createState() => DesvanDesWidgetState();
}

class DesvanDesWidgetState extends State<DesvanDesmayo> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: 'Desvanecimiento o desmayo',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierDesmayo.value,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          widget.valueNotifierDesmayo.value = newValue;
        });
      },
      textStyle: TextStyle(
        fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      checkboxScale: 1.5,
    );
  }
}
// --------------------------------------------Caídas -------------------------------------------------

class Caidas extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierCaidas;

  Caidas({this.valueNotifierCaidas});

  @override
  CaidasWidgetState createState() => CaidasWidgetState();
}

class CaidasWidgetState extends State<Caidas> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: 'Caídas',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierCaidas.value,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          widget.valueNotifierCaidas.value = newValue;
        });
      },
      textStyle: TextStyle(
        fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      checkboxScale: 1.5,
    );
  }
}
// --------------------------------------------Pérdida de sensibilidad -----------------------------------------

class PerdidaSensibilidad extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierPerdidaSensibilidad;

  PerdidaSensibilidad({this.valueNotifierPerdidaSensibilidad});

  @override
  PerdidaSensibilidadWidgetState createState() =>
      PerdidaSensibilidadWidgetState();
}

class PerdidaSensibilidadWidgetState extends State<PerdidaSensibilidad> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: 'Pérdida de sensibilidad',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierPerdidaSensibilidad.value,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          widget.valueNotifierPerdidaSensibilidad.value = newValue;
        });
      },
      textStyle: TextStyle(
        fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      checkboxScale: 1.5,
    );
  }
}
// --------------------------------------------Cosquilleo o sensaciones extrañas en la piel ---------------------------------------------

class CosqSensaPiel extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierCosquilleoPiel;

  CosqSensaPiel({this.valueNotifierCosquilleoPiel});

  @override
  EsquizofreniaWidgetState createState() => EsquizofreniaWidgetState();
}

class EsquizofreniaWidgetState extends State<CosqSensaPiel> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: 'Cosquilleo o sensaciones extrañas en la piel',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierCosquilleoPiel.value,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          widget.valueNotifierCosquilleoPiel.value = newValue;
        });
      },
      textStyle: TextStyle(
        fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      checkboxScale: 1.5,
    );
  }
}

//---------------------------------------------Necesidad de entrecerrar los ojos o acercarse para ver con claridad ----------------------------

class NecesidadOjosClaridad extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierOjosClaridad;

  NecesidadOjosClaridad({this.valueNotifierOjosClaridad});

  @override
  NecesidadOjosClaridadWidgetState createState() =>
      NecesidadOjosClaridadWidgetState();
}

class NecesidadOjosClaridadWidgetState extends State<NecesidadOjosClaridad> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label:
          'Necesidad de entrecerrar los ojos o acercarse para ver con claridad.',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierOjosClaridad.value,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          widget.valueNotifierOjosClaridad.value = newValue;
        });
      },
      textStyle: TextStyle(
        fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      checkboxScale: 1.5,
    );
  }
}
//---------------------------------------------Pérdida de audición ---------------------------------------------

class PerdidaAudicion extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierPerdidaAudicion;

  PerdidaAudicion({this.valueNotifierPerdidaAudicion});

  @override
  PerdidaAudicionWidgetState createState() => PerdidaAudicionWidgetState();
}

class PerdidaAudicionWidgetState extends State<PerdidaAudicion> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: 'Pérdida de audición',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierPerdidaAudicion.value,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          widget.valueNotifierPerdidaAudicion.value = newValue;
        });
      },
      textStyle: TextStyle(
        fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      checkboxScale: 1.5,
    );
  }
}

//---------------------------------------------Utiliza audífonos ---------------------------------------------

class UtilizaAudifonos extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierUtilizaAudifonos;

  UtilizaAudifonos({this.valueNotifierUtilizaAudifonos});

  @override
  UtilizaAudiWidgetState createState() => UtilizaAudiWidgetState();
}

class UtilizaAudiWidgetState extends State<UtilizaAudifonos> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: 'Utiliza audífonos',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierUtilizaAudifonos.value,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          widget.valueNotifierUtilizaAudifonos.value = newValue;
        });
      },
      textStyle: TextStyle(
        fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      checkboxScale: 1.5,
    );
  }
}

//---------------------------------------------Zumbido ---------------------------------------------

class Zumbido extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierZumbido;

  Zumbido({this.valueNotifierZumbido});

  @override
  ZumbidoWidgetState createState() => ZumbidoWidgetState();
}

class ZumbidoWidgetState extends State<Zumbido> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: 'Zumbido',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierZumbido.value,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          widget.valueNotifierZumbido.value = newValue;
        });
      },
      textStyle: TextStyle(
        fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      checkboxScale: 1.5,
    );
  }
}

//---------------------------------------------Utiliza anteojos para ver de cerca ---------------------------------------------

class UtilizaAnteojosCerca extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierAnteojoCerca;

  UtilizaAnteojosCerca({this.valueNotifierAnteojoCerca});

  @override
  UtilizaAnteojosCercaWidgetState createState() =>
      UtilizaAnteojosCercaWidgetState();
}

class UtilizaAnteojosCercaWidgetState extends State<UtilizaAnteojosCerca> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: 'Utiliza anteojos para ver de cerca',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierAnteojoCerca.value,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          widget.valueNotifierAnteojoCerca.value = newValue;
        });
      },
      textStyle: TextStyle(
        fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      checkboxScale: 1.5,
    );
  }
}

//---------------------------------------------Utiliza anteojos para ver de cerca ---------------------------------------------

class UtilizaAnteojosLejos extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierAnteojoLejos;

  UtilizaAnteojosLejos({this.valueNotifierAnteojoLejos});

  @override
  UtilizaAnteojosLejosWidgetState createState() =>
      UtilizaAnteojosLejosWidgetState();
}

class UtilizaAnteojosLejosWidgetState extends State<UtilizaAnteojosLejos> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: 'Utiliza anteojos para ver de lejos',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierAnteojoLejos.value,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          widget.valueNotifierAnteojoLejos.value = newValue;
        });
      },
      textStyle: TextStyle(
        fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      checkboxScale: 1.5,
    );
  }
}

//---------------------------------------------Problemas de visión de un lado ---------------------------------------------

class ProblemaVisionLado extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierVisionLado;

  ProblemaVisionLado({this.valueNotifierVisionLado});

  @override
  ProblemaVisionLadoWidgetState createState() =>
      ProblemaVisionLadoWidgetState();
}

class ProblemaVisionLadoWidgetState extends State<ProblemaVisionLado> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: 'Problemas de visión de un lado',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierVisionLado.value,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          widget.valueNotifierVisionLado.value = newValue;
        });
      },
      textStyle: TextStyle(
        fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      checkboxScale: 1.5,
    );
  }
}

//---------------------------------------------Visión borrosa ---------------------------------------------

class VisionBorrosa extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierVisionBorrosa;

  VisionBorrosa({this.valueNotifierVisionBorrosa});

  @override
  VisionBorrosaWidgetState createState() => VisionBorrosaWidgetState();
}

class VisionBorrosaWidgetState extends State<VisionBorrosa> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: 'Visión borrosa',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierVisionBorrosa.value,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          widget.valueNotifierVisionBorrosa.value = newValue;
        });
      },
      textStyle: TextStyle(
        fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      checkboxScale: 1.5,
    );
  }
}

//---------------------------------------------Visión doble ---------------------------------------------

class VisionDoble extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierVisionDoble;

  VisionDoble({this.valueNotifierVisionDoble});

  @override
  VisionDobleWidgetState createState() => VisionDobleWidgetState();
}

class VisionDobleWidgetState extends State<VisionDoble> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: 'Utiliza anteojos para ver de cerca',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierVisionDoble.value,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          widget.valueNotifierVisionDoble.value = newValue;
        });
      },
      textStyle: TextStyle(
        fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      checkboxScale: 1.5,
    );
  }
}

//---------------------------------------------Ve cosas que no existen ---------------------------------------------

class VeCosasNoExisten extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierCosasNoExisten;

  VeCosasNoExisten({this.valueNotifierCosasNoExisten});

  @override
  VeCosasNoExistenWidgetState createState() => VeCosasNoExistenWidgetState();
}

class VeCosasNoExistenWidgetState extends State<VeCosasNoExisten> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: 'Ve cosas que no existen',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierCosasNoExisten.value,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          widget.valueNotifierCosasNoExisten.value = newValue;
        });
      },
      textStyle: TextStyle(
        fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      checkboxScale: 1.5,
    );
  }
}

//---------------------------------------------Sensibilidad a las luces brillantes ---------------------------------------------

class SensiLucesBrillantes extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierSensibilidadCosasBrillantes;

  SensiLucesBrillantes({this.valueNotifierSensibilidadCosasBrillantes});

  @override
  SensiLucesBrillantesWidgetState createState() =>
      SensiLucesBrillantesWidgetState();
}

class SensiLucesBrillantesWidgetState extends State<SensiLucesBrillantes> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: 'Sensibilidad a las luces brillantes',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierSensibilidadCosasBrillantes.value,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          widget.valueNotifierSensibilidadCosasBrillantes.value = newValue;
        });
      },
      textStyle: TextStyle(
        fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      checkboxScale: 1.5,
    );
  }
}

//---------------------------------------------Periodos cortos de ceguera ---------------------------------------------

class PeriodosCortosCeguera extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierPeriodosCeguera;

  PeriodosCortosCeguera({this.valueNotifierPeriodosCeguera});

  @override
  PeriodosCortosCegueraWidgetState createState() =>
      PeriodosCortosCegueraWidgetState();
}

class PeriodosCortosCegueraWidgetState extends State<PeriodosCortosCeguera> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: 'Periodos cortos de ceguera',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierPeriodosCeguera.value,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          widget.valueNotifierPeriodosCeguera.value = newValue;
        });
      },
      textStyle: TextStyle(
        fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      checkboxScale: 1.5,
    );
  }
}

//---------------------------------------------No percibe cosas que pasan al lado de su cuerpo ---------------------------------------------

class CosasPasanCuerpo extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierPersibeCosasCuerpo;

  CosasPasanCuerpo({this.valueNotifierPersibeCosasCuerpo});

  @override
  CosasPasanCuerpoWidgetState createState() => CosasPasanCuerpoWidgetState();
}

class CosasPasanCuerpoWidgetState extends State<CosasPasanCuerpo> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: 'No percibe cosas que pasan al lado de su cuerpo',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierPersibeCosasCuerpo.value,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          widget.valueNotifierPersibeCosasCuerpo.value = newValue;
        });
      },
      textStyle: TextStyle(
        fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      checkboxScale: 1.5,
    );
  }
}

//---------------------------------------------Dificultad para distinguir el calor del frío ---------------------------------------------

class DistinguirCalorFrio extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierDificultadCalorFrio;

  DistinguirCalorFrio({this.valueNotifierDificultadCalorFrio});

  @override
  DistinguirCalorFrioWidgetState createState() =>
      DistinguirCalorFrioWidgetState();
}

class DistinguirCalorFrioWidgetState extends State<DistinguirCalorFrio> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: 'Dificultad para distinguir el calor del frío',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierDificultadCalorFrio.value,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          widget.valueNotifierDificultadCalorFrio.value = newValue;
        });
      },
      textStyle: TextStyle(
        fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      checkboxScale: 1.5,
    );
  }
}

//---------------------------------------------Problemas de gusto ---------------------------------------------

class ProblemasGusto extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierProblemasGusto;

  ProblemasGusto({this.valueNotifierProblemasGusto});

  @override
  ProblemasGustoWidgetState createState() => ProblemasGustoWidgetState();
}

class ProblemasGustoWidgetState extends State<ProblemasGusto> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: 'Problemas de gusto',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierProblemasGusto.value,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          widget.valueNotifierProblemasGusto.value = newValue;
        });
      },
      textStyle: TextStyle(
        fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      checkboxScale: 1.5,
    );
  }
}

//---------------------------------------------Problemas de olfato ---------------------------------------------

class ProblemasOlfato extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierProblemasOlfato;

  ProblemasOlfato({this.valueNotifierProblemasOlfato});

  @override
  ProblemasOlfatoWidgetState createState() => ProblemasOlfatoWidgetState();
}

class ProblemasOlfatoWidgetState extends State<ProblemasOlfato> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: 'Problemas de olfato',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierProblemasOlfato.value,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          widget.valueNotifierProblemasOlfato.value = newValue;
        });
      },
      textStyle: TextStyle(
        fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      checkboxScale: 1.5,
    );
  }
}

//---------------------------------------------Dolor ---------------------------------------------

class Dolor extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierDolor;

  Dolor({this.valueNotifierDolor});

  @override
  DolorWidgetState createState() => DolorWidgetState();
}

class DolorWidgetState extends State<Dolor> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: 'Dolor',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierDolor.value,
      onChanged: (bool newValue) {
        setState(() {
          if (newValue == true) {
            cant_check += 1;
          } else {
            cant_check -= 1;
          }
          widget.valueNotifierDolor.value = newValue;
        });
      },
      textStyle: TextStyle(
        fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      checkboxScale: 1.5,
    );
  }
}
