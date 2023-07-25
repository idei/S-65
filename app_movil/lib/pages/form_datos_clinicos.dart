import 'package:app_salud/pages/screening_diabetes.dart';
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

  GlobalKey<FormState> _formKey_datos_clinicos = GlobalKey<FormState>();

  final _presion_alta = TextEditingController();
  final _pulso = TextEditingController();
  final _presion_baja = TextEditingController();
  final _circunfer_cintura = TextEditingController();
  final _peso_corporal = TextEditingController();
  final _altura = TextEditingController();

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
  void dispose() {
    _presion_alta.dispose();
    _presion_baja.dispose();
    _circunfer_cintura.dispose();
    _pulso.dispose();
    _peso_corporal.dispose();
    _altura.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              Navigator.pushNamed(context, '/datoscli');
            },
          ),
          title: Text('Datos Clínicos',
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
              )),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey_datos_clinicos,
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            "Presión Alta ",
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
                    controller: _presion_alta,
                    keyboardType: TextInputType.number,
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
                          Text(
                            "Presión Baja ",
                            style: TextStyle(
                                fontSize: 17,
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
                    controller: _presion_baja,
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
                                  fontSize: 17,
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
                    controller: _pulso,
                    keyboardType: TextInputType.number,
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
                                fontSize: 17,
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
                    controller: _peso_corporal,
                    keyboardType: TextInputType.number,
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
                                fontSize: 17,
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
                    controller: _altura,
                    keyboardType: TextInputType.number,
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
                                fontSize: 17,
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
                    controller: _circunfer_cintura,
                    keyboardType: TextInputType.number,
                    onChanged: (text) {
                      print("Debe completar el campo");
                    },
                  ),
                  SizedBox(height: 20),
                  CardGenerico(ConsumeAlcohol(), "¿Consume Alcohol?"),
                  SizedBox(height: 15),
                  CardGenerico(ConsumeTabaco(), "¿Fuma Tabaco?"),
                  SizedBox(height: 15),
                  CardGenerico(ConsumeMarihuana(), "¿Fuma Marihuana?"),
                  SizedBox(height: 15),
                  CardGenerico(ConsumeOtrasDrogas(), "¿Consume otras drogas?"),
                  SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(elevation: 8),
                    onPressed: () {
                      if (_formKey_datos_clinicos.currentState.validate()) {
                        verification(context);
                        if (estado_verification == true) {
                          guardar_datos();
                        }
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
          ),
        ));
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

  guardar_datos() async {
    String URL_base = Env.URL_API;
    var url = URL_base + "/save_datos_clinicos";
    var response = await http.post(url, body: {
      "presion_alta": _presion_alta.text,
      "presion_baja": _presion_baja.text,
      "pulso": _pulso.text,
      "peso_corporal": _peso_corporal.text,
      "talla": _altura.text,
      "circunfer_cintura": _circunfer_cintura.text,
      "id_alcohol": id_alcohol,
      "id_tabaco": id_tabaco,
      "id_marihuana": id_marihuana,
      "id_otras": id_otras_drogas,
      "id_paciente": id_paciente.toString(),
    });

    var data = json.decode(response.body);

    if (response.statusCode == 200) {
      if (data["status"] == "Success") {
        _alert_clinicos(
            context, "Informacion para tener en cuenta", descri_informe, 2);
      } else {
        loginToast("Error al guardar la información");
      }
    }
  }

  var pulso_confirm = false;
  var cintura_confirm = false;

  verification(BuildContext context) async {
    descri_informe = "";

    // CONSUME --------------------------------------------------
    if (id_alcohol == null && _opcionSeleccionada == 1) {
      loginToast("Debe responder si consume alcohol");
    } else {
      if (text_resp_alcohol == "Siempre (casi todos los días)") {
        descri_informe +=
            " Beber demasiado alcohol en una sola ocasión o a lo largo del "
            "tiempo puede ocasionar problemas de salud, como enfermedades hepaticas, problemas digestivos, problemas del corazon,"
            "entre otros. Comenteselo a su médico clínico. ";
      }
    }

    if (id_tabaco == null && _opcionSeleccionadaTabaco == 1) {
      loginToast("Debe responder si consume tabaco");
    } else {
      if (text_resp_tabaco == "Siempre (casi todos los días)") {
        descri_informe +=
            "Las personas que fuman cigarrillos tienen muchas más probabilidades de desarrollar ciertas "
            "enfermedades, pero puedes no darte cuenta de la cantidad de problemas de salud diferentes que causa el fumar como cáncer, "
            "problemas del corazon, diabetes, entre otros. Comenteselo a su médico clínico. ";
      }
    }

    if (id_marihuana == null && _opcionSeleccionadaMarihuana == 1) {
      loginToast("Debe responder si consume marihuana");
    } else {
      if (text_resp_tabaco == "Siempre (casi todos los días)") {
        descri_informe +=
            "\n\nFumar marihuana puede afectarte la memoria y las funciones cognitivas y causar efectos cardiovasculares perjudiciales, como hipertensión arterial."
            " Comenteselo a su médico clínico.  ";
      }
    }

    if (id_otras_drogas == null && _opcionSeleccionadaOtrasDrogas == 1) {
      loginToast("Debe responder si consume otras drogas");
    }

    // ----------------------------------------------------------------------------------------------------------------------------

    // PRESION
    if (int.parse(_presion_baja.text) < 40) {
      loginToast("\n\nLa presion baja no puede ser menor a 40");
    } else {
      if (int.parse(_presion_alta.text) > 300) {
        loginToast("\n\nLa presión lata no puede ser mayor a 300");
      }
    }

    if (int.parse(_presion_alta.text) > 130 ||
        int.parse(_presion_alta.text) < 179) {
      descri_informe +=
          "\n\nSu presion se encuentra un poco elevada. Le sugerimos que consulte con su medico de cabecera o cardiologo.";
    }
    if (int.parse(_presion_alta.text) > 170) {
      descri_informe +=
          "\n\nUsted esta en este momento con una Crisis Hipertensiva por lo cual debe consultar a una guardia médica para ser controlado a la brevedad posible.";
    }

    if (int.parse(_presion_baja.text) > 110) {
      descri_informe +=
          "\n\nUsted esta en este momento con una Crisis Hipertensiva por lo cual debe consultar a una guardia médica para ser controlado a la brevedad posible.";
    }

    if (int.parse(_presion_baja.text) < 90) {
      descri_informe +=
          "\n\nSu presion se encuentra baja, le recomendamos que consulte con su medico de cabecera.";
    }

    //-------------------------------------------------------------------------------------------------------------------------

    //  PULSO
    if (int.parse(_pulso.text) < 30 && pulso_confirm == false) {
      pulso_confirm = true;
      var pulso_var = _pulso.text;
      _alert_clinicos(context, "Confirmar datos.",
          "Ingresaste $pulso_var lpm ¿Es correcto?", 1);
      return;
    }

    if (int.parse(_pulso.text) > 230 && pulso_confirm == false) {
      pulso_confirm = true;
      var pulso_var = _pulso.text;
      _alert_clinicos(context, "Confirmar datos.",
          "Ingresaste $pulso_var lpm ¿Es correcto?", 1);
      return;
    }

    if (int.parse(_pulso.text) < 60) {
      descri_informe +=
          "\n\nSu frecuencia cardiaca se encuentra baja, le recomendamos que consulte con su medico de cabecera.";
    } else {
      if (int.parse(_pulso.text) > 100) {
        descri_informe +=
            "\n\nSu frecuencia cardiaca se encuentra elevada, le recomendamos que consulte con su medico de cabecera.";
      }
    }
    //--------------------------------------------------------------------------------------------------------------------------

    // PESO Y TALLA -----------------------------------------------------------------------------------------------------------
    var IMC;
    IMC = int.parse(_peso_corporal.text) /
        double.parse(_altura.text) *
        double.parse(_altura.text);

    if (IMC < 17.4) {
      descri_informe +=
          "\n\nIMC : Su IMC es de $IMC se encuentra dentro de los valores correspondientes a 'bajo peso'. Seria bueno que consulte a su clínico o a un especialista en  nutrición.";
    } else {
      if (IMC >= 17.4) {
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
    circintura = int.parse(_circunfer_cintura.text);

    if (int.parse(_circunfer_cintura.text) < 30) {
      if (int.parse(_circunfer_cintura.text) > 160 &&
          cintura_confirm == false) {
        cintura_confirm = true;
        _alert_clinicos(context, "Confirmar datos",
            "Ingresaste $circintura cm ¿Es correcto? ", 1);
      }
    } else {
      if (int.parse(_circunfer_cintura.text) < 80) {
        descri_informe +=
            "\n\nUsted no presenta indicadores de riesgo cardio vascular asociado a la circunferencia de cintura.";
      } else {
        if (int.parse(_circunfer_cintura.text) >= 80) {
          if (int.parse(_circunfer_cintura.text) <= 88) {
            descri_informe +=
                "\n\nUsted presenta indicadores de riesgo cardio vascular asociado a la circunferencia de cintura.";
          }
        } else {
          if (int.parse(_circunfer_cintura.text) > 88) {
            descri_informe +=
                "\n\nUsted presenta indicadores de riesgo cardio vascular asociado a la circunferencia de cintura.";
          }
        }
      }
    }

    // CIRCUNFERENCIA DE LA CINTURA HOMBRES

    if (int.parse(_circunfer_cintura.text) < 94) {
      descri_informe +=
          "\n\n Usted no presenta indicadores de riesgo cardio vascular asociado a la circunferencia de cintura.";
    } else {
      if (int.parse(_circunfer_cintura.text) >= 94) {
        if (int.parse(_circunfer_cintura.text) <= 102) {
          descri_informe +=
              "\n\n Usted presenta indicadores de riesgo cardio vascular asociado a la circunferencia de cintura, deberia consultar con su médico clínico.";
        }
      } else {
        if (int.parse(_circunfer_cintura.text) > 102) {
          descri_informe +=
              "\n\n Usted presenta indicadores de riesgo cardio vascular asociado a la circunferencia de cintura, deberia consultar con su médico clínico.";
        }
      }
    }

    estado_verification = true;
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

var id_alcohol = null;
String text_resp_alcohol;
var id_tabaco = null;
String text_resp_tabaco;
var id_marihuana = null;
String text_resp_marihuana;
var id_otras_drogas = null;
String text_resp_otras;
bool estado_verification = false;
var option_alcohol = null;

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
var _opcionSeleccionada = null;

//----------------------------------------CONSUME ALCOHOL------------------------------------------------------------------------------------------
class ConsumeAlcohol extends StatefulWidget {
  @override
  _ConsumeAlcoholState createState() => _ConsumeAlcoholState();
}

class _ConsumeAlcoholState extends State<ConsumeAlcohol> {
  bool _mostrarOpcion = false;

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
    getAllRespuesta();
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

var _opcionSeleccionadaTabaco = null;

class _ConsumeTabacoState extends State<ConsumeTabaco> {
  bool _mostrarOpcion = false;

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

var _opcionSeleccionadaMarihuana = null;

class _ConsumeMarihuanaState extends State<ConsumeMarihuana> {
  bool _mostrarOpcion = false;

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

var _opcionSeleccionadaOtrasDrogas = null;

class _ConsumeOtrasDrogasState extends State<ConsumeOtrasDrogas> {
  bool _mostrarOpcion = false;

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
