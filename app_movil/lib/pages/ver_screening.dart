import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

TextEditingController email = TextEditingController();
TextEditingController email_nuevo = TextEditingController();
TextEditingController password = TextEditingController();
TextEditingController password_nuevo = TextEditingController();

class VerScreening extends StatefulWidget {
  @override
  _VerScreeningState createState() => _VerScreeningState();
}

final _formKey_ver_screening = GlobalKey<FormState>();
var id_paciente;
var nombre;
var fecha;
var result_screening;
var mensaje = "";
var codigo;
var titulo;
var fechaFormateada;

class _VerScreeningState extends State<VerScreening> {
  @override
  Widget build(BuildContext context) {
    Map parametros = ModalRoute.of(context).settings.arguments;
    id_paciente = parametros["id_paciente"];
    nombre = parametros["nombre"];
    fecha = parametros["fecha"];
    result_screening = parametros["result_screening"];
    codigo = parametros["codigo"];

    DateFormat dateFormatEntrada = DateFormat("yyyy-MM-dd");
    DateTime fechaEntrada = dateFormatEntrada.parse(fecha);

    DateFormat dateFormatSalida = DateFormat("dd-MM-yyyy");
    fechaFormateada = dateFormatSalida.format(fechaEntrada);

    if (codigo == "SFMS") {
      titulo = "Físico";
      if (double.parse(result_screening) > 3) {
        mensaje =
            "A tener en cuenta: Le sugerimos que consulte con su médico clínico sobre estos síntomas.";
      } else {
        mensaje = "Resultado: Su estado de Ánimo es bueno.";
      }
    }

    if (codigo == "QCQ") {
      titulo = "de Cognición";
      if (double.parse(result_screening) > 20) {
        mensaje =
            "A tener en cuenta: Sería bueno que consulte con su médico clínico o neurólogo sobre los síntomas cognitivos, probablemente le solicite una evaluación cognitiva para explorar su funcionamiento cognitivo.";
      }

      if (double.parse(result_screening) < 20) {
        mensaje =
            "Resultado: En este momento no presenta quejas cognitivas significativas. Continue estimulando sus funciones cognitivas, como la memoria, con actividades desafiantes para su cerebro.";
      }
    }

    if (codigo == "ANIMO") {
      titulo = "de Ánimo";
      if (double.parse(result_screening) >= 9) {
        mensaje =
            "A tener en cuenta: Usted tiene algunos síntomas del estado del ánimo de los cuales ocuparse, le sugerimos que realice una consulta psiquiátrica o que converse sobre estos síntomas con su médico de cabecera. ";
      }

      if (double.parse(result_screening) < 9) {
        mensaje =
            "Resultado: En este momento no presenta sintomatología del estado del ánimo que requiera una consulta con especialista. Sin embargo, le sugerimos seguir controlando su estado de ánimo periódicamente.";
      }
    }

    if (codigo == "CONDUC") {
      titulo = "Comportamiento";
      if (double.parse(result_screening) > 4) {
        mensaje =
            "A tener en cuenta: Sería bueno que consulte con su médico clínico o neurólogo sobre lo informado con respecto a su funcionamiento en la vida cotidiana. Es posible que el especialista le solicite una evaluación cognitiva para explorar màs en detalle su funcionamiento cognitivo y posible impacto sobre su rutina.";
      } else {
        mensaje =
            "Resultado: No se presentaron resultados que indiquen algún problema.";
      }
    }

    if (codigo == "CDR") {
      titulo = "de CDR";
      if (double.parse(result_screening) > 1) {
        mensaje =
            "A tener en cuenta: Sería bueno que consulte con su médico clínico o neurólogo sobre lo informado con respecto a su funcionamiento en la vida cotidiana. Es posible que el especialista le solicite una evaluación cognitiva para explorar màs en detalle su funcionamiento cognitivo y posible impacto sobre su rutina.";
      }
    }

    if (codigo == "ADLQ") {
      titulo = "de Actividad de la Vida Diaria";
      if (double.parse(result_screening) > 1) {
        mensaje = "A tener en cuenta: Sería bueno que consulte con su médico.";
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
        future: Future.value(
            true), // Simulamos una operación asíncrona que se resuelve inmediatamente con el valor true
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Screenings(context);
          } else {
            return Scaffold(
              appBar: AppBar(
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

  Widget Screenings(BuildContext context) {
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
            Navigator.pop(context);
            // Navigator.pushNamed(context, '/screening', arguments: {
            //   "select_screening": "CONDUC",
            // });
          },
        ),
        title: Text('Chequeo ' + titulo,
            style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          child: Container(
            padding: EdgeInsets.all(20),
            child: ListView(children: <Widget>[
              Center(
                child: Text(
                  'Resultado Obtenido',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 25),
                ),
              ),
              Divider(height: 3.0, color: Colors.black),
              SizedBox(
                height: 30,
              ),
              Text(
                'Tipo: $nombre',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily,
                    fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              Text("Fecha: $fechaFormateada ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 20)),
              SizedBox(
                height: 30,
              ),
              Text("Puntuación: $result_screening ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 20)),
              SizedBox(
                height: 30,
              ),
              Text("$mensaje ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 20)),
              SizedBox(
                height: 30,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
