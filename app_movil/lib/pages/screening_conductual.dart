import 'package:app_salud/widgets/alert_informe.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:app_salud/pages/env.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../services/usuario_services.dart';

class ScreeningConductualPage extends StatefulWidget {
  @override
  _ScreeningConductualState createState() => _ScreeningConductualState();
}

final _formKey_screening_conductual = GlobalKey<_ScreeningConductualState>();

TextEditingController otro = TextEditingController();

var id_paciente;
var id_medico;
var tipo_screening;
var id_recordatorio;
var observaciones;
var email;
var screening_recordatorio;
List itemsConductual;
List itemsConductualOtro;
bool otroVisible = false;
var usuarioModel;
var _isPaciente = true;

class _ScreeningConductualState extends State<ScreeningConductualPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getStringValuesSF();

    return WillPopScope(
      onWillPop: () async {
        // Navegar a la ruta deseada, por ejemplo, la ruta '/inicio':
        Navigator.pushNamed(context, '/screening', arguments: {
          "select_screening": "CONDUC",
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
              Navigator.pushNamed(context, '/screening', arguments: {
                "select_screening": "CONDUC",
              });
            },
          ),
          title: Text('Chequeo de Conducta',
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
              )),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: FutureBuilder(
                future: getAllRespuesta(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ColumnWidgetConductual();
                  } else {
                    return Container(
                      alignment: Alignment.center,
                      child: _isLoadingIcon(),
                    );
                    // return Container(
                    //     child: Column(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     ListTile(
                    //         title: Text(
                    //       'Error',
                    //       textAlign: TextAlign.center,
                    //       style: TextStyle(
                    //           fontWeight: FontWeight.bold,
                    //           fontFamily: Theme.of(context)
                    //               .textTheme
                    //               .headline1
                    //               .fontFamily),
                    //     )),
                    //   ],
                    // ));
                  }
                }),
          ),
        ),
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

  Future<List> getAllRespuesta({
    bool otro = false,
  }) async {
    var response;
    var responseOtro;

    String URL_base = Env.URL_API;
    var url = URL_base + "/tipo_respuesta_conductual";

    responseOtro = await http.post(url, body: {"otro": "otro"});

    response = await http.post(url, body: {});

    var jsonData = json.decode(response.body);
    var jsonDataOtro = json.decode(responseOtro.body);

    if (response.statusCode == 200 && (responseOtro.statusCode == 200)) {
      itemsConductualOtro = jsonDataOtro['data'];
      return itemsConductual = jsonData['data'];
    } else {
      return null;
    }
  }
}

class _isLoadingIcon extends StatelessWidget {
  const _isLoadingIcon({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 60,
      width: 60,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
      child: const CircularProgressIndicator(color: Colors.blue),
    );
  }
}

class ColumnWidgetConductual extends StatefulWidget {
  const ColumnWidgetConductual({
    Key key,
  }) : super(key: key);

  @override
  State<ColumnWidgetConductual> createState() => _ColumnWidgetConductualState();
}

