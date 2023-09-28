import 'package:app_salud/widgets/LabeledCheckboxGeneric.dart';
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

class ScreeningNutricional extends StatefulWidget {
  final pageName = 'screening_nutricional';

  @override
  _ScreeningNutricionalState createState() => _ScreeningNutricionalState();
}

class _ScreeningNutricionalState extends State<ScreeningNutricional> {
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
}

List respuestaNutricional;

Future<List> getAllRespuestaNutricional() async {
  var response;

  String URL_base = Env.URL_API;
  var url = URL_base + "/tipo_eventos_nutricional";

  response = await http.post(url, body: {});

  var jsonData = json.decode(response.body);

  if (response.statusCode == 200) {
    return respuestaNutricional = jsonData['data'];
  } else {
    return null;
  }
}

//----------------------------------------Screening de Sintomas ------------------------------------------

class FormNutricional extends StatefulWidget {
  FormNutricional({Key key}) : super(key: key);

  @override
  State<FormNutricional> createState() => _FormNutricionalState();
}

class _FormNutricionalState extends State<FormNutricional> {
  //----------------------------------------VARIABLES CHECKBOX -----------------------------------------------
  ValueNotifier<bool> valueNotifierNutri1 = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierNutri2 = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierNutri3 = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierNutri4 = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierNutri5 = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierNutri6 = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierNutri7 = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierNutri8 = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierNutri81 = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierNutri9 = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierNutri91 = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierNutri10 = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Nutri1(valueNotifierNutri1: valueNotifierNutri1),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Divider(height: 5.0, color: Colors.black),
            Nutri2(valueNotifierNutri2: valueNotifierNutri2),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Divider(height: 5.0, color: Colors.black),
            Nutri3(valueNotifierNutri3: valueNotifierNutri3),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Divider(height: 5.0, color: Colors.black),
            Nutri4(valueNotifierNutri4: valueNotifierNutri4),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Divider(height: 5.0, color: Colors.black),
            Nutri5(valueNotifierNutri5: valueNotifierNutri5),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Divider(height: 5.0, color: Colors.black),
            Nutri6(valueNotifierNutri6: valueNotifierNutri6),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Divider(height: 5.0, color: Colors.black),
            Nutri7(valueNotifierNutri7: valueNotifierNutri7),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Divider(height: 5.0, color: Colors.black),
            Nutri8(valueNotifierNutri8: valueNotifierNutri8),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Divider(height: 5.0, color: Colors.black),
            Nutri81(valueNotifierNutri81: valueNotifierNutri81),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Divider(height: 5.0, color: Colors.black),
            Nutri9(valueNotifierNutri9: valueNotifierNutri9),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Divider(height: 5.0, color: Colors.black),
            Nutri91(valueNotifierNutri91: valueNotifierNutri91),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Divider(height: 5.0, color: Colors.black),
            Nutri10(valueNotifierNutri10: valueNotifierNutri10),
            Divider(height: 10.0, color: Colors.black),
            Padding(
              padding: EdgeInsets.all(15.0),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  guardarDatos(context);
                },
                child: Text(
                  'GUARDAR',
                  style: TextStyle(
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  guardarDatos(BuildContext context) async {
    String URL_base = Env.URL_API;
    var url = URL_base + "/respuesta_screening_nutricional";
    var response = await http.post(url, body: {
      "id_paciente": id_paciente.toString(),
      "id_medico": id_medico.toString(),
      "id_recordatorio": id_recordatorio.toString(),
      "tipo_screening": tipo_screening['data'].toString(),
      "nutri1": valueNotifierNutri1.value.toString(),
      "nutri2": valueNotifierNutri2.value.toString(),
      "nutri3": valueNotifierNutri3.value.toString(),
      "nutri4": valueNotifierNutri4.value.toString(),
      "nutri5": valueNotifierNutri5.value.toString(),
      "nutri6": valueNotifierNutri6.value.toString(),
      "nutri7": valueNotifierNutri7.value.toString(),
      "nutri8": valueNotifierNutri8.value.toString(),
      "nutri81": valueNotifierNutri81.value.toString(),
      "nutri9": valueNotifierNutri9.value.toString(),
      "nutri91": valueNotifierNutri91.value.toString(),
      "nutri10": valueNotifierNutri10.value.toString(),
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
      // _alert_informe(
      //   context,
      //   "Para tener en cuenta",
      //   responseDecode['data'],
      // );
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
  ValueNotifier<bool> valueNotifierNutri1;

  Nutri1({this.valueNotifierNutri1});

  @override
  CheckNutri1WidgetState createState() => CheckNutri1WidgetState();
}

class CheckNutri1WidgetState extends State<Nutri1> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: respuestaNutricional[0]["nombre_evento"],
      // '¿Tiene una enfermedad o malestar que le ha hecho cambiar el tipo y/o cantidad de alimento que come?',
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      value: widget.valueNotifierNutri1.value,
      onChanged: (bool newValue) {
        setState(() {
          widget.valueNotifierNutri1.value = newValue;
        });
      },
      textStyle: TextStyle(
        fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      checkboxScale: 1.5,
    );
  }
}

//-----------------------------------------------------------------------------------------------------------

// --------------------------------- NUTRI 2 ----------------------------------------------------

class Nutri2 extends StatefulWidget {
  ValueNotifier<bool> valueNotifierNutri2;

  Nutri2({this.valueNotifierNutri2});

  @override
  CheckNutri2WidgetState createState() => CheckNutri2WidgetState();
}

class CheckNutri2WidgetState extends State<Nutri2> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: respuestaNutricional[1]["nombre_evento"],
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      value: widget.valueNotifierNutri2.value,
      onChanged: (bool newValue) {
        setState(() {
          widget.valueNotifierNutri2.value = newValue;
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

//-------------------------------------------NUTRI 3--------------------------------------------

class Nutri3 extends StatefulWidget {
  ValueNotifier<bool> valueNotifierNutri3;

  Nutri3({this.valueNotifierNutri3});

  @override
  Nutri3WidgetState createState() => Nutri3WidgetState();
}

class Nutri3WidgetState extends State<Nutri3> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: respuestaNutricional[2]["nombre_evento"],
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      value: widget.valueNotifierNutri3.value,
      onChanged: (bool newValue) {
        setState(() {
          widget.valueNotifierNutri3.value = newValue;
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

//------------------------------------------ NUTRI 4 -------------------------------------------

class Nutri4 extends StatefulWidget {
  ValueNotifier<bool> valueNotifierNutri4;

  Nutri4({this.valueNotifierNutri4});

  @override
  Nutri4WidgetState createState() => Nutri4WidgetState();
}

class Nutri4WidgetState extends State<Nutri4> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: respuestaNutricional[3]["nombre_evento"],
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      value: widget.valueNotifierNutri4.value,
      onChanged: (bool newValue) {
        setState(() {
          widget.valueNotifierNutri4.value = newValue;
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

//------------------------------------------NUTRI 5 ---------------------------------------

class Nutri5 extends StatefulWidget {
  ValueNotifier<bool> valueNotifierNutri5;

  Nutri5({this.valueNotifierNutri5});

  @override
  Nutri5WidgetState createState() => Nutri5WidgetState();
}

class Nutri5WidgetState extends State<Nutri5> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: respuestaNutricional[4]["nombre_evento"],
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      value: widget.valueNotifierNutri5.value,
      onChanged: (bool newValue) {
        setState(() {
          widget.valueNotifierNutri5.value = newValue;
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

// ----------------------------------------NUTRI 6---------------------------------------

class Nutri6 extends StatefulWidget {
  ValueNotifier<bool> valueNotifierNutri6;

  Nutri6({this.valueNotifierNutri6});

  @override
  Nutri6WidgetState createState() => Nutri6WidgetState();
}

class Nutri6WidgetState extends State<Nutri6> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: respuestaNutricional[5]["nombre_evento"],
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      value: widget.valueNotifierNutri6.value,
      onChanged: (bool newValue) {
        setState(() {
          widget.valueNotifierNutri6.value = newValue;
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

// ---------------------------------------- NUTRI 7 -----------------------------------

class Nutri7 extends StatefulWidget {
  ValueNotifier<bool> valueNotifierNutri7;

  Nutri7({this.valueNotifierNutri7});

  @override
  Nutri7WidgetState createState() => Nutri7WidgetState();
}

class Nutri7WidgetState extends State<Nutri7> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: respuestaNutricional[6]["nombre_evento"],
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      value: widget.valueNotifierNutri7.value,
      onChanged: (bool newValue) {
        setState(() {
          widget.valueNotifierNutri7.value = newValue;
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

// -----------------------------------------NUTRI 8 -----------------------------------------------------

class Nutri8 extends StatefulWidget {
  ValueNotifier<bool> valueNotifierNutri8;

  Nutri8({this.valueNotifierNutri8});

  @override
  Nutri8WidgetState createState() => Nutri8WidgetState();
}

class Nutri8WidgetState extends State<Nutri8> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: respuestaNutricional[7]["nombre_evento"],
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      value: widget.valueNotifierNutri8.value,
      onChanged: (bool newValue) {
        setState(() {
          widget.valueNotifierNutri8.value = newValue;
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

// -----------------------------------------NUTRI 8.1 -----------------------------------------------------

class Nutri81 extends StatefulWidget {
  ValueNotifier<bool> valueNotifierNutri81;

  Nutri81({this.valueNotifierNutri81});

  @override
  Nutri81WidgetState createState() => Nutri81WidgetState();
}

class Nutri81WidgetState extends State<Nutri81> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: respuestaNutricional[10]["nombre_evento"],
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      value: widget.valueNotifierNutri81.value,
      onChanged: (bool newValue) {
        setState(() {
          widget.valueNotifierNutri81.value = newValue;
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

//-------------------------------------------- NUTRI 9 -----------------------------------------------------------

class Nutri9 extends StatefulWidget {
  ValueNotifier<bool> valueNotifierNutri9;

  Nutri9({this.valueNotifierNutri9});

  @override
  Nutri9WidgetState createState() => Nutri9WidgetState();
}

class Nutri9WidgetState extends State<Nutri9> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: respuestaNutricional[8]["nombre_evento"],
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      value: widget.valueNotifierNutri9.value,
      onChanged: (bool newValue) {
        setState(() {
          widget.valueNotifierNutri9.value = newValue;
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

//-------------------------------------------- NUTRI 9.1 -----------------------------------------------------------

class Nutri91 extends StatefulWidget {
  ValueNotifier<bool> valueNotifierNutri91;

  Nutri91({this.valueNotifierNutri91});

  @override
  Nutri91WidgetState createState() => Nutri91WidgetState();
}

class Nutri91WidgetState extends State<Nutri91> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: respuestaNutricional[11]["nombre_evento"],
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      value: widget.valueNotifierNutri91.value,
      onChanged: (bool newValue) {
        setState(() {
          widget.valueNotifierNutri91.value = newValue;
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

// -------------------------------------------NUTRI 10 --------------------------------------------

class Nutri10 extends StatefulWidget {
  ValueNotifier<bool> valueNotifierNutri10;

  Nutri10({this.valueNotifierNutri10});

  @override
  Nutri10WidgetState createState() => Nutri10WidgetState();
}

class Nutri10WidgetState extends State<Nutri10> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: respuestaNutricional[9]["nombre_evento"],
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      value: widget.valueNotifierNutri10.value,
      onChanged: (bool newValue) {
        setState(() {
          widget.valueNotifierNutri10.value = newValue;
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
