import 'dart:async';
import 'package:app_salud/widgets/LabeledCheckboxGeneric.dart';
import 'package:app_salud/widgets/alert_informe.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../services/usuario_services.dart';
import 'env.dart';

class ScreeningCerebral extends StatefulWidget {
  @override
  _ScreeningCerebralState createState() => _ScreeningCerebralState();
}

//final _formKey_cerebral = GlobalKey<_ScreeningCerebralState>();

TextEditingController otro_habito_controller = TextEditingController();
TextEditingController key_otro_controller = TextEditingController();

List itemsRespuestasSaludCerebral;

var id_paciente;
var id_medico;
var tipo_screening;
var id_recordatorio;
var screening_recordatorio;
var usuarioModel;

class _ScreeningCerebralState extends State<ScreeningCerebral> {
  http.Client _client; // Cliente HTTP para realizar las solicitudes

  @override
  void initState() {
    _client = http.Client(); // Inicializar el cliente HTTP
    super.initState();
  }

  @override
  void dispose() {
    _client.close(); // Cerrar el cliente HTTP cuando la página se destruye
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, '/menu_chequeo');
        return true;
      },
      child: Scaffold(
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
              Navigator.pushNamed(context, '/menu_chequeo');
            },
          ),
          title: Center(
            child: Text('Cuestionario de Hábitos \n     de Salud Cerebral',
                style: TextStyle(
                  fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
                )),
          ),
        ),
        body: FutureBuilder(
            future: getAllRespuesta(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.data.isEmpty) {
                return Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListTile(
                        title: Text(
                      'Ya realizó el Cuestionario de Salud Cerebral',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily:
                              Theme.of(context).textTheme.headline1.fontFamily),
                    )),
                    ListTile(
                        title: Text(
                      'El resultado obtenido fue: ' + mensajeResultado,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily:
                              Theme.of(context).textTheme.headline1.fontFamily),
                    )),
                  ],
                ));
              } else {
                return ColumnWidgetCerebral();
              }

              // if (snapshot.connectionState == ConnectionState.waiting) {
              //   // Estado de carga
              //   return Center(child: CircularProgressIndicator());
              // } else if (snapshot.hasError) {
              //   // Estado de error
              //   return Text("Error al cargar los datos");
              // } else {
              //   // Estado de datos cargados

              //     return ColumnWidgetCerebral();
              //   }
              // }
            }),
      ),
    );
  }

  getStringValuesSF() async {
    usuarioModel = Provider.of<UsuarioServices>(context);
    id_paciente = usuarioModel.usuario.paciente.id_paciente;

    Map parametros = ModalRoute.of(context).settings.arguments;

    get_tiposcreening("SCER");

    tipo_screening = parametros["select_screening"];

    screening_recordatorio = false;
    id_recordatorio = null;
    id_medico = null;

    // if (parametros["bandera"] == "recordatorio") {
    //   screening_recordatorio = true;
    //   id_recordatorio = parametros["id_recordatorio"];
    //   id_paciente = id_paciente;
    //   id_medico = parametros["id_medico"];
    //   tipo_screening = parametros["tipo_screening"];
    // } else {
    //   if (parametros["bandera"] == "screening_nuevo") {
    //     screening_recordatorio = false;
    //     id_paciente = id_paciente;
    //     id_recordatorio = null;
    //     id_medico = null;
    //     //tipo_screening = parametros["tipo_screening"];
    //   }
    // }
  }

  get_tiposcreening(var codigo_screening) async {
    String URL_base = Env.URL_API;
    var url = URL_base + "/read_tipo_screening";
    var response = await _client.post(url, body: {
      "codigo_screening": codigo_screening,
    });

    tipo_screening = json.decode(response.body);
  }

  Future<List> getAllRespuesta() async {
    getStringValuesSF();

    var response;
    final completer = Completer<List>();

    String URL_base = Env.URL_API;
    var url = URL_base + "/tipo_respuesta_salud_cerebral";

    response = await _client.post(url, body: {
      "id_paciente": id_paciente.toString(),
    });

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      if (jsonData['status'] == "Success") {
        itemsRespuestasSaludCerebral = jsonData['data'];
        completer.complete(jsonData['data']);
      } else {
        if (jsonData['status'] == "SinScreening") {
          mensajeResultado = jsonData['data'][0]['result_screening'];
          completer.complete([]);
        } else {
          completer.completeError("Error en la respuesta");
        }
      }
    } else {
      completer.completeError("Error en la solicitud");
    }
    return completer.future;
  }

  var mensajeResultado;
}

