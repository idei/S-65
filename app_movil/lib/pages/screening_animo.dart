import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../services/usuario_services.dart';
import 'package:app_salud/widgets/alert_informe.dart';
import 'package:app_salud/widgets/alert_scaffold.dart';
import 'env.dart';
import 'ajustes.dart';

var id_paciente;
var id_medico;
var tipo_screening;
var id_recordatorio;
var screening_recordatorio;
var email;
List eventoAnimo;
var usuarioModel;
List itemsRespuestasAnimo = [];

class FormScreeningAnimo extends StatefulWidget {
  @override
  _FormScreeningAnimoState createState() => _FormScreeningAnimoState();
}

class _FormScreeningAnimoState extends State<FormScreeningAnimo> {
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => showCustomAlert(
          context,
          "Chequeo de Ánimo",
          "Este chequeo valora cómo está su ánimo actualmente . Por favor responda sinceramente a cada una de las preguntas.  ",
          true,
          () => Navigator.pop(context),
        ));
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
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
    print(response);
    var jsonDate = json.decode(response.body);
    print(jsonDate);
    tipo_screening = jsonDate;
  }

  @override
  Widget build(BuildContext context) {
    getStringValuesSF();

    return WillPopScope(
      onWillPop: () async {
        // Navegar a la ruta deseada, por ejemplo, la ruta '/inicio':
        Navigator.pushNamed(context, '/screening', arguments: {
          "select_screening": "ÁNIMO",
        });
        // Devuelve 'true' para permitir la navegación hacia atrás.
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
              Navigator.pushReplacementNamed(context, '/screening', arguments: {
                "select_screening": "ÁNIMO",
              });
            },
          ),
          title: Text('Chequeo de Ánimo',
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              )),
        ),
        body: FutureBuilder(
            future: getAllRespuesta(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              print(snapshot.connectionState);
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    semanticsLabel: "Cargando",
                  ),
                );
              } else {
                return ScreeningAnimo();
              }
            }),
      ),
    );
  }
}

class ScreeningAnimo extends StatefulWidget {
  ScreeningAnimo({Key key}) : super(key: key);

  @override
  ScreeningAnimoWidgetState createState() => ScreeningAnimoWidgetState();
}

class ScreeningAnimoWidgetState extends State<ScreeningAnimo> {
  final _formKey_screening_animo = GlobalKey<FormState>();

