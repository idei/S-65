import 'package:app_salud/widgets/alert_scaffold.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_salud/pages/env.dart';
import 'package:provider/provider.dart';
import '../services/usuario_services.dart';
import '../widgets/alert_informe.dart';

var id_paciente;
var id_medico;
var tipo_screening;
var id_recordatorio;
var email;
var screening_recordatorio;
var usuarioModel;
List itemsRespuestasNutricion = [];
List respuestaNutricional;

class ScreeningNutricional extends StatefulWidget {
  final pageName = 'screening_nutricional';

  @override
  _ScreeningNutricionalState createState() => _ScreeningNutricionalState();
}

class _ScreeningNutricionalState extends State<ScreeningNutricional> {
  final myController = TextEditingController();
  http.Client _client; // Cliente HTTP para realizar las solicitudes

  @override
  void initState() {
    _client = http.Client(); // Inicializar el cliente HTTP
    super.initState();
  }

  @override
  void dispose() {
    _client.close(); // Cerrar el cliente HTTP cuando la página se destruye
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getStringValuesSF();

    return WillPopScope(
      onWillPop: () async {
        // Navegar a la ruta deseada, por ejemplo, la ruta '/inicio':
        Navigator.pushNamed(context, '/screening', arguments: {
          "select_screening": "RNUTRI",
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
                "select_screening": "RNUTRI",
              });
            },
          ),
          title: Text('Riesgo Nutricional',
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
              )),
        ),
        body: FutureBuilder(
            future: getAllRespuestaNutricional(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return FormNutricional();
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

    tipo_screening = jsonDate;
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
                    "Guardando Datos",
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

  Future<bool> getAllRespuestaNutricional() async {
    try {
      await getAllEventosNutricional();

      String URL_base = Env.URL_API;
      var url = URL_base + "/tipo_respuesta_animo";
      var response = await _client.post(url, body: {});

      if (response.statusCode == 200) {
        var jsonDate = json.decode(response.body);
        if (jsonDate['status'] != "Vacio") {
          itemsRespuestasNutricion = jsonDate['data'];
          return true;
        } else {
          return false;
        }
      } else {
        print(
            'Error en la solicitud getAllRespuestaNutricional: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error en la solicitud getAllRespuestaNutricional: $e');
      return false;
    }
  }

  Future<List> getAllEventosNutricional() async {
    try {
      String URL_base = Env.URL_API;
      var url = URL_base + "/tipo_eventos_nutricional";
      var response = await _client.post(url, body: {});

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        return respuestaNutricional = jsonData['data'];
      } else {
        print(
            'Error en la solicitud getAllEventosNutricional: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error en la solicitud getAllEventosNutricional: $e');
      return null;
    }
  }
}

//----------------------------------------Screening de Sintomas ------------------------------------------

class FormNutricional extends StatefulWidget {
  FormNutricional({Key key}) : super(key: key);

  @override
  State<FormNutricional> createState() => _FormNutricionalState();
}

class _FormNutricionalState extends State<FormNutricional> {
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
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Nutri1(),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),

            Nutri2(),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),

            Nutri3(),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),

            Nutri4(),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),

            Nutri5(),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),

            Nutri6(),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),

            Nutri7(),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),

            Nutri8(),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),

            // Nutri81(),
            // Padding(
            //   padding: EdgeInsets.all(8.0),
            // ),
            //
            Nutri9(),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),

            // Nutri91(),
            // Padding(
            //   padding: EdgeInsets.all(8.0),
            // ),
            //
            Nutri10(),
            Divider(height: 10.0, color: Colors.black),
            Padding(
              padding: EdgeInsets.all(15.0),
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
            SizedBox(
              width: 10,
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

    await guardarDatos();

    setState(() {
      _isLoading = false;
    });
  }

  guardarDatos() async {
    List<dynamic> ids_nutricional = [
      id_nutri1,
      id_nutri2,
      id_nutri3,
      id_nutri4,
      id_nutri5,
      id_nutri6,
      id_nutri7,
      id_nutri8,
      //id_nutri81,
      id_nutri9,
      //id_nutri91,
      id_nutri10,
    ];

    for (var variable in ids_nutricional) {
      if (variable == null) {
        alert_informe_scaffold(
            context, "Debe responder todas las preguntas", 2);
        return; // Salir de la función
      }
    }

    String URL_base = Env.URL_API;
    var url = URL_base + "/respuesta_screening_nutricional";
    var response = await _client.post(url, body: {
      "id_paciente": id_paciente.toString(),
      "id_medico": id_medico.toString(),
      "id_recordatorio": id_recordatorio.toString(),
      "tipo_screening": tipo_screening['data'].toString(),
      "nutri1": id_nutri1.toString(),
      "nutri2": id_nutri2.toString(),
      "nutri3": id_nutri3.toString(),
      "nutri4": id_nutri4.toString(),
      "nutri5": id_nutri5.toString(),
      "nutri6": id_nutri6.toString(),
      "nutri7": id_nutri7.toString(),
      "nutri8": id_nutri8.toString(),
      //"nutri81": id_nutri81.toString(),
      "nutri9": id_nutri9.toString(),
      //"nutri91": id_nutri91.toString(),
      "nutri10": id_nutri10.toString(),
      "cod_event_nutri1": cod_event_nutri1,
      "cod_event_nutri2": cod_event_nutri2,
      "cod_event_nutri3": cod_event_nutri3,
      "cod_event_nutri4": cod_event_nutri4,
      "cod_event_nutri5": cod_event_nutri5,
      "cod_event_nutri6": cod_event_nutri6,
      "cod_event_nutri7": cod_event_nutri7,
      "cod_event_nutri8": cod_event_nutri8,
      "cod_event_nutri81": cod_event_nutri81,
      "cod_event_nutri9": cod_event_nutri9,
      "cod_event_nutri91": cod_event_nutri91,
      "cod_event_nutri10": cod_event_nutri10,
    });

    var responseDecode = json.decode(response.body);

    if (responseDecode != "Vacio") {
      showCustomAlert(
          context, "Para tener en cuenta", responseDecode['data'], true, () {
        if (screening_recordatorio == true) {
          Navigator.pushNamed(context, '/recordatorio');
        } else {
          Navigator.pushNamed(context, '/screening', arguments: {
            "select_screening": "RNUTRI",
          });
        }
      });
    } else {
      if (screening_recordatorio == true) {
        Navigator.pushNamed(context, '/recordatorio');
      } else {
        Navigator.pushNamed(context, '/screening', arguments: {
          "select_screening": "RNUTRI",
        });
      }
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

//----------------------------------------VARIABLES CHECKBOX -----------------------------------------------

String cod_event_nutri1 = 'NUTRI1';
String cod_event_nutri2 = 'NUTRI2';
String cod_event_nutri3 = 'NUTRI3';
String cod_event_nutri4 = 'NUTRI4';
String cod_event_nutri5 = 'NUTRI5';
String cod_event_nutri6 = 'NUTRI6';
String cod_event_nutri7 = 'NUTRI7';
String cod_event_nutri8 = 'NUTRI8';
String cod_event_nutri81 = 'NUTRI81';
String cod_event_nutri9 = 'NUTRI9';
String cod_event_nutri91 = 'NUTRI91';
String cod_event_nutri10 = 'NUTRI10';

//-------------------------------------- NUTRICIONAL 1 -----------------------------------------------------

class Nutri1 extends StatefulWidget {
  @override
  CheckNutri1WidgetState createState() => CheckNutri1WidgetState();
}

class CheckNutri1WidgetState extends State<Nutri1> {
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
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                respuestaNutricional[0]["nombre_evento"],
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
            Nutri1Opcion()
          ],
        ),
      ),
    );
  }
}

