import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../services/usuario_services.dart';
import 'env.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VerDatosClinicos extends StatefulWidget {
  final pageName = '/form_datos_clinicos';

  @override
  _VerDatosClinicosState createState() => _VerDatosClinicosState();
}

class _VerDatosClinicosState extends State<VerDatosClinicos> {
  List dataRespuestas;

  GlobalKey<FormState> _formKey_ver_datos_clinicos = GlobalKey<FormState>();

  //final _presion_alta = TextEditingController();
  var _presion_alta = GlobalKey<FormFieldState<String>>();
  var _presion_baja = GlobalKey<FormFieldState<String>>();

  final _pulso = TextEditingController();
  //final _presion_baja = TextEditingController();
  final _circunfer_cintura = TextEditingController();
  final _peso_corporal = TextEditingController();
  final _altura = TextEditingController();

  var usuarioModel;
  var id_paciente;
  var id_dato_clinico;
  var otras_drogas_text;
  var consume_alcohol_text;
  var fuma_tabaco_text;
  var consume_marihuana_text;

  @override
  void initState() {
    super.initState();
    //getAllRespuesta();
  }

  @override
  void dispose() {
    // _presion_alta.dispose();
    //_presion_baja.dispose();
    _circunfer_cintura.dispose();
    _pulso.dispose();
    _peso_corporal.dispose();
    _altura.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    usuarioModel = Provider.of<UsuarioServices>(context);
    id_paciente = usuarioModel.usuario.paciente.id_paciente;

    Map parametros = ModalRoute.of(context).settings.arguments;
    if (parametros != null) {
      id_dato_clinico = parametros['id_dato_clinico'];
    }

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
              Navigator.pushNamed(context, '/historial_clinico');
            },
          ),
          title: Text('Datos Clínicos',
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
              )),
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: getAllRespuesta(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Map<String, dynamic> datosClinicos = snapshot.data;

                Map<String, String> respuestas_opciones = {
                  "1": "Si",
                  "2": "No",
                  "902": "A veces (una vez al mes)",
                  "903": "Con frecuencia (una vez por semana)",
                  "904": "Siempre (casi todos los días)",
                };

                otras_drogas_text =
                    respuestas_opciones[datosClinicos['otras_drogas']] ??
                        "Desconocido";
                consume_alcohol_text =
                    respuestas_opciones[datosClinicos['consume_alcohol']] ??
                        "Desconocido";
                consume_marihuana_text =
                    respuestas_opciones[datosClinicos['consume_marihuana']] ??
                        "Desconocido";
                fuma_tabaco_text =
                    respuestas_opciones[datosClinicos['fuma_tabaco']] ??
                        "Desconocido";

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Presión Alta : " +
                                      datosClinicos['presion_alta'],
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .fontFamily,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Presión Baja: " +
                                      datosClinicos['presion_baja'],
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .fontFamily),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                    "Pulso (por minuto): " +
                                        datosClinicos['pulso'],
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontFamily: Theme.of(context)
                                            .textTheme
                                            .headline1
                                            .fontFamily)),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Peso(kg): " + datosClinicos['peso'],
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .fontFamily),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Talla / Altura (mts): " +
                                      datosClinicos['talla'],
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .fontFamily),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Circunferencia de Cintura (cm): " +
                                      datosClinicos['circunferencia_cintura'],
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .fontFamily),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Container(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "¿Consume Alcohol?: $consume_alcohol_text.",
                            textAlign: TextAlign
                                .justify, // Alinea el texto y justifica el texto
                            style: TextStyle(
                                fontSize: 17,
                                fontFamily: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    .fontFamily),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "¿Fuma Tabaco?: $fuma_tabaco_text .",
                            style: TextStyle(
                                fontSize: 17,
                                fontFamily: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    .fontFamily),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "¿Fuma Marihuana?: $consume_marihuana_text.",
                            style: TextStyle(
                                fontSize: 17,
                                fontFamily: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    .fontFamily),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  "¿Consume otras drogas?: $otras_drogas_text.",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .fontFamily),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListTile(
                        title: Text(
                      'No tiene dato clínico',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontFamily:
                              Theme.of(context).textTheme.headline1.fontFamily),
                    )),
                  ],
                ));
              }
              return Center(
                child: CircularProgressIndicator(
                  semanticsLabel: "Cargando",
                ),
              );
            },
          ),
        ));
  }

  var datos_clinicos;
  Future getAllRespuesta() async {
    String URL_base = Env.URL_API;
    var url = URL_base + "/read_datos_clinicos_paciente";
    var response = await http.post(url, body: {
      "id_paciente": id_paciente,
      "id_dato_clinico": id_dato_clinico,
    });

    if (response.statusCode == 200) {
      var jsonDate = json.decode(response.body);
      if (jsonDate['status'] == 'Success') {
        datos_clinicos = jsonDate['data'];
        return datos_clinicos;
      } else {
        return null;
      }
    } else {
      throw Exception('Error al obtener JSON');
    }
  }

  Widget CardGenerico(StatefulWidget widget, String pregunta) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: EdgeInsets.all(10),
        elevation: 10,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  pregunta,
                  style: TextStyle(
                      fontSize: 17.0,
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontWeight: FontWeight.bold),
                ),
              ),
              widget,
            ],
          ),
        ));
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