class _ColumnWidgetConductualState extends State<ColumnWidgetConductual> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) =>
        alert_screenings_generico(context, "Cuestionario Conductual",
            " Tómese su tiempo para responder de la mejor manera "));
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: <
        Widget>[
      if (!_isPaciente)
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(20),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                        '¿Qué parentesco tiene con (nombre del usuario)?',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: Theme.of(context)
                                .textTheme
                                .headline1
                                .fontFamily)),
                  ),
                ),

                Conductual1(),

                // Usamos Container para el contenedor de la descripción
              ],
            ),
          ),
        ),
      Divider(height: 5.0, color: Colors.black),
      Padding(
        padding: EdgeInsets.all(8.0),
      ),
      Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: EdgeInsets.all(20),
        elevation: 10,
        child: ClipRRect(
          // Los bordes del contenido del card se cortan usando BorderRadius
          borderRadius: BorderRadius.circular(15),

          // EL widget hijo que será recortado segun la propiedad anterior
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  '¿Tiene el paciente creencias falsas, como creer que otras personas le están robando o que planean hacerle daño de alguna manera?',
                  style: TextStyle(
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              //espacio entre el texto y el radio button
              SizedBox(
                height: 10,
              ),
              Conductual2(),
            ],
          ),
        ),
      ),
      Divider(height: 5.0, color: Colors.black),
      Padding(
        padding: EdgeInsets.all(8.0),
      ),
      Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(20),
          elevation: 10,
          child: ClipRRect(
            // Los bordes del contenido del card se cortan usando BorderRadius
            borderRadius: BorderRadius.circular(15),

            // EL widget hijo que será recortado segun la propiedad anterior
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    '¿Tiene el paciente alucinaciones como visiones falsas o voces? ¿Actúa el paciente como si oyera o viera cosas que no están presentes?',
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Conductual3(),
              ],
            ),
          )),
      Divider(height: 5.0, color: Colors.black),
      Padding(
        padding: EdgeInsets.all(8.0),
      ),
      Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(20),
          elevation: 10,
          child: ClipRRect(
            // Los bordes del contenido del card se cortan usando BorderRadius
            borderRadius: BorderRadius.circular(15),

            // EL widget hijo que será recortado segun la propiedad anterior
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    '¿Se resiste el paciente a la ayuda de otros o es difícil de manejar?',
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Conductual4(),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          )),
      Divider(height: 5.0, color: Colors.black),
      Padding(
        padding: EdgeInsets.all(8.0),
      ),
      Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(20),
          elevation: 10,
          child: ClipRRect(
            // Los bordes del contenido del card se cortan usando BorderRadius
            borderRadius: BorderRadius.circular(15),

            // EL widget hijo que será recortado segun la propiedad anterior
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    '¿Actúa el paciente como si estuviera triste o dice que está deprimido?',
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Conductual5(),
              ],
            ),
          )),
      Divider(height: 5.0, color: Colors.black),
      Padding(
        padding: EdgeInsets.all(8.0),
      ),
      Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(20),
          elevation: 10,
          child: ClipRRect(
            // Los bordes del contenido del card se cortan usando BorderRadius
            borderRadius: BorderRadius.circular(15),

            // EL widget hijo que será recortado segun la propiedad anterior
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    '¿Se molesta el paciente cuando se separa de usted? ¿Muestra otras señales de nerviosismo, como falta de aire, suspiros, incapacidad de relajarse o se siente excesivamente tenso?',
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Conductual6(),
              ],
            ),
          )),
      Divider(height: 5.0, color: Colors.black),
      Padding(
        padding: EdgeInsets.all(8.0),
      ),
      Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(20),
          elevation: 10,
          child: ClipRRect(
            // Los bordes del contenido del card se cortan usando BorderRadius
            borderRadius: BorderRadius.circular(15),

            // EL widget hijo que será recortado segun la propiedad anterior
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    '¿Parece que el paciente se siente demasiado bien o actúa excesivamente alegre?',
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Conductual7(),
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(20),
          elevation: 10,
          child: ClipRRect(
            // Los bordes del contenido del card se cortan usando BorderRadius
            borderRadius: BorderRadius.circular(15),

            // EL widget hijo que será recortado segun la propiedad anterior
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    '¿Parece el paciente menos interesado en sus actividades habituales o en las actividades y planes de los demás?',
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Conductual8(),
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(20),
          elevation: 10,
          child: ClipRRect(
            // Los bordes del contenido del card se cortan usando BorderRadius
            borderRadius: BorderRadius.circular(15),

            // EL widget hijo que será recortado segun la propiedad anterior
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    '¿Parece que el paciente actúa impulsivamente? Por ejemplo, habla el paciente con extraños como si los conociera o dice cosas que podrían herir los sentimientos de los demás?',
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Conductual9(),
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(20),
          elevation: 10,
          child: ClipRRect(
            // Los bordes del contenido del card se cortan usando BorderRadius
            borderRadius: BorderRadius.circular(15),

            // EL widget hijo que será recortado segun la propiedad anterior
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    '¿Se muestra el paciente irritable o impaciente? ¿Tiene dificultad para lidiar con retrasos o para esperar actividades planeadas?',
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Conductual10(),
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(20),
          elevation: 10,
          child: ClipRRect(
            // Los bordes del contenido del card se cortan usando BorderRadius
            borderRadius: BorderRadius.circular(15),

            // EL widget hijo que será recortado segun la propiedad anterior
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    '¿Lleva a cabo el paciente actividades repetitivas, como dar vueltas por la casa, jugar con botones, enrollar hilos o hacer otras cosas repetitivamente?',
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Conductual11(),
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(20),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    '¿Le despierta el paciente durante la noche, se levanta muy temprano por la mañana o toma siestas excesivas durante el día?',
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Conductual12(),
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(20),
          elevation: 10,
          child: ClipRRect(
            // Los bordes del contenido del card se cortan usando BorderRadius
            borderRadius: BorderRadius.circular(15),

            // EL widget hijo que será recortado segun la propiedad anterior
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    '¿El paciente ha perdido o aumentado de peso o ha tenido algún cambio en la comida que le gusta?',
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Conductual13(),
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
    ]);
  }

  bool _isLoading = false;
  void _startLoading() async {
    setState(() {
      _isLoading = true;
    });

    await guardarDatosConductual(context);

    setState(() {
      _isLoading = false;
    });
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

  guardarDatosConductual(BuildContext context) async {
    if (id_conductual1 == null && _isLoading) {
      id_conductual1 = "";
    }

    List<dynamic> conductuales = [
      id_conductual1,
      id_conductual2,
      id_conductual3,
      id_conductual4,
      id_conductual5,
      id_conductual6,
      id_conductual7,
      id_conductual8,
      id_conductual9,
      id_conductual10,
      id_conductual11,
      id_conductual12,
      id_conductual13,
    ];

    for (var conductual in conductuales) {
      if (conductual == null) {
        loginToast("Debe responder todas las preguntas");
        return; // Salir de la función
      }
    }

    showDialogMessage(context);
    String URL_base = Env.URL_API;
    var url = URL_base + "/respuesta_screening_conductual";
    var response = await http.post(url, body: {
      "id_paciente": id_paciente.toString(),
      "id_medico": id_medico.toString(),
      "id_recordatorio": id_recordatorio.toString(),
      "tipo_screening": tipo_screening['data'].toString(),
      "id_conductual1": id_conductual1,
      "observaciones": otro.text,
      "id_conductual2": id_conductual2,
      "id_conductual3": id_conductual3,
      "id_conductual4": id_conductual4,
      "id_conductual5": id_conductual5,
      "id_conductual6": id_conductual6,
      "id_conductual7": id_conductual7,
      "id_conductual8": id_conductual8,
      "id_conductual9": id_conductual9,
      "id_conductual10": id_conductual10,
      "id_conductual11": id_conductual11,
      "id_conductual12": id_conductual12,
      "id_conductual13": id_conductual13,
    });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['status'] == "Success") {
        if (data['data'] == "alert") {
          _alert_informe(
            context,
            "Para tener en cuenta",
            "Sería bueno que consulte con su médico clínico o neurólogo sobre lo informado con respecto a su funcionamiento en la vida cotidiana. Es posible que el especialista le solicite una evaluación cognitiva para explorar màs en detalle su funcionamiento cognitivo y posible impacto sobre su rutina.",
          );
        } else {
          _alert_informe(
            context,
            "Resultado:",
            "No se presentaron resultados que indiquen algún problema.",
          );
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

//------------***************
class GenericRadioList extends StatefulWidget {
  final List items;
  final String groupValue;
  final void Function(String) onChanged;
  final double heightContainer;

  const GenericRadioList(
      {this.items, this.groupValue, this.onChanged, this.heightContainer});

  @override
  _GenericRadioListState createState() => _GenericRadioListState();
}

class _GenericRadioListState extends State<GenericRadioList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.heightContainer,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: widget.items.map((list) {
          return RadioListTile(
            groupValue: widget.groupValue,
            title: Text(
              list['respuesta'],
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
              ),
            ),
            value: list['id'].toString(),
            onChanged: (val) {
              setState(() {
                widget.onChanged(val);
                if (val == "48") {
                  otroVisible = true;
                } else {
                  otroVisible = false;
                }
              });
            },
          );
        }).toList(),
      ),
    );
  }
}

//----------------------------------------Conductual ------------------------------------------------------------------------------------------
var id_conductual1;
var id_conductual2;
var id_conductual3;
var id_conductual4;

class Conductual1 extends StatefulWidget {
  @override
  Conductual1WidgetState createState() => Conductual1WidgetState();
}

class Conductual1WidgetState extends State<Conductual1> {
  @override
  void initState() {
    id_conductual1 = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GenericRadioList(
          items: itemsConductualOtro,
          groupValue: id_conductual1,
          heightContainer: 190.0,
          onChanged: (val) {
            setState(() {
              debugPrint('VAL = $val');
              id_conductual1 = val;
            });
          },
        ),
        Visibility(
          visible: otroVisible,
          child: Container(
            padding: EdgeInsets.all(20),
            child: TextFormField(
              style: TextStyle(
                  fontFamily: Theme.of(context).textTheme.headline1.fontFamily),
              controller: otro,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(labelText: "Si es otro, especifique"),
            ),
          ),
        ),
      ],
    );
  }
}

