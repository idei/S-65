import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/LabeledCheckboxGeneric.dart';
import 'package:app_salud/widgets/alert_informe.dart';
import 'env.dart';
import 'ajustes.dart';

var id_paciente;
var id_medico;
var tipo_screening;
var id_recordatorio;
var screening_recordatorio;
var email;
List respuestaAnimo;

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
          "Cuestionario de Ánimo",
          "Este cuestionario valora cómo está su ánimo actualmente . Por favor responda sinceramente a cada una de las preguntas.  ",
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email_prefer = prefs.getString("email_prefer");
    email = email_prefer;
    id_paciente = prefs.getInt("id_paciente");

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
          future: getAllRespuestaNutricional(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            print(snapshot.connectionState);
            if (snapshot.hasData) {
              return ScreeningAnimo();
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

  Future<List> getAllRespuestaNutricional() async {
    var response;

    String URL_base = Env.URL_API;
    var url = URL_base + "/tipo_eventos_animo";

    response = await http.post(url, body: {});

    var jsonData = json.decode(response.body);

    if (response.statusCode == 200) {
      return respuestaAnimo = jsonData['data'];
    } else {
      return null;
    }
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
  ValueNotifier<bool> valueNotifierSatisfecho = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierAbandonado = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierVidaVacia = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierAburrida = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierHumor = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierTemor = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierFeliz = ValueNotifier<bool>(false);

  ValueNotifier<bool> valueNotifierDesamparado = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierPrefiere = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierMemoria = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierEstar_vivo = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierInutil = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierEnergia = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierSituacion = ValueNotifier<bool>(false);
  ValueNotifier<bool> valueNotifierSituacionMejor = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey_screening_animo,
      child: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
          ),
          SatisfechoVida(valueNotifierSatisfecho: valueNotifierSatisfecho),
          Padding(
            padding: EdgeInsets.all(5.0),
          ),
          Divider(height: 10.0, color: Colors.black),
          Padding(
            padding: EdgeInsets.all(5.0),
          ),
          Abandonado(valueNotifierAbandonado: valueNotifierAbandonado),
          Padding(
            padding: EdgeInsets.all(5.0),
          ),
          Divider(height: 10.0, color: Colors.black),
          VidaVacia(valueNotifierVidaVacia: valueNotifierVidaVacia),
          Padding(
            padding: EdgeInsets.all(5.0),
          ),
          Divider(height: 10.0, color: Colors.black),
          Aburrida(valueNotifierAburrida: valueNotifierAburrida),
          Padding(
            padding: EdgeInsets.all(5.0),
          ),
          Divider(height: 10.0, color: Colors.black),
          Humor(valueNotifierHumor: valueNotifierHumor),
          Padding(
            padding: EdgeInsets.all(5.0),
          ),
          Divider(height: 10.0, color: Colors.black),
          Temor(valueNotifierTemor: valueNotifierTemor),
          Padding(
            padding: EdgeInsets.all(5.0),
          ),
          Divider(height: 10.0, color: Colors.black),
          Feliz(valueNotifierFeliz: valueNotifierFeliz),
          Padding(
            padding: EdgeInsets.all(5.0),
          ),
          Divider(height: 10.0, color: Colors.black),
          Desamparados(valueNotifierDesamparado: valueNotifierDesamparado),
          Padding(
            padding: EdgeInsets.all(5.0),
          ),
          Divider(height: 10.0, color: Colors.black),
          Prefiere(valueNotifierPrefiere: valueNotifierPrefiere),
          Padding(
            padding: EdgeInsets.all(5.0),
          ),
          Divider(height: 10.0, color: Colors.black),
          Memoria(valueNotifierMemoria: valueNotifierMemoria),
          Padding(
            padding: EdgeInsets.all(5.0),
          ),
          Divider(height: 10.0, color: Colors.black),
          EstarVivo(valueNotifierEstar_vivo: valueNotifierEstar_vivo),
          Padding(
            padding: EdgeInsets.all(5.0),
          ),
          Divider(height: 10.0, color: Colors.black),
          Inutil(valueNotifierInutil: valueNotifierInutil),
          Padding(
            padding: EdgeInsets.all(5.0),
          ),
          Divider(height: 10.0, color: Colors.black),
          Energia(valueNotifierEnergia: valueNotifierEnergia),
          Padding(
            padding: EdgeInsets.all(5.0),
          ),
          Divider(height: 10.0, color: Colors.black),
          Situacion(valueNotifierSituacion: valueNotifierSituacion),
          Padding(
            padding: EdgeInsets.all(5.0),
          ),
          Divider(height: 10.0, color: Colors.black),
          MejorUsted(valueNotifierSituacion_mejor: valueNotifierSituacionMejor),
          Padding(
            padding: EdgeInsets.all(5.0),
          ),
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
        ],
      ),
    );
  }

  var responseDecoder;

  guardar_datos(context) async {
    String URL_base = Env.URL_API;
    var url = URL_base + "/respuesta_screening_animo";
    var response = await http.post(url, body: {
      "id_paciente": id_paciente.toString(),
      "id_medico": id_medico.toString(),
      "id_recordatorio": id_recordatorio.toString(),
      "tipo_screening": tipo_screening["data"].toString(),
      "satisfecho": valueNotifierSatisfecho.value.toString(),
      "abandonado": valueNotifierAbandonado.value.toString(),
      "vacia": valueNotifierVidaVacia.value.toString(),
      "aburrida": valueNotifierAburrida.value.toString(),
      "humor": valueNotifierHumor.value.toString(),
      "temor": valueNotifierTemor.value.toString(),
      "feliz": valueNotifierFeliz.value.toString(),
      "desamparado": valueNotifierDesamparado.value.toString(),
      "prefiere": valueNotifierPrefiere.value.toString(),
      "memoria": valueNotifierMemoria.value.toString(),
      "estar_vivo": valueNotifierEstar_vivo.value.toString(),
      "inutil": valueNotifierInutil.value.toString(),
      "energia": valueNotifierEnergia.value.toString(),
      "situacion": valueNotifierSituacion.value.toString(),
      "situacion_mejor": valueNotifierSituacionMejor.value.toString(),
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
          showCustomAlert(
            context,
            "Para tener en cuenta",
            "Usted tiene algunos síntomas del estado del ánimo de los cuales ocuparse, le sugerimos que realice una consulta psiquiátrica o que converse sobre estos síntomas con su médico de cabecera. ",
            screening_recordatorio,
            () {},
          );
        } else {
          if (int.parse(responseDecoder['data']) < 9) {
            showCustomAlert(
              context,
              "Para tener en cuenta",
              "En este momento no presenta sintomatología del estado del ánimo que requiera una consulta con especialista. Sin embargo, le sugerimos seguir controlando su estado de ánimo periódicamente.",
              screening_recordatorio,
              () {},
            );
          } else {
            if (screening_recordatorio == true) {
              Navigator.pushNamed(context, '/recordatorio');
            } else {
              Navigator.pushNamed(context, '/screening', arguments: {
                "select_screening": "ÁNIMO",
              });
            }
          }
        }
      }
    } else {
      showCustomAlert(
        context,
        "Error al guardar",
        response.body,
        screening_recordatorio,
        () {},
      );
    }
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

  void choiceAction(String choice) {
    if (choice == Constants.Ajustes) {
      Navigator.pushNamed(context, '/ajustes');
    } else if (choice == Constants.Salir) {
      Navigator.pushNamed(context, '/');
    }
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
  ValueNotifier<bool> valueNotifierSatisfecho;

  SatisfechoVida({this.valueNotifierSatisfecho});

  @override
  CheckSatisfechoVidaWidgetState createState() =>
      CheckSatisfechoVidaWidgetState();
}