class ColumnWidgetCerebral extends StatefulWidget {
  @override
  _ColumnWidgetCerebralState createState() => _ColumnWidgetCerebralState();
}

class _ColumnWidgetCerebralState extends State<ColumnWidgetCerebral> {
  ValueNotifier<bool> valueNotifierActividadFisica = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierAlimentacionSaludable =
      ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierContactoSocial = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierSueno = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierActividadEsfuerzoMental =
      ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierOtro = ValueNotifier<bool>(false);
  ValueNotifier<bool> _showAdditionalFieldsNotifier =
      ValueNotifier<bool>(false);
  http.Client _client; // Cliente HTTP para realizar las solicitudes

  @override
  void initState() {
    _client = http.Client(); // Inicializar el cliente HTTP

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => alert_screenings_generico(
        context,
        "Cuestionario Cerebral",
        "Consigna: seleccione la opción que mejor describa sus hábitos. Si este cuestionario no puede ser completado por Ud. mismo pida ayuda a alguien cercano que conozca sobre sus hábtitos actuales y pasados. Recuerde que este cuestionario se realiza una sola vez"));
  }

  @override
  void dispose() {
    _client.close(); // Cerrar el cliente HTTP cuando la página se destruye
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                shadowColor: Colors.yellow,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                margin: EdgeInsets.all(15),
                elevation: 10,
                child: Column(children: [
                  Container(
                    padding: EdgeInsets.all(25),
                    child: Text(
                      '¿Qué hábitos considera que le hacen bien a la salud de su cerebro? (Varias respuestas)',
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
                  ActividadFisica(
                      valueNotifierActividadFisica:
                          valueNotifierActividadFisica),
                  AlimentacionSaludable(
                      valueNotifierAlimentacionSaludable:
                          valueNotifierAlimentacionSaludable),
                  ContactoSocial(
                      valueNotifierContactoSocial: valueNotifierContactoSocial),
                  Sueno(valueNotifierSueno: valueNotifierSueno),
                  ActividadEsfuerzoMental(
                      valueNotifierActividadEsfuerzoMental:
                          valueNotifierActividadEsfuerzoMental),
                  Otro(
                    valueNotifierOtro: valueNotifierOtro,
                    showAdditionalFieldsNotifier: _showAdditionalFieldsNotifier,
                  ),
                ]),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.yellow,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(25),
                  child: Text(
                    '¿Realiza actividad física moderada a vigorosa (que provoca sudoración)? ',
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
                ActividadFisicaModerada()
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.yellow,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(25),
                  child: Text(
                    '¿Cuántos minutos por semana realiza actividad física moderada a vigorosa (que provoca sudoración)?',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily),
                  ),
                ),
                Divider(
                  height: 4.0,
                  color: Colors.black,
                ),
                ActividadFisicaModeradaMinutos()
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.yellow,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(25),
                  child: Text(
                    '¿Se considera una persona que se ha mantenido activa físicamente durante los últimos 10 años?',
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
                PersonaActiva10Anos()
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.yellow,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(25),
                  child: Text(
                    '¿Se considera una persona que se ha mantenido activa físicamente durante el transcurso de su vida?',
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
                PersonaActivaVida()
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.yellow,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(25),
                  child: Text(
                    "¿Cuántos días en la semana considera que se alimenta saludablemente? Considere que una alimentación saludable hace referencia al consumo elevado de vegetales, legumbres, frutas, nueces, cereales y aceite de oliva, y baja ingesta de grasas saturadas, carne y sodio (sal).",
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
                DiasAlimentaSaludable()
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.yellow,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(25),
                  child: Text(
                    "¿Se considera una persona que se ha alimentado saludablemente durante el transcurso de su vida?",
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
                AlimentarSaludableVida()
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.yellow,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(25),
                  child: Text(
                    "Contacto social. ¿Cuántos días en la semana tiene contacto con amigos o vínculos sociales?",
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
                ContactoSocialAmigos()
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.yellow,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(25),
                  child: Text(
                    "Contacto social. ¿Cuántos días en la semana tiene contacto con familiares?",
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
                ContactoSocialFamilia()
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.yellow,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(25),
                  child: Text(
                    "Contacto social. ¿Realiza actividades sociales, culturales y/o de participación grupal o comunitaria?",
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
                ContactoSocialActividad()
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.yellow,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(25),
                  child: Text(
                    "Sueño. ¿Está satisfecho con la calidad de su sueño?",
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
                SuenoCalidadSueno()
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.yellow,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(25),
                  child: Text(
                    "Sueño. ¿Se mantiene despierto todo el día sin somnolencia?",
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
                SuenoDespiernoDia()
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.yellow,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(25),
                  child: Text(
                    "Sueño. En general, ¿Realiza siestas durante el día?",
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
                SuenoSiestaDia()
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.yellow,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(25),
                  child: Text(
                    "Sueño ¿En general, se acuesta y se levanta en el mismo horario?",
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
                SuenoDuerme()
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.yellow,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(25),
                  child: Text(
                    "Sueño. ¿Cuántas horas duerme por noche?",
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
                SuenoHoraNoche()
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.yellow,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(25),
                  child: Text(
                    "Sueño ¿Ha estado con problemas de sueño (para conciliar, mantener o despertar) durante los últimos 2 años?",
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
                SuenoDuermeNoche()
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.yellow,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(25),
                  child: Text(
                    "¿Realiza actividades que impliquen un mínimo de esfuerzo mental? Las actividades que implican esfuerzo mental hacen referencia a hábitos como la lectura, escritura, juegos mentales (por ejemplo crucigramas) y aprendizajes (por ejemplo de un idioma, una manualidad, de un instrumento).",
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
                ActividadesEsfuerzoMental()
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.yellow,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(25),
                  child: Text(
                    "¿Participa en actividades de índole cultural (cine, teatro, conciertos, museos) y/o artístico (canto, pintura, cerámica, baile, música)?",
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
                ActividadesIndoleCultural()
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.yellow,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(25),
                  child: Text(
                    "¿Usted tendría esperanza en que incorporando algunos hábitos saludables como los relacionados a las artes (incluidas las artes visuales, la música y la danza) podrían mejorar la salud de su cerebro?",
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
                EsperanzaHabitoSaludable()
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.yellow,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(25),
                  child: Text(
                    "¿Qué hábito le gustaría incorporar a su vida diaria?",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  height: 150,
                  child: TextFormField(
                    maxLength: _characterLimitHabitos,
                    controller: otro_habito_controller,
                    decoration: InputDecoration(
                        labelText: 'Escriba',
                        labelStyle: TextStyle(
                          fontFamily:
                              Theme.of(context).textTheme.headline1.fontFamily,
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
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
          padding: EdgeInsets.all(8.0),
        ),
      ]),
    );
  }

  guardarDatosSaludCerebral(BuildContext context) async {
    List<dynamic> ids_cerebrales = [
      id_actividad_fisica_moderada,
      id_actividad_fisica_minutos,
      id_persona_mantenida_10anos,
      id_persona_activa_vida,
      id_dias_alimenta_saludable,
      id_alimenta_saludable_vida,
      id_contacto_social_amigos,
      id_contacto_social_actividad,
      id_sueno_calidad_sueno,
      id_sueno_despierto_dia,
      id_sueno_siesta_dia,
      id_sueno_duerme,
      id_sueno_duerme_noche,
      id_sueno_hora_noche,
      id_actividades_esfuerzo_mental,
      id_actividad_indole_cultural,
      id_esperanza_habito_saludable,
    ];

    for (var variable in ids_cerebrales) {
      if (variable == null) {
        loginToast("Debe responder todas las preguntas");
        return; // Salir de la función
      }
    }

    showDialogMessage(context);

    String URL_base = Env.URL_API;
    var url = URL_base + "/respuesta_screening_cerebral";
    var response = await _client.post(url, body: {
      "id_paciente": id_paciente.toString(),
      "id_medico": id_medico.toString(),
      "id_recordatorio": id_recordatorio.toString(),
      "tipo_screening": tipo_screening['data'].toString(),
      "actividad_fisica": valueNotifierActividadFisica.value.toString(),
      "alimentacion_saludable":
          valueNotifierAlimentacionSaludable.value.toString(),
      "contacto_social": valueNotifierContactoSocial.value.toString(),
      "sueno": valueNotifierSueno.value.toString(),
      "actividades_esfuerzo_mental":
          valueNotifierActividadEsfuerzoMental.value.toString(),
      "otro": valueNotifierOtro.value.toString(),
      "otro_texto": key_otro_controller.text.toString(),
      "otro_habito_texto": otro_habito_controller.text.toString(),
      "id_actividad_fisica_moderada": id_actividad_fisica_moderada.toString(),
      "id_actividad_fisica_minutos": id_actividad_fisica_minutos.toString(),
      "id_persona_mantenida_10anos": id_persona_mantenida_10anos.toString(),
      "id_persona_activa_vida": id_persona_activa_vida.toString(),
      "id_dias_alimenta_saludable": id_dias_alimenta_saludable.toString(),
      "id_alimenta_saludable_vida": id_alimenta_saludable_vida.toString(),
      "id_contacto_social_amigos": id_contacto_social_amigos.toString(),
      "id_contacto_social_actividad": id_contacto_social_actividad.toString(),
      "id_sueno_calidad_sueno": id_sueno_calidad_sueno.toString(),
      "id_sueno_despierto_dia": id_sueno_despierto_dia.toString(),
      "id_sueno_siesta_dia": id_sueno_siesta_dia.toString(),
      "id_sueno_duerme": id_sueno_duerme.toString(),
      "id_sueno_duerme_noche": id_sueno_duerme_noche.toString(),
      "id_sueno_hora_noche": id_sueno_hora_noche.toString(),
      "id_actividades_esfuerzo_mental":
          id_actividades_esfuerzo_mental.toString(),
      "id_actividad_indole_cultural": id_actividad_indole_cultural.toString(),
      "id_esperanza_habito_saludable": id_esperanza_habito_saludable.toString()
    });

    var data;

    if (response.statusCode == 200) {
      data = json.decode(response.body);

      if (data['data'] == "alert") {
        showCustomAlert(
          context,
          "Chequeo Terminado",
          "",
          true,
          () {
            _scaffold_messenger(context, "Chequeo Registrado", 1);

            if (screening_recordatorio == true) {
              Navigator.pushNamed(context, '/recordatorio');
            } else {
              // Navigator.pushNamed(context, '/screening', arguments: {
              //   "select_screening": "SCER",
              // });
              Navigator.pushNamed(context, '/menu_chequeo');
            }
          },
        );
      } else {
        _scaffold_messenger(context, "Chequeo Registrado", 1);

        if (data['status'] == "Success") {
          if (screening_recordatorio == true) {
            Navigator.pushNamed(context, '/recordatorio');
          } else {
            // Navigator.pushNamed(context, '/screening', arguments: {
            //   "select_screening": "SCER",
            // });
            Navigator.pushNamed(context, '/menu_chequeo');
          }
        }
      }
    } else {
      _scaffold_messenger(context, "No se pudo guardar el chequeo", 2);
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

  bool _isLoading = false;
  void _startLoading() async {
    setState(() {
      _isLoading = true;
    });

    await guardarDatosSaludCerebral(context);

    setState(() {
      _isLoading = false;
    });
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

int _characterLimit = 60; // Cambia este valor según tus necesidades
int _characterLimitHabitos = 60; // Cambia este valor según tus necesidades

//-------------------------------------- ActividadFisicas -----------------------------------------------------

class ActividadFisica extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierActividadFisica;

  ActividadFisica({this.valueNotifierActividadFisica});

  @override
  CheckActividadFisicaWidgetState createState() =>
      CheckActividadFisicaWidgetState();
}

class CheckActividadFisicaWidgetState extends State<ActividadFisica> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: 'Actividad Física',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierActividadFisica.value,
      onChanged: (bool newValue) {
        setState(() {
          widget.valueNotifierActividadFisica.value = newValue;
        });
      },
    );
  }
}

//-----------------------------------------------------------------------------------------------------------
//-------------------------------------- Alimentacion Saludable -----------------------------------------------------

class AlimentacionSaludable extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierAlimentacionSaludable;

  AlimentacionSaludable({this.valueNotifierAlimentacionSaludable});

  @override
  CheckAlimentacionSaludableWidgetState createState() =>
      CheckAlimentacionSaludableWidgetState();
}

class CheckAlimentacionSaludableWidgetState
    extends State<AlimentacionSaludable> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: 'Alimentación Saludable',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierAlimentacionSaludable.value,
      onChanged: (bool newValue) {
        setState(() {
          widget.valueNotifierAlimentacionSaludable.value = newValue;
        });
      },
    );
  }
}

//-----------------------------------------------------------------------------------------------------------
//-------------------------------------- ContactoSocial -----------------------------------------------------

class ContactoSocial extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierContactoSocial;

  ContactoSocial({this.valueNotifierContactoSocial});

  @override
  CheckContactoSocialWidgetState createState() =>
      CheckContactoSocialWidgetState();
}

class CheckContactoSocialWidgetState extends State<ContactoSocial> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: 'Contacto Social',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierContactoSocial.value,
      onChanged: (bool newValue) {
        setState(() {
          widget.valueNotifierContactoSocial.value = newValue;
        });
      },
    );
  }
}

//-----------------------------------------------------------------------------------------------------------

//-------------------------------------- Sueño -----------------------------------------------------

class Sueno extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierSueno;

  Sueno({this.valueNotifierSueno});
  @override
  CheckSuenoWidgetState createState() => CheckSuenoWidgetState();
}

class CheckSuenoWidgetState extends State<Sueno> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: 'Sueño',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierSueno.value,
      onChanged: (bool newValue) {
        setState(() {
          widget.valueNotifierSueno.value = newValue;
        });
      },
    );
  }
}

//-----------------------------------------------------------------------------------------------------------

//-------------------------------------- Actividades que implican esfuerzo mental -----------------------------------------------------

class ActividadEsfuerzoMental extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierActividadEsfuerzoMental;

  ActividadEsfuerzoMental({this.valueNotifierActividadEsfuerzoMental});

  @override
  CheckActividadEsfuerzoMentalWidgetState createState() =>
      CheckActividadEsfuerzoMentalWidgetState();
}

class CheckActividadEsfuerzoMentalWidgetState
    extends State<ActividadEsfuerzoMental> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: 'Actividades que implican esfuerzo mental',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierActividadEsfuerzoMental.value,
      onChanged: (bool newValue) {
        setState(() {
          widget.valueNotifierActividadEsfuerzoMental.value = newValue;
        });
      },
    );
  }
}

