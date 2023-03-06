import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'env.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

String email;

class FormDatosClinicos extends StatefulWidget {
  final pageName = '/form_datos_clinicos';

  @override
  _FormDatosClinicosState createState() => _FormDatosClinicosState();
}

class _FormDatosClinicosState extends State<FormDatosClinicos> {
  List dataRespuestas;

  getAllRespuesta() async {
    // String URL_base = Env.URL_API;
    String URL_base = Env.URL_API;
    var url = URL_base + "/respuesta_datos_clinicos";
    var response = await http.post(url, body: {});
    print(response);
    var jsonBody = response.body;
    var jsonDate = json.decode(jsonBody);
    if (this.mounted) {
      setState(() {
        dataRespuestas = jsonDate;
      });
    }
    print(jsonDate);
  }

  @override
  void setState(VoidCallback fn) {
    getStringValuesSF();
  }

  @override
  void initState() {
    super.initState();
    getAllRespuesta();
    getStringValuesSF();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey_datos_clinicos = GlobalKey<FormState>();

    void choiceAction(String choice) {
      if (choice == Constants.Ajustes) {
        Navigator.pushNamed(context, '/ajustes');
      } else if (choice == Constants.Salir) {
        Navigator.pushNamed(context, '/');
      }
    }

    Map parametros = ModalRoute.of(context).settings.arguments;
    if (parametros != null) {
      email_prefer = parametros['email'];
    } else {
      getStringValuesSF();
    }

    return Scaffold(
        appBar: AppBar(
          //backgroundColor: Color.fromRGBO(157, 19, 34, 1),
          title: Text('Datos Clínicos',
              style: TextStyle(
                  fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
                  fontWeight: FontWeight.bold)),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.help_outline),
              tooltip: 'Show Snackbar',
              onPressed: () {},
            ),
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
        body: Form(
          key: _formKey_datos_clinicos,
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: ListView(
              children: <Widget>[
                Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          "Presión Alta ",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: Theme.of(context)
                                .textTheme
                                .headline1
                                .fontFamily,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            icon: Icon(Icons.info_outline),
                            tooltip: 'Más información',
                            color: Colors.blue,
                            onPressed: () {
                              _alert_clinicos(
                                  context,
                                  "Presión Arterial",
                                  "La presión arterial es la fuerza de su sangre al empujar contra las paredes de sus arterias." +
                                      "Cada vez que su corazón late, bombea sangre hacia las arterias. \n\n Recuerde colocar los valores de" +
                                      "presion asi por ejemplo -> 120/80 y no 12/8.",
                                  1);
                            })
                      ],
                    ),
                  ],
                ),
                TextFormField(
                  controller: presion_alta,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(

                      //labelText: 'Presión Alta'
                      hintText: ''),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Por favor complete el campo';
                    }

                    return null;
                  },
                  onChanged: (text) {
                    print("Debe completar el campo");
                  },
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          "Presión Baja ",
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  .fontFamily),
                        ),
                      ],
                    ),
                    /*Column(
                      children: [
                        IconButton(
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            icon: Icon(Icons.info_outline),
                            tooltip: 'Más información',
                            color: Colors.blue,
                            onPressed: () {})
                      ],
                    ),*/
                  ],
                ),
                TextFormField(
                  controller: presion_baja,
                  keyboardType: TextInputType.number,
                  //decoration: InputDecoration(labelText: 'Presión Baja'),
                  decoration: InputDecoration(hintText: ''),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Por favor complete el campo';
                    }
                    return null;
                  },
                  onChanged: (text) {
                    print("Debe completar el campo");
                  },
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Column(
                      children: [
                        Text("Pulso ",
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    .fontFamily)),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            icon: Icon(Icons.info_outline),
                            tooltip: 'Más información',
                            color: Colors.blue,
                            onPressed: () {
                              _alert_clinicos(
                                  context,
                                  "Pulso",
                                  "La frecuencia cardiaca se refiere a cuantas veces tu corazón late por minuto se podria usar como una medida de tu salud cardiovascular.",
                                  1);
                            })
                      ],
                    ),
                  ],
                ),
                TextFormField(
                  controller: pulso,
                  keyboardType: TextInputType.number,
                  //decoration: InputDecoration(labelText: 'Pulso'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Por favor ingrese el pulso';
                    }
                    return null;
                  },
                  onChanged: (text) {
                    print("Debe completar el campo");
                  },
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          "Peso(Kg) ",
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  .fontFamily),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            icon: Icon(Icons.info_outline),
                            tooltip: 'Más información',
                            color: Colors.blue,
                            onPressed: () {
                              _alert_clinicos(
                                  context,
                                  "Peso Corporal",
                                  "El indice de masa corporal (IMC) es un indicador de grasa que hay en el cuerpo." +
                                      "Se calcula a partir de la estatura y el peso, y puede indicar si se tiene peso bajo, normal," +
                                      "sobrepeso u obesidad. Tambien puede ayudar a evaluar el riesgo que hay de tener enfermedades que" +
                                      "ocurren al tener mas grasa corporal." +
                                      "\n\nRecuerde ingresar su peso en KG por ejemplo: 80 KG.",
                                  1);
                            })
                      ],
                    ),
                  ],
                ),
                TextFormField(
                  controller: peso_corporal,
                  keyboardType: TextInputType.number,
                  //decoration: InputDecoration(labelText: 'Peso'),
                  decoration: InputDecoration(hintText: ''),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Por favor ingrese el peso corporal';
                    }
                    return null;
                  },
                  onChanged: (text) {
                    print("Debe completar el campo");
                  },
                  onTap: () {},
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          "Altura (Metros)",
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  .fontFamily),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            icon: Icon(Icons.info_outline),
                            tooltip: 'Más información',
                            color: Colors.blue,
                            onPressed: () {
                              _alert_clinicos(
                                  context,
                                  "Circunferencia de Cintura",
                                  "Recuerde ingresar su altura en metro por ejemplo: 1,70 m y no en cm 170 cm.",
                                  1);
                            })
                      ],
                    ),
                  ],
                ),
                TextFormField(
                  controller: altura,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Por favor ingrese la altura';
                    }
                    return null;
                  },
                  onChanged: (text) {
                    print("Debe completar el campo");
                  },
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          "Circunferencia de Cintura ",
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  .fontFamily),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            icon: Icon(Icons.info_outline),
                            tooltip: 'Más información',
                            color: Colors.blue,
                            onPressed: () {
                              _alert_clinicos(
                                  context,
                                  "Circunferencia de Cintura",
                                  "La circunferencia de la cintura es una medida para evaluar el riesgo de padecimientos relacionados " +
                                      "con la obesidad como la diabetes tipo 2, el colesterol alto, la hipertension y las cardiopatias. " +
                                      "Una manera de controlarlo es mediante alimentacion y  el ejercicio. Para registrarla, coloca una cinta" +
                                      "metrica alrededor de tu cintura a la altura del ombligo. No aguantes la respiracion ni metas el vientre." +
                                      "\n\nRecuerde que la medida ingresada tiene que ser en cm.",
                                  1);
                            })
                      ],
                    ),
                  ],
                ),
                TextFormField(
                  controller: circunfer_cintura,
                  keyboardType: TextInputType.number,
                  //decoration:
                  //  InputDecoration(labelText: 'Circunferencia de Cintura'),
                  onChanged: (text) {
                    print("Debe completar el campo");
                  },
                ),
                SizedBox(height: 20),
                CardGenerico(Consume_Alcohol(), "¿Consume Alcohol?"),
                SizedBox(height: 15),
                CardGenerico(Consume_Tabaco(), "¿Fuma Tabaco?"),
                SizedBox(height: 15),
                CardGenerico(Consume_Marihuana(), "¿Fuma Marihuana?"),
                SizedBox(height: 15),
                CardGenerico(Otras_drogas(), "¿Consume otras drogas?"),
                SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(elevation: 8),
                  onPressed: () {
                    if (_formKey_datos_clinicos.currentState.validate()) {
                      verification(context);
                      if (estado_verification == true) {
                        guardar_datos(context);
                      }
                      loginToast(
                          "se guardaron correctamente sus datos clínicos");
                    }
                  },
                  child: Text(
                    'Guardar Datos Clínicos',
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget CardGenerico(StatefulWidget widget, String pregunta) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: EdgeInsets.all(10),
        elevation: 10,
        child: ClipRRect(
          // Los bordes del contenido del card se cortan usando BorderRadius
          borderRadius: BorderRadius.circular(15),

          // EL widget hijo que será recortado segun la propiedad anterior
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  pregunta,
                  style: new TextStyle(
                      fontSize: 18.0,
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

guardar_datos(BuildContext context) async {
  print(email_prefer);
  String URL_base = Env.URL_API;
  var url = URL_base + "/save_datos_clinicos";
  var response = await http.post(url, body: {
    "presion_alta": presion_alta.text,
    "presion_baja": presion_baja.text,
    "pulso": pulso.text,
    "peso_corporal": peso_corporal.text,
    "talla": altura.text,
    "circunfer_cintura": circunfer_cintura.text,
    "id_alcohol": id_alcohol,
    "id_tabaco": id_tabaco,
    "id_marihuana": id_marihuana,
    "id_otras": id_otras_drogas,
    "id_paciente": id_paciente.toString(),
  });

  var data = json.decode(response.body);

  if (data['estado_users'] == "Success") {
    loginToast("Datos Clínicos Guardados Correctamente");
  } else {
    loginToast(data['estado_users']);
  }

  _alert_clinicos(
      context, "Informacion para tener en cuenta", descri_informe, 2);
}

loginToast(String toast) {
  return Fluttertoast.showToast(
      msg: toast,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white);
}

var pulso_confirm = false;
var cintura_confirm = false;

verification(BuildContext context) async {
  // CONSUME --------------------------------------------------
  if (id_alcohol == null) {
    loginToast("Debe responder si consume alcohol");
  } else {
    if (text_resp_alcohol == "Siempre (casi todos los días)") {
      descri_informe +=
          " Beber demasiado alcohol en una sola ocasión o a lo largo del "
          "tiempo puede ocasionar problemas de salud, como enfermedades hepaticas, problemas digestivos, problemas del corazon,"
          "entre otros. Comenteselo a su médico clínico. ";
    }
  }

  if (id_tabaco == null) {
    loginToast("Debe responder si consume tabaco");
  } else {
    if (text_resp_tabaco == "Siempre (casi todos los días)") {
      descri_informe +=
          "Las personas que fuman cigarrillos tienen muchas más probabilidades de desarrollar ciertas "
          "enfermedades, pero puedes no darte cuenta de la cantidad de problemas de salud diferentes que causa el fumar como cáncer, "
          "problemas del corazon, diabetes, entre otros. Comenteselo a su médico clínico. ";
    }
  }

  if (id_marihuana == null) {
    loginToast("Debe responder si consume marihuana");
  } else {
    if (text_resp_tabaco == "Siempre (casi todos los días)") {
      descri_informe +=
          "\n\nFumar marihuana puede afectarte la memoria y las funciones cognitivas y causar efectos cardiovasculares perjudiciales, como hipertensión arterial."
          " Comenteselo a su médico clínico.  ";
    }
  }

  if (id_otras_drogas == null) {
    loginToast("Debe responder si consume otras drogas");
  }

  // ----------------------------------------------------------------------------------------------------------------------------

  // PRESION
  if (int.parse(presion_baja.text) < 40) {
    loginToast("\n\nLa presion baja no puede ser menor a 40");
  } else {
    if (int.parse(presion_alta.text) > 300) {
      loginToast("\n\nLa presión lata no puede ser mayor a 300");
    }
  }

  if (int.parse(presion_alta.text) > 130 ||
      int.parse(presion_alta.text) < 179) {
    descri_informe +=
        "\n\nSu presion se encuentra un poco elevada. Le sugerimos que consulte con su medico de cabecera o cardiologo.";
  }
  if (int.parse(presion_alta.text) > 180) {
    descri_informe +=
        "\n\nUsted esta en este momento con una Crisis Hipertensiva por lo cual debe consultar a una guardia médica para ser controlado a la brevedad posible.";
  }

  if (int.parse(presion_baja.text) > 110) {
    descri_informe +=
        "\n\nUsted esta en este momento con una Crisis Hipertensiva por lo cual debe consultar a una guardia médica para ser controlado a la brevedad posible.";
  }

  if (int.parse(presion_baja.text) < 90) {
    descri_informe +=
        "\n\nSu presion se encuentra baja, le recomendamos que consulte con su medico de cabecera.";
  }

  //-------------------------------------------------------------------------------------------------------------------------

  //  PULSO
  if (int.parse(pulso.text) < 30 && pulso_confirm == false) {
    pulso_confirm = true;
    var pulso_var = pulso.text;
    _alert_clinicos(context, "Confirmar datos.",
        "Ingresaste $pulso_var lpm ¿Es correcto?", 1);
    return;
  }

  if (int.parse(pulso.text) > 230 && pulso_confirm == false) {
    pulso_confirm = true;
    var pulso_var = pulso.text;
    _alert_clinicos(context, "Confirmar datos.",
        "Ingresaste $pulso_var lpm ¿Es correcto?", 1);
    return;
  }

  if (int.parse(pulso.text) < 60) {
    descri_informe +=
        "\n\nSu frecuencia cardiaca se encuentra baja, le recomendamos que consulte con su medico de cabecera.";
  } else {
    if (int.parse(pulso.text) > 100) {
      descri_informe +=
          "\n\nSu frecuencia cardiaca se encuentra elevada, le recomendamos que consulte con su medico de cabecera.";
    }
  }
  //--------------------------------------------------------------------------------------------------------------------------

  // PESO Y TALLA -----------------------------------------------------------------------------------------------------------
  var IMC;
  IMC = int.parse(peso_corporal.text) / double.parse(altura.text);

  if (IMC < 18.4) {
    descri_informe +=
        "\n\nIMC : Su IMC es de $IMC se encuentra dentro de los valores correspondientes a 'bajo peso'. Seria bueno que consulte a su clínico o a un especialista en  nutrición.";
  } else {
    if (IMC >= 18.4) {
      if (IMC <= 24.9) {
        descri_informe +=
            "\n\nIMC : Su IMC es de $IMC se encuentra dentro de los valores normales o peso saludable.";
      }
    } else {
      if (IMC >= 30) {
        descri_informe +=
            "\n\nIMC : Su IMC es de $IMC se encuentra dentro de los valores correspondientes a 'Obesidad'. Sería bueno que consulte a su clínico o a un especialista en nutrición.";
      }
    }
  }

  // CIRCUNFERENCIA DE LA CINTURA MUJERES

  var circintura;
  circintura = int.parse(circunfer_cintura.text);

  if (int.parse(circunfer_cintura.text) < 30) {
    if (int.parse(circunfer_cintura.text) > 160 && cintura_confirm == false) {
      cintura_confirm = true;
      _alert_clinicos(context, "Confirmar datos",
          "Ingresaste $circintura cm ¿Es correcto? ", 1);
    }
  } else {
    if (int.parse(circunfer_cintura.text) < 80) {
      descri_informe +=
          "\n\nUsted no presenta indicadores de riesgo cardio vascular asociado a la circunferencia de cintura.";
    } else {
      if (int.parse(circunfer_cintura.text) >= 80) {
        if (int.parse(circunfer_cintura.text) <= 88) {
          descri_informe +=
              "\n\nUsted presenta indicadores de riesgo cardio vascular asociado a la circunferencia de cintura.";
        }
      } else {
        if (int.parse(circunfer_cintura.text) > 88) {
          descri_informe +=
              "\n\nUsted presenta indicadores de riesgo cardio vascular asociado a la circunferencia de cintura.";
        }
      }
    }
  }

  // CIRCUNFERENCIA DE LA CINTURA HOMBRES

  if (int.parse(circunfer_cintura.text) < 94) {
    descri_informe +=
        "\n\n Usted no presenta indicadores de riesgo cardio vascular asociado a la circunferencia de cintura.";
  } else {
    if (int.parse(circunfer_cintura.text) >= 94) {
      if (int.parse(circunfer_cintura.text) <= 102) {
        descri_informe +=
            "\n\n Usted presenta indicadores de riesgo cardio vascular asociado a la circunferencia de cintura, deberia consultar con su médico clínico.";
      }
    } else {
      if (int.parse(circunfer_cintura.text) > 102) {
        descri_informe +=
            "\n\n Usted presenta indicadores de riesgo cardio vascular asociado a la circunferencia de cintura, deberia consultar con su médico clínico.";
      }
    }
  }

  estado_verification = true;
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

TextEditingController presion_alta = TextEditingController();
TextEditingController pulso = TextEditingController();
TextEditingController presion_baja = TextEditingController();
TextEditingController circunfer_cintura = TextEditingController();
TextEditingController peso_corporal = TextEditingController();
TextEditingController altura = TextEditingController();

var id_alcohol = null;
String text_resp_alcohol;
var id_tabaco = null;
String text_resp_tabaco;
var id_marihuana = null;
String text_resp_marihuana;
var id_otras_drogas = null;
String text_resp_otras;
bool estado_verification = false;

String email_prefer;
var id_paciente;

getStringValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  email_prefer = prefs.getString("email_prefer");
  id_paciente = prefs.getInt("id_paciente");
  print("email_prefer");
  print(email_prefer);
}

String descri_informe = "";

//----------------------------------------CONSUME ALCOHOL------------------------------------------------------------------------------------------

class Consume_Alcohol extends StatefulWidget {
  @override
  Consume_AlcoholWidgetState createState() => Consume_AlcoholWidgetState();
}

class Consume_AlcoholWidgetState extends State<Consume_Alcohol> {
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
    getAllRespuesta();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      // width: 350,
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
                      debugPrint('VAL = $val');
                      id_alcohol = val;
                      text_resp_alcohol = list['respuesta'];
                      debugPrint(text_resp_alcohol);
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

//------------------------------------- TABACO ----------------------------------------------------------------

class Consume_Tabaco extends StatefulWidget {
  @override
  Consume_TabacoWidgetState createState() => Consume_TabacoWidgetState();
}

class Consume_TabacoWidgetState extends State<Consume_Tabaco> {
  List data = List();

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
    getAllRespuesta();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      // width: 450,
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

class Consume_Marihuana extends StatefulWidget {
  @override
  Consume_MarihuanaWidgetState createState() => Consume_MarihuanaWidgetState();
}

class Consume_MarihuanaWidgetState extends State<Consume_Marihuana> {
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
    return SizedBox(
      height: 230,
      // width: 450,
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
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}
//--------------------------------------OTRAS ------------------------------------------------------------------

class Otras_drogas extends StatefulWidget {
  @override
  Otras_drogasWidgetState createState() => Otras_drogasWidgetState();
}

class Otras_drogasWidgetState extends State<Otras_drogas> {
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
    return SizedBox(
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
