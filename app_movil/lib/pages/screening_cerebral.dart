import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/opciones_navbar.dart';
import 'env.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ScreeningCerebral extends StatefulWidget {
  @override
  _ScreeningCerebralState createState() => _ScreeningCerebralState();
}

final _formKey_cerebral = GlobalKey<_ScreeningCerebralState>();

TextEditingController otro_controller = TextEditingController();
TextEditingController otro_habito_controller = TextEditingController();
List itemsRespuestasSaludCerebral;

var id_paciente;
var id_medico;
var tipo_screening;
var id_recordatorio;
var email;
var screening_recordatorio;

class _ScreeningCerebralState extends State<ScreeningCerebral> {
  double _animatedHeight = 0.0;

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email_prefer = prefs.getString("email_prefer");
    email = email_prefer;
    id_paciente = prefs.getInt("id_paciente");
    print(email);

    Map parametros = ModalRoute.of(context).settings.arguments;

    get_tiposcreening("SCER");

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

    tipo_screening = json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        _alert_clinicos(context, "Cuestionario Cerebral", " Descripcion"));
  }

  @override
  Widget build(BuildContext context) {
    //getStringValuesSF();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/screening', arguments: {
              "select_screening": "SFMS",
            });
          },
        ),
        title: Text('Chequeo de Salud Cerebral',
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
          future: getAllRespuesta(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ColumnWidgetCerebral();
            } else {
              return Center(
                child: CircularProgressIndicator(
                  semanticsLabel: "Cargando",
                ),
              );
            }
          }),
    );
  }

  Future<List> getAllRespuesta() async {
    var response;

    String URL_base = Env.URL_API;
    var url = URL_base + "/tipo_respuesta_salud_cerebral";

    response = await http.post(url, body: {});

    var jsonData = json.decode(response.body);

    if (response.statusCode == 200) {
      await Future.delayed(Duration(milliseconds: 500));
      return itemsRespuestasSaludCerebral = jsonData['data'];
    } else {
      return null;
    }
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

  void choiceAction(String choice) {
    if (choice == Constants.Ajustes) {
      Navigator.pushNamed(context, '/ajustes');
    } else if (choice == Constants.Salir) {
      Navigator.pushNamed(context, '/');
    }
  }
}

class ColumnWidgetCerebral extends StatefulWidget {
  const ColumnWidgetCerebral({
    Key key,
  }) : super(key: key);

  @override
  State<ColumnWidgetCerebral> createState() => _ColumnWidgetCerebralState();
}

class _ColumnWidgetCerebralState extends State<ColumnWidgetCerebral> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        // Container(
        //   padding: EdgeInsets.only(top: 20.0), // Padding superior de 20 puntos
        //   child: CustomDivider(
        //     text: 'ACTIVIDADES DE AUTOCUIDADO',
        //     color: Colors.red,
        //   ),
        // ),
        Card(
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
                ActividadFisica(),
                AlimentacionSaludable(),
                ContactoSocial(),
                Sueno(),
                ActividadEsfuerzoMental(),
                Otro(),
                Padding(
                  padding: EdgeInsets.all(10.0),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
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
                    "Contacto social. ¿Cuántos días en la semana tiene contacto con amigos?",
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
                    "Sueño. ¿Realiza siestas durante el día?",
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
                    "Sueño. ¿A que hora se duerme habitualmenbte?",
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
                    "Sueño. ¿Duerme menos de 8 hs por noche?",
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
                    "¿Participa en actividades de indole cultural (cine, teatro, conciertos, museos) y/o artístico (canto, pintura, cerámica, baile, música)?",
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
                    "¿Ud. tendría esperanza en que incorporando algunos hábitos saludables como los relacionados a las artes (incluidas las artes visuales, la música y la danza) podrían mejorar la salud de su cerebro?",
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
          padding: EdgeInsets.all(4.0),
        ),
      ]),
    );
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

  delayTimer() async {
    await Future.delayed(Duration(milliseconds: 500));
    return true;
  }
}