//-----------------------------------------------------------------------------------------------------------

//-------------------------------------- Otro -----------------------------------------------------

class Otro extends StatefulWidget {
  final ValueNotifier<bool> valueNotifierOtro;
  final ValueNotifier<bool> showAdditionalFieldsNotifier;

  Otro({this.valueNotifierOtro, this.showAdditionalFieldsNotifier});

  @override
  CheckOtroWidgetState createState() => CheckOtroWidgetState();
}

class CheckOtroWidgetState extends State<Otro> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LabeledCheckboxGeneric(
          label: 'Otro',
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          value: widget.valueNotifierOtro.value,
          onChanged: (bool newValue) {
            setState(() {
              widget.valueNotifierOtro.value = newValue;
              if (newValue) {
                widget.showAdditionalFieldsNotifier.value = true;
              } else {
                widget.showAdditionalFieldsNotifier.value = false;
              }
            });
          },
        ),
        //---------
        ValueListenableBuilder<bool>(
          valueListenable: widget.showAdditionalFieldsNotifier,
          builder: (context, value, child) {
            return Visibility(
              visible: widget.showAdditionalFieldsNotifier.value,
              maintainSize:
                  false, // Esto evita que mantenga el espacio incluso cuando está oculto
              child: AnimatedOpacity(
                opacity: widget.showAdditionalFieldsNotifier.value ? 1.0 : 0.0,
                duration: Duration(
                    milliseconds:
                        500), // Duración de la animación en milisegundos
                curve: Curves.easeInOut, // Curva de la animación
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      TextFormField(
                        controller: key_otro_controller,
                        decoration: InputDecoration(
                            labelText: '¿Qué otro hábito? ',
                            labelStyle: TextStyle(
                                fontFamily: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    .fontFamily)),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Por favor ingrese el nombre del contacto';
                          }
                          return null;
                        },
                        onChanged: (text) {
                          print("Debe completar el campo");
                        },
                      ),
                      SizedBox(height: 10.0),
                    ]),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