// Nutri1Opcion *******************

var id_nutri1;

class Nutri1Opcion extends StatefulWidget {
  @override
  Nutri1OpcionWidgetState createState() => Nutri1OpcionWidgetState();
}

class Nutri1OpcionWidgetState extends State<Nutri1Opcion> {
  @override
  void initState() {
    id_nutri1 = null;
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
        children: itemsRespuestasNutricion
            .map((list) => RadioListTile(
                  groupValue: id_nutri1,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_nutri1 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//-----------------------------------------------------------------------------------------------------------

// --------------------------------- NUTRI 2 ----------------------------------------------------

class Nutri2 extends StatefulWidget {
  @override
  CheckNutri2WidgetState createState() => CheckNutri2WidgetState();
}

class CheckNutri2WidgetState extends State<Nutri2> {
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
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                respuestaNutricional[1]["nombre_evento"],
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
            Nutri2Opcion()
          ],
        ),
      ),
    );
  }
}

// Nutri2Opcion *******************

var id_nutri2;

class Nutri2Opcion extends StatefulWidget {
  @override
  Nutri2OpcionWidgetState createState() => Nutri2OpcionWidgetState();
}

class Nutri2OpcionWidgetState extends State<Nutri2Opcion> {
  @override
  void initState() {
    id_nutri2 = null;
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
        children: itemsRespuestasNutricion
            .map((list) => RadioListTile(
                  groupValue: id_nutri2,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_nutri2 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//-------------------------------------------NUTRI 3--------------------------------------------

class Nutri3 extends StatefulWidget {
  @override
  CheckNutri3WidgetState createState() => CheckNutri3WidgetState();
}

class CheckNutri3WidgetState extends State<Nutri3> {
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
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                respuestaNutricional[2]["nombre_evento"],
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
            Nutri3Opcion()
          ],
        ),
      ),
    );
  }
}