  //----------------------------------------VARIABLES CHECKBOX -----------------------------------------------

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
            ),
            SatisfechoVida(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Abandonado(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            VidaVacia(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Aburrida(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Humor(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Temor(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Feliz(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Desamparado(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Prefiere(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Memoria(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            EstarVivo(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Inutil(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Energia(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            Situacion(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
            MejorUsted(),
            Padding(
              padding: EdgeInsets.all(5.0),
            ),
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
          ],
        ),
      ),
    );
  }

  var responseDecoder;

  guardar_datos(context) async {
    List<dynamic> ids_animo = [
      id_satisfecho,
      id_abandonado,
      id_aburrida,
      id_desamparado,
      id_energia,
      id_estar_vivo,
      id_feliz,
      id_humor,
      id_inutil,
      id_mejor_usted,
      id_memoria,
      id_prefiere,
      id_situacion,
      id_temor,
      id_vida_vacia,
    ];

    for (var variable in ids_animo) {
      if (variable == null) {
        alert_informe_scaffold(
            context, "Debe responder todas las preguntas", 2);
        _isLoading = false;
        return; // Salir de la función
      }
    }

    String URL_base = Env.URL_API;
    var url = URL_base + "/respuesta_screening_animo";
    var response = await http.post(url, body: {
      "id_paciente": id_paciente.toString(),
      "id_medico": id_medico.toString(),
      "id_recordatorio": id_recordatorio.toString(),
      "tipo_screening": tipo_screening["data"].toString(),
      "satisfecho": id_satisfecho.toString(),
      "abandonado": id_abandonado.toString(),
      "vacia": id_vida_vacia.toString(),
      "aburrida": id_aburrida.toString(),
      "humor": id_humor.toString(),
      "temor": id_temor.toString(),
      "feliz": id_feliz.toString(),
      "desamparado": id_desamparado.toString(),
      "prefiere": id_prefiere.toString(),
      "memoria": id_memoria.toString(),
      "estar_vivo": id_estar_vivo.toString(),
      "inutil": id_inutil.toString(),
      "energia": id_energia.toString(),
      "situacion": id_situacion.toString(),
      "situacion_mejor": id_mejor_usted.toString(),
      "cod_event_satisfecho": cod_event_satisfecho,
      "cod_event_abandonado": cod_event_abandonado,
      "cod_event_vacia": cod_event_vacia,
      "cod_event_aburrida": cod_event_aburrida,
      "cod_event_humor": cod_event_humor,
      "cod_event_temor": cod_event_temor,
      "cod_event_feliz": cod_event_feliz,
      "cod_event_desamparado": cod_event_desamparado,
      "cod_event_prefiere": cod_event_prefiere,
      "cod_event_memoria": cod_event_memoria,
      "cod_event_estar_vivo": cod_event_estar_vivo,
      "cod_event_inutil": cod_event_inutil,
      "cod_event_energia": cod_event_energia,
      "cod_event_situacion": cod_event_situacion,
      "cod_event_situacion_mejor": cod_event_situacion_mejor,
    });

    if (response.statusCode == 200) {
      responseDecoder = json.decode(response.body);

      if (responseDecoder['status'] == "Success") {
        if (int.parse(responseDecoder['data']) >= 9) {
          _alert_informe(
            context,
            "Para tener en cuenta",
            "Usted tiene algunos síntomas del estado del ánimo de los cuales ocuparse, le sugerimos que realice una consulta psiquiátrica o que converse sobre estos síntomas con su médico de cabecera. ",
          );
        } else {
          if (int.parse(responseDecoder['data']) < 9) {
            _alert_informe(
              context,
              "Para tener en cuenta",
              "En este momento no presenta sintomatología del estado del ánimo que requiera una consulta con especialista. Sin embargo, le sugerimos seguir controlando su estado de ánimo periódicamente.",
            );
          }
        }
        // if (screening_recordatorio == true) {
        //   Navigator.pushNamed(context, '/recordatorio');
        // } else {
        //   Navigator.pushNamed(context, '/screening', arguments: {
        //     "select_screening": "ÁNIMO",
        //   });
        // }
      }
    } else {
      _alert_informe(
        context,
        "Error al guardar",
        response.body,
      );
    }
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
                "select_screening": "ÁNIMO",
              });
            }
          },
          width: 120,
        )
      ],
    ).show();
  }

  bool _isLoading = false;
  void _startLoading() async {
    setState(() {
      _isLoading = true;
    });

    showDialogMessage();

    await guardar_datos(context);

    setState(() {
      _isLoading = false;
    });
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

Future getAllRespuesta() async {
  await getAllEventosAnimo();

  String URL_base = Env.URL_API;
  var url = URL_base + "/tipo_respuesta_animo";
  var response = await http.post(url, body: {});

  var jsonDate = json.decode(response.body);

  if (response.statusCode == 200 && jsonDate['status'] != "Vacio") {
    //setState(() {
    itemsRespuestasAnimo = jsonDate['data'];
    //});
    return true;
  } else {
    return false;
  }
}

Future<List> getAllEventosAnimo() async {
  var response;

  String URL_base = Env.URL_API;
  var url = URL_base + "/tipo_eventos_animo";

  response = await http.post(url, body: {});

  var jsonData = json.decode(response.body);

  if (response.statusCode == 200) {
    return eventoAnimo = jsonData['data'];
  } else {
    return null;
  }
}

String cod_event_satisfecho = "ANI1";
String cod_event_abandonado = 'ANI2';
String cod_event_vacia = 'ANI3';
String cod_event_aburrida = 'ANI4';
String cod_event_humor = 'ANI5';
String cod_event_temor = 'ANI6';
String cod_event_feliz = 'ANI7';
String cod_event_desamparado = 'ANI8';
String cod_event_prefiere = "ANI9";
String cod_event_memoria = 'ANI10';
String cod_event_estar_vivo = 'ANI11';
String cod_event_inutil = 'ANI12';
String cod_event_energia = 'ANI13';
String cod_event_situacion = 'ANI14';
String cod_event_situacion_mejor = 'ANI15';

//-------------------------------------- ÄNIMO 1 -----------------------------------------------------

class SatisfechoVida extends StatefulWidget {
  @override
  CheckSatisfechoVidaWidgetState createState() =>
      CheckSatisfechoVidaWidgetState();
}

class CheckSatisfechoVidaWidgetState extends State<SatisfechoVida> {
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
                eventoAnimo[0]["nombre_evento"],
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
            Satisfecho()
          ],
        ),
      ),
    );
  }
}

