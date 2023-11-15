import 'package:app_salud/widgets/alert_informe.dart';
import 'package:app_salud/widgets/alert_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../services/usuario_services.dart';
import '../widgets/CustomDivider.dart';
import 'env.dart';
import 'ajustes.dart';

var id_paciente;
var id_medico;
var tipo_screening;
var id_recordatorio;
var screening_recordatorio;
var email;
var usuarioModel;
var cant_check = 0;
List itemsRespuestasFisico = [];

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
    cant_check = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) => showCustomAlert(
          context,
          "Cuestionario Físico",
          "¿Usted presentó alguno de los siguientes sintomas en los últimos 6 meses?",
          true,
          () => Navigator.pop(context),
        ));
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

Future getAllRespuestaFisico() async {
  await getAllEventosFisico();

  String URL_base = Env.URL_API;
  var url = URL_base + "/tipo_respuesta_animo";
  var response = await http.post(url, body: {});

  var jsonDate = json.decode(response.body);

  if (response.statusCode == 200 && jsonDate['status'] != "Vacio") {
    //setState(() {
    itemsRespuestasFisico = jsonDate['data'];
    //});
    return true;
  } else {
    return false;
  }
}

List respuestaFisico;

Future<List> getAllEventosFisico() async {
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(1.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            DolorCabeza(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Mareos(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Nauseas(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Vomitos(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            FatigaExcesiva(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            IncontineciaUrinaria(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            ProblemasIntestinales(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            DebilidadLadoCuerpo(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            ProblemasMotricidadFina(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Temblores(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            InestabilidadMarcha(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            TicsMovExtranos(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            ProblemasEquilibrio(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            ConFrecuenciaGolpea(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            DesvanecimientoDesmayo(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Caidas(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            PerdidaSencibilidad(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            CosquilleoSensacionPiel(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            NecesidadOjosClaridad(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            PerdidadAudicion(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            UtilizaAudifonos(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Zumbido(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            UtilizaAnteojosCerca(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            UtilizaAnteojosLejos(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            ProblemasVisionLado(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            VisionBorrosa(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            VisionDoble(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            VeCosasNoExisten(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            SensibilidadLuz(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            PeriodosCortosCeguera(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            CosasPasanCuerpo(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            DistinguirCalorFrio(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            ProblemasGusto(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            ProblemaOlfato(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Dolor(),
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
    List<dynamic> ids_fisico = [
      id_dolor_cabeza,
      id_mareos,
      id_nauseas,
      id_vomito,
      id_fatiga_excesiva,
      id_incontinencia_urinaria,
      id_problemas_intestinales,
      id_debilidad_lado_cuerpo,
      id_problema_motricidad_fina,
      id_temblores,
      id_inestabilidad_marcha,
      id_tics_mov_extranos,
      id_problema_equilibrio,
      id_frecuencia_choca_golpea,
      id_desvanecimiento_desmayo,
      id_caidas,
      id_perdida_sencibilidad,
      id_cosquilleo_sensacion_piel,
      id_necesidad_ojos_claridad,
      id_perdidad_audicion,
      id_utiliza_audifonos,
      id_zumbido,
      id_utiliza_anteojos_cerca,
      id_utiliza_anteojos_lejos,
      id_problemas_vision_lado,
      id_vision_borrosa,
      id_vision_doble,
      id_cosas_no_existen,
      id_sensibildad_luz,
      id_periodo_ceguera,
      id_cosas_pasan_cuerpo,
      id_distinguir_calor_frio,
      id_problema_gusto,
      id_problema_olfato,
      id_dolor,
    ];

    for (var variable in ids_fisico) {
      if (variable == null) {
        alert_informe_scaffold(
            context, "Debe responder todas las preguntas", 2);
        _isLoading = false;
        return; // Salir de la función
      }
    }

    for (var variable_si in ids_fisico) {
      if (variable_si == "977") {
        cant_check += 1;
      }
    }

    String URL_base = Env.URL_API;
    var url = URL_base + "/respuesta_screening_fisico";
    var response = await http.post(url, body: {
      "id_paciente": id_paciente.toString(),
      "id_medico": id_medico.toString(),
      "id_recordatorio": id_recordatorio.toString(),
      "tipo_screening": tipo_screening['data'].toString(),
      "cantidad": cant_check.toString(),
      "dolor_cabeza": id_dolor_cabeza.toString(),
      "mareos": id_mareos.toString(),
      "nauceas": id_nauseas.toString(),
      "vomito": id_vomito.toString(),
      "fatiga_excesiva": id_fatiga_excesiva.toString(),
      "urinaria": id_incontinencia_urinaria.toString(),
      "problemas_instestinales": id_problemas_intestinales.toString(),
      "debilidad_lado_cuerpo": id_debilidad_lado_cuerpo.toString(),
      "problemas_motricidad": id_problema_motricidad_fina.toString(),
      "temblores": id_temblores.toString(),
      "inestabilidad_marcha": id_inestabilidad_marcha.toString(),
      "tics_mov_extranos": id_tics_mov_extranos.toString(),
      "problemas_equilibrio": id_problema_equilibrio.toString(),
      "choque_cosas": id_frecuencia_choca_golpea.toString(),
      "desmayo": id_desvanecimiento_desmayo.toString(),
      "caidas": id_caidas.toString(),
      "perdida_sensibilidad": id_perdida_sencibilidad.toString(),
      "cosquilleo_piel": id_cosquilleo_sensacion_piel.toString(),
      "ojos_claridad": id_necesidad_ojos_claridad.toString(),
      "perdida_audicion": id_perdidad_audicion.toString(),
      "utiliza_audifonos": id_utiliza_audifonos.toString(),
      "zumbido": id_zumbido.toString(),
      "anteojo_cerca": id_utiliza_anteojos_cerca.toString(),
      "anteojo_lejos": id_utiliza_anteojos_lejos.toString(),
      "vision_lado": id_problemas_vision_lado.toString(),
      "vision_borrosa": id_vision_borrosa.toString(),
      "vision_doble": id_vision_doble.toString(),
      "cosas_no_existen": id_cosas_no_existen.toString(),
      "sensibilidad_cosas_brillantes": id_sensibildad_luz.toString(),
      "periodos_ceguera": id_periodo_ceguera.toString(),
      "persibe_cosas_cuerpo": id_cosas_pasan_cuerpo.toString(),
      "dificultad_calor_frio": id_distinguir_calor_frio.toString(),
      "problemas_gusto": id_problema_gusto.toString(),
      "problemas_olfato": id_problema_olfato.toString(),
      "dolor": id_dolor.toString(),
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
        showCustomAlert(
          context,
          "Resultado",
          "Su estado de Ánimo es bueno.",
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
      }
    } else {
      showCustomAlert(
          context, "Error detectado", '${response.body}', true, () {});
    }
  }

  showDialogMessage() async {
    if (!_isLoading) {
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

class DolorCabeza extends StatefulWidget {
  @override
  CheckDolorCabezaWidgetState createState() => CheckDolorCabezaWidgetState();
}

class CheckDolorCabezaWidgetState extends State<DolorCabeza> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.yellow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            CustomDivider(
              text: 'Físico',
              color: Colors.lightGreen,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                "¿" + respuestaFisico[0]["nombre_evento"] + "?",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily),
              ),
            ),
            Divider(
              height: 5.0,
              color: Colors.black,
            ),
            DolorCabezaOpcion()
          ],
        ),
      ),
    );
  }
}

// DolorCabezaOpcion *******************

var id_dolor_cabeza;

class DolorCabezaOpcion extends StatefulWidget {
  @override
  DolorCabezaOpcionWidgetState createState() => DolorCabezaOpcionWidgetState();
}

class DolorCabezaOpcionWidgetState extends State<DolorCabezaOpcion> {
  @override
  void initState() {
    id_dolor_cabeza = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasFisico
            .map((list) => RadioListTile(
                  groupValue: id_dolor_cabeza,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_dolor_cabeza = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//-----------------------------------------------------------------------------------------------------------

// --------------------------------- MAREOS ----------------------------------------------------

class Mareos extends StatefulWidget {
  @override
  CheckMareosWidgetState createState() => CheckMareosWidgetState();
}

class CheckMareosWidgetState extends State<Mareos> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.yellow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            CustomDivider(
              text: 'Físico',
              color: Colors.lightGreen,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                "¿" + respuestaFisico[1]["nombre_evento"] + "?",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily),
              ),
            ),
            Divider(
              height: 5.0,
              color: Colors.black,
            ),
            MareoOpcion()
          ],
        ),
      ),
    );
  }
}

// MareoOpcion *******************

var id_mareos;

class MareoOpcion extends StatefulWidget {
  @override
  MareoOpcionWidgetState createState() => MareoOpcionWidgetState();
}

class MareoOpcionWidgetState extends State<MareoOpcion> {
  @override
  void initState() {
    id_mareos = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasFisico
            .map((list) => RadioListTile(
                  groupValue: id_mareos,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_mareos = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//-------------------------------------------Nauseas--------------------------------------------

class Nauseas extends StatefulWidget {
  @override
  CheckNauseasWidgetState createState() => CheckNauseasWidgetState();
}

class CheckNauseasWidgetState extends State<Nauseas> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.yellow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            CustomDivider(
              text: 'Físico',
              color: Colors.lightGreen,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                "¿" + respuestaFisico[2]["nombre_evento"] + "?",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily),
              ),
            ),
            Divider(
              height: 5.0,
              color: Colors.black,
            ),
            NauseasOpcion()
          ],
        ),
      ),
    );
  }
}

// NauseasOpcion *******************

var id_nauseas;

class NauseasOpcion extends StatefulWidget {
  @override
  NauseasOpcionWidgetState createState() => NauseasOpcionWidgetState();
}

class NauseasOpcionWidgetState extends State<NauseasOpcion> {
  @override
  void initState() {
    id_nauseas = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasFisico
            .map((list) => RadioListTile(
                  groupValue: id_nauseas,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_nauseas = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}
//------------------------------------------ VOMITOS -------------------------------------------

class Vomitos extends StatefulWidget {
  @override
  CheckVomitosWidgetState createState() => CheckVomitosWidgetState();
}

class CheckVomitosWidgetState extends State<Vomitos> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.yellow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            CustomDivider(
              text: 'Físico',
              color: Colors.lightGreen,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                "¿" + respuestaFisico[3]["nombre_evento"] + "?",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily),
              ),
            ),
            Divider(
              height: 5.0,
              color: Colors.black,
            ),
            VomitosOpcion()
          ],
        ),
      ),
    );
  }
}

// VomitosOpcion *******************

var id_vomito;

class VomitosOpcion extends StatefulWidget {
  @override
  VomitosOpcionWidgetState createState() => VomitosOpcionWidgetState();
}

class VomitosOpcionWidgetState extends State<VomitosOpcion> {
  @override
  void initState() {
    id_vomito = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasFisico
            .map((list) => RadioListTile(
                  groupValue: id_vomito,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_vomito = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//------------------------------------------Fatiga excesiva ---------------------------------------

class FatigaExcesiva extends StatefulWidget {
  @override
  CheckFatigaExcesivaWidgetState createState() =>
      CheckFatigaExcesivaWidgetState();
}

class CheckFatigaExcesivaWidgetState extends State<FatigaExcesiva> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.yellow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            CustomDivider(
              text: 'Físico',
              color: Colors.lightGreen,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                "¿" + respuestaFisico[4]["nombre_evento"] + "?",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily),
              ),
            ),
            Divider(
              height: 5.0,
              color: Colors.black,
            ),
            FatigaExcesivaOpcion()
          ],
        ),
      ),
    );
  }
}

// FatigaExcesivaOpcion *******************

var id_fatiga_excesiva;

class FatigaExcesivaOpcion extends StatefulWidget {
  @override
  FatigaExcesivaOpcionWidgetState createState() =>
      FatigaExcesivaOpcionWidgetState();
}

class FatigaExcesivaOpcionWidgetState extends State<FatigaExcesivaOpcion> {
  @override
  void initState() {
    id_fatiga_excesiva = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasFisico
            .map((list) => RadioListTile(
                  groupValue: id_fatiga_excesiva,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_fatiga_excesiva = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

// ----------------------------------------Incontinencia urinaria---------------------------------------

class IncontineciaUrinaria extends StatefulWidget {
  @override
  CheckIncontineciaUrinariaWidgetState createState() =>
      CheckIncontineciaUrinariaWidgetState();
}

class CheckIncontineciaUrinariaWidgetState extends State<IncontineciaUrinaria> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.yellow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            CustomDivider(
              text: 'Físico',
              color: Colors.lightGreen,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                "¿" + respuestaFisico[5]["nombre_evento"] + "?",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily),
              ),
            ),
            Divider(
              height: 5.0,
              color: Colors.black,
            ),
            IncontineciaUrinariaOpcion()
          ],
        ),
      ),
    );
  }
}

// IncontineciaUrinariaOpcion *******************

var id_incontinencia_urinaria;

class IncontineciaUrinariaOpcion extends StatefulWidget {
  @override
  IncontineciaUrinariaOpcionWidgetState createState() =>
      IncontineciaUrinariaOpcionWidgetState();
}

class IncontineciaUrinariaOpcionWidgetState
    extends State<IncontineciaUrinariaOpcion> {
  @override
  void initState() {
    id_incontinencia_urinaria = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasFisico
            .map((list) => RadioListTile(
                  groupValue: id_incontinencia_urinaria,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_incontinencia_urinaria = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

// ----------------------------------------Problemas intestinales -----------------------------------

class ProblemasIntestinales extends StatefulWidget {
  @override
  CheckProblemasIntestinalesWidgetState createState() =>
      CheckProblemasIntestinalesWidgetState();
}

class CheckProblemasIntestinalesWidgetState
    extends State<ProblemasIntestinales> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.yellow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            CustomDivider(
              text: 'Físico',
              color: Colors.lightGreen,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                "¿" + respuestaFisico[6]["nombre_evento"] + "?",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily),
              ),
            ),
            Divider(
              height: 5.0,
              color: Colors.black,
            ),
            ProblemasIntestinalesOpcion()
          ],
        ),
      ),
    );
  }
}

// ProblemasIntestinalesOpcion *******************

var id_problemas_intestinales;

class ProblemasIntestinalesOpcion extends StatefulWidget {
  @override
  ProblemasIntestinalesOpcionWidgetState createState() =>
      ProblemasIntestinalesOpcionWidgetState();
}

class ProblemasIntestinalesOpcionWidgetState
    extends State<ProblemasIntestinalesOpcion> {
  @override
  void initState() {
    id_problemas_intestinales = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasFisico
            .map((list) => RadioListTile(
                  groupValue: id_problemas_intestinales,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_problemas_intestinales = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

// -----------------------------------------Debilidad de un lado del cuerpo -----------------------------------------------------

class DebilidadLadoCuerpo extends StatefulWidget {
  @override
  CheckDebilidadLadoCuerpoWidgetState createState() =>
      CheckDebilidadLadoCuerpoWidgetState();
}

class CheckDebilidadLadoCuerpoWidgetState extends State<DebilidadLadoCuerpo> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.yellow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            CustomDivider(
              text: 'Motor',
              color: Colors.deepPurple,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                "¿" + respuestaFisico[7]["nombre_evento"] + "?",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily),
              ),
            ),
            Divider(
              height: 5.0,
              color: Colors.black,
            ),
            DebilidadLadoCuerpoOpcion()
          ],
        ),
      ),
    );
  }
}

// DebilidadLadoCuerpoOpcion *******************

var id_debilidad_lado_cuerpo;

class DebilidadLadoCuerpoOpcion extends StatefulWidget {
  @override
  DebilidadLadoCuerpoOpcionWidgetState createState() =>
      DebilidadLadoCuerpoOpcionWidgetState();
}

class DebilidadLadoCuerpoOpcionWidgetState
    extends State<DebilidadLadoCuerpoOpcion> {
  @override
  void initState() {
    id_debilidad_lado_cuerpo = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasFisico
            .map((list) => RadioListTile(
                  groupValue: id_debilidad_lado_cuerpo,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_debilidad_lado_cuerpo = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}
//-------------------------------------------- Problemas en la motricidad fina -----------------------------------------------------------

class ProblemasMotricidadFina extends StatefulWidget {
  @override
  CheckProblemasMotricidadFinaWidgetState createState() =>
      CheckProblemasMotricidadFinaWidgetState();
}

class CheckProblemasMotricidadFinaWidgetState
    extends State<ProblemasMotricidadFina> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.deepPurple,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            CustomDivider(
              text: 'Motor',
              color: Colors.deepPurple,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                "¿" + respuestaFisico[8]["nombre_evento"] + "?",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily),
              ),
            ),
            Divider(
              height: 5.0,
              color: Colors.black,
            ),
            ProblemasMotricidadFinaOpcion()
          ],
        ),
      ),
    );
  }
}