class Conductual2 extends StatefulWidget {
  @override
  Conductual2WidgetState createState() => Conductual2WidgetState();
}

class Conductual2WidgetState extends State<Conductual2> {
  @override
  void initState() {
    id_conductual2 = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GenericRadioList(
      items: itemsConductual,
      groupValue: id_conductual2,
      heightContainer: 300.0,
      onChanged: (val) {
        setState(() {
          debugPrint('VAL = $val');
          id_conductual2 = val;
        });
      },
    );
  }
}

class Conductual3 extends StatefulWidget {
  @override
  Conductual3WidgetState createState() => Conductual3WidgetState();
}

class Conductual3WidgetState extends State<Conductual3> {
  @override
  void initState() {
    id_conductual3 = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GenericRadioList(
      items: itemsConductual,
      groupValue: id_conductual3,
      heightContainer: 300.0,
      onChanged: (val) {
        setState(() {
          debugPrint('VAL = $val');
          id_conductual3 = val;
        });
      },
    );
  }
}

class Conductual4 extends StatefulWidget {
  @override
  Conductual4WidgetState createState() => Conductual4WidgetState();
}

class Conductual4WidgetState extends State<Conductual4> {
  @override
  void initState() {
    id_conductual4 = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GenericRadioList(
      items: itemsConductual,
      groupValue: id_conductual4,
      heightContainer: 300.0,
      onChanged: (val) {
        setState(() {
          debugPrint('VAL = $val');
          id_conductual4 = val;
        });
      },
    );
  }
}