class CheckSatisfechoVidaWidgetState extends State<SatisfechoVida> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: respuestaAnimo[0]["nombre_evento"],
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierSatisfecho.value,
      onChanged: (bool newValue) {
        setState(() {
          widget.valueNotifierSatisfecho.value = newValue ?? false;
        });
      },
    );
  }
}

//-----------------------------------------------------------------------------------------------------------

// --------------------------------- ANIMO 2 ----------------------------------------------------

// ignore: must_be_immutable
class Abandonado extends StatefulWidget {
  ValueNotifier<bool> valueNotifierAbandonado;

  Abandonado({this.valueNotifierAbandonado});

  @override
  CheckAbandonadoWidgetState createState() => CheckAbandonadoWidgetState();
}

class CheckAbandonadoWidgetState extends State<Abandonado> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: respuestaAnimo[1]["nombre_evento"],
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierAbandonado.value,
      onChanged: (bool newValue) {
        setState(() {
          widget.valueNotifierAbandonado.value = newValue;
        });
      },
    );
  }
}

//-------------------------------------------ANIMO 3--------------------------------------------

class VidaVacia extends StatefulWidget {
  ValueNotifier<bool> valueNotifierVidaVacia;

  VidaVacia({this.valueNotifierVidaVacia});

  @override
  VidaVaciaWidgetState createState() => VidaVaciaWidgetState();
}