// ProblemasMotricidadFinaOpcion *******************

var id_problema_motricidad_fina;

class ProblemasMotricidadFinaOpcion extends StatefulWidget {
  @override
  ProblemasMotricidadFinaOpcionWidgetState createState() =>
      ProblemasMotricidadFinaOpcionWidgetState();
}

class ProblemasMotricidadFinaOpcionWidgetState
    extends State<ProblemasMotricidadFinaOpcion> {
  @override
  void initState() {
    id_problema_motricidad_fina = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasFisico
            .map((list) => RadioListTile(
                  groupValue: id_problema_motricidad_fina,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_problema_motricidad_fina = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}
// -------------------------------------------Temblores --------------------------------------------

class Temblores extends StatefulWidget {
  @override
  CheckTembloresWidgetState createState() => CheckTembloresWidgetState();
}

class CheckTembloresWidgetState extends State<Temblores> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.yellow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            CustomDivider(
              text: 'Motor',
              color: Colors.deepPurple,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                "¿" + respuestaFisico[9]["nombre_evento"] + "?",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily),
              ),
            ),
            Divider(
              height: 5.0,
              color: Colors.black,
            ),
            TembloresOpcion()
          ],
        ),
      ),
    );
  }
}

// TembloresOpcion *******************

var id_temblores;