//-----------------------------------------------------------------------------------------------------------
// Realiza Actividad Fisica *******************

var id_actividad_fisica_moderada;

class ActividadFisicaModerada extends StatefulWidget {
  @override
  ActividadFisicaModeradaWidgetState createState() =>
      ActividadFisicaModeradaWidgetState();
}

class ActividadFisicaModeradaWidgetState
    extends State<ActividadFisicaModerada> {
  @override
  void initState() {
    id_actividad_fisica_moderada = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasSaludCerebral
            .map(
              (list) => list['code'] == "SCER06" ||
                      list['code'] == "SCER07" ||
                      list['code'] == "SCER08" ||
                      list['code'] == "SCER09" ||
                      list['code'] == "SCER10"
                  ? RadioListTile(
                      groupValue: id_actividad_fisica_moderada,
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
                          id_actividad_fisica_moderada = val;
                        });
                      },
                    )
                  : SizedBox(),
            )
            .toList(),
      ),
    );
  }
}

// Realiza Actividad Fisica *******************

var id_actividad_fisica_minutos;

class ActividadFisicaModeradaMinutos extends StatefulWidget {
  @override
  ActividadFisicaModeradaMinutosWidgetState createState() =>
      ActividadFisicaModeradaMinutosWidgetState();
}

class ActividadFisicaModeradaMinutosWidgetState
    extends State<ActividadFisicaModeradaMinutos> {
  @override
  void initState() {
    id_actividad_fisica_minutos = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasSaludCerebral
            .map(
              (list) => list['code'] == "SCER11" ||
                      list['code'] == "SCER12" ||
                      list['code'] == "SCER13" ||
                      list['code'] == "SCER14" ||
                      list['code'] == "SCER15"
                  ? RadioListTile(
                      groupValue: id_actividad_fisica_minutos,
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
                          id_actividad_fisica_minutos = val;
                        });
                      },
                    )
                  : SizedBox(),
            )
            .toList(),
      ),
    );
  }
}