// Satisfecho *******************

var id_satisfecho;

class Satisfecho extends StatefulWidget {
  @override
  SatisfechoWidgetState createState() => SatisfechoWidgetState();
}

class SatisfechoWidgetState extends State<Satisfecho> {
  @override
  void initState() {
    id_satisfecho = null;
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
        children: itemsRespuestasAnimo
            .map((list) => RadioListTile(
                  groupValue: id_satisfecho,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_satisfecho = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//-----------------------------------------------------------------------------------------------------------

// --------------------------------- ANIMO 2 ----------------------------------------------------

class Abandonado extends StatefulWidget {
  @override
  CardAbandonadoWidgetState createState() => CardAbandonadoWidgetState();
}

class CardAbandonadoWidgetState extends State<Abandonado> {
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
                //"¿Está satisfecho con su vida?",
                eventoAnimo[1]["nombre_evento"],
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
            RadioButtonAbandonado()
          ],
        ),
      ),
    );
  }
}

var id_abandonado;

class RadioButtonAbandonado extends StatefulWidget {
  @override
  RadioButtonAbandonadoWidgetState createState() =>
      RadioButtonAbandonadoWidgetState();
}

class RadioButtonAbandonadoWidgetState extends State<RadioButtonAbandonado> {
  @override
  void initState() {
    id_abandonado = null;
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
        children: itemsRespuestasAnimo
            .map((list) => RadioListTile(
                  groupValue: id_abandonado,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_abandonado = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//-------------------------------------------ANIMO 3--------------------------------------------
class VidaVacia extends StatefulWidget {
  @override
  CardVidaVaciaWidgetState createState() => CardVidaVaciaWidgetState();
}

class CardVidaVaciaWidgetState extends State<VidaVacia> {
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
                eventoAnimo[2]["nombre_evento"],
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
            RadioButtonVidaVacia()
          ],
        ),
      ),
    );
  }
}

var id_vida_vacia;

class RadioButtonVidaVacia extends StatefulWidget {
  @override
  RadioButtonVidaVaciaWidgetState createState() =>
      RadioButtonVidaVaciaWidgetState();
}

class RadioButtonVidaVaciaWidgetState extends State<RadioButtonVidaVacia> {
  @override
  void initState() {
    id_vida_vacia = null;
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
        children: itemsRespuestasAnimo
            .map((list) => RadioListTile(
                  groupValue: id_vida_vacia,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_vida_vacia = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//------------------------------------------ ANIMO 4 -------------------------------------------

class Aburrida extends StatefulWidget {
  @override
  CardAburridaWidgetState createState() => CardAburridaWidgetState();
}

class CardAburridaWidgetState extends State<Aburrida> {
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
                eventoAnimo[3]["nombre_evento"],
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
            RadioButtonAburrida()
          ],
        ),
      ),
    );
  }
}

var id_aburrida;

class RadioButtonAburrida extends StatefulWidget {
  @override
  RadioButtonAburridaWidgetState createState() =>
      RadioButtonAburridaWidgetState();
}

class RadioButtonAburridaWidgetState extends State<RadioButtonAburrida> {
  @override
  void initState() {
    id_aburrida = null;
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
        children: itemsRespuestasAnimo
            .map((list) => RadioListTile(
                  groupValue: id_aburrida,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_aburrida = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//------------------------------------------ANIMO 5 ---------------------------------------
class Humor extends StatefulWidget {
  @override
  CardHumorWidgetState createState() => CardHumorWidgetState();
}

class CardHumorWidgetState extends State<Humor> {
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
                eventoAnimo[4]["nombre_evento"],
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
            RadioButtonHumor()
          ],
        ),
      ),
    );
  }
}

var id_humor;

class RadioButtonHumor extends StatefulWidget {
  @override
  RadioButtonHumorWidgetState createState() => RadioButtonHumorWidgetState();
}

class RadioButtonHumorWidgetState extends State<RadioButtonHumor> {
  @override
  void initState() {
    id_humor = null;
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
        children: itemsRespuestasAnimo
            .map((list) => RadioListTile(
                  groupValue: id_humor,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_humor = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

// ----------------------------------------ANIMO 6---------------------------------------

class Temor extends StatefulWidget {
  @override
  CardTemorWidgetState createState() => CardTemorWidgetState();
}

class CardTemorWidgetState extends State<Temor> {
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
                eventoAnimo[5]["nombre_evento"],
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
            RadioButtonTemor()
          ],
        ),
      ),
    );
  }
}