class TembloresOpcion extends StatefulWidget {
  @override
  TembloresOpcionWidgetState createState() => TembloresOpcionWidgetState();
}

class TembloresOpcionWidgetState extends State<TembloresOpcion> {
  @override
  void initState() {
    id_temblores = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasFisico
            .map((list) => RadioListTile(
                  groupValue: id_temblores,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_temblores = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

// ------------------------------------------Inestabilidad en la marcha ---------------------------------------------------

class InestabilidadMarcha extends StatefulWidget {
  @override
  CheckInestabilidadMarchaWidgetState createState() =>
      CheckInestabilidadMarchaWidgetState();
}

class CheckInestabilidadMarchaWidgetState extends State<InestabilidadMarcha> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.yellow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            CustomDivider(
              text: 'Motor',
              color: Colors.deepPurple,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                "¿" + respuestaFisico[10]["nombre_evento"] + "?",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily),
              ),
            ),
            Divider(
              height: 5.0,
              color: Colors.black,
            ),
            InestabilidadMarchaOpcion()
          ],
        ),
      ),
    );
  }
}

// InestabilidadMarchaOpcion *******************

var id_inestabilidad_marcha;

class InestabilidadMarchaOpcion extends StatefulWidget {
  @override
  InestabilidadMarchaOpcionWidgetState createState() =>
      InestabilidadMarchaOpcionWidgetState();
}