//--------------------------------------------------------------------------------------------
////----------------------------------------CONDUCTUAL ------------------------------------------------------------------------------------------
var id_conductual5;
var id_conductual6;
var id_conductual7;
var id_conductual8;

class Conductual5 extends StatefulWidget {
  @override
  Conductual5WidgetState createState() => Conductual5WidgetState();
}

class Conductual5WidgetState extends State<Conductual5> {
  @override
  void initState() {
    id_conductual5 = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GenericRadioList(
      items: itemsConductual,
      groupValue: id_conductual5,
      heightContainer: 300.0,
      onChanged: (val) {
        setState(() {
          debugPrint('VAL = $val');
          id_conductual5 = val;
        });
      },
    );
  }
}

class Conductual6 extends StatefulWidget {
  @override
  Conductual6WidgetState createState() => Conductual6WidgetState();
}

class Conductual6WidgetState extends State<Conductual6> {
  @override
  void initState() {
    id_conductual6 = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GenericRadioList(
      items: itemsConductual,
      groupValue: id_conductual6,
      heightContainer: 300.0,
      onChanged: (val) {
        setState(() {
          debugPrint('VAL = $val');
          id_conductual6 = val;
        });
      },
    );
  }
}

class Conductual7 extends StatefulWidget {
  @override
  Conductual7WidgetState createState() => Conductual7WidgetState();
}