// Nutri3Opcion *******************

var id_nutri3;

class Nutri3Opcion extends StatefulWidget {
  @override
  Nutri3OpcionWidgetState createState() => Nutri3OpcionWidgetState();
}

class Nutri3OpcionWidgetState extends State<Nutri3Opcion> {
  @override
  void initState() {
    id_nutri3 = null;
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
        children: itemsRespuestasNutricion
            .map((list) => RadioListTile(
                  groupValue: id_nutri3,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_nutri3 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//------------------------------------------ NUTRI 4 -------------------------------------------

class Nutri4 extends StatefulWidget {
  @override
  CheckNutri4WidgetState createState() => CheckNutri4WidgetState();
}

class CheckNutri4WidgetState extends State<Nutri4> {
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
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                respuestaNutricional[3]["nombre_evento"],
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
            Nutri4Opcion()
          ],
        ),
      ),
    );
  }
}

// Nutri4Opcion *******************

var id_nutri4;

class Nutri4Opcion extends StatefulWidget {
  @override
  Nutri4OpcionWidgetState createState() => Nutri4OpcionWidgetState();
}

class Nutri4OpcionWidgetState extends State<Nutri4Opcion> {
  @override
  void initState() {
    id_nutri4 = null;
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
        children: itemsRespuestasNutricion
            .map((list) => RadioListTile(
                  groupValue: id_nutri4,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_nutri4 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//------------------------------------------NUTRI 5 ---------------------------------------

class Nutri5 extends StatefulWidget {
  @override
  CheckNutri5WidgetState createState() => CheckNutri5WidgetState();
}

class CheckNutri5WidgetState extends State<Nutri5> {
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
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                respuestaNutricional[4]["nombre_evento"],
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
            Nutri5Opcion()
          ],
        ),
      ),
    );
  }
}

// Nutri5Opcion *******************

var id_nutri5;

class Nutri5Opcion extends StatefulWidget {
  @override
  Nutri5OpcionWidgetState createState() => Nutri5OpcionWidgetState();
}

class Nutri5OpcionWidgetState extends State<Nutri5Opcion> {
  @override
  void initState() {
    id_nutri5 = null;
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
        children: itemsRespuestasNutricion
            .map((list) => RadioListTile(
                  groupValue: id_nutri5,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_nutri5 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

// ----------------------------------------NUTRI 6---------------------------------------

class Nutri6 extends StatefulWidget {
  @override
  CheckNutri6WidgetState createState() => CheckNutri6WidgetState();
}

class CheckNutri6WidgetState extends State<Nutri6> {
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
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                respuestaNutricional[5]["nombre_evento"],
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
            Nutri6Opcion()
          ],
        ),
      ),
    );
  }
}

// Nutri6Opcion *******************

var id_nutri6;

class Nutri6Opcion extends StatefulWidget {
  @override
  Nutri6OpcionWidgetState createState() => Nutri6OpcionWidgetState();
}

class Nutri6OpcionWidgetState extends State<Nutri6Opcion> {
  @override
  void initState() {
    id_nutri6 = null;
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
        children: itemsRespuestasNutricion
            .map((list) => RadioListTile(
                  groupValue: id_nutri6,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_nutri6 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

// ---------------------------------------- NUTRI 7 -----------------------------------

class Nutri7 extends StatefulWidget {
  @override
  CheckNutri7WidgetState createState() => CheckNutri7WidgetState();
}

class CheckNutri7WidgetState extends State<Nutri7> {
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
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                respuestaNutricional[6]["nombre_evento"],
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
            Nutri7Opcion()
          ],
        ),
      ),
    );
  }
}

// Nutri7Opcion *******************

var id_nutri7;

class Nutri7Opcion extends StatefulWidget {
  @override
  Nutri7OpcionWidgetState createState() => Nutri7OpcionWidgetState();
}