class InestabilidadMarchaOpcionWidgetState
    extends State<InestabilidadMarchaOpcion> {
  @override
  void initState() {
    id_inestabilidad_marcha = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasFisico
            .map((list) => RadioListTile(
                  groupValue: id_inestabilidad_marcha,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_inestabilidad_marcha = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}
//-------------------------------------------- Tics o movimientos extraños---------------------------------------------------

class TicsMovExtranos extends StatefulWidget {
  @override
  CheckTicsMovExtranosWidgetState createState() =>
      CheckTicsMovExtranosWidgetState();
}

class CheckTicsMovExtranosWidgetState extends State<TicsMovExtranos> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.yellow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            CustomDivider(
              text: 'Motor',
              color: Colors.deepPurple,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                "¿" + respuestaFisico[11]["nombre_evento"] + "?",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily),
              ),
            ),
            Divider(
              height: 5.0,
              color: Colors.black,
            ),
            TicsMovExtranosOpcion()
          ],
        ),
      ),
    );
  }
}

// TicsMovExtranosOpcion *******************

var id_tics_mov_extranos;

class TicsMovExtranosOpcion extends StatefulWidget {
  @override
  TicsMovExtranosOpcionWidgetState createState() =>
      TicsMovExtranosOpcionWidgetState();
}

class TicsMovExtranosOpcionWidgetState extends State<TicsMovExtranosOpcion> {
  @override
  void initState() {
    id_tics_mov_extranos = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasFisico
            .map((list) => RadioListTile(
                  groupValue: id_tics_mov_extranos,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_tics_mov_extranos = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//------------------------------------------Problemas de equilibrio --------------------------------------------------

class ProblemasEquilibrio extends StatefulWidget {
  @override
  CheckProblemasEquilibrioWidgetState createState() =>
      CheckProblemasEquilibrioWidgetState();
}

class CheckProblemasEquilibrioWidgetState extends State<ProblemasEquilibrio> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.yellow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            CustomDivider(
              text: 'Motor',
              color: Colors.deepPurple,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                "¿" + respuestaFisico[12]["nombre_evento"] + "?",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily),
              ),
            ),
            Divider(
              height: 5.0,
              color: Colors.black,
            ),
            ProblemasEquilibrioOpcion()
          ],
        ),
      ),
    );
  }
}

// ProblemasEquilibrioOpcion *******************

var id_problema_equilibrio;

class ProblemasEquilibrioOpcion extends StatefulWidget {
  @override
  ProblemasEquilibrioOpcionWidgetState createState() =>
      ProblemasEquilibrioOpcionWidgetState();
}

class ProblemasEquilibrioOpcionWidgetState
    extends State<ProblemasEquilibrioOpcion> {
  @override
  void initState() {
    id_problema_equilibrio = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasFisico
            .map((list) => RadioListTile(
                  groupValue: id_problema_equilibrio,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_problema_equilibrio = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//-------------------------------------------- Con frecuencia se choca las cosas -------------------------------------------------

class ConFrecuenciaGolpea extends StatefulWidget {
  @override
  CheckConFrecuenciaGolpeaWidgetState createState() =>
      CheckConFrecuenciaGolpeaWidgetState();
}

class CheckConFrecuenciaGolpeaWidgetState extends State<ConFrecuenciaGolpea> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.yellow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            CustomDivider(
              text: 'Motor',
              color: Colors.deepPurple,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                "¿" + respuestaFisico[13]["nombre_evento"] + "?",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily),
              ),
            ),
            Divider(
              height: 5.0,
              color: Colors.black,
            ),
            ConFrecuenciaGolpeaOpcion()
          ],
        ),
      ),
    );
  }
}

// ConFrecuenciaGolpeaOpcion *******************

var id_frecuencia_choca_golpea;

class ConFrecuenciaGolpeaOpcion extends StatefulWidget {
  @override
  ConFrecuenciaGolpeaOpcionWidgetState createState() =>
      ConFrecuenciaGolpeaOpcionWidgetState();
}

class ConFrecuenciaGolpeaOpcionWidgetState
    extends State<ConFrecuenciaGolpeaOpcion> {
  @override
  void initState() {
    id_frecuencia_choca_golpea = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasFisico
            .map((list) => RadioListTile(
                  groupValue: id_frecuencia_choca_golpea,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_frecuencia_choca_golpea = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

// --------------------------------------------Desvanecimiento o desmayo ------------------------------------------------

class DesvanecimientoDesmayo extends StatefulWidget {
  @override
  CheckDesvanecimientoDesmayoWidgetState createState() =>
      CheckDesvanecimientoDesmayoWidgetState();
}

class CheckDesvanecimientoDesmayoWidgetState
    extends State<DesvanecimientoDesmayo> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.yellow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            CustomDivider(
              text: 'Motor',
              color: Colors.deepPurple,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                "¿" + respuestaFisico[14]["nombre_evento"] + "?",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily),
              ),
            ),
            Divider(
              height: 5.0,
              color: Colors.black,
            ),
            DesvanecimientoDesmayoOpcion()
          ],
        ),
      ),
    );
  }
}

// DesvanecimientoDesmayoOpcion *******************

var id_desvanecimiento_desmayo;

class DesvanecimientoDesmayoOpcion extends StatefulWidget {
  @override
  DesvanecimientoDesmayoOpcionWidgetState createState() =>
      DesvanecimientoDesmayoOpcionWidgetState();
}

