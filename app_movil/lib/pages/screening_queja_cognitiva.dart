import 'package:app_salud/widgets/alert_informe.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_salud/pages/env.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/opciones_navbar.dart';

class ScreeningBPage extends StatefulWidget {
  @override
  _ScreeningBState createState() => _ScreeningBState();
}

final _formKey_quejas_cognitivas = GlobalKey<_ScreeningBState>();
var id_paciente;
var id_medico;
var tipo_screening;
var id_recordatorio;

var email;
var screening_recordatorio;

List dataScreeningQC = [];

class _ScreeningBState extends State<ScreeningBPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => alert_screenings_generico(
          context,
          "Cuestionario de Quejas Cognitivas",
          "Este cuestionario explora sobre posibles y actuales quejas cognitivas, por ejemplo que ultimamente hay a notado que se olvida más que antes o que está más disperso. Deberà elegir la opción que describa la frecuencia en que dicha queja aparece en su rutina."),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _formKey_quejas_cognitivas = GlobalKey<FormState>();

    getStringValuesSF();

    return WillPopScope(
      onWillPop: () async {
        // Navegar a la ruta deseada, por ejemplo, la ruta '/inicio':
        Navigator.pushNamed(context, '/screening', arguments: {
          "select_screening": "QCQ",
        });
        // Devuelve 'true' para permitir la navegación hacia atrás.
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Cuestionario de Quejas Cognitivas - QCQ',
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
              )),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, '/screening', arguments: {
                "select_screening": "QCQ",
              });
            },
          ),
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
            ),
          ],
        ),
        body: FutureBuilder(
            future: getAllRespuestaQC(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ScreeningQCQ();
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

  getAllRespuestaQC() async {
    String URL_base = Env.URL_API;
    var url = URL_base + "/tipo_respuesta_quejas";
    var response = await http.post(url, body: {});

    var jsonDate = json.decode(response.body);

    if (response.statusCode == 200 && jsonDate['status'] != "Vacio") {
      //setState(() {
      dataScreeningQC = jsonDate['data'];
      //});
      return true;
    } else {
      return false;
    }
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
    String URL_base = Env.URL_API;
    var url = URL_base + "/read_tipo_screening";
    var response = await http.post(url, body: {
      "codigo_screening": codigo_screening,
    });

    var jsonDate = json.decode(response.body);

    tipo_screening = jsonDate['data'];
  }

  choiceAction(String choice) {
    if (choice == Constants.Ajustes) {
      Navigator.pushNamed(context, '/ajustes');
    } else if (choice == Constants.Salir) {
      Navigator.pushNamed(context, '/');
    }
  }
}

//----------------------------------------Screening de Quejas Cognitivas ------------------------------------------

class ScreeningQCQ extends StatefulWidget {
  ScreeningQCQ({Key key}) : super(key: key);

  @override
  ScreeningQCQWidgetState createState() => ScreeningQCQWidgetState();
}

class ScreeningQCQWidgetState extends State<ScreeningQCQ> {
  final _formKey_quejas_cognitivas = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.all(10),
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
                      text: 'Atención',
                      color: Colors.lightGreen,
                    ),
                    //Divider(height: 5.0, color: Colors.black),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    Container(
                      width: 320,
                      child: Text(
                        '¿Se distrae con facilidad, por ejemplo cuando lee, mira una película o conversa con alguien?',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontFamily:
                              Theme.of(context).textTheme.headline1.fontFamily,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Atencion1(),
                    SizedBox(height: 20),
                  ],
                ),
              )),
          Padding(
            padding: EdgeInsets.all(8.0),
          ),

          Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.all(10),
              elevation: 10,
              child: ClipRRect(
                // Los bordes del contenido del card se cortan usando BorderRadius
                borderRadius: BorderRadius.circular(15),

                // EL widget hijo que será recortado segun la propiedad anterior
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    CustomDivider(
                      text: 'Atención',
                      color: Colors.lightGreen,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    Container(
                      width: 320,
                      child: Text(
                        '¿Necesita prestar más atención que antes o hacer más esfuerzos que otros para realizar las tareas?',
                        style: TextStyle(
                          fontFamily:
                              Theme.of(context).textTheme.headline1.fontFamily,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Atencion2(),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )),

          //-------------------------------------------------------AAAAAAAAAAAAAAAACAAAAAAAAAAAAAAAAAAAAAAAAAA

          Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.all(10),
              elevation: 10,
              child: ClipRRect(
                // Los bordes del contenido del card se cortan usando BorderRadius
                borderRadius: BorderRadius.circular(15),

                // EL widget hijo que será recortado segun la propiedad anterior
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    CustomDivider(
                      text: 'Atención',
                      color: Colors.lightGreen,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    Container(
                      width: 320,
                      child: Text(
                        '¿Pierde el hilo del pensamiento, por ejemplo cuando está conversando con alguien cambia de tema en tema?',
                        style: TextStyle(
                          fontFamily:
                              Theme.of(context).textTheme.headline1.fontFamily,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Atencion3(),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )),

          Divider(
            height: 5.0,
            color: Colors.black,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
          ),

          Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.all(10),
              elevation: 10,
              child: ClipRRect(
                // Los bordes del contenido del card se cortan usando BorderRadius
                borderRadius: BorderRadius.circular(15),

                // EL widget hijo que será recortado segun la propiedad anterior
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    CustomDivider(
                      text: 'Atención',
                      color: Colors.lightGreen,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    Container(
                      width: 320,
                      child: Text(
                        '¿Le resulta difícil hacer más de una cosa a la vez?',
                        style: TextStyle(
                          fontFamily:
                              Theme.of(context).textTheme.headline1.fontFamily,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Atencion4(),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )),

          Divider(
            height: 5.0,
            color: Colors.black,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
          ),
          // Text(
          //   'Orientación',
          //   style: TextStyle(
          //     fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
          //     fontSize: 20.0,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),

          Padding(
            padding: EdgeInsets.all(8.0),
          ),

          Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.all(10),
              elevation: 10,
              child: ClipRRect(
                // Los bordes del contenido del card se cortan usando BorderRadius
                borderRadius: BorderRadius.circular(15),

                // EL widget hijo que será recortado segun la propiedad anterior
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    CustomDivider(
                      text: 'Orientación',
                      color: Colors.indigoAccent,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    Container(
                      width: 320,
                      child: Text(
                        '¿Tiene problemas para orientarse en lugares conocidos (por ejemplo, su barrio)?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Orientacion1(),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )),

          Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.all(10),
              elevation: 10,
              child: ClipRRect(
                // Los bordes del contenido del card se cortan usando BorderRadius
                borderRadius: BorderRadius.circular(15),

                // EL widget hijo que será recortado segun la propiedad anterior
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    CustomDivider(
                      text: 'Orientación',
                      color: Colors.indigoAccent,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    Container(
                      width: 320,
                      child: Text(
                        '¿Tiene problemas para encontrar alguna habitación dentro de su propia casa o institución que frecuenta (por ejemplo, baño)?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Orientacion2(),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )),

          Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.all(10),
              elevation: 10,
              child: ClipRRect(
                // Los bordes del contenido del card se cortan usando BorderRadius
                borderRadius: BorderRadius.circular(15),

                // EL widget hijo que será recortado segun la propiedad anterior
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    CustomDivider(
                      text: 'Orientación',
                      color: Colors.indigoAccent,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    Container(
                      width: 320,
                      child: Text(
                        '¿Se equivoca o no está seguro de la fecha (día, mes y año)?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Orientacion3(),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )),

          Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.all(10),
              elevation: 10,
              child: ClipRRect(
                // Los bordes del contenido del card se cortan usando BorderRadius
                borderRadius: BorderRadius.circular(15),

                // EL widget hijo que será recortado segun la propiedad anterior
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    CustomDivider(
                      text: 'Orientación',
                      color: Colors.indigoAccent,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    Container(
                      width: 320,
                      child: Text(
                        '¿Tiene dificultades para decir con precisión su edad actual?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Orientacion4(),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )),

          Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.all(10),
              elevation: 10,
              child: ClipRRect(
                // Los bordes del contenido del card se cortan usando BorderRadius
                borderRadius: BorderRadius.circular(15),

                // EL widget hijo que será recortado segun la propiedad anterior
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    CustomDivider(
                      text: 'Orientación',
                      color: Colors.indigoAccent,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    Container(
                      width: 320,
                      child: Text(
                        '¿Tiene dificultades para decir con precisión su edad actual?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Orientacion4(),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )),

          Divider(height: 5.0, color: Colors.black),
          Padding(
            padding: EdgeInsets.all(10),
          ),

          Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.all(10),
              elevation: 10,
              child: ClipRRect(
                // Los bordes del contenido del card se cortan usando BorderRadius
                borderRadius: BorderRadius.circular(15),

                // EL widget hijo que será recortado segun la propiedad anterior
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    CustomDivider(
                      text: 'Funciones Ejecutivas',
                      color: Colors.teal,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    Container(
                      width: 320,
                      child: Text(
                        '¿Le cuesta tomar decisiones o decidir qué hacer?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    FunEjec1(),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )),

          Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.all(10),
              elevation: 10,
              child: ClipRRect(
                // Los bordes del contenido del card se cortan usando BorderRadius
                borderRadius: BorderRadius.circular(15),

                // EL widget hijo que será recortado segun la propiedad anterior
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    CustomDivider(
                      text: 'Funciones Ejecutivas',
                      color: Colors.teal,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    Container(
                      width: 320,
                      child: Text(
                        '¿Tiene dificultades para organizar planes, por ejemplo una salida con amigos?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    FunEjec2(),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )),

          Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.all(10),
              elevation: 10,
              child: ClipRRect(
                // Los bordes del contenido del card se cortan usando BorderRadius
                borderRadius: BorderRadius.circular(15),

                // EL widget hijo que será recortado segun la propiedad anterior
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    CustomDivider(
                      text: 'Funciones Ejecutivas',
                      color: Colors.teal,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    Container(
                      width: 320,
                      child: Text(
                        '¿Presenta dificultades para hacer cambios de planes o cambiar la actividad cuando es necesario, por ejemplo no hacer las compras como todos los viernes porque el domingo se irá de viaje por unas semanas?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    FunEjec3(),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )),

          Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.all(10),
              elevation: 10,
              child: ClipRRect(
                // Los bordes del contenido del card se cortan usando BorderRadius
                borderRadius: BorderRadius.circular(15),

                // EL widget hijo que será recortado segun la propiedad anterior
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    CustomDivider(
                      text: 'Funciones Ejecutivas',
                      color: Colors.teal,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    Container(
                      width: 320,
                      child: Text(
                        '¿Dificultad para seguir el orden de pasos necesario para realizar una tarea (ejemplo, cocinar, vestirse) o deja cosas sin terminar?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    FunEjec4(),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )),

          // Text(
          //   'Memoria',
          //   style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          // ),
          Padding(
            padding: EdgeInsets.all(8.0),
          ),
          Divider(height: 5.0, color: Colors.black),
          Padding(
            padding: EdgeInsets.all(10),
          ),

          Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.all(10),
              elevation: 10,
              child: ClipRRect(
                // Los bordes del contenido del card se cortan usando BorderRadius
                borderRadius: BorderRadius.circular(15),

                // EL widget hijo que será recortado segun la propiedad anterior
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    CustomDivider(
                      text: 'Memoria',
                      color: Colors.orangeAccent,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    Container(
                      width: 320,
                      child: Text(
                        '¿Olvida o confunde los nombres de personas conocidas (por ejemplo, nombres de nietos o amigos?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Memoria1(),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )),

          Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.all(10),
              elevation: 10,
              child: ClipRRect(
                // Los bordes del contenido del card se cortan usando BorderRadius
                borderRadius: BorderRadius.circular(15),

                // EL widget hijo que será recortado segun la propiedad anterior
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    CustomDivider(
                      text: 'Memoria',
                      color: Colors.orangeAccent,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    Container(
                      width: 320,
                      child: Text(
                        '¿Olvida citas o planes previamente pautados?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Memoria2(),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )),

          Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.all(10),
              elevation: 10,
              child: ClipRRect(
                // Los bordes del contenido del card se cortan usando BorderRadius
                borderRadius: BorderRadius.circular(15),

                // EL widget hijo que será recortado segun la propiedad anterior
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    CustomDivider(
                      text: 'Memoria',
                      color: Colors.orangeAccent,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    Container(
                      width: 320,
                      child: Text(
                        '¿Olvida el lugar donde dejo objetos de uso cotidiano (por ejemplo, llaves, anteojos, celular)?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Memoria3(),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )),

          Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.all(10),
              elevation: 10,
              child: ClipRRect(
                // Los bordes del contenido del card se cortan usando BorderRadius
                borderRadius: BorderRadius.circular(15),

                // EL widget hijo que será recortado segun la propiedad anterior
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    CustomDivider(
                      text: 'Memoria',
                      color: Colors.orangeAccent,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    Container(
                      width: 320,
                      child: Text(
                        '¿Algunas veces no recuerda hechos recientes (por ejemplo, que almorzó ayer, que le regalaron para su cumpleaños, quien llamó por teléfono)?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Memoria4(),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )),

          // Text(
          //   'Praxias y gnosias',
          //   style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          // ),
          Divider(height: 5.0, color: Colors.black),

          Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.all(10),
              elevation: 10,
              child: ClipRRect(
                // Los bordes del contenido del card se cortan usando BorderRadius
                borderRadius: BorderRadius.circular(15),

                // EL widget hijo que será recortado segun la propiedad anterior
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    CustomDivider(
                      text: 'Praxias y gnosias',
                      color: Colors.blueGrey,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    Container(
                      width: 320,
                      child: Text(
                        '¿Tiene dificultades para vestirse (no por problemas motrices, por ejemplo, prender los botones de la camisa)?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    PraxiaGnosia1(),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )),

          Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.all(10),
              elevation: 10,
              child: ClipRRect(
                // Los bordes del contenido del card se cortan usando BorderRadius
                borderRadius: BorderRadius.circular(15),

                // EL widget hijo que será recortado segun la propiedad anterior
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    CustomDivider(
                      text: 'Praxias y gnosias',
                      color: Colors.blueGrey,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    Container(
                      width: 320,
                      child: Text(
                        '¿Le cuesta hacer o copiar dibujos?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    PraxiaGnosia2(),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )),

          Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.all(10),
              elevation: 10,
              child: ClipRRect(
                // Los bordes del contenido del card se cortan usando BorderRadius
                borderRadius: BorderRadius.circular(15),

                // EL widget hijo que será recortado segun la propiedad anterior
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    CustomDivider(
                      text: 'Praxias y gnosias',
                      color: Colors.blueGrey,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    Container(
                      width: 320,
                      child: Text(
                        '¿Tiene dificultades para reconocer objetos o personas que conoce?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    PraxiaGnosia3(),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )),

          Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.all(10),
              elevation: 10,
              child: ClipRRect(
                // Los bordes del contenido del card se cortan usando BorderRadius
                borderRadius: BorderRadius.circular(15),

                // EL widget hijo que será recortado segun la propiedad anterior
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    CustomDivider(
                      text: 'Praxias y gnosias',
                      color: Colors.blueGrey,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    Container(
                      width: 320,
                      child: Text(
                        '¿Le cuesta encontrar objetos, particularmente cuando no están en la posición habitual?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    PraxiaGnosia4(),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )),

          // Text(
          //   'Lenguaje',
          //   style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          // ),
          Divider(height: 5.0, color: Colors.black),
          Padding(
            padding: EdgeInsets.all(10),
          ),
          Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.all(10),
              elevation: 10,
              child: ClipRRect(
                // Los bordes del contenido del card se cortan usando BorderRadius
                borderRadius: BorderRadius.circular(15),

                // EL widget hijo que será recortado segun la propiedad anterior
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    CustomDivider(
                      text: 'Lenguaje',
                      color: Colors.brown,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    Container(
                      width: 320,
                      child: Text(
                        '¿Tiene dificultades para encontrar la palabra correcta?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Lenguaje1(),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )),

          Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.all(10),
              elevation: 10,
              child: ClipRRect(
                // Los bordes del contenido del card se cortan usando BorderRadius
                borderRadius: BorderRadius.circular(15),

                // EL widget hijo que será recortado segun la propiedad anterior
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    CustomDivider(
                      text: 'Lenguaje',
                      color: Colors.brown,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    Container(
                      width: 320,
                      child: Text(
                        '¿Le cuesta escribir, su letra empeoró en el último tiempo?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Lenguaje2(),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )),

          Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.all(10),
              elevation: 10,
              child: ClipRRect(
                // Los bordes del contenido del card se cortan usando BorderRadius
                borderRadius: BorderRadius.circular(15),

                // EL widget hijo que será recortado segun la propiedad anterior
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    CustomDivider(
                      text: 'Lenguaje',
                      color: Colors.brown,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    Container(
                      width: 320,
                      child: Text(
                        '¿Le resulta difícil entender lo que otros dicen?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Lenguaje3(),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )),

          Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.all(10),
              elevation: 10,
              child: ClipRRect(
                // Los bordes del contenido del card se cortan usando BorderRadius
                borderRadius: BorderRadius.circular(15),

                // EL widget hijo que será recortado segun la propiedad anterior
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    CustomDivider(
                      text: 'Lenguaje',
                      color: Colors.brown,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                    ),
                    Container(
                      width: 320,
                      child: Text(
                        '¿Le cuesta entender lo que lee?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    Lenguaje4(),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )),

          Padding(
            padding: EdgeInsets.all(8.0),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                //primary: Color.fromRGBO(157, 19, 34, 1),
                ),
            onPressed: () {
              guardarDatos(context);
            },
            child: Text('GUARDAR',
                style: TextStyle(
                  fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
                )),
          ),

          Padding(
            padding: EdgeInsets.all(4.0),
          ),
        ]),
      ),
    );
  }
}

class CustomDivider extends StatefulWidget {
  var text;
  var color;

  CustomDivider({this.text, this.color});

  @override
  State<CustomDivider> createState() => _CustomDividerState();
}

class _CustomDividerState extends State<CustomDivider> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Expanded(
              child: Divider(
            thickness: 5,
            color: widget.color,
          )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
              child: Divider(
            thickness: 5,
            color: widget.color,
          )),
        ],
      ),
    );
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

guardarDatos(BuildContext context) async {
  if (id_ate1 == null ||
      id_ate2 == null ||
      id_ate3 == null ||
      id_ate4 == null) {
    loginToast("Debe responder si los item de Atención");
    return;
  }

  if (id_funejec1 == null ||
      id_funejec2 == null ||
      id_funejec3 == null ||
      id_funejec4 == null) {
    loginToast("Debe responder si los item de Funciones Ejecutivas");
    return;
  }

  if (id_ori1 == null ||
      id_ori2 == null ||
      id_ori3 == null ||
      id_ori4 == null) {
    loginToast("Debe responder si los item de Orientación");
    return;
  }

  if (id_memoria1 == null ||
      id_memoria2 == null ||
      id_memoria3 == null ||
      id_memoria4 == null) {
    loginToast("Debe responder si los item de Memoria");
    return;
  }

  if (id_prexgnosia1 == null ||
      id_prexgnosia2 == null ||
      id_prexgnosia3 == null ||
      id_prexgnosia4 == null) {
    loginToast("Debe responder si los item de Praxias y Gnosias");
    return;
  }

  if (id_leng1 == null ||
      id_leng2 == null ||
      id_leng3 == null ||
      id_leng4 == null) {
    loginToast("Debe responder si los item de Lenguajes");
    return;
  }

  String URL_base = Env.URL_API;
  var url = URL_base + "/respuesta_screening_quejas";
  var response = await http.post(url, body: {
    "id_paciente": id_paciente.toString(),
    "id_medico": id_medico.toString(),
    "id_recordatorio": id_recordatorio.toString(),
    "tipo_screening": tipo_screening.toString(),
    "id_ate1": id_ate1,
    "id_ate2": id_ate2,
    "id_ate3": id_ate3,
    "id_ate4": id_ate4,
    "id_ori1": id_ori1,
    "id_ori2": id_ori2,
    "id_ori3": id_ori3,
    "id_ori4": id_ori4,
    "id_funejec1": id_funejec1,
    "id_funejec2": id_funejec2,
    "id_funejec3": id_funejec3,
    "id_funejec4": id_funejec4,
    "id_memoria1": id_memoria1,
    "id_memoria2": id_memoria2,
    "id_memoria3": id_memoria3,
    "id_memoria4": id_memoria4,
    "id_prexgnosia1": id_prexgnosia1,
    "id_prexgnosia2": id_prexgnosia2,
    "id_prexgnosia3": id_prexgnosia3,
    "id_prexgnosia4": id_prexgnosia4,
    "id_leng1": id_leng1,
    "id_leng2": id_leng2,
    "id_leng3": id_leng3,
    "id_leng4": id_leng4,
  });

  var data = json.decode(response.body);
  String mensajeCQC;

  if (data['data'] == "mas_20") {
    mensajeCQC =
        "Sería bueno que consulte con su médico clínico o neurólogo sobre los síntomas cognitivos, probablemente le solicite una evaluación cognitiva para explorar su funcionamiento cognitivo.";
  }

  if (data['data'] == "menos_20") {
    mensajeCQC =
        "En este momento no presenta quejas cognitivas significativas. Continue estimulando sus funciones cognitivas, como la memoria, con actividades desafiantes para su cerebro.";
  }

  showCustomAlert(
    context,
    "Para tener en cuenta",
    mensajeCQC,
    true,
    () {
      if (screening_recordatorio == true) {
        Navigator.pushNamed(context, '/recordatorio');
      } else {
        Navigator.pushNamed(context, '/screening', arguments: {
          "select_screening": "QCQ",
        });
      }
    },
  );
}

//----------------------------------------ATENCION 1------------------------------------------------------------------------------------------
var id_ate1;
var id_ate2;
var id_ate3;
var id_ate4;

class Atencion1 extends StatefulWidget {
  @override
  Atencion1WidgetState createState() => Atencion1WidgetState();
}

class Atencion1WidgetState extends State<Atencion1> {
  @override
  void initState() {
    id_ate1 = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: dataScreeningQC
            .map((list) => RadioListTile(
                  groupValue: id_ate1,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_ate1 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class Atencion2 extends StatefulWidget {
  @override
  Atencion2WidgetState createState() => Atencion2WidgetState();
}

class Atencion2WidgetState extends State<Atencion2> {
  @override
  void initState() {
    id_ate2 = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: dataScreeningQC
            .map((list) => RadioListTile(
                  groupValue: id_ate2,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_ate2 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class Atencion3 extends StatefulWidget {
  @override
  Atencion3WidgetState createState() => Atencion3WidgetState();
}

class Atencion3WidgetState extends State<Atencion3> {
  @override
  void initState() {
    id_ate3 = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: dataScreeningQC
            .map((list) => RadioListTile(
                  groupValue: id_ate3,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_ate3 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class Atencion4 extends StatefulWidget {
  @override
  Atencion4WidgetState createState() => Atencion4WidgetState();
}

class Atencion4WidgetState extends State<Atencion4> {
  @override
  void initState() {
    id_ate4 = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: dataScreeningQC
            .map((list) => RadioListTile(
                  groupValue: id_ate4,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_ate4 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//--------------------------------------------------------------------------------------------
////----------------------------------------ORIENTACION ------------------------------------------------------------------------------------------
var id_ori1;
var id_ori2;
var id_ori3;
var id_ori4;

class Orientacion1 extends StatefulWidget {
  @override
  Orientacion1WidgetState createState() => Orientacion1WidgetState();
}

class Orientacion1WidgetState extends State<Orientacion1> {
  @override
  void initState() {
    id_ori1 = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: dataScreeningQC
            .map((list) => RadioListTile(
                  groupValue: id_ori1,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_ori1 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class Orientacion2 extends StatefulWidget {
  @override
  Orientacion2WidgetState createState() => Orientacion2WidgetState();
}

class Orientacion2WidgetState extends State<Orientacion2> {
  @override
  void initState() {
    id_ori2 = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: dataScreeningQC
            .map((list) => RadioListTile(
                  groupValue: id_ori2,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_ori2 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class Orientacion3 extends StatefulWidget {
  @override
  Orientacion3WidgetState createState() => Orientacion3WidgetState();
}

class Orientacion3WidgetState extends State<Orientacion3> {
  @override
  void initState() {
    id_ori3 = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: dataScreeningQC
            .map((list) => RadioListTile(
                  groupValue: id_ori3,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_ori3 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class Orientacion4 extends StatefulWidget {
  @override
  Orientacion4WidgetState createState() => Orientacion4WidgetState();
}

class Orientacion4WidgetState extends State<Orientacion4> {
  @override
  void initState() {
    id_ori4 = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: dataScreeningQC
            .map((list) => RadioListTile(
                  groupValue: id_ori4,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_ori4 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//-----------------------------------------------------------------------------
//
////----------------------------------------ATENCION 1------------------------------------------------------------------------------------------
var id_funejec1;
var id_funejec2;
var id_funejec3;
var id_funejec4;

class FunEjec1 extends StatefulWidget {
  @override
  FunEjec1WidgetState createState() => FunEjec1WidgetState();
}

class FunEjec1WidgetState extends State<FunEjec1> {
  @override
  void initState() {
    id_funejec1 = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: dataScreeningQC
            .map((list) => RadioListTile(
                  groupValue: id_funejec1,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_funejec1 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class FunEjec2 extends StatefulWidget {
  @override
  FunEjec2WidgetState createState() => FunEjec2WidgetState();
}

class FunEjec2WidgetState extends State<FunEjec2> {
  @override
  void initState() {
    id_funejec2 = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: dataScreeningQC
            .map((list) => RadioListTile(
                  groupValue: id_funejec2,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_funejec2 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class FunEjec3 extends StatefulWidget {
  @override
  FunEjec3WidgetState createState() => FunEjec3WidgetState();
}

class FunEjec3WidgetState extends State<FunEjec3> {
  @override
  void initState() {
    id_funejec3 = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: dataScreeningQC
            .map((list) => RadioListTile(
                  groupValue: id_funejec3,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_funejec3 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class FunEjec4 extends StatefulWidget {
  @override
  FunEjec4WidgetState createState() => FunEjec4WidgetState();
}

class FunEjec4WidgetState extends State<FunEjec4> {
  @override
  void initState() {
    id_funejec4 = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: dataScreeningQC
            .map((list) => RadioListTile(
                  groupValue: id_funejec4,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_funejec4 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//-----------------------------------------------------------------
//
////----------------------------------------MEMORIA ------------------------------------------------------------------------------------------
var id_memoria1;
var id_memoria2;
var id_memoria3;
var id_memoria4;

class Memoria1 extends StatefulWidget {
  @override
  Memoria1WidgetState createState() => Memoria1WidgetState();
}

class Memoria1WidgetState extends State<Memoria1> {
  @override
  void initState() {
    id_memoria1 = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: dataScreeningQC
            .map((list) => RadioListTile(
                  groupValue: id_memoria1,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_memoria1 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class Memoria2 extends StatefulWidget {
  @override
  Memoria2WidgetState createState() => Memoria2WidgetState();
}

class Memoria2WidgetState extends State<Memoria2> {
  @override
  void initState() {
    id_memoria2 = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: dataScreeningQC
            .map((list) => RadioListTile(
                  groupValue: id_memoria2,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_memoria2 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class Memoria3 extends StatefulWidget {
  @override
  Memoria3WidgetState createState() => Memoria3WidgetState();
}

class Memoria3WidgetState extends State<Memoria3> {
  @override
  void initState() {
    id_memoria3 = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: dataScreeningQC
            .map((list) => RadioListTile(
                  groupValue: id_memoria3,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_memoria3 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class Memoria4 extends StatefulWidget {
  @override
  Memoria4WidgetState createState() => Memoria4WidgetState();
}

class Memoria4WidgetState extends State<Memoria4> {
  @override
  void initState() {
    id_memoria4 = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: dataScreeningQC
            .map((list) => RadioListTile(
                  groupValue: id_memoria4,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_memoria4 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//-------------------------------------------------------------------------
//////----------------------------------------PraxiaGnosia ------------------------------------------------------------------------------------------
var id_prexgnosia1;
var id_prexgnosia2;
var id_prexgnosia3;
var id_prexgnosia4;

class PraxiaGnosia1 extends StatefulWidget {
  @override
  PraxiaGnosia1WidgetState createState() => PraxiaGnosia1WidgetState();
}

class PraxiaGnosia1WidgetState extends State<PraxiaGnosia1> {
  @override
  void initState() {
    id_prexgnosia1 = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: dataScreeningQC
            .map((list) => RadioListTile(
                  groupValue: id_prexgnosia1,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_prexgnosia1 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class PraxiaGnosia2 extends StatefulWidget {
  @override
  PraxiaGnosia2WidgetState createState() => PraxiaGnosia2WidgetState();
}

class PraxiaGnosia2WidgetState extends State<PraxiaGnosia2> {
  @override
  void initState() {
    id_prexgnosia2 = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: dataScreeningQC
            .map((list) => RadioListTile(
                  groupValue: id_prexgnosia2,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_prexgnosia2 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class PraxiaGnosia3 extends StatefulWidget {
  @override
  PraxiaGnosia3WidgetState createState() => PraxiaGnosia3WidgetState();
}

class PraxiaGnosia3WidgetState extends State<PraxiaGnosia3> {
  @override
  void initState() {
    id_prexgnosia3 = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: dataScreeningQC
            .map((list) => RadioListTile(
                  groupValue: id_prexgnosia3,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_prexgnosia3 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class PraxiaGnosia4 extends StatefulWidget {
  @override
  PraxiaGnosia4WidgetState createState() => PraxiaGnosia4WidgetState();
}

class PraxiaGnosia4WidgetState extends State<PraxiaGnosia4> {
  @override
  void initState() {
    id_prexgnosia4 = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: dataScreeningQC
            .map((list) => RadioListTile(
                  groupValue: id_prexgnosia4,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_prexgnosia4 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//-----------------------------------------------------------------------
//----------------------------------------LENGUAJE------------------------------------------------------------------------------------------
var id_leng1 = null;
var id_leng2 = null;
var id_leng3 = null;
var id_leng4 = null;

class Lenguaje1 extends StatefulWidget {
  @override
  Lenguaje1WidgetState createState() => Lenguaje1WidgetState();
}

class Lenguaje1WidgetState extends State<Lenguaje1> {
  @override
  void initState() {
    id_leng1 = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: dataScreeningQC
            .map((list) => RadioListTile(
                  groupValue: id_leng1,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_leng1 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class Lenguaje2 extends StatefulWidget {
  @override
  Lenguaje2WidgetState createState() => Lenguaje2WidgetState();
}

class Lenguaje2WidgetState extends State<Lenguaje2> {
  @override
  void initState() {
    id_leng2 = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: dataScreeningQC
            .map((list) => RadioListTile(
                  groupValue: id_leng2,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_leng2 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class Lenguaje3 extends StatefulWidget {
  @override
  Lenguaje3WidgetState createState() => Lenguaje3WidgetState();
}

class Lenguaje3WidgetState extends State<Lenguaje3> {
  @override
  void initState() {
    id_leng3 = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: dataScreeningQC
            .map((list) => RadioListTile(
                  groupValue: id_leng3,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_leng3 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class Lenguaje4 extends StatefulWidget {
  @override
  Lenguaje4WidgetState createState() => Lenguaje4WidgetState();
}

class Lenguaje4WidgetState extends State<Lenguaje4> {
  @override
  void initState() {
    id_leng4 = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: dataScreeningQC
            .map((list) => RadioListTile(
                  groupValue: id_leng4,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_leng4 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}