guardarDatosSaludCerebral(BuildContext context) async {
  if (id_actividad_fisica == null)
    loginToast("Debe responder todas las preguntas");
  if (id_actividad_fisica_minutos == null)
    loginToast("Debe responder todas las preguntas");
  if (id_persona_mantenida_10anos == null)
    loginToast("Debe responder todas las preguntas");
  if (id_persona_activa_vida == null)
    loginToast("Debe responder todas las preguntas");
  if (id_dias_alimenta_saludable == null)
    loginToast("Debe responder todas las preguntas");
  if (id_alimenta_saludable_vida == null)
    loginToast("Debe responder todas las preguntas");
  if (id_contacto_social_amigos == null)
    loginToast("Debe responder todas las preguntas");
  if (id_contacto_social_actividad == null)
    loginToast("Debe responder todas las preguntas");
  if (id_sueno_calidad_sueno == null)
    loginToast("Debe responder todas las preguntas");
  if (id_sueno_despierto_dia == null)
    loginToast("Debe responder todas las preguntas");
  if (id_sueno_siesta_dia == null)
    loginToast("Debe responder todas las preguntas");
  if (id_sueno_duerme == null) loginToast("Debe responder todas las preguntas");
  if (id_sueno_hora_noche == null)
    loginToast("Debe responder todas las preguntas");
  if (id_actividades_esfuerzo_mental == null)
    loginToast("Debe responder todas las preguntas");
  if (id_actividad_indole_cultural == null)
    loginToast("Debe responder todas las preguntas");
  if (id_esperanza_habito_saludable == null)
    loginToast("Debe responder todas las preguntas");

  if (id_actividad_fisica != null &&
      id_actividad_fisica_minutos != null &&
      id_persona_mantenida_10anos != null &&
      id_persona_activa_vida != null &&
      id_dias_alimenta_saludable != null &&
      id_alimenta_saludable_vida != null &&
      id_contacto_social_amigos != null &&
      id_contacto_social_actividad != null &&
      id_sueno_calidad_sueno != null &&
      id_sueno_despierto_dia != null &&
      id_sueno_siesta_dia != null &&
      id_sueno_duerme != null &&
      id_sueno_hora_noche != null &&
      id_actividades_esfuerzo_mental &&
      id_actividad_indole_cultural &&
      id_esperanza_habito_saludable) {
    showDialogMessage(context);
    String URL_base = Env.URL_API;
    var url = URL_base + "/respuesta_screening_cerebral";
    var response = await http.post(url, body: {
      "id_paciente": id_paciente.toString(),
      "id_medico": id_medico.toString(),
      "id_recordatorio": id_recordatorio.toString(),
      "tipo_screening": tipo_screening['data'].toString(),
      "id_actividad_fisica": id_actividad_fisica.toString(),
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
      "id_sueno_hora_noche": id_sueno_hora_noche.toString(),
      "id_actividades_esfuerzo_mental":
          id_actividades_esfuerzo_mental.toString(),
      "id_actividad_indole_cultural": id_actividad_indole_cultural.toString(),
      "id_esperanza_habito_saludable": id_esperanza_habito_saludable.toString()
    });

    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      if (data['data'] == "alert") {
        _alert_informe(
          context,
          "Para tener en cuenta",
          "Sería bueno que consulte con su médico clínico o neurologo sobre lo informado con respecto a su funcionamiento en la vida cotidiana. Es posible que el especialista le solicite una evaluación cognitiva para explorar màs en detalle su funcionamiento cognitivo y posible impacto sobre su rutina.",
        );
      } else {
        if (data['status'] == "Success") {
          if (screening_recordatorio == true) {
            Navigator.pushNamed(context, '/recordatorio');
          } else {
            Navigator.pushNamed(context, '/screening', arguments: {
              "select_screening": "CONDUC",
            });
          }
        }
      }
    }
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
              "select_screening": "CONDUC",
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

//----------------------------------------VARIABLES CHECKBOX -----------------------------------------------

bool actividadFisica = false;
bool alimentacionSaludable = false;
bool contactoSocial = false;
bool sueno = false;
bool actividadEsfuerzoMental = false;
bool otro = false;

String cod_event_satisfecho = "ANI1";
String cod_event_abandonado = 'ANI2';
String cod_event_vacia = 'ANI3';
String cod_event_aburrida = 'ANI4';
String cod_event_humor = 'ANI5';
String cod_event_temor = 'ANI6';
String cod_event_feliz = 'ANI7';

int _characterLimit = 60; // Cambia este valor según tus necesidades
int _characterLimitHabitos = 60; // Cambia este valor según tus necesidades

//-------------------------------------- ActividadFisicas -----------------------------------------------------

class LabeledCheckboxActividadFisica extends StatelessWidget {
  const LabeledCheckboxActividadFisica({
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
                      fontSize: 18,
                      //fontWeight: FontWeight.bold,
                    ))),
            Transform.scale(
              scale: 1.5,
              child: Checkbox(
                value: value,
                onChanged: (bool newValue) {
                  onChanged(newValue);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActividadFisica extends StatefulWidget {
  ActividadFisica({Key key}) : super(key: key);

  @override
  CheckActividadFisicaWidgetState createState() =>
      CheckActividadFisicaWidgetState();
}

class CheckActividadFisicaWidgetState extends State<ActividadFisica> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxActividadFisica(
      label: 'Actividad Física',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: actividadFisica,
      onChanged: (bool newValue) {
        setState(() {
          actividadFisica = newValue;
        });
      },
    );
  }
}

//-----------------------------------------------------------------------------------------------------------
//-------------------------------------- Alimentacion Saludable -----------------------------------------------------

class LabeledCheckboxAlimentacionSaludable extends StatelessWidget {
  const LabeledCheckboxAlimentacionSaludable({
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
                      fontSize: 18,
                    ))),
            Transform.scale(
              scale: 1.5,
              child: Checkbox(
                value: value,
                onChanged: (bool newValue) {
                  onChanged(newValue);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AlimentacionSaludable extends StatefulWidget {
  AlimentacionSaludable({Key key}) : super(key: key);

  @override
  CheckAlimentacionSaludableWidgetState createState() =>
      CheckAlimentacionSaludableWidgetState();
}

class CheckAlimentacionSaludableWidgetState
    extends State<AlimentacionSaludable> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxAlimentacionSaludable(
      label: 'Alimentación Saludable',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: alimentacionSaludable,
      onChanged: (bool newValue) {
        setState(() {
          alimentacionSaludable = newValue;
        });
      },
    );
  }
}

//-----------------------------------------------------------------------------------------------------------
//-------------------------------------- Alimentacion Saludable -----------------------------------------------------

class LabeledCheckboxContactoSocial extends StatelessWidget {
  const LabeledCheckboxContactoSocial({
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
                      fontSize: 18,
                    ))),
            Transform.scale(
              scale: 1.5,
              child: Checkbox(
                value: value,
                onChanged: (bool newValue) {
                  onChanged(newValue);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactoSocial extends StatefulWidget {
  ContactoSocial({Key key}) : super(key: key);

  @override
  CheckContactoSocialWidgetState createState() =>
      CheckContactoSocialWidgetState();
}

class CheckContactoSocialWidgetState extends State<ContactoSocial> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxContactoSocial(
      label: 'Contacto Social',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: contactoSocial,
      onChanged: (bool newValue) {
        setState(() {
          contactoSocial = newValue;
        });
      },
    );
  }
}

//-----------------------------------------------------------------------------------------------------------

//-------------------------------------- Sueño -----------------------------------------------------

class LabeledCheckboxSueno extends StatelessWidget {
  const LabeledCheckboxSueno({
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
                  fontSize: 18,
                ),
              ),
            ),
            Transform.scale(
              scale: 1.5,
              child: Checkbox(
                value: value,
                onChanged: (bool newValue) {
                  onChanged(newValue);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Sueno extends StatefulWidget {
  Sueno({Key key}) : super(key: key);

  @override
  CheckSuenoWidgetState createState() => CheckSuenoWidgetState();
}

class CheckSuenoWidgetState extends State<Sueno> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxSueno(
      label: 'Sueño',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: sueno,
      onChanged: (bool newValue) {
        setState(() {
          sueno = newValue;
        });
      },
    );
  }
}

//-----------------------------------------------------------------------------------------------------------

//-------------------------------------- Actividades que implican esfuerzo mental -----------------------------------------------------

class LabeledCheckboxActividadEsfuerzoMental extends StatelessWidget {
  const LabeledCheckboxActividadEsfuerzoMental({
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
                  fontSize: 18,
                ),
              ),
            ),
            Transform.scale(
              scale: 1.5,
              child: Checkbox(
                value: value,
                onChanged: (bool newValue) {
                  onChanged(newValue);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActividadEsfuerzoMental extends StatefulWidget {
  ActividadEsfuerzoMental({Key key}) : super(key: key);

  @override
  CheckActividadEsfuerzoMentalWidgetState createState() =>
      CheckActividadEsfuerzoMentalWidgetState();
}

class CheckActividadEsfuerzoMentalWidgetState
    extends State<ActividadEsfuerzoMental> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxActividadEsfuerzoMental(
      label: 'Actividades que implican esfuerzo mental',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: actividadEsfuerzoMental,
      onChanged: (bool newValue) {
        setState(() {
          actividadEsfuerzoMental = newValue;
        });
      },
    );
  }
}

//-----------------------------------------------------------------------------------------------------------

//-------------------------------------- Otro -----------------------------------------------------

class LabeledCheckboxOtro extends StatelessWidget {
  const LabeledCheckboxOtro({
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
                  fontSize: 18,
                ),
              ),
            ),
            Transform.scale(
              scale: 1.5,
              child: Checkbox(
                value: value,
                onChanged: (bool newValue) {
                  onChanged(newValue);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Otro extends StatefulWidget {
  Otro({Key key}) : super(key: key);

  @override
  CheckOtroWidgetState createState() => CheckOtroWidgetState();
}

class CheckOtroWidgetState extends State<Otro> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LabeledCheckboxOtro(
          label: 'Otro',
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          value: otro,
          onChanged: (bool newValue) {
            setState(() {
              otro = newValue;
              if (!otro) {
                otro_habito_controller
                    .clear(); // Reiniciar el TextField cuando el checkbox se desactiva
              }
              print(otro);
            });
          },
        ),
        if (otro)
          Container(
            padding: EdgeInsets.all(10),
            child: TextFormField(
              controller: otro_habito_controller,
              maxLength: _characterLimit,
              decoration: InputDecoration(
                  labelText: '¿Qué otro hábito?',
                  labelStyle: TextStyle(
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily,
                  )),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Debe completar este campo';
                }
                return null;
              },
              onChanged: (text) {
                print("Debe completar el campo");
              },
            ),
          ),
      ],
    );
  }
}

//-----------------------------------------------------------------------------------------------------------
// Realiza Actividad Fisica *******************

var id_actividad_fisica = null;

class ActividadFisicaModerada extends StatefulWidget {
  @override
  ActividadFisicaModeradaWidgetState createState() =>
      ActividadFisicaModeradaWidgetState();
}

class ActividadFisicaModeradaWidgetState
    extends State<ActividadFisicaModerada> {
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
              (list) => list['codigo_evento'] == "SCER06" ||
                      list['codigo_evento'] == "SCER07" ||
                      list['codigo_evento'] == "SCER08" ||
                      list['codigo_evento'] == "SCER09" ||
                      list['codigo_evento'] == "SCER10"
                  ? RadioListTile(
                      groupValue: id_actividad_fisica,
                      title: Text(
                        list['nombre_evento'],
                        style: TextStyle(
                          fontFamily:
                              Theme.of(context).textTheme.headline1.fontFamily,
                        ),
                      ),
                      value: list['id'].toString(),
                      onChanged: (val) {
                        setState(() {
                          debugPrint('VAL = $val');
                          id_actividad_fisica = val;
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

var id_actividad_fisica_minutos = null;

class ActividadFisicaModeradaMinutos extends StatefulWidget {
  @override
  ActividadFisicaModeradaMinutosWidgetState createState() =>
      ActividadFisicaModeradaMinutosWidgetState();
}

class ActividadFisicaModeradaMinutosWidgetState
    extends State<ActividadFisicaModeradaMinutos> {
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
              (list) => list['codigo_evento'] == "SCER11" ||
                      list['codigo_evento'] == "SCER12" ||
                      list['codigo_evento'] == "SCER13" ||
                      list['codigo_evento'] == "SCER14" ||
                      list['codigo_evento'] == "SCER15"
                  ? RadioListTile(
                      groupValue: id_actividad_fisica_minutos,
                      title: Text(
                        list['nombre_evento'],
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

var id_persona_mantenida_10anos = null;

class PersonaActiva10Anos extends StatefulWidget {
  @override
  PersonaActiva10AnosWidgetState createState() =>
      PersonaActiva10AnosWidgetState();
}

class PersonaActiva10AnosWidgetState extends State<PersonaActiva10Anos> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasSaludCerebral
            .map(
              (list) => list['codigo_evento'] == "SCER16" ||
                      list['codigo_evento'] == "SCER17" ||
                      list['codigo_evento'] == "SCER18" ||
                      list['codigo_evento'] == "SCER19"
                  ? RadioListTile(
                      groupValue: id_persona_mantenida_10anos,
                      title: Text(
                        list['nombre_evento'],
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

var id_persona_activa_vida = null;

class PersonaActivaVida extends StatefulWidget {
  @override
  PersonaActivaVidaWidgetState createState() => PersonaActivaVidaWidgetState();
}

class PersonaActivaVidaWidgetState extends State<PersonaActivaVida> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasSaludCerebral
            .map(
              (list) => list['codigo_evento'] == "SCER20" ||
                      list['codigo_evento'] == "SCER21" ||
                      list['codigo_evento'] == "SCER22" ||
                      list['codigo_evento'] == "SCER23"
                  ? RadioListTile(
                      groupValue: id_persona_activa_vida,
                      title: Text(
                        list['nombre_evento'],
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

var id_dias_alimenta_saludable = null;

class DiasAlimentaSaludable extends StatefulWidget {
  @override
  DiasAlimentaSaludableWidgetState createState() =>
      DiasAlimentaSaludableWidgetState();
}

class DiasAlimentaSaludableWidgetState extends State<DiasAlimentaSaludable> {
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
              (list) => list['codigo_evento'] == "SCER24" ||
                      list['codigo_evento'] == "SCER25" ||
                      list['codigo_evento'] == "SCER26" ||
                      list['codigo_evento'] == "SCER27" ||
                      list['codigo_evento'] == "SCER28"
                  ? RadioListTile(
                      groupValue: id_dias_alimenta_saludable,
                      title: Text(
                        list['nombre_evento'],
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

var id_alimenta_saludable_vida = null;

class AlimentarSaludableVida extends StatefulWidget {
  @override
  AlimentarSaludableVidaWidgetState createState() =>
      AlimentarSaludableVidaWidgetState();
}

class AlimentarSaludableVidaWidgetState extends State<AlimentarSaludableVida> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasSaludCerebral
            .map(
              (list) => list['codigo_evento'] == "SCER29" ||
                      list['codigo_evento'] == "SCER30" ||
                      list['codigo_evento'] == "SCER31" ||
                      list['codigo_evento'] == "SCER32"
                  ? RadioListTile(
                      groupValue: id_alimenta_saludable_vida,
                      title: Text(
                        list['nombre_evento'],
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

var id_contacto_social_amigos = null;

class ContactoSocialAmigos extends StatefulWidget {
  @override
  ContactoSocialAmigosWidgetState createState() =>
      ContactoSocialAmigosWidgetState();
}

class ContactoSocialAmigosWidgetState extends State<ContactoSocialAmigos> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasSaludCerebral
            .map(
              (list) => list['codigo_evento'] == "SCER33" ||
                      list['codigo_evento'] == "SCER34" ||
                      list['codigo_evento'] == "SCER35" ||
                      list['codigo_evento'] == "SCER36"
                  ? RadioListTile(
                      groupValue: id_contacto_social_amigos,
                      title: Text(
                        list['nombre_evento'],
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

// Contacto Social Amigos *******************

var id_contacto_social_familia = null;

class ContactoSocialFamilia extends StatefulWidget {
  @override
  ContactoSocialFamiliaWidgetState createState() =>
      ContactoSocialFamiliaWidgetState();
}

class ContactoSocialFamiliaWidgetState extends State<ContactoSocialFamilia> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasSaludCerebral
            .map(
              (list) => list['codigo_evento'] == "SCER37" ||
                      list['codigo_evento'] == "SCER38" ||
                      list['codigo_evento'] == "SCER39" ||
                      list['codigo_evento'] == "SCER40" ||
                      list['codigo_evento'] == "SCER41"
                  ? RadioListTile(
                      groupValue: id_contacto_social_familia,
                      title: Text(
                        list['nombre_evento'],
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

// Contacto Social Amigos *******************

var id_contacto_social_actividad = null;

class ContactoSocialActividad extends StatefulWidget {
  @override
  ContactoSocialActividadWidgetState createState() =>
      ContactoSocialActividadWidgetState();
}

class ContactoSocialActividadWidgetState
    extends State<ContactoSocialActividad> {
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
              (list) => list['codigo_evento'] == "SCER42" ||
                      list['codigo_evento'] == "SCER43" ||
                      list['codigo_evento'] == "SCER44" ||
                      list['codigo_evento'] == "SCER45"
                  ? RadioListTile(
                      groupValue: id_contacto_social_actividad,
                      title: Text(
                        list['nombre_evento'],
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

var id_sueno_calidad_sueno = null;

class SuenoCalidadSueno extends StatefulWidget {
  @override
  SuenoCalidadSuenoWidgetState createState() => SuenoCalidadSuenoWidgetState();
}

class SuenoCalidadSuenoWidgetState extends State<SuenoCalidadSueno> {
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
              (list) => list['codigo_evento'] == "SCER60" ||
                      list['codigo_evento'] == "SCER61"
                  ? RadioListTile(
                      groupValue: id_sueno_calidad_sueno,
                      title: Text(
                        list['nombre_evento'],
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

var id_sueno_despierto_dia = null;

class SuenoDespiernoDia extends StatefulWidget {
  @override
  SuenoDespiernoDiaWidgetState createState() => SuenoDespiernoDiaWidgetState();
}

class SuenoDespiernoDiaWidgetState extends State<SuenoDespiernoDia> {
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
              (list) => list['codigo_evento'] == "SCER60" ||
                      list['codigo_evento'] == "SCER61"
                  ? RadioListTile(
                      groupValue: id_sueno_despierto_dia,
                      title: Text(
                        list['nombre_evento'],
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

var id_sueno_siesta_dia = null;

class SuenoSiestaDia extends StatefulWidget {
  @override
  SuenoSiestaDiaWidgetState createState() => SuenoSiestaDiaWidgetState();
}

class SuenoSiestaDiaWidgetState extends State<SuenoSiestaDia> {
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
              (list) => list['codigo_evento'] == "SCER60" ||
                      list['codigo_evento'] == "SCER61"
                  ? RadioListTile(
                      groupValue: id_sueno_siesta_dia,
                      title: Text(
                        list['nombre_evento'],
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

var id_sueno_duerme = null;

class SuenoDuerme extends StatefulWidget {
  @override
  SuenoDuermeWidgetState createState() => SuenoDuermeWidgetState();
}

class SuenoDuermeWidgetState extends State<SuenoDuerme> {
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
              (list) => list['codigo_evento'] == "SCER60" ||
                      list['codigo_evento'] == "SCER61"
                  ? RadioListTile(
                      groupValue: id_sueno_duerme,
                      title: Text(
                        list['nombre_evento'],
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

var id_sueno_duerme_noche = null;

class SuenoDuermeNoche extends StatefulWidget {
  @override
  SuenoDuermeNocheWidgetState createState() => SuenoDuermeNocheWidgetState();
}

class SuenoDuermeNocheWidgetState extends State<SuenoDuermeNoche> {
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
              (list) => list['codigo_evento'] == "SCER60" ||
                      list['codigo_evento'] == "SCER61"
                  ? RadioListTile(
                      groupValue: id_sueno_duerme_noche,
                      title: Text(
                        list['nombre_evento'],
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

var id_sueno_hora_noche = null;

class SuenoHoraNoche extends StatefulWidget {
  @override
  SuenoHoraNocheWidgetState createState() => SuenoHoraNocheWidgetState();
}

class SuenoHoraNocheWidgetState extends State<SuenoHoraNoche> {
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
              (list) => list['codigo_evento'] == "SCER60" ||
                      list['codigo_evento'] == "SCER61"
                  ? RadioListTile(
                      groupValue: id_sueno_hora_noche,
                      title: Text(
                        list['nombre_evento'],
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

var id_actividades_esfuerzo_mental = null;

class ActividadesEsfuerzoMental extends StatefulWidget {
  @override
  ActividadesEsfuerzoMentalWidgetState createState() =>
      ActividadesEsfuerzoMentalWidgetState();
}

class ActividadesEsfuerzoMentalWidgetState
    extends State<ActividadesEsfuerzoMental> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasSaludCerebral
            .map(
              (list) => list['codigo_evento'] == "SCER50" ||
                      list['codigo_evento'] == "SCER51" ||
                      list['codigo_evento'] == "SCER52" ||
                      list['codigo_evento'] == "SCER53" ||
                      list['codigo_evento'] == "SCER54"
                  ? RadioListTile(
                      groupValue: id_actividades_esfuerzo_mental,
                      title: Text(
                        list['nombre_evento'],
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

// Actividades Esfuerzo Mental *******************

var id_actividad_indole_cultural = null;

class ActividadesIndoleCultural extends StatefulWidget {
  @override
  ActividadesIndoleCulturalWidgetState createState() =>
      ActividadesIndoleCulturalWidgetState();
}

class ActividadesIndoleCulturalWidgetState
    extends State<ActividadesIndoleCultural> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasSaludCerebral
            .map(
              (list) => list['codigo_evento'] == "SCER55" ||
                      list['codigo_evento'] == "SCER56" ||
                      list['codigo_evento'] == "SCER57" ||
                      list['codigo_evento'] == "SCER58" ||
                      list['codigo_evento'] == "SCER59"
                  ? RadioListTile(
                      groupValue: id_actividad_indole_cultural,
                      title: Text(
                        list['nombre_evento'],
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

// Actividades Esfuerzo Mental *******************

var id_esperanza_habito_saludable = null;

class EsperanzaHabitoSaludable extends StatefulWidget {
  @override
  EsperanzaHabitoSaludableWidgetState createState() =>
      EsperanzaHabitoSaludableWidgetState();
}

class EsperanzaHabitoSaludableWidgetState
    extends State<EsperanzaHabitoSaludable> {
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
              (list) => list['codigo_evento'] == "SCER60" ||
                      list['codigo_evento'] == "SCER61"
                  ? RadioListTile(
                      groupValue: id_esperanza_habito_saludable,
                      title: Text(
                        list['nombre_evento'],
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