class VidaVaciaWidgetState extends State<VidaVacia> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: respuestaAnimo[2]["nombre_evento"],
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierVidaVacia.value,
      onChanged: (bool newValue) {
        setState(() {
          widget.valueNotifierVidaVacia.value = newValue;
        });
      },
    );
  }
}

//------------------------------------------ ANIMO 4 -------------------------------------------

// ignore: must_be_immutable
class Aburrida extends StatefulWidget {
  ValueNotifier<bool> valueNotifierAburrida;

  Aburrida({this.valueNotifierAburrida});

  @override
  AburridaWidgetState createState() => AburridaWidgetState();
}

class AburridaWidgetState extends State<Aburrida> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: respuestaAnimo[3]["nombre_evento"],
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierAburrida.value,
      onChanged: (bool newValue) {
        setState(() {
          widget.valueNotifierAburrida.value = newValue;
        });
      },
    );
  }
}

//------------------------------------------ANIMO 5 ---------------------------------------

class Humor extends StatefulWidget {
  ValueNotifier<bool> valueNotifierHumor;

  Humor({this.valueNotifierHumor});

  @override
  HumorWidgetState createState() => HumorWidgetState();
}

class HumorWidgetState extends State<Humor> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: respuestaAnimo[4]["nombre_evento"],
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierHumor.value,
      onChanged: (bool newValue) {
        setState(() {
          widget.valueNotifierHumor.value = newValue;
        });
      },
    );
  }
}

// ----------------------------------------ANIMO 6---------------------------------------

class Temor extends StatefulWidget {
  ValueNotifier<bool> valueNotifierTemor;

  Temor({this.valueNotifierTemor});

  @override
  TemorWidgetState createState() => TemorWidgetState();
}

class TemorWidgetState extends State<Temor> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: respuestaAnimo[5]["nombre_evento"],
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierTemor.value,
      onChanged: (bool newValue) {
        setState(() {
          widget.valueNotifierTemor.value = newValue;
        });
      },
    );
  }
}

// ---------------------------------------- ANIMO 7 -----------------------------------

class Feliz extends StatefulWidget {
  ValueNotifier<bool> valueNotifierFeliz;

  Feliz({this.valueNotifierFeliz});

  @override
  FelizWidgetState createState() => FelizWidgetState();
}

class FelizWidgetState extends State<Feliz> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: respuestaAnimo[6]["nombre_evento"],
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierFeliz.value,
      onChanged: (bool newValue) {
        setState(() {
          widget.valueNotifierFeliz.value = newValue;
        });
      },
    );
  }
}

// -----------------------------------------ANIMO 8 -----------------------------------------------------

class Desamparados extends StatefulWidget {
  ValueNotifier<bool> valueNotifierDesamparado;

  Desamparados({this.valueNotifierDesamparado});
  @override
  DesamparadosWidgetState createState() => DesamparadosWidgetState();
}

class DesamparadosWidgetState extends State<Desamparados> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: respuestaAnimo[7]["nombre_evento"],
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierDesamparado.value,
      onChanged: (bool newValue) {
        setState(() {
          widget.valueNotifierDesamparado.value = newValue;
        });
      },
    );
  }
}

//-------------------------------------------- ANIMO 9 -----------------------------------------------------------

class Prefiere extends StatefulWidget {
  ValueNotifier<bool> valueNotifierPrefiere;