// Persona Activa 10 Años *******************

var id_persona_mantenida_10anos;

class PersonaActiva10Anos extends StatefulWidget {
  @override
  PersonaActiva10AnosWidgetState createState() =>
      PersonaActiva10AnosWidgetState();
}

class PersonaActiva10AnosWidgetState extends State<PersonaActiva10Anos> {
  @override
  void initState() {
    id_persona_mantenida_10anos = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 290,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasSaludCerebral
            .map(
              (list) => list['code'] == "SCER16" ||
                      list['code'] == "SCER17" ||
                      list['code'] == "SCER18" ||
                      list['code'] == "SCER19"
                  ? RadioListTile(
                      groupValue: id_persona_mantenida_10anos,
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
                          id_persona_mantenida_10anos = val;
                        });
                      },
                    )
                  : SizedBox(),
            )
            .toList(),
      ),
    );
  }
}

// Persona Activa Vida *******************

var id_persona_activa_vida;

class PersonaActivaVida extends StatefulWidget {
  @override
  PersonaActivaVidaWidgetState createState() => PersonaActivaVidaWidgetState();
}

class PersonaActivaVidaWidgetState extends State<PersonaActivaVida> {
  @override
  void initState() {
    id_persona_activa_vida = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasSaludCerebral
            .map(
              (list) => list['code'] == "SCER20" ||
                      list['code'] == "SCER21" ||
                      list['code'] == "SCER22" ||
                      list['code'] == "SCER23"
                  ? RadioListTile(
                      groupValue: id_persona_activa_vida,
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
                          id_persona_activa_vida = val;
                        });
                      },
                    )
                  : SizedBox(),
            )
            .toList(),
      ),
    );
  }
}