var id_temor;

class RadioButtonTemor extends StatefulWidget {
  @override
  RadioButtonTemorWidgetState createState() => RadioButtonTemorWidgetState();
}

class RadioButtonTemorWidgetState extends State<RadioButtonTemor> {
  @override
  void initState() {
    id_temor = null;
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
        children: itemsRespuestasAnimo
            .map((list) => RadioListTile(
                  groupValue: id_temor,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_temor = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

// ---------------------------------------- ANIMO 7 -----------------------------------

class Feliz extends StatefulWidget {
  @override
  CardFelizWidgetState createState() => CardFelizWidgetState();
}

class CardFelizWidgetState extends State<Feliz> {
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
                eventoAnimo[6]["nombre_evento"],
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
            RadioButtonFeliz()
          ],
        ),
      ),
    );
  }
}

var id_feliz;

class RadioButtonFeliz extends StatefulWidget {
  @override
  RadioButtonFelizWidgetState createState() => RadioButtonFelizWidgetState();
}

class RadioButtonFelizWidgetState extends State<RadioButtonFeliz> {
  @override
  void initState() {
    id_feliz = null;
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
        children: itemsRespuestasAnimo
            .map((list) => RadioListTile(
                  groupValue: id_feliz,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_feliz = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

// -----------------------------------------ANIMO 8 -----------------------------------------------------

class Desamparado extends StatefulWidget {
  @override
  CardDesamparadoWidgetState createState() => CardDesamparadoWidgetState();
}

class CardDesamparadoWidgetState extends State<Desamparado> {
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
                eventoAnimo[7]["nombre_evento"],
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
            RadioButtonDesamparado()
          ],
        ),
      ),
    );
  }
}

var id_desamparado;

class RadioButtonDesamparado extends StatefulWidget {
  @override
  RadioButtonDesamparadoWidgetState createState() =>
      RadioButtonDesamparadoWidgetState();
}

class RadioButtonDesamparadoWidgetState extends State<RadioButtonDesamparado> {
  @override
  void initState() {
    id_desamparado = null;
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
        children: itemsRespuestasAnimo
            .map((list) => RadioListTile(
                  groupValue: id_desamparado,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_desamparado = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//-------------------------------------------- ANIMO 9 -----------------------------------------------------------

class Prefiere extends StatefulWidget {
  @override
  CardPrefiereWidgetState createState() => CardPrefiereWidgetState();
}

class CardPrefiereWidgetState extends State<Prefiere> {
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
                eventoAnimo[8]["nombre_evento"],
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
            RadioButtonPrefiere()
          ],
        ),
      ),
    );
  }
}

var id_prefiere;

class RadioButtonPrefiere extends StatefulWidget {
  @override
  RadioButtonPrefiereWidgetState createState() =>
      RadioButtonPrefiereWidgetState();
}

class RadioButtonPrefiereWidgetState extends State<RadioButtonPrefiere> {
  @override
  void initState() {
    id_prefiere = null;
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
        children: itemsRespuestasAnimo
            .map((list) => RadioListTile(
                  groupValue: id_prefiere,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_prefiere = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

// -------------------------------------------ANIMO 10 --------------------------------------------

class Memoria extends StatefulWidget {
  @override
  CardMemoriaWidgetState createState() => CardMemoriaWidgetState();
}

class CardMemoriaWidgetState extends State<Memoria> {
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
                eventoAnimo[9]["nombre_evento"],
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
            RadioButtonMemoria()
          ],
        ),
      ),
    );
  }
}

var id_memoria;

class RadioButtonMemoria extends StatefulWidget {
  @override
  RadioButtonMemoriaWidgetState createState() =>
      RadioButtonMemoriaWidgetState();
}

class RadioButtonMemoriaWidgetState extends State<RadioButtonMemoria> {
  @override
  void initState() {
    id_memoria = null;
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
        children: itemsRespuestasAnimo
            .map((list) => RadioListTile(
                  groupValue: id_memoria,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_memoria = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

// ------------------------------------------ANIMO 11 ---------------------------------------------------

class EstarVivo extends StatefulWidget {
  @override
  CardEstarVivoWidgetState createState() => CardEstarVivoWidgetState();
}

class CardEstarVivoWidgetState extends State<EstarVivo> {
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
                eventoAnimo[10]["nombre_evento"],
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
            RadioButtonEstarVivo()
          ],
        ),
      ),
    );
  }
}