class DesvanecimientoDesmayoOpcionWidgetState
    extends State<DesvanecimientoDesmayoOpcion> {
  @override
  void initState() {
    id_desvanecimiento_desmayo = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasFisico
            .map((list) => RadioListTile(
                  groupValue: id_desvanecimiento_desmayo,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_desvanecimiento_desmayo = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

// --------------------------------------------Caídas -------------------------------------------------

class Caidas extends StatefulWidget {
  @override
  CheckCaidasWidgetState createState() => CheckCaidasWidgetState();
}

class CheckCaidasWidgetState extends State<Caidas> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.yellow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            CustomDivider(
              text: 'Motor',
              color: Colors.deepPurple,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                "¿" + respuestaFisico[15]["nombre_evento"] + "?",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily),
              ),
            ),
            Divider(
              height: 5.0,
              color: Colors.black,
            ),
            CaidasOpcion()
          ],
        ),
      ),
    );
  }
}

// CaidasOpcion *******************

var id_caidas;

class CaidasOpcion extends StatefulWidget {
  @override
  CaidasOpcionWidgetState createState() => CaidasOpcionWidgetState();
}

class CaidasOpcionWidgetState extends State<CaidasOpcion> {
  @override
  void initState() {
    id_caidas = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasFisico
            .map((list) => RadioListTile(
                  groupValue: id_caidas,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_caidas = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

// --------------------------------------------Pérdida de sensibilidad -----------------------------------------

class PerdidaSencibilidad extends StatefulWidget {
  @override
  CheckPerdidaSencibilidadWidgetState createState() =>
      CheckPerdidaSencibilidadWidgetState();
}

class CheckPerdidaSencibilidadWidgetState extends State<PerdidaSencibilidad> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.yellow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            CustomDivider(
              text: 'Sensorial',
              color: Colors.pinkAccent,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                "¿" + respuestaFisico[16]["nombre_evento"] + "?",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily),
              ),
            ),
            Divider(
              height: 5.0,
              color: Colors.black,
            ),
            PerdidaSencibilidadOpcion()
          ],
        ),
      ),
    );
  }
}

// PerdidaSencibilidadOpcion *******************

var id_perdida_sencibilidad;

class PerdidaSencibilidadOpcion extends StatefulWidget {
  @override
  PerdidaSencibilidadOpcionWidgetState createState() =>
      PerdidaSencibilidadOpcionWidgetState();
}

class PerdidaSencibilidadOpcionWidgetState
    extends State<PerdidaSencibilidadOpcion> {
  @override
  void initState() {
    id_perdida_sencibilidad = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasFisico
            .map((list) => RadioListTile(
                  groupValue: id_perdida_sencibilidad,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_perdida_sencibilidad = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

// --------------------------------------------Cosquilleo o sensaciones extrañas en la piel ---------------------------------------------

class CosquilleoSensacionPiel extends StatefulWidget {
  @override
  CheckCosquilleoSensacionPielWidgetState createState() =>
      CheckCosquilleoSensacionPielWidgetState();
}

class CheckCosquilleoSensacionPielWidgetState
    extends State<CosquilleoSensacionPiel> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.yellow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            CustomDivider(
              text: 'Sensorial',
              color: Colors.pinkAccent,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                "¿" + respuestaFisico[17]["nombre_evento"] + "?",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily),
              ),
            ),
            Divider(
              height: 5.0,
              color: Colors.black,
            ),
            CosquilleoSensacionPielOpcion()
          ],
        ),
      ),
    );
  }
}

// CosquilleoSensacionPielOpcion *******************

var id_cosquilleo_sensacion_piel;

class CosquilleoSensacionPielOpcion extends StatefulWidget {
  @override
  CosquilleoSensacionPielOpcionWidgetState createState() =>
      CosquilleoSensacionPielOpcionWidgetState();
}

class CosquilleoSensacionPielOpcionWidgetState
    extends State<CosquilleoSensacionPielOpcion> {
  @override
  void initState() {
    id_cosquilleo_sensacion_piel = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasFisico
            .map((list) => RadioListTile(
                  groupValue: id_cosquilleo_sensacion_piel,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_cosquilleo_sensacion_piel = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//---------------------------------------------Necesidad de entrecerrar los ojos o acercarse para ver con claridad ----------------------------

class NecesidadOjosClaridad extends StatefulWidget {
  @override
  CheckNecesidadOjosClaridadWidgetState createState() =>
      CheckNecesidadOjosClaridadWidgetState();
}

class CheckNecesidadOjosClaridadWidgetState
    extends State<NecesidadOjosClaridad> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.yellow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            CustomDivider(
              text: 'Sensorial',
              color: Colors.pinkAccent,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                "¿" + respuestaFisico[18]["nombre_evento"] + "?",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily),
              ),
            ),
            Divider(
              height: 5.0,
              color: Colors.black,
            ),
            NecesidadOjosClaridadOpcion()
          ],
        ),
      ),
    );
  }
}

// NecesidadOjosClaridadOpcion *******************

var id_necesidad_ojos_claridad;

class NecesidadOjosClaridadOpcion extends StatefulWidget {
  @override
  NecesidadOjosClaridadOpcionWidgetState createState() =>
      NecesidadOjosClaridadOpcionWidgetState();
}

class NecesidadOjosClaridadOpcionWidgetState
    extends State<NecesidadOjosClaridadOpcion> {
  @override
  void initState() {
    id_necesidad_ojos_claridad = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasFisico
            .map((list) => RadioListTile(
                  groupValue: id_necesidad_ojos_claridad,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_necesidad_ojos_claridad = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//---------------------------------------------Pérdida de audición ---------------------------------------------

class PerdidadAudicion extends StatefulWidget {
  @override
  CheckPerdidadAudicionWidgetState createState() =>
      CheckPerdidadAudicionWidgetState();
}

class CheckPerdidadAudicionWidgetState extends State<PerdidadAudicion> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.yellow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            CustomDivider(
              text: 'Sensorial',
              color: Colors.pinkAccent,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                "¿" + respuestaFisico[19]["nombre_evento"] + "?",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily),
              ),
            ),
            Divider(
              height: 5.0,
              color: Colors.black,
            ),
            PerdidadAudicionOpcion()
          ],
        ),
      ),
    );
  }
}

// PerdidadAudicionOpcion *******************

var id_perdidad_audicion;

class PerdidadAudicionOpcion extends StatefulWidget {
  @override
  PerdidadAudicionOpcionWidgetState createState() =>
      PerdidadAudicionOpcionWidgetState();
}