  Prefiere({this.valueNotifierPrefiere});
  @override
  PrefiereWidgetState createState() => PrefiereWidgetState();
}

class PrefiereWidgetState extends State<Prefiere> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: respuestaAnimo[8]["nombre_evento"],
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierPrefiere.value,
      onChanged: (bool newValue) {
        setState(() {
          widget.valueNotifierPrefiere.value = newValue;
        });
      },
    );
  }
}

// -------------------------------------------ANIMO 10 --------------------------------------------

class Memoria extends StatefulWidget {
  ValueNotifier<bool> valueNotifierMemoria;

  Memoria({this.valueNotifierMemoria});
  @override
  MemoriaWidgetState createState() => MemoriaWidgetState();
}

class MemoriaWidgetState extends State<Memoria> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: respuestaAnimo[9]["nombre_evento"],
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierMemoria.value,
      onChanged: (bool newValue) {
        setState(() {
          widget.valueNotifierMemoria.value = newValue;
        });
      },
    );
  }
}

// ------------------------------------------ANIMO 11 ---------------------------------------------------

class EstarVivo extends StatefulWidget {
  ValueNotifier<bool> valueNotifierEstar_vivo;

  EstarVivo({this.valueNotifierEstar_vivo});
  @override
  EstarVivoWidgetState createState() => EstarVivoWidgetState();
}

class EstarVivoWidgetState extends State<EstarVivo> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: respuestaAnimo[10]["nombre_evento"],
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierEstar_vivo.value,
      onChanged: (bool newValue) {
        setState(() {
          widget.valueNotifierEstar_vivo.value = newValue;
        });
      },
    );
  }
}
//-------------------------------------------- ANIMO 12---------------------------------------------------

class Inutil extends StatefulWidget {
  ValueNotifier<bool> valueNotifierInutil;

  Inutil({this.valueNotifierInutil});

  @override
  InutilWidgetState createState() => InutilWidgetState();
}

class InutilWidgetState extends State<Inutil> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: respuestaAnimo[11]["nombre_evento"],
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierInutil.value,
      onChanged: (bool newValue) {
        setState(() {
          widget.valueNotifierInutil.value = newValue;
        });
      },
    );
  }
}
//------------------------------------------ANIMO 13 --------------------------------------------------

class Energia extends StatefulWidget {
  ValueNotifier<bool> valueNotifierEnergia;

  Energia({this.valueNotifierEnergia});

  @override
  EnergiaWidgetState createState() => EnergiaWidgetState();
}

class EnergiaWidgetState extends State<Energia> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: respuestaAnimo[12]["nombre_evento"],
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierEnergia.value,
      onChanged: (bool newValue) {
        setState(() {
          widget.valueNotifierEnergia.value = newValue;
        });
      },
    );
  }
}
//-------------------------------------------- ANIMO 14 -------------------------------------------------

class Situacion extends StatefulWidget {
  ValueNotifier<bool> valueNotifierSituacion;

  Situacion({this.valueNotifierSituacion});

  @override
  ConFrecWidgetState createState() => ConFrecWidgetState();
}

class ConFrecWidgetState extends State<Situacion> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: respuestaAnimo[13]["nombre_evento"],
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierSituacion.value,
      onChanged: (bool newValue) {
        setState(() {
          widget.valueNotifierSituacion.value = newValue;
        });
      },
    );
  }
}

// --------------------------------------------ANIMO 15 ------------------------------------------------

class MejorUsted extends StatefulWidget {
  ValueNotifier<bool> valueNotifierSituacion_mejor;

  MejorUsted({this.valueNotifierSituacion_mejor});

  @override
  MejorUstedWidgetState createState() => MejorUstedWidgetState();
}

class MejorUstedWidgetState extends State<MejorUsted> {
  @override
  Widget build(BuildContext context) {
    return LabeledCheckboxGeneric(
      label: respuestaAnimo[14]["nombre_evento"],
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: widget.valueNotifierSituacion_mejor.value,
      onChanged: (bool newValue) {
        setState(() {
          widget.valueNotifierSituacion_mejor.value = newValue;
        });
      },
    );
  }
}