// Dias Alimenta Saludable *******************

var id_dias_alimenta_saludable;

class DiasAlimentaSaludable extends StatefulWidget {
  @override
  DiasAlimentaSaludableWidgetState createState() =>
      DiasAlimentaSaludableWidgetState();
}

class DiasAlimentaSaludableWidgetState extends State<DiasAlimentaSaludable> {
  @override
  void initState() {
    id_dias_alimenta_saludable = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasSaludCerebral
            .map(
              (list) => list['code'] == "SCER24" ||
                      list['code'] == "SCER25" ||
                      list['code'] == "SCER26" ||
                      list['code'] == "SCER27" ||
                      list['code'] == "SCER28"
                  ? RadioListTile(
                      groupValue: id_dias_alimenta_saludable,
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
                          id_dias_alimenta_saludable = val;
                        });
                      },
                    )
                  : SizedBox(),
            )
            .toList(),
      ),
    );
  }
}

// Alimenta Saludable Vida *******************

var id_alimenta_saludable_vida;

class AlimentarSaludableVida extends StatefulWidget {
  @override
  AlimentarSaludableVidaWidgetState createState() =>
      AlimentarSaludableVidaWidgetState();
}

class AlimentarSaludableVidaWidgetState extends State<AlimentarSaludableVida> {
  @override
  void initState() {
    id_alimenta_saludable_vida = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 290,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasSaludCerebral
            .map(
              (list) => list['code'] == "SCER29" ||
                      list['code'] == "SCER30" ||
                      list['code'] == "SCER31" ||
                      list['code'] == "SCER32"
                  ? RadioListTile(
                      groupValue: id_alimenta_saludable_vida,
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
                          id_alimenta_saludable_vida = val;
                        });
                      },
                    )
                  : SizedBox(),
            )
            .toList(),
      ),
    );
  }
}

// Contacto Social Amigos *******************

var id_contacto_social_amigos;

class ContactoSocialAmigos extends StatefulWidget {
  @override
  ContactoSocialAmigosWidgetState createState() =>
      ContactoSocialAmigosWidgetState();
}

class ContactoSocialAmigosWidgetState extends State<ContactoSocialAmigos> {
  @override
  void initState() {
    id_contacto_social_amigos = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasSaludCerebral
            .map(
              (list) => list['code'] == "SCER33" ||
                      list['code'] == "SCER34" ||
                      list['code'] == "SCER35" ||
                      list['code'] == "SCER36"
                  ? RadioListTile(
                      groupValue: id_contacto_social_amigos,
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
                          id_contacto_social_amigos = val;
                        });
                      },
                    )
                  : SizedBox(),
            )
            .toList(),
      ),
    );
  }
}