var id_estar_vivo;

class RadioButtonEstarVivo extends StatefulWidget {
  @override
  RadioButtonEstarVivoWidgetState createState() =>
      RadioButtonEstarVivoWidgetState();
}

class RadioButtonEstarVivoWidgetState extends State<RadioButtonEstarVivo> {
  @override
  void initState() {
    id_estar_vivo = null;
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
        children: itemsRespuestasAnimo
            .map((list) => RadioListTile(
                  groupValue: id_estar_vivo,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_estar_vivo = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//-------------------------------------------- ANIMO 12---------------------------------------------------

class Inutil extends StatefulWidget {
  @override
  CardInutilWidgetState createState() => CardInutilWidgetState();
}

class CardInutilWidgetState extends State<Inutil> {
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
                eventoAnimo[11]["nombre_evento"],
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
            RadioButtonInutil()
          ],
        ),
      ),
    );
  }
}

var id_inutil;

class RadioButtonInutil extends StatefulWidget {
  @override
  RadioButtonInutilWidgetState createState() => RadioButtonInutilWidgetState();
}

class RadioButtonInutilWidgetState extends State<RadioButtonInutil> {
  @override
  void initState() {
    id_inutil = null;
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
        children: itemsRespuestasAnimo
            .map((list) => RadioListTile(
                  groupValue: id_inutil,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_inutil = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//------------------------------------------ANIMO 13 --------------------------------------------------

class Energia extends StatefulWidget {
  @override
  CardEnergiaWidgetState createState() => CardEnergiaWidgetState();
}

class CardEnergiaWidgetState extends State<Energia> {
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
                eventoAnimo[12]["nombre_evento"],
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
            RadioButtonEnergia()
          ],
        ),
      ),
    );
  }
}

var id_energia;

class RadioButtonEnergia extends StatefulWidget {
  @override
  RadioButtonEnergiaWidgetState createState() =>
      RadioButtonEnergiaWidgetState();
}

class RadioButtonEnergiaWidgetState extends State<RadioButtonEnergia> {
  @override
  void initState() {
    id_energia = null;
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
        children: itemsRespuestasAnimo
            .map((list) => RadioListTile(
                  groupValue: id_energia,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_energia = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//-------------------------------------------- ANIMO 14 -------------------------------------------------

class Situacion extends StatefulWidget {
  @override
  CardSituacionWidgetState createState() => CardSituacionWidgetState();
}

class CardSituacionWidgetState extends State<Situacion> {
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
                eventoAnimo[13]["nombre_evento"],
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
            RadioButtonSituacion()
          ],
        ),
      ),
    );
  }
}

var id_situacion;

class RadioButtonSituacion extends StatefulWidget {
  @override
  RadioButtonSituacionWidgetState createState() =>
      RadioButtonSituacionWidgetState();
}

class RadioButtonSituacionWidgetState extends State<RadioButtonSituacion> {
  @override
  void initState() {
    id_situacion = null;
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
        children: itemsRespuestasAnimo
            .map((list) => RadioListTile(
                  groupValue: id_situacion,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_situacion = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

// --------------------------------------------ANIMO 15 ------------------------------------------------

class MejorUsted extends StatefulWidget {
  @override
  CardMejorUstedWidgetState createState() => CardMejorUstedWidgetState();
}

class CardMejorUstedWidgetState extends State<MejorUsted> {
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
                eventoAnimo[14]["nombre_evento"],
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
            RadioButtonMejorUsted()
          ],
        ),
      ),
    );
  }
}

var id_mejor_usted;

class RadioButtonMejorUsted extends StatefulWidget {
  @override
  RadioButtonMejorUstedWidgetState createState() =>
      RadioButtonMejorUstedWidgetState();
}

class RadioButtonMejorUstedWidgetState extends State<RadioButtonMejorUsted> {
  @override
  void initState() {
    id_mejor_usted = null;
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
        children: itemsRespuestasAnimo
            .map((list) => RadioListTile(
                  groupValue: id_mejor_usted,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_mejor_usted = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}