class PerdidadAudicionOpcionWidgetState extends State<PerdidadAudicionOpcion> {
  @override
  void initState() {
    id_perdidad_audicion = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasFisico
            .map((list) => RadioListTile(
                  groupValue: id_perdidad_audicion,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_perdidad_audicion = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//---------------------------------------------Utiliza audífonos ---------------------------------------------

class UtilizaAudifonos extends StatefulWidget {
  @override
  CheckUtilizaAudifonosWidgetState createState() =>
      CheckUtilizaAudifonosWidgetState();
}

class CheckUtilizaAudifonosWidgetState extends State<UtilizaAudifonos> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.yellow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            CustomDivider(
              text: 'Sensorial',
              color: Colors.pinkAccent,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                "¿" + respuestaFisico[20]["nombre_evento"] + "?",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily),
              ),
            ),
            Divider(
              height: 5.0,
              color: Colors.black,
            ),
            UtilizaAudifonosOpcion()
          ],
        ),
      ),
    );
  }
}

// UtilizaAudifonosOpcion *******************

var id_utiliza_audifonos;

class UtilizaAudifonosOpcion extends StatefulWidget {
  @override
  UtilizaAudifonosOpcionWidgetState createState() =>
      UtilizaAudifonosOpcionWidgetState();
}

class UtilizaAudifonosOpcionWidgetState extends State<UtilizaAudifonosOpcion> {
  @override
  void initState() {
    id_utiliza_audifonos = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasFisico
            .map((list) => RadioListTile(
                  groupValue: id_utiliza_audifonos,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_utiliza_audifonos = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//---------------------------------------------Zumbido ---------------------------------------------

class Zumbido extends StatefulWidget {
  @override
  CheckZumbidoWidgetState createState() => CheckZumbidoWidgetState();
}

class CheckZumbidoWidgetState extends State<Zumbido> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.yellow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            CustomDivider(
              text: 'Sensorial',
              color: Colors.pinkAccent,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                "¿" + respuestaFisico[21]["nombre_evento"] + "?",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily),
              ),
            ),
            Divider(
              height: 5.0,
              color: Colors.black,
            ),
            ZumbidoOpcion()
          ],
        ),
      ),
    );
  }
}

// ZumbidoOpcion *******************

var id_zumbido;

class ZumbidoOpcion extends StatefulWidget {
  @override
  ZumbidoOpcionWidgetState createState() => ZumbidoOpcionWidgetState();
}

class ZumbidoOpcionWidgetState extends State<ZumbidoOpcion> {
  @override
  void initState() {
    id_zumbido = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasFisico
            .map((list) => RadioListTile(
                  groupValue: id_zumbido,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_zumbido = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//---------------------------------------------Utiliza anteojos para ver de cerca ---------------------------------------------

class UtilizaAnteojosCerca extends StatefulWidget {
  @override
  CheckUtilizaAnteojosCercaWidgetState createState() =>
      CheckUtilizaAnteojosCercaWidgetState();
}

class CheckUtilizaAnteojosCercaWidgetState extends State<UtilizaAnteojosCerca> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.yellow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            CustomDivider(
              text: 'Sensorial',
              color: Colors.pinkAccent,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                "¿" + respuestaFisico[22]["nombre_evento"] + "?",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily),
              ),
            ),
            Divider(
              height: 5.0,
              color: Colors.black,
            ),
            UtilizaAnteojosCercaOpcion()
          ],
        ),
      ),
    );
  }
}

// UtilizaAnteojosCercaOpcion *******************

var id_utiliza_anteojos_cerca;

class UtilizaAnteojosCercaOpcion extends StatefulWidget {
  @override
  UtilizaAnteojosCercaOpcionWidgetState createState() =>
      UtilizaAnteojosCercaOpcionWidgetState();
}

class UtilizaAnteojosCercaOpcionWidgetState
    extends State<UtilizaAnteojosCercaOpcion> {
  @override
  void initState() {
    id_utiliza_anteojos_cerca = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasFisico
            .map((list) => RadioListTile(
                  groupValue: id_utiliza_anteojos_cerca,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_utiliza_anteojos_cerca = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//---------------------------------------------Utiliza anteojos para ver de lejos ---------------------------------------------

class UtilizaAnteojosLejos extends StatefulWidget {
  @override
  CheckUtilizaAnteojosLejosWidgetState createState() =>
      CheckUtilizaAnteojosLejosWidgetState();
}

class CheckUtilizaAnteojosLejosWidgetState extends State<UtilizaAnteojosLejos> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.yellow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            CustomDivider(
              text: 'Sensorial',
              color: Colors.pinkAccent,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                "¿" + respuestaFisico[23]["nombre_evento"] + "?",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily),
              ),
            ),
            Divider(
              height: 5.0,
              color: Colors.black,
            ),
            UtilizaAnteojosLejosOpcion()
          ],
        ),
      ),
    );
  }
}

// UtilizaAnteojosLejosOpcion *******************

var id_utiliza_anteojos_lejos;

class UtilizaAnteojosLejosOpcion extends StatefulWidget {
  @override
  UtilizaAnteojosLejosOpcionWidgetState createState() =>
      UtilizaAnteojosLejosOpcionWidgetState();
}

class UtilizaAnteojosLejosOpcionWidgetState
    extends State<UtilizaAnteojosLejosOpcion> {
  @override
  void initState() {
    id_utiliza_anteojos_lejos = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasFisico
            .map((list) => RadioListTile(
                  groupValue: id_utiliza_anteojos_lejos,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_utiliza_anteojos_lejos = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//---------------------------------------------Problemas de visión de un lado ---------------------------------------------

class ProblemasVisionLado extends StatefulWidget {
  @override
  CheckProblemasVisionLadoWidgetState createState() =>
      CheckProblemasVisionLadoWidgetState();
}

class CheckProblemasVisionLadoWidgetState extends State<ProblemasVisionLado> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.yellow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            CustomDivider(
              text: 'Sensorial',
              color: Colors.pinkAccent,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                "¿" + respuestaFisico[24]["nombre_evento"] + "?",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily),
              ),
            ),
            Divider(
              height: 5.0,
              color: Colors.black,
            ),
            ProblemasVisionLadoOpcion()
          ],
        ),
      ),
    );
  }
}

// ProblemasVisionLadoOpcion *******************

var id_problemas_vision_lado;

class ProblemasVisionLadoOpcion extends StatefulWidget {
  @override
  ProblemasVisionLadoOpcionWidgetState createState() =>
      ProblemasVisionLadoOpcionWidgetState();
}

