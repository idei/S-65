import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/opciones_navbar.dart';
import 'env.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ScreeningCDR extends StatefulWidget {
  @override
  _ScreeningCDRState createState() => _ScreeningCDRState();
}

final _formKey_screening_cdr = GlobalKey<_ScreeningCDRState>();
var id_paciente;
var id_medico;
var tipo_screening;
var id_recordatorio;
var email;
var screening_recordatorio;

class _ScreeningCDRState extends State<ScreeningCDR> {
  double _animatedHeight = 0.0;

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
    print(response);
    var jsonDate = json.decode(response.body);
    print(jsonDate);
    tipo_screening = jsonDate;
  }

  @override
  void initState() {
    super.initState();
    _resetChecksNull();
    WidgetsBinding.instance.addPostFrameCallback((_) => _alert_clinicos(
        context,
        "Cuestionario CDR",
        "El CDR es un cuestionario que idealmente debe completaro junto a una persona cercana (usualmente el cónyuge, hijo/a o un cuidador primario) para confirmar las habilidades cognitivas, es decir cómo esta funcionando por ejemplo su memoria y orientación en la vida cotidiana, además de algunos posibles cambios sociales, conductuales y funcionales. "));
  }

  @override
  Widget build(BuildContext context) {
    final _formKey_screening_cdr = GlobalKey<FormState>();

    getStringValuesSF();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/screening', arguments: {
              "select_screening": "CDR",
            });
          },
        ),
        title: Text('Actividades de la vida diaria - CDR',
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
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                  color: Colors.blue[50],
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
                        Container(
                          width: 320,
                          child: Text(
                            'Memoria',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        Divider(height: 5.0, color: Colors.black),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                        ),
                        Memoria(),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  )),
              Card(
                  color: Colors.blue[50],
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
                        Container(
                          width: 320,
                          child: Text(
                            'Juicio y Resolución de Problemas',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        Divider(height: 5.0, color: Colors.black),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                        ),
                        JuicioResoProblema(),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  )),
              Card(
                  color: Colors.blue[50],
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
                        Container(
                          width: 320,
                          child: Text(
                            'Orientación',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        Divider(height: 5.0, color: Colors.black),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                        ),
                        Orientacion(),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  )),
              Card(
                  color: Colors.blue[50],
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
                        Container(
                          width: 320,
                          child: Text(
                            'Vida Social',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        Divider(height: 5.0, color: Colors.black),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                        ),
                        VidaSocial(),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  )),
              Card(
                  color: Colors.blue[50],
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
                        Container(
                          width: 320,
                          child: Text(
                            'Hogar y Aficiones',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        Divider(height: 5.0, color: Colors.black),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                        ),
                        Hogar(),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  )),
              Card(
                  color: Colors.blue[50],
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
                        Container(
                          width: 320,
                          child: Text(
                            'Cuidado Personal',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        Divider(height: 5.0, color: Colors.black),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                        ),
                        CuidadoPersonal(),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  )),
              Padding(
                padding: EdgeInsets.all(8.0),
              ),
              ElevatedButton.icon(
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
              Padding(
                padding: EdgeInsets.all(4.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isLoading = false;
  void _startLoading() async {
    setState(() {
      _isLoading = true;
    });

    await guardar_datos(context);

    setState(() {
      _isLoading = false;
    });
  }

  void choiceAction(String choice) {
    if (choice == Constants.Ajustes) {
      Navigator.pushNamed(context, '/ajustes');
    } else if (choice == Constants.Salir) {
      Navigator.pushNamed(context, '/');
    }
  }
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

loginToast(String toast) {
  return Fluttertoast.showToast(
      msg: toast,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white);
}

List itemsRadioList;
Future<List> getAllRespuesta(var estado) async {
  String URL_base = Env.URL_API;
  var url = URL_base + "/tipo_respuesta_cdr";
  var response = await http.post(url, body: {
    "estado": "${estado}",
  });
  print(response);
  var jsonBody = response.body;
  var jsonDate = json.decode(jsonBody);
  if (response.statusCode == 200) {
    return itemsRadioList = jsonDate['data'];
  } else {
    return null;
  }
}

var data;

guardar_datos(BuildContext context) async {
  if (memoria == null) loginToast("Debe responder los item de memoria");

  if (orientacion == null) loginToast("Debe responder los item de orientacion");

  if (juicio_res_problema == null)
    loginToast("Debe responder los item de juicio y resolucion de problemas");

  if (vida_social == null) loginToast("Debe responder los item de vida social");

  if (hogar == null) loginToast("Debe responder los item de Orientación");

  if (cuid_personal == null) {
    loginToast("Debe responder los item de Cuidado Personal");
  }

  if (memoria != null &&
      orientacion != null &&
      juicio_res_problema != null &&
      vida_social != null &&
      hogar != null &&
      cuid_personal != null) {
    showDialogMessage(context);

    String URL_base = Env.URL_API;
    var url = URL_base + "/respuesta_screening_cdr";
    var response = await http.post(url, body: {
      "id_paciente": id_paciente.toString(),
      "id_medico": id_medico.toString(),
      "id_recordatorio": id_recordatorio.toString(),
      "tipo_screening": tipo_screening.toString(),
      "memoria": memoria,
      "orientacion": orientacion,
      "juicio_res_problema": juicio_res_problema,
      "vida_social": vida_social,
      "hogar": hogar,
      "cuid_personal": cuid_personal,
    });

    var responseDecoder = json.decode(response.body);

    if (response.statusCode == 200) {
      _resetChecksNull();

      if (responseDecoder['data'] == "Alert") {
        _alert_informe(
          context,
          "Para tener en cuenta",
          "Sería bueno que consulte con su médico clínico o neurologo sobre lo informado con respecto a su funcionamiento en la vida cotidiana. Es posible que el especialista le solicite una evaluación cognitiva para explorar màs en detalle su funcionamiento cognitivo y posible impacto sobre su rutina.",
        );
      } else {
        if (screening_recordatorio == true) {
          Navigator.pushNamed(context, '/recordatorio');
        } else {
          Navigator.pushNamed(context, '/screening', arguments: {
            "select_screening": "CDR",
          });
        }
      }
    } else {
      _alertInforme(context, "Error detectado", '${responseDecoder}');
    }
  }
}

_resetChecksNull() {
  memoria = null;
  orientacion = null;
  juicio_res_problema = null;
  vida_social = null;
  hogar = null;
  cuid_personal = null;
}

_alertInforme(context, title, descripcion) async {
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

//----------------------------------------MEMORIA------------------------------------------------------------------------------------------
var memoria;
var orientacion;
var juicio_res_problema;
var vida_social;
var hogar;
var cuid_personal;

class Memoria extends StatefulWidget {
  @override
  MemoriaWidgetState createState() => MemoriaWidgetState();
}

class MemoriaWidgetState extends State<Memoria> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 520,
      // width: 350,
      child: FutureBuilder<List>(
        future: getAllRespuesta("M"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
                physics: NeverScrollableScrollPhysics(),
                children: ListTile.divideTiles(
                    color: Colors.black12,
                    tiles: snapshot.data.map(
                      (data) => RadioListTile(
                        groupValue: memoria,
                        title: Text(data['respuesta']),
                        value: data['id'].toString(),
                        onChanged: (val) {
                          setState(() {
                            debugPrint('VAL = $val');
                            memoria = val;
                          });
                        },
                      ),
                    )));
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class Orientacion extends StatefulWidget {
  @override
  OrientacionWidgetState createState() => OrientacionWidgetState();
}

class OrientacionWidgetState extends State<Orientacion> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      // width: 350,
      child: FutureBuilder<List>(
        future: getAllRespuesta("O"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
                physics: NeverScrollableScrollPhysics(),
                children: ListTile.divideTiles(
                    color: Colors.black12,
                    tiles: snapshot.data.map(
                      (data) => RadioListTile(
                        groupValue: orientacion,
                        title: Text(data['respuesta']),
                        value: data['id'].toString(),
                        onChanged: (val) {
                          setState(() {
                            debugPrint('VAL = $val');
                            orientacion = val;
                          });
                        },
                      ),
                    )));
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
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

_alert_informe(context, title, descripcion) {
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
        onPressed: () {
          if (screening_recordatorio == true) {
            Navigator.pushNamed(context, '/recordatorio');
          } else {
            Navigator.pushNamed(context, '/screening', arguments: {
              "select_screening": "CDR",
            });
          }
        },
        width: 120,
      )
    ],
  ).show();
}

class JuicioResoProblema extends StatefulWidget {
  @override
  JuicioResoProblemaWidgetState createState() =>
      JuicioResoProblemaWidgetState();
}

class JuicioResoProblemaWidgetState extends State<JuicioResoProblema> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 330,
      // width: 350,
      child: FutureBuilder<List>(
        future: getAllRespuesta("Q"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
                physics: NeverScrollableScrollPhysics(),
                children: ListTile.divideTiles(
                    color: Colors.black12,
                    tiles: snapshot.data.map(
                      (data) => RadioListTile(
                        groupValue: juicio_res_problema,
                        title: Text(data['respuesta']),
                        value: data['id'].toString(),
                        onChanged: (val) {
                          setState(() {
                            debugPrint('VAL = $val');
                            juicio_res_problema = val;
                          });
                        },
                      ),
                    )));
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class VidaSocial extends StatefulWidget {
  @override
  VidaSocialWidgetState createState() => VidaSocialWidgetState();
}

class VidaSocialWidgetState extends State<VidaSocial> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380,
      // width: 350,
      child: FutureBuilder<List>(
        future: getAllRespuesta("V"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
                physics: NeverScrollableScrollPhysics(),
                children: ListTile.divideTiles(
                    color: Colors.black12,
                    tiles: snapshot.data.map(
                      (data) => RadioListTile(
                        groupValue: vida_social,
                        title: Text(data['respuesta']),
                        value: data['id'].toString(),
                        onChanged: (val) {
                          setState(() {
                            debugPrint('VAL = $val');
                            vida_social = val;
                          });
                        },
                      ),
                    )));
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class Hogar extends StatefulWidget {
  @override
  HogarWidgetState createState() => HogarWidgetState();
}

class HogarWidgetState extends State<Hogar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      // width: 350,
      child: FutureBuilder<List>(
        future: getAllRespuesta("H"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
                physics: NeverScrollableScrollPhysics(),
                children: ListTile.divideTiles(
                    color: Colors.black12,
                    tiles: snapshot.data.map(
                      (data) => RadioListTile(
                        groupValue: hogar,
                        title: Text(data['respuesta']),
                        value: data['id'].toString(),
                        onChanged: (val) {
                          setState(() {
                            debugPrint('VAL = $val');
                            hogar = val;
                          });
                        },
                      ),
                    )));
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class CuidadoPersonal extends StatefulWidget {
  @override
  CuidadoPersonalWidgetState createState() => CuidadoPersonalWidgetState();
}

class CuidadoPersonalWidgetState extends State<CuidadoPersonal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      // width: 350,
      child: FutureBuilder<List>(
        future: getAllRespuesta("CP"),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
                physics: NeverScrollableScrollPhysics(),
                children: ListTile.divideTiles(
                    color: Colors.black12,
                    tiles: snapshot.data.map(
                      (data) => RadioListTile(
                        groupValue: cuid_personal,
                        title: Text(data['respuesta']),
                        value: data['id'].toString(),
                        onChanged: (val) {
                          setState(() {
                            debugPrint('VAL = $val');
                            cuid_personal = val;
                          });
                        },
                      ),
                    )));
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
