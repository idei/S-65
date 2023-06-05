import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/opciones_navbar.dart';
import '../models/screening_model.dart';
import 'env.dart';

class ScreeningPage extends StatefulWidget {
  @override
  _ScreeningState createState() => _ScreeningState();
}

final _formKey_screening = GlobalKey<_ScreeningState>();
var select_screening;
var titulo;
bool isLoading = false;

class _ScreeningState extends State<ScreeningPage> {
  @override
  Widget build(BuildContext context) {
    Map parametros = ModalRoute.of(context).settings.arguments;
    select_screening = parametros["select_screening"];

    titulo = setTitulo(select_screening);

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, '/menu_chequeo');
            },
          ),
          title: Text('Mis Chequeos ' + titulo,
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
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
        body: FutureBuilder<List<ScreeningModel>>(
            future: read_screenings(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
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
                );
              } else {
                if (!isLoading) {
                  return Container(
                    alignment: Alignment.center,
                    child: Positioned(
                      child: _isLoadingIcon(),
                    ),
                  );
                } else {
                  return Container(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ListTile(
                          title: Text(
                        'No tiene chequeos ' + titulo + ' registrados',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: Theme.of(context)
                                .textTheme
                                .headline1
                                .fontFamily),
                      )),
                    ],
                  ));
                }
              }
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              if (select_screening == "SFMS") {
                Navigator.of(context).pushReplacementNamed('/screening_fisico',
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
                    Navigator.of(context)
                        .pushReplacementNamed('/screening_animo', arguments: {
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
                        Navigator.of(context)
                            .pushReplacementNamed('/screening_cdr', arguments: {
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
                              Navigator.of(context).pushReplacementNamed(
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
            },
          ),
        ));
  }

  String setTitulo(var select_screening) {
    if (select_screening == "SFMS") {
      titulo = "Físicos";
    }

    if (select_screening == "QCQ") {
      titulo = "de Cognición";
    }

    if (select_screening == "ÁNIMO") {
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

    return titulo;
  }

  List<ScreeningModel> recordatorios_items;
  var data;
  var email_argument;
  var id_paciente;

  Future<List<ScreeningModel>> read_screenings() async {
    await getStringValuesSF();
    List<ScreeningModel> list_sreenings = [];

    String URL_base = Env.URL_API;
    var url = URL_base + "/read_screenings";
    var response = await http.post(url, body: {
      "id_paciente": id_paciente.toString(),
      "select_screening": select_screening,
    });
    data = json.decode(response.body);

    if (data['status'] != 'Vacio') {
      for (var recordatorio in data['data']) {
        list_sreenings.add(ScreeningModel.fromJson(recordatorio));
      }

      return list_sreenings;
    } else {
      isLoading = true;
      return null;
    }
  }

  void choiceAction(String choice) {
    if (choice == Constants.Ajustes) {
      Navigator.pushNamed(context, '/ajustes');
    } else if (choice == Constants.Salir) {
      Navigator.pushNamed(context, '/');
    }
  }

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email_prefer = await prefs.getString("email_prefer");
    email_argument = email_prefer;
    id_paciente = await prefs.getInt("id_paciente");
    print(email_argument);
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