class Nutri7OpcionWidgetState extends State<Nutri7Opcion> {
  @override
  void initState() {
    id_nutri7 = null;
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
        children: itemsRespuestasNutricion
            .map((list) => RadioListTile(
                  groupValue: id_nutri7,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_nutri7 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

// -----------------------------------------NUTRI 8 -----------------------------------------------------

class Nutri8 extends StatefulWidget {
  @override
  CheckNutri8WidgetState createState() => CheckNutri8WidgetState();
}

class CheckNutri8WidgetState extends State<Nutri8> {
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
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                respuestaNutricional[7]["nombre_evento"],
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
            Nutri8Opcion()
          ],
        ),
      ),
    );
  }
}

// Nutri8Opcion *******************

var id_nutri8;

class Nutri8Opcion extends StatefulWidget {
  @override
  Nutri8OpcionWidgetState createState() => Nutri8OpcionWidgetState();
}

class Nutri8OpcionWidgetState extends State<Nutri8Opcion> {
  @override
  void initState() {
    id_nutri8 = null;
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
        children: itemsRespuestasNutricion
            .map((list) => RadioListTile(
                  groupValue: id_nutri8,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_nutri8 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

// -----------------------------------------NUTRI 8.1 -----------------------------------------------------

class Nutri81 extends StatefulWidget {
  @override
  CheckNutri81WidgetState createState() => CheckNutri81WidgetState();
}

class CheckNutri81WidgetState extends State<Nutri81> {
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
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                respuestaNutricional[0]["nombre_evento"],
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
            Nutri81Opcion()
          ],
        ),
      ),
    );
  }
}

// Nutri81Opcion *******************

var id_nutri81;

class Nutri81Opcion extends StatefulWidget {
  @override
  Nutri81OpcionWidgetState createState() => Nutri81OpcionWidgetState();
}

class Nutri81OpcionWidgetState extends State<Nutri81Opcion> {
  @override
  void initState() {
    id_nutri81 = null;
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
        children: itemsRespuestasNutricion
            .map((list) => RadioListTile(
                  groupValue: id_nutri81,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_nutri81 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//-------------------------------------------- NUTRI 9 -----------------------------------------------------------

class Nutri9 extends StatefulWidget {
  @override
  CheckNutri9WidgetState createState() => CheckNutri9WidgetState();
}

class CheckNutri9WidgetState extends State<Nutri9> {
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
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                respuestaNutricional[8]["nombre_evento"],
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
            Nutri9Opcion()
          ],
        ),
      ),
    );
  }
}

// Nutri9Opcion *******************

var id_nutri9;

class Nutri9Opcion extends StatefulWidget {
  @override
  Nutri9OpcionWidgetState createState() => Nutri9OpcionWidgetState();
}

class Nutri9OpcionWidgetState extends State<Nutri9Opcion> {
  @override
  void initState() {
    id_nutri9 = null;
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
        children: itemsRespuestasNutricion
            .map((list) => RadioListTile(
                  groupValue: id_nutri9,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_nutri9 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//-------------------------------------------- NUTRI 9.1 -----------------------------------------------------------

class Nutri91 extends StatefulWidget {
  @override
  CheckNutri91WidgetState createState() => CheckNutri91WidgetState();
}

class CheckNutri91WidgetState extends State<Nutri91> {
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
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                respuestaNutricional[0]["nombre_evento"],
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
            Nutri91Opcion()
          ],
        ),
      ),
    );
  }
}

// Nutri91Opcion *******************

var id_nutri91;

class Nutri91Opcion extends StatefulWidget {
  @override
  Nutri91OpcionWidgetState createState() => Nutri91OpcionWidgetState();
}

class Nutri91OpcionWidgetState extends State<Nutri91Opcion> {
  @override
  void initState() {
    id_nutri91 = null;
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
        children: itemsRespuestasNutricion
            .map((list) => RadioListTile(
                  groupValue: id_nutri91,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_nutri91 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

// -------------------------------------------NUTRI 10 --------------------------------------------

class Nutri10 extends StatefulWidget {
  @override
  CheckNutri10WidgetState createState() => CheckNutri10WidgetState();
}

class CheckNutri10WidgetState extends State<Nutri10> {
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
            Container(
              padding: EdgeInsets.all(25),
              child: Text(
                respuestaNutricional[9]["nombre_evento"],
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
            Nutri10Opcion()
          ],
        ),
      ),
    );
  }
}

// Nutri10Opcion *******************

var id_nutri10;

class Nutri10Opcion extends StatefulWidget {
  @override
  Nutri10OpcionWidgetState createState() => Nutri10OpcionWidgetState();
}

class Nutri10OpcionWidgetState extends State<Nutri10Opcion> {
  @override
  void initState() {
    id_nutri10 = null;
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
        children: itemsRespuestasNutricion
            .map((list) => RadioListTile(
                  groupValue: id_nutri10,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_nutri10 = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}
