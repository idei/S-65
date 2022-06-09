import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'env.dart';

class ScreeningPage extends StatefulWidget {
  @override
  _ScreeningState createState() => _ScreeningState();
}

final _formKey = GlobalKey<_ScreeningState>();
var select_screening;
var titulo;

class _ScreeningState extends State<ScreeningPage> {
  double _animatedHeight = 0.0;
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    Map parametros = ModalRoute.of(context).settings.arguments;
    select_screening = parametros["select_screening"];

    if (select_screening == "SFMS") {
      titulo = "Físicos";
    }

    if (select_screening == "QCQ") {
      titulo = "de Cognición";
    }

    if (select_screening == "ANIMO") {
      titulo = "de Ánimo";
    }

    if (select_screening == "CONDUC") {
      titulo = "Conductuales";
    }

    if (select_screening == "CDR") {
      titulo = "de Cognición y Vida Cotidiana";
    }

    if (select_screening == "RNUTRI") {
      titulo = "de Nutrición";
    }

    if (select_screening == "DIAB") {
      titulo = "de Diabetes";
    }

    if (select_screening == "ENCRO") {
      titulo = "enfermedades crónicas";
    }
    return FutureBuilder<List<Screenings_database>>(
        future: read_screenings(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                  leading: new IconButton(
                    icon: new Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pushNamed(context, '/menu_chequeo');
                    },
                  ),
                  //backgroundColor: Color.fromRGBO(157, 19, 34, 1),
                  title: Text('Chequeos ' + titulo,
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily,
                      )),
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
                    ),
                  ],
                ),
                body: ListView(
                  children: ListTile.divideTiles(
                    color: Colors.black,
                    tiles: snapshot.data
                        .map((data) => ListTile(
                              title: GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed('/ver_screening', arguments: {
                                    "id_paciente": data.id_paciente,
                                    "nombre": data.nombre,
                                    "fecha": data.fecha,
                                    "result_screening": data.result_screening,
                                    "codigo": data.codigo,
                                  });
                                },
                                child: Card(
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.calendar_today,
                                      color: Colors.blue,
                                    ),
                                    title: Text(data.nombre),
                                    subtitle: Text("Puntuación:  " +
                                        data.result_screening.toString() +
                                        " Fecha: " +
                                        data.fecha),
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ).toList(),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    // Add your onPressed code here!
                  },
                  child: IconButton(
                    icon: Icon(Icons.add, color: Colors.white),
                    onPressed: () {
                      if (select_screening == "SFMS") {
                        Navigator.of(context).pushReplacementNamed(
                            '/screening_fisico',
                            arguments: {
                              "tipo_screening": select_screening,
                              "bandera": "screening_nuevo"
                            });
                      } else {
                        if (select_screening == "QCQ") {
                          Navigator.of(context).pushReplacementNamed(
                              '/screening_queja_cognitiva',
                              arguments: {
                                "tipo_screening": select_screening,
                                "bandera": "screening_nuevo"
                              });
                        } else {
                          if (select_screening == "ÁNIMO") {
                            Navigator.of(context).pushReplacementNamed(
                                '/screening_animo',
                                arguments: {
                                  "tipo_screening": select_screening,
                                  "bandera": "screening_nuevo"
                                });
                          } else {
                            if (select_screening == "CONDUC") {
                              Navigator.of(context).pushReplacementNamed(
                                  '/screening_conductual',
                                  arguments: {
                                    "tipo_screening": select_screening,
                                    "bandera": "screening_nuevo"
                                  });
                            } else {
                              if (select_screening == "CDR") {
                                Navigator.of(context).pushReplacementNamed(
                                    '/screening_cdr',
                                    arguments: {
                                      "tipo_screening": select_screening,
                                      "bandera": "screening_nuevo"
                                    });
                              } else {
                                if (select_screening == "RNUTRI") {
                                  Navigator.of(context).pushReplacementNamed(
                                      '/screening_nutricional',
                                      arguments: {
                                        "tipo_screening": select_screening,
                                        "bandera": "screening_nuevo"
                                      });
                                } else {
                                  if (select_screening == "DIAB") {
                                    Navigator.of(context).pushReplacementNamed(
                                        '/screening_diabetes',
                                        arguments: {
                                          "tipo_screening": select_screening,
                                          "bandera": "screening_nuevo"
                                        });
                                  } else {
                                    if (select_screening == "ENCRO") {
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              '/screening_encro',
                                              arguments: {
                                            "tipo_screening": select_screening,
                                            "bandera": "screening_nuevo"
                                          });
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }

                      //Navigator.pushNamed(context, '/screening_new');
                    },
                    //color: Color.fromRGBO(100, 20, 28, 1),
                  ),
                ));
          } else {
            return Scaffold(
              appBar: AppBar(
                //backgroundColor: Color.fromRGBO(157, 19, 34, 1),
                title: Text('Chequeo',
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                    )),
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

  Future<List<Screenings_database>> read_screenings() async {
    await getStringValuesSF();

    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/read_screenings.php";
    var response = await http.post(url, body: {
      "id_paciente": id_paciente.toString(),
      "select_screening": select_screening,
    });
    data_error = json.decode(response.body);
    print(response.body);

    if (data_error.toString() != 'Error') {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      recordatorios_items = items.map<Screenings_database>((json) {
        return Screenings_database.fromJson(json);
      }).toList();
      return recordatorios_items;
    }
    await new Future.delayed(new Duration(milliseconds: 500));
    recordatorios_items = [];
    return recordatorios_items;
  }

  void choiceAction(String choice) {
    if (choice == Constants.Ajustes) {
      Navigator.pushNamed(context, '/ajustes');
    } else if (choice == Constants.Salir) {
      Navigator.pushNamed(context, '/');
    }
  }
}

List<Screenings_database> recordatorios_items;
var data_error;
var email_argument;
var id_paciente;

class Screenings_database {
  var tipo_screening;
  var id_resultado_screening;
  var id_paciente;
  var result_screening;
  String nombre;
  String codigo;
  String fecha;

  Screenings_database(
      {this.tipo_screening,
      this.id_resultado_screening,
      this.id_paciente,
      this.result_screening,
      this.nombre,
      this.codigo,
      this.fecha});

  factory Screenings_database.fromJson(Map<String, dynamic> json) {
    return Screenings_database(
      id_resultado_screening: json['id'],
      tipo_screening: json['rela_screening'],
      id_paciente: json['rela_paciente'],
      result_screening: json['result_screening'],
      nombre: json['nombre'],
      codigo: json['codigo'],
      fecha: json['fecha_alta'],
    );
  }
}

getStringValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String email_prefer = await prefs.getString("email_prefer");
  email_argument = email_prefer;
  id_paciente = await prefs.getInt("id_paciente");
  print(email_argument);
}

class Constants {
  static const String Ajustes = 'Ajustes';
  static const String Salir = 'Salir';
  static const List<String> choices = <String>[
    Ajustes,
    Salir,
  ];
}