_alert_clinicos(context, title, descripcion, number) async {
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
          if (number == 1) {
            Navigator.pop(context);
          } else {
            Navigator.pushNamed(context, '/datoscli');
            _alert_informe(context, "Datos Clínicos Guardados", 1);
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

String descri_informe = "";

var _opcionSeleccionada;
var id_alcohol;
String text_resp_alcohol;
var id_tabaco;
String text_resp_tabaco;
var id_marihuana;
String text_resp_marihuana;
var id_otras_drogas;
String text_resp_otras;
bool estado_verification = false;
var option_alcohol;

//----------------------------------------CONSUME ALCOHOL------------------------------------------------------------------------------------------
class ConsumeAlcohol extends StatefulWidget {
  @override
  _ConsumeAlcoholState createState() => _ConsumeAlcoholState();
}

class _ConsumeAlcoholState extends State<ConsumeAlcohol> {
  bool _mostrarOpcion = false;

  @override
  void initState() {
    id_alcohol = null;
    _opcionSeleccionada = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: UniqueKey(),
      children: [
        RadioListTile(
          title: Text('Si'),
          value: 1,
          groupValue: _opcionSeleccionada,
          onChanged: (valor) {
            setState(() {
              _opcionSeleccionada = valor;
              _mostrarOpcion = true;
              id_alcohol = valor;
              print(id_alcohol);
            });
          },
        ),
        RadioListTile(
          title: Text('No'),
          value: 2,
          groupValue: _opcionSeleccionada,
          onChanged: (valor) {
            setState(() {
              _opcionSeleccionada = valor;
              _mostrarOpcion = false;
              id_alcohol = valor;
              print(id_alcohol);
            });
          },
        ),
        if (_mostrarOpcion && _opcionSeleccionada != null)
          OpcionConsumeAlcohol()
      ],
    );
  }
}

class OpcionConsumeAlcohol extends StatefulWidget {
  @override
  Consume_AlcoholWidgetState createState() => Consume_AlcoholWidgetState();
}

class Consume_AlcoholWidgetState extends State<OpcionConsumeAlcohol> {
  List data = List();
  var list_view_alcohol;

  getAllRespuesta() async {
    String URL_base = Env.URL_API;
    var url = URL_base + "/respuesta_datos_clinicos";
    var response = await http.post(url, body: {});
    print(response);
    var jsonBody = response.body;
    var jsonDate = json.decode(jsonBody);
    if (this.mounted) {
      setState(() {
        data = jsonDate;
      });
    }
    print(jsonDate);
  }

  @override
  void initState() {
    super.initState();
    //getAllRespuesta();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: UniqueKey(),
      color: Colors.blue[100],
      height: 230,
      child: ListView(
        key: list_view_alcohol,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: data
            .map((list) => RadioListTile(
                  groupValue: id_alcohol,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      id_alcohol = val;
                      print(id_alcohol);
                      text_resp_alcohol = list['respuesta'];
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//------------------------------------- TABACO ----------------------------------------------------------------

class ConsumeTabaco extends StatefulWidget {
  @override
  _ConsumeTabacoState createState() => _ConsumeTabacoState();
}

var _opcionSeleccionadaTabaco;

class _ConsumeTabacoState extends State<ConsumeTabaco> {
  bool _mostrarOpcion = false;

  @override
  void initState() {
    id_tabaco = null;
    _opcionSeleccionadaTabaco = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: UniqueKey(),
      children: [
        RadioListTile(
          title: Text('Si'),
          value: 1,
          groupValue: _opcionSeleccionadaTabaco,
          onChanged: (valor) {
            setState(() {
              _opcionSeleccionadaTabaco = valor;
              _mostrarOpcion = true;
              id_tabaco = valor;
            });
          },
        ),
        RadioListTile(
          title: Text('No'),
          value: 2,
          groupValue: _opcionSeleccionadaTabaco,
          onChanged: (valor) {
            setState(() {
              _opcionSeleccionadaTabaco = valor;
              _mostrarOpcion = false;
              id_tabaco = valor;
            });
          },
        ),
        if (_mostrarOpcion && _opcionSeleccionadaTabaco != null)
          Opcion_Consume_Tabaco()
      ],
    );
  }
}

class Opcion_Consume_Tabaco extends StatefulWidget {
  @override
  Consume_TabacoWidgetState createState() => Consume_TabacoWidgetState();
}

class Consume_TabacoWidgetState extends State<Opcion_Consume_Tabaco> {
  List data = List();

  getAllRespuesta() async {
    String URL_base = Env.URL_API;
    var url = URL_base + "/respuesta_datos_clinicos";
    var response = await http.post(url, body: {});
    var jsonBody = response.body;
    var jsonDate = json.decode(jsonBody);
    if (this.mounted) {
      setState(() {
        data = jsonDate;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getAllRespuesta();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: UniqueKey(),
      color: Colors.blue[100],
      height: 230,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: data
            .map((list) => RadioListTile(
                  groupValue: id_tabaco,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_tabaco = val;
                      text_resp_tabaco = list['respuesta'];
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//--------------------------------------MARIHUANA---------------------------------------------------------------

class ConsumeMarihuana extends StatefulWidget {
  @override
  _ConsumeMarihuanaState createState() => _ConsumeMarihuanaState();
}

var _opcionSeleccionadaMarihuana;

class _ConsumeMarihuanaState extends State<ConsumeMarihuana> {
  bool _mostrarOpcion = false;

  @override
  void initState() {
    id_marihuana = null;
    _opcionSeleccionadaMarihuana = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: UniqueKey(),
      children: [
        RadioListTile(
          title: Text('Si'),
          value: 1,
          groupValue: _opcionSeleccionadaMarihuana,
          onChanged: (valor) {
            setState(() {
              _opcionSeleccionadaMarihuana = valor;
              _mostrarOpcion = true;
              id_marihuana = valor;
            });
          },
        ),
        RadioListTile(
          title: Text('No'),
          value: 2,
          groupValue: _opcionSeleccionadaMarihuana,
          onChanged: (valor) {
            setState(() {
              _opcionSeleccionadaMarihuana = valor;
              _mostrarOpcion = false;
              id_marihuana = valor;
            });
          },
        ),
        if (_mostrarOpcion && _opcionSeleccionadaMarihuana != null)
          Opcion_Consume_Tabaco()
      ],
    );
  }
}

class Opcion_Consume_Marihuana extends StatefulWidget {
  @override
  Consume_MarihuanaWidgetState createState() => Consume_MarihuanaWidgetState();
}

class Consume_MarihuanaWidgetState extends State<Opcion_Consume_Marihuana> {
  List data = List();

  Future getAllRespuesta() async {
    String URL_base = Env.URL_API;
    var url = URL_base + "/respuesta_datos_clinicos";
    var response = await http.post(url, body: {});
    print(response);
    var jsonBody = response.body;
    var jsonDate = json.decode(jsonBody);
    if (this.mounted) {
      setState(() {
        data = jsonDate;
      });
    }
    print(jsonDate);
  }

  @override
  void initState() {
    getAllRespuesta();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: UniqueKey(),
      color: Colors.blue[100],
      height: 230,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: data
            .map((list) => RadioListTile(
                  groupValue: id_marihuana,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      debugPrint('VAL = $val');
                      id_marihuana = val;
                      text_resp_marihuana = list['respuesta'];
                      id_marihuana = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}
//--------------------------------------OTRAS ------------------------------------------------------------------

class ConsumeOtrasDrogas extends StatefulWidget {
  @override
  _ConsumeOtrasDrogasState createState() => _ConsumeOtrasDrogasState();
}

var _opcionSeleccionadaOtrasDrogas;

class _ConsumeOtrasDrogasState extends State<ConsumeOtrasDrogas> {
  bool _mostrarOpcion = false;

  @override
  void initState() {
    id_otras_drogas = null;
    _opcionSeleccionadaOtrasDrogas = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: UniqueKey(),
      children: [
        RadioListTile(
          title: Text('Si'),
          value: 1,
          groupValue: _opcionSeleccionadaOtrasDrogas,
          onChanged: (valor) {
            setState(() {
              _opcionSeleccionadaOtrasDrogas = valor;
              _mostrarOpcion = true;
              id_otras_drogas = valor;
            });
          },
        ),
        RadioListTile(
          title: Text('No'),
          value: 2,
          groupValue: _opcionSeleccionadaOtrasDrogas,
          onChanged: (valor) {
            setState(() {
              _opcionSeleccionadaOtrasDrogas = valor;
              _mostrarOpcion = false;
              id_otras_drogas = valor;
            });
          },
        ),
        if (_mostrarOpcion && _opcionSeleccionadaOtrasDrogas != null)
          OpcionOtrasDrogas()
      ],
    );
  }
}

class OpcionOtrasDrogas extends StatefulWidget {
  @override
  OpcionOtrasDrogasWidgetState createState() => OpcionOtrasDrogasWidgetState();
}

class OpcionOtrasDrogasWidgetState extends State<OpcionOtrasDrogas> {
  List data = List();

  Future getAllRespuesta() async {
    String URL_base = Env.URL_API;
    var url = URL_base + "/respuesta_datos_clinicos";
    var response = await http.post(url, body: {});
    print(response);
    var jsonBody = response.body;
    var jsonDate = json.decode(jsonBody);
    if (this.mounted) {
      setState(() {
        data = jsonDate;
      });
    }
  }

  @override
  void initState() {
    getAllRespuesta();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: UniqueKey(),
      color: Colors.blue[100],
      height: 230,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: data
            .map((list) => RadioListTile(
                  groupValue: id_otras_drogas,
                  title: Text(list['respuesta']),
                  value: list['id'].toString(),
                  onChanged: (val) {
                    setState(() {
                      id_otras_drogas = val;
                      text_resp_otras = list['respuesta'];
                    });
                  },
                ))
            .toList(),
      ),
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