// Contacto Social Familiares *******************

var id_contacto_social_familia;

class ContactoSocialFamilia extends StatefulWidget {
  @override
  ContactoSocialFamiliaWidgetState createState() =>
      ContactoSocialFamiliaWidgetState();
}

class ContactoSocialFamiliaWidgetState extends State<ContactoSocialFamilia> {
  @override
  void initState() {
    id_contacto_social_familia = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasSaludCerebral
            .map(
              (list) => list['code'] == "SCER37" ||
                      list['code'] == "SCER38" ||
                      list['code'] == "SCER39" ||
                      list['code'] == "SCER40" ||
                      list['code'] == "SCER41"
                  ? RadioListTile(
                      groupValue: id_contacto_social_familia,
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
                          id_contacto_social_familia = val;
                        });
                      },
                    )
                  : SizedBox(),
            )
            .toList(),
      ),
    );
  }
}

// Contacto Social Actividad *******************

var id_contacto_social_actividad;

class ContactoSocialActividad extends StatefulWidget {
  @override
  ContactoSocialActividadWidgetState createState() =>
      ContactoSocialActividadWidgetState();
}

class ContactoSocialActividadWidgetState
    extends State<ContactoSocialActividad> {
  @override
  void initState() {
    id_contacto_social_actividad = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasSaludCerebral
            .map(
              (list) => list['code'] == "SCER42" ||
                      list['code'] == "SCER43" ||
                      list['code'] == "SCER44" ||
                      list['code'] == "SCER45"
                  ? RadioListTile(
                      groupValue: id_contacto_social_actividad,
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
                          id_contacto_social_actividad = val;
                        });
                      },
                    )
                  : SizedBox(),
            )
            .toList(),
      ),
    );
  }
}

// Sueño Calidad de Sueño *******************

var id_sueno_calidad_sueno;

class SuenoCalidadSueno extends StatefulWidget {
  @override
  SuenoCalidadSuenoWidgetState createState() => SuenoCalidadSuenoWidgetState();
}

class SuenoCalidadSuenoWidgetState extends State<SuenoCalidadSueno> {
  @override
  void initState() {
    id_sueno_calidad_sueno = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasSaludCerebral
            .map(
              (list) => list['code'] == "SCER60" || list['code'] == "SCER61"
                  ? RadioListTile(
                      groupValue: id_sueno_calidad_sueno,
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
                          id_sueno_calidad_sueno = val;
                        });
                      },
                    )
                  : SizedBox(),
            )
            .toList(),
      ),
    );
  }
}

// Sueño Despierto Dia *******************

var id_sueno_despierto_dia;

class SuenoDespiernoDia extends StatefulWidget {
  @override
  SuenoDespiernoDiaWidgetState createState() => SuenoDespiernoDiaWidgetState();
}

class SuenoDespiernoDiaWidgetState extends State<SuenoDespiernoDia> {
  @override
  void initState() {
    id_sueno_despierto_dia = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasSaludCerebral
            .map(
              (list) => list['code'] == "SCER60" || list['code'] == "SCER61"
                  ? RadioListTile(
                      groupValue: id_sueno_despierto_dia,
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
                          id_sueno_despierto_dia = val;
                        });
                      },
                    )
                  : SizedBox(),
            )
            .toList(),
      ),
    );
  }
}

// Sueño Siesta Dia *******************

var id_sueno_siesta_dia;

class SuenoSiestaDia extends StatefulWidget {
  @override
  SuenoSiestaDiaWidgetState createState() => SuenoSiestaDiaWidgetState();
}

class SuenoSiestaDiaWidgetState extends State<SuenoSiestaDia> {
  @override
  void initState() {
    id_sueno_siesta_dia = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasSaludCerebral
            .map(
              (list) => list['code'] == "SCER60" || list['code'] == "SCER61"
                  ? RadioListTile(
                      groupValue: id_sueno_siesta_dia,
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
                          id_sueno_siesta_dia = val;
                        });
                      },
                    )
                  : SizedBox(),
            )
            .toList(),
      ),
    );
  }
}

// Sueño Duerme *******************

var id_sueno_duerme;

class SuenoDuerme extends StatefulWidget {
  @override
  SuenoDuermeWidgetState createState() => SuenoDuermeWidgetState();
}

class SuenoDuermeWidgetState extends State<SuenoDuerme> {
  @override
  void initState() {
    id_sueno_duerme = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasSaludCerebral
            .map(
              (list) => list['code'] == "SCER60" || list['code'] == "SCER61"
                  ? RadioListTile(
                      groupValue: id_sueno_duerme,
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
                          id_sueno_duerme = val;
                        });
                      },
                    )
                  : SizedBox(),
            )
            .toList(),
      ),
    );
  }
}