class Conductual7WidgetState extends State<Conductual7> {
  @override
  void initState() {
    id_conductual7 = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GenericRadioList(
      items: itemsConductual,
      groupValue: id_conductual7,
      heightContainer: 300.0,
      onChanged: (val) {
        setState(() {
          debugPrint('VAL = $val');
          id_conductual7 = val;
        });
      },
    );
  }
}

class Conductual8 extends StatefulWidget {
  @override
  Conductual8WidgetState createState() => Conductual8WidgetState();
}

class Conductual8WidgetState extends State<Conductual8> {
  @override
  void initState() {
    id_conductual8 = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GenericRadioList(
      items: itemsConductual,
      groupValue: id_conductual8,
      heightContainer: 300.0,
      onChanged: (val) {
        setState(() {
          debugPrint('VAL = $val');
          id_conductual8 = val;
        });
      },
    );
  }
}

//-----------------------------------------------------------------------------
//
////----------------------------------------ATENCION 1------------------------------------------------------------------------------------------
var id_conductual9;
var id_conductual10;
var id_conductual11;
var id_conductual12;
var id_conductual13;

class Conductual9 extends StatefulWidget {
  @override
  Conductual9WidgetState createState() => Conductual9WidgetState();
}

class Conductual9WidgetState extends State<Conductual9> {
  @override
  void initState() {
    id_conductual9 = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GenericRadioList(
      items: itemsConductual,
      groupValue: id_conductual9,
      heightContainer: 300.0,
      onChanged: (val) {
        setState(() {
          debugPrint('VAL = $val');
          id_conductual9 = val;
        });
      },
    );
  }
}

class Conductual10 extends StatefulWidget {
  @override
  Conductual10WidgetState createState() => Conductual10WidgetState();
}

class Conductual10WidgetState extends State<Conductual10> {
  @override
  void initState() {
    id_conductual10 = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GenericRadioList(
      items: itemsConductual,
      groupValue: id_conductual10,
      heightContainer: 300.0,
      onChanged: (val) {
        setState(() {
          debugPrint('VAL = $val');
          id_conductual10 = val;
        });
      },
    );
  }
}

class Conductual11 extends StatefulWidget {
  @override
  Conductual11WidgetState createState() => Conductual11WidgetState();
}

class Conductual11WidgetState extends State<Conductual11> {
  @override
  void initState() {
    id_conductual11 = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GenericRadioList(
      items: itemsConductual,
      groupValue: id_conductual11,
      heightContainer: 300.0,
      onChanged: (val) {
        setState(() {
          debugPrint('VAL = $val');
          id_conductual11 = val;
        });
      },
    );
  }
}

class Conductual12 extends StatefulWidget {
  @override
  Conductual12WidgetState createState() => Conductual12WidgetState();
}

class Conductual12WidgetState extends State<Conductual12> {
  @override
  void initState() {
    id_conductual12 = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GenericRadioList(
      items: itemsConductual,
      groupValue: id_conductual12,
      heightContainer: 300.0,
      onChanged: (val) {
        setState(() {
          debugPrint('VAL = $val');
          id_conductual12 = val;
        });
      },
    );
  }
}

class Conductual13 extends StatefulWidget {
  @override
  Conductual13WidgetState createState() => Conductual13WidgetState();
}

class Conductual13WidgetState extends State<Conductual13> {
  @override
  void initState() {
    id_conductual13 = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GenericRadioList(
      items: itemsConductual,
      groupValue: id_conductual13,
      heightContainer: 300.0,
      onChanged: (val) {
        setState(() {
          debugPrint('VAL = $val');
          id_conductual13 = val;
        });
      },
    );
  }
}