class ProblemasVisionLadoOpcionWidgetState
    extends State<ProblemasVisionLadoOpcion> {
  @override
  void initState() {
    id_problemas_vision_lado = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasFisico
            .map((list) => RadioListTile(
                  groupValue: id_problemas_vision_lado,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_problemas_vision_lado = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//---------------------------------------------Visión borrosa ---------------------------------------------

class VisionBorrosa extends StatefulWidget {
  @override
  CheckVisionBorrosaWidgetState createState() =>
      CheckVisionBorrosaWidgetState();
}

class CheckVisionBorrosaWidgetState extends State<VisionBorrosa> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.yellow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            CustomDivider(
              text: 'Sensorial',
              color: Colors.pinkAccent,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                "¿" + respuestaFisico[25]["nombre_evento"] + "?",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily),
              ),
            ),
            Divider(
              height: 5.0,
              color: Colors.black,
            ),
            VisionBorrosaOpcion()
          ],
        ),
      ),
    );
  }
}

// VisionBorrosaOpcion *******************

var id_vision_borrosa;

class VisionBorrosaOpcion extends StatefulWidget {
  @override
  VisionBorrosaOpcionWidgetState createState() =>
      VisionBorrosaOpcionWidgetState();
}

class VisionBorrosaOpcionWidgetState extends State<VisionBorrosaOpcion> {
  @override
  void initState() {
    id_vision_borrosa = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasFisico
            .map((list) => RadioListTile(
                  groupValue: id_vision_borrosa,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_vision_borrosa = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//---------------------------------------------Visión doble ---------------------------------------------

class VisionDoble extends StatefulWidget {
  @override
  CheckVisionDobleWidgetState createState() => CheckVisionDobleWidgetState();
}

class CheckVisionDobleWidgetState extends State<VisionDoble> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.yellow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            CustomDivider(
              text: 'Sensorial',
              color: Colors.pinkAccent,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                "¿" + respuestaFisico[26]["nombre_evento"] + "?",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily),
              ),
            ),
            Divider(
              height: 5.0,
              color: Colors.black,
            ),
            VisionDobleOpcion()
          ],
        ),
      ),
    );
  }
}

// VisionDobleOpcion *******************

var id_vision_doble;

class VisionDobleOpcion extends StatefulWidget {
  @override
  VisionDobleOpcionWidgetState createState() => VisionDobleOpcionWidgetState();
}

class VisionDobleOpcionWidgetState extends State<VisionDobleOpcion> {
  @override
  void initState() {
    id_vision_doble = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasFisico
            .map((list) => RadioListTile(
                  groupValue: id_vision_doble,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_vision_doble = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//---------------------------------------------Ve cosas que no existen ---------------------------------------------

class VeCosasNoExisten extends StatefulWidget {
  @override
  CheckVeCosasNoExistenWidgetState createState() =>
      CheckVeCosasNoExistenWidgetState();
}

class CheckVeCosasNoExistenWidgetState extends State<VeCosasNoExisten> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.yellow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            CustomDivider(
              text: 'Sensorial',
              color: Colors.pinkAccent,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                "¿" + respuestaFisico[27]["nombre_evento"] + "?",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily),
              ),
            ),
            Divider(
              height: 5.0,
              color: Colors.black,
            ),
            VeCosasNoExistenOpcion()
          ],
        ),
      ),
    );
  }
}

// VeCosasNoExistenOpcion *******************

var id_cosas_no_existen;

class VeCosasNoExistenOpcion extends StatefulWidget {
  @override
  VeCosasNoExistenOpcionWidgetState createState() =>
      VeCosasNoExistenOpcionWidgetState();
}

class VeCosasNoExistenOpcionWidgetState extends State<VeCosasNoExistenOpcion> {
  @override
  void initState() {
    id_cosas_no_existen = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasFisico
            .map((list) => RadioListTile(
                  groupValue: id_cosas_no_existen,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_cosas_no_existen = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//---------------------------------------------Sensibilidad a las luces brillantes ---------------------------------------------

class SensibilidadLuz extends StatefulWidget {
  @override
  CheckSensibilidadLuzWidgetState createState() =>
      CheckSensibilidadLuzWidgetState();
}

class CheckSensibilidadLuzWidgetState extends State<SensibilidadLuz> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.yellow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            CustomDivider(
              text: 'Sensorial',
              color: Colors.pinkAccent,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                "¿" + respuestaFisico[28]["nombre_evento"] + "?",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily),
              ),
            ),
            Divider(
              height: 5.0,
              color: Colors.black,
            ),
            SensibilidadLuzOpcion()
          ],
        ),
      ),
    );
  }
}

// SensibilidadLuzOpcion *******************

var id_sensibildad_luz;

class SensibilidadLuzOpcion extends StatefulWidget {
  @override
  SensibilidadLuzOpcionWidgetState createState() =>
      SensibilidadLuzOpcionWidgetState();
}

class SensibilidadLuzOpcionWidgetState extends State<SensibilidadLuzOpcion> {
  @override
  void initState() {
    id_sensibildad_luz = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasFisico
            .map((list) => RadioListTile(
                  groupValue: id_sensibildad_luz,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_sensibildad_luz = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//---------------------------------------------Periodos cortos de ceguera ---------------------------------------------

class PeriodosCortosCeguera extends StatefulWidget {
  @override
  CheckPeriodosCortosCegueraWidgetState createState() =>
      CheckPeriodosCortosCegueraWidgetState();
}

class CheckPeriodosCortosCegueraWidgetState
    extends State<PeriodosCortosCeguera> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.yellow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            CustomDivider(
              text: 'Sensorial',
              color: Colors.pinkAccent,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                "¿" + respuestaFisico[29]["nombre_evento"] + "?",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily),
              ),
            ),
            Divider(
              height: 5.0,
              color: Colors.black,
            ),
            PeriodosCortosCegueraOpcion()
          ],
        ),
      ),
    );
  }
}

// PeriodosCortosCegueraOpcion *******************

var id_periodo_ceguera;

class PeriodosCortosCegueraOpcion extends StatefulWidget {
  @override
  PeriodosCortosCegueraOpcionWidgetState createState() =>
      PeriodosCortosCegueraOpcionWidgetState();
}