// Sueño Duerme Noche *******************

var id_sueno_duerme_noche;

class SuenoDuermeNoche extends StatefulWidget {
  @override
  SuenoDuermeNocheWidgetState createState() => SuenoDuermeNocheWidgetState();
}

class SuenoDuermeNocheWidgetState extends State<SuenoDuermeNoche> {
  @override
  void initState() {
    id_sueno_duerme_noche = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasSaludCerebral
            .map(
              (list) => list['code'] == "SCER60" || list['code'] == "SCER61"
                  ? RadioListTile(
                      groupValue: id_sueno_duerme_noche,
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
                          id_sueno_duerme_noche = val;
                        });
                      },
                    )
                  : SizedBox(),
            )
            .toList(),
      ),
    );
  }
}

// Sueño Duerme Hora de Noche *******************

var id_sueno_hora_noche;

class SuenoHoraNoche extends StatefulWidget {
  @override
  SuenoHoraNocheWidgetState createState() => SuenoHoraNocheWidgetState();
}

class SuenoHoraNocheWidgetState extends State<SuenoHoraNoche> {
  @override
  void initState() {
    id_sueno_hora_noche = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasSaludCerebral
            .map(
              (list) => list['code'] == "SCER46" ||
                      list['code'] == "SCER47" ||
                      list['code'] == "SCER48" ||
                      list['code'] == "SCER49"
                  ? RadioListTile(
                      groupValue: id_sueno_hora_noche,
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
                          id_sueno_hora_noche = val;
                        });
                      },
                    )
                  : SizedBox(),
            )
            .toList(),
      ),
    );
  }
}

// Actividades Esfuerzo Mental *******************

var id_actividades_esfuerzo_mental;

class ActividadesEsfuerzoMental extends StatefulWidget {
  @override
  ActividadesEsfuerzoMentalWidgetState createState() =>
      ActividadesEsfuerzoMentalWidgetState();
}

class ActividadesEsfuerzoMentalWidgetState
    extends State<ActividadesEsfuerzoMental> {
  @override
  void initState() {
    id_actividades_esfuerzo_mental = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasSaludCerebral
            .map(
              (list) => list['code'] == "SCER50" ||
                      list['code'] == "SCER51" ||
                      list['code'] == "SCER52" ||
                      list['code'] == "SCER53" ||
                      list['code'] == "SCER54"
                  ? RadioListTile(
                      groupValue: id_actividades_esfuerzo_mental,
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
                          id_actividades_esfuerzo_mental = val;
                        });
                      },
                    )
                  : SizedBox(),
            )
            .toList(),
      ),
    );
  }
}

// Actividades Indole Cultural *******************

var id_actividad_indole_cultural;

class ActividadesIndoleCultural extends StatefulWidget {
  @override
  ActividadesIndoleCulturalWidgetState createState() =>
      ActividadesIndoleCulturalWidgetState();
}

class ActividadesIndoleCulturalWidgetState
    extends State<ActividadesIndoleCultural> {
  @override
  void initState() {
    id_actividad_indole_cultural = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasSaludCerebral
            .map(
              (list) => list['code'] == "SCER55" ||
                      list['code'] == "SCER56" ||
                      list['code'] == "SCER57" ||
                      list['code'] == "SCER58" ||
                      list['code'] == "SCER59"
                  ? RadioListTile(
                      groupValue: id_actividad_indole_cultural,
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
                          id_actividad_indole_cultural = val;
                        });
                      },
                    )
                  : SizedBox(),
            )
            .toList(),
      ),
    );
  }
}

// Esperanza Habito Saludable *******************

var id_esperanza_habito_saludable;

class EsperanzaHabitoSaludable extends StatefulWidget {
  @override
  EsperanzaHabitoSaludableWidgetState createState() =>
      EsperanzaHabitoSaludableWidgetState();
}

class EsperanzaHabitoSaludableWidgetState
    extends State<EsperanzaHabitoSaludable> {
  @override
  void initState() {
    id_esperanza_habito_saludable = null;
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
        children: itemsRespuestasSaludCerebral
            .map(
              (list) => list['code'] == "SCER60" || list['code'] == "SCER61"
                  ? RadioListTile(
                      groupValue: id_esperanza_habito_saludable,
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
                          id_esperanza_habito_saludable = val;
                        });
                      },
                    )
                  : SizedBox(),
            )
            .toList(),
      ),
    );
  }
}
