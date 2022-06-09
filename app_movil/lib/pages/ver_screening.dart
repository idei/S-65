import 'package:app_salud/pages/new_recordatorio_personal.dart';
import 'package:flutter/material.dart';
import 'package:app_salud/pages/form_datos_generales.dart';

TextEditingController email = TextEditingController();
TextEditingController email_nuevo = TextEditingController();
TextEditingController password = TextEditingController();
TextEditingController password_nuevo = TextEditingController();
String email_set_shared;

class VerScreening extends StatefulWidget {
  @override
  _VerScreeningState createState() => _VerScreeningState();
}

final _formKey = GlobalKey<FormState>();
var id_paciente;
var nombre;
var fecha;
var result_screening;
var mensaje = "";
var codigo;
var titulo;

class _VerScreeningState extends State<VerScreening> {
  @override
  Widget build(BuildContext context) {
    Map parametros = ModalRoute.of(context).settings.arguments;
    id_paciente = parametros["id_paciente"];
    nombre = parametros["nombre"];
    fecha = parametros["fecha"];
    result_screening = parametros["result_screening"];
    codigo = parametros["codigo"];

    if (codigo == "SFMS") {
      titulo = "Físico";
      if (double.parse(result_screening) > 3) {
        mensaje =
            "A tener en cuenta: Le sugerimos que consulte con su médico clínico sobre estos síntomas.";
      }
    }

    if (codigo == "QCQ") {
      titulo = "de Cognición";
      if (double.parse(result_screening) > 20) {
        mensaje =
            "Sería bueno que consulte con su médico clínico o neurólogo sobre los síntomas cognitivos, probablemente le solicite una evaluación cognitiva para explorar su funcionamiento cognitivo.";
      }
    }

    if (codigo == "ANIMO") {
      titulo = "de Ánimo";
      if (double.parse(result_screening) >= 9) {
        mensaje =
            "A tener en cuenta: Usted tiene algunos síntomas del estado del ánimo de los cuales ocuparse, le sugerimos que realice una consulta psiquiátrica o que converse sobre estos síntomas con su médico de cabecera. ";
      }
    }

    if (codigo == "CONDUC") {
      titulo = "Conductual";
      if (double.parse(result_screening) > 4) {
        mensaje =
            "A tener en cuenta: Sería bueno que consulte con su médico clínico o neurologo sobre lo informado con respecto a su funcionamiento en la vida cotidiana. Es posible que el especialista le solicite una evaluación cognitiva para explorar màs en detalle su funcionamiento cognitivo y posible impacto sobre su rutina.";
      }
    }

    if (codigo == "CDR") {
      titulo = "de CDR";
      if (double.parse(result_screening) > 1) {
        mensaje =
            "A tener en cuenta: Sería bueno que consulte con su médico clínico o neurologo sobre lo informado con respecto a su funcionamiento en la vida cotidiana. Es posible que el especialista le solicite una evaluación cognitiva para explorar màs en detalle su funcionamiento cognitivo y posible impacto sobre su rutina.";
      }
    }

    if (codigo == "RNUTRI") {
      titulo = "de Nutrición";
      if (double.parse(result_screening) <= 2) {
        mensaje = "A tener en cuenta: Buen Estado nutricional";
      }

      if (double.parse(result_screening) >= 3) {
        if (double.parse(result_screening) <= 5) {
          mensaje = "A tener en cuenta: Moderado Riesgo nutricional";
        }
      }

      if (double.parse(result_screening) >= 6) {
        mensaje = "A tener en cuenta: Alto Riesgo nutricional";
      }
    }

    return FutureBuilder(
        future: timer(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print(snapshot.connectionState);

          if (snapshot.hasData) {
            return Screenings(context);
          } else {
            return Scaffold(
              appBar: AppBar(
                //backgroundColor: Color.fromRGBO(157, 19, 34, 1),
                title: Text('Chequeo',
                    style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily)),
              ),
              body: Center(
                child: CircularProgressIndicator(
                  semanticsLabel: "Cargando",
                ),
              ),
            );
          }
        });
  }

  timer() async {
    await new Future.delayed(new Duration(milliseconds: 500));
    return true;
  }

  Widget Screenings(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //backgroundColor: Color.fromRGBO(157, 19, 34, 1),
          title: Text('Chequeo ' + titulo,
              style: TextStyle(
                  fontFamily:
                      Theme.of(context).textTheme.headline1.fontFamily)),
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
            )
          ],
        ),
        body: Form(
            key: _formKey,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(children: <Widget>[
                  Text('Tipo: $nombre',
                      style: TextStyle(
                          fontFamily:
                              Theme.of(context).textTheme.headline1.fontFamily,
                          fontSize: 20)),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Fecha: $fecha ",
                      style: TextStyle(
                          fontFamily:
                              Theme.of(context).textTheme.headline1.fontFamily,
                          fontSize: 20)),
                  SizedBox(
                    height: 30,
                  ),
                  Text("Puntuación: $result_screening ",
                      style: TextStyle(
                          fontFamily:
                              Theme.of(context).textTheme.headline1.fontFamily,
                          fontSize: 20)),
                  SizedBox(
                    height: 30,
                  ),
                  Text("$mensaje ",
                      style: TextStyle(
                          fontFamily:
                              Theme.of(context).textTheme.headline1.fontFamily,
                          fontSize: 20)),
                  SizedBox(
                    height: 30,
                  ),
                ]))));
  }

  void choiceAction(String choice) {
    if (choice == Constants.Ajustes) {
      Navigator.pushNamed(context, '/ajustes');
    } else if (choice == Constants.Salir) {
      email_argument.remove();
      Navigator.pushNamed(context, '/');
    }
  }
}