class PeriodosCortosCegueraOpcionWidgetState
    extends State<PeriodosCortosCegueraOpcion> {
  @override
  void initState() {
    id_periodo_ceguera = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasFisico
            .map((list) => RadioListTile(
                  groupValue: id_periodo_ceguera,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_periodo_ceguera = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//---------------------------------------------No percibe cosas que pasan al lado de su cuerpo ---------------------------------------------

class CosasPasanCuerpo extends StatefulWidget {
  @override
  CheckCosasPasanCuerpoWidgetState createState() =>
      CheckCosasPasanCuerpoWidgetState();
}

class CheckCosasPasanCuerpoWidgetState extends State<CosasPasanCuerpo> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.yellow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            CustomDivider(
              text: 'Sensorial',
              color: Colors.pinkAccent,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                "¿" + respuestaFisico[30]["nombre_evento"] + "?",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily),
              ),
            ),
            Divider(
              height: 5.0,
              color: Colors.black,
            ),
            CosasPasanCuerpoOpcion()
          ],
        ),
      ),
    );
  }
}

// CosasPasanCuerpoOpcion *******************

var id_cosas_pasan_cuerpo;

class CosasPasanCuerpoOpcion extends StatefulWidget {
  @override
  CosasPasanCuerpoOpcionWidgetState createState() =>
      CosasPasanCuerpoOpcionWidgetState();
}

class CosasPasanCuerpoOpcionWidgetState extends State<CosasPasanCuerpoOpcion> {
  @override
  void initState() {
    id_cosas_pasan_cuerpo = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasFisico
            .map((list) => RadioListTile(
                  groupValue: id_cosas_pasan_cuerpo,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_cosas_pasan_cuerpo = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//---------------------------------------------Dificultad para distinguir el calor del frío ---------------------------------------------

class DistinguirCalorFrio extends StatefulWidget {
  @override
  CheckDistinguirCalorFrioWidgetState createState() =>
      CheckDistinguirCalorFrioWidgetState();
}

class CheckDistinguirCalorFrioWidgetState extends State<DistinguirCalorFrio> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.yellow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            CustomDivider(
              text: 'Sensorial',
              color: Colors.pinkAccent,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                "¿" + respuestaFisico[31]["nombre_evento"] + "?",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily),
              ),
            ),
            Divider(
              height: 5.0,
              color: Colors.black,
            ),
            DistinguirCalorFrioOpcion()
          ],
        ),
      ),
    );
  }
}

// DistinguirCalorFrioOpcion *******************

var id_distinguir_calor_frio;

class DistinguirCalorFrioOpcion extends StatefulWidget {
  @override
  DistinguirCalorFrioOpcionWidgetState createState() =>
      DistinguirCalorFrioOpcionWidgetState();
}

class DistinguirCalorFrioOpcionWidgetState
    extends State<DistinguirCalorFrioOpcion> {
  @override
  void initState() {
    id_distinguir_calor_frio = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasFisico
            .map((list) => RadioListTile(
                  groupValue: id_distinguir_calor_frio,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_distinguir_calor_frio = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//---------------------------------------------Problemas de gusto ---------------------------------------------

class ProblemasGusto extends StatefulWidget {
  @override
  CheckProblemasGustoWidgetState createState() =>
      CheckProblemasGustoWidgetState();
}

class CheckProblemasGustoWidgetState extends State<ProblemasGusto> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.yellow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            CustomDivider(
              text: 'Sensorial',
              color: Colors.pinkAccent,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                "¿" + respuestaFisico[32]["nombre_evento"] + "?",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily),
              ),
            ),
            Divider(
              height: 5.0,
              color: Colors.black,
            ),
            ProblemasGustoOpcion()
          ],
        ),
      ),
    );
  }
}

// ProblemasGustoOpcion *******************

var id_problema_gusto;

class ProblemasGustoOpcion extends StatefulWidget {
  @override
  ProblemasGustoOpcionWidgetState createState() =>
      ProblemasGustoOpcionWidgetState();
}

class ProblemasGustoOpcionWidgetState extends State<ProblemasGustoOpcion> {
  @override
  void initState() {
    id_problema_gusto = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasFisico
            .map((list) => RadioListTile(
                  groupValue: id_problema_gusto,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_problema_gusto = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//---------------------------------------------Problemas de olfato ---------------------------------------------

class ProblemaOlfato extends StatefulWidget {
  @override
  CheckProblemaOlfatoWidgetState createState() =>
      CheckProblemaOlfatoWidgetState();
}

class CheckProblemaOlfatoWidgetState extends State<ProblemaOlfato> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.yellow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            CustomDivider(
              text: 'Sensorial',
              color: Colors.pinkAccent,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                "¿" + respuestaFisico[33]["nombre_evento"] + "?",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily),
              ),
            ),
            Divider(
              height: 5.0,
              color: Colors.black,
            ),
            ProblemaOlfatoOpcion()
          ],
        ),
      ),
    );
  }
}

// ProblemaOlfatoOpcion *******************

var id_problema_olfato;

class ProblemaOlfatoOpcion extends StatefulWidget {
  @override
  ProblemaOlfatoOpcionWidgetState createState() =>
      ProblemaOlfatoOpcionWidgetState();
}

class ProblemaOlfatoOpcionWidgetState extends State<ProblemaOlfatoOpcion> {
  @override
  void initState() {
    id_problema_olfato = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasFisico
            .map((list) => RadioListTile(
                  groupValue: id_problema_olfato,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_problema_olfato = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//---------------------------------------------Dolor ---------------------------------------------

class Dolor extends StatefulWidget {
  @override
  CheckDolorWidgetState createState() => CheckDolorWidgetState();
}

class CheckDolorWidgetState extends State<Dolor> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.yellow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            CustomDivider(
              text: 'Sensorial',
              color: Colors.pinkAccent,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                "¿" + respuestaFisico[34]["nombre_evento"] + "?",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily),
              ),
            ),
            Divider(
              height: 5.0,
              color: Colors.black,
            ),
            DolorOpcion()
          ],
        ),
      ),
    );
  }
}

// DolorOpcion *******************

var id_dolor;

class DolorOpcion extends StatefulWidget {
  @override
  DolorOpcionWidgetState createState() => DolorOpcionWidgetState();
}

class DolorOpcionWidgetState extends State<DolorOpcion> {
  @override
  void initState() {
    id_dolor = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasFisico
            .map((list) => RadioListTile(
                  groupValue: id_dolor,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_dolor = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}
