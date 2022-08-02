import 'package:app_salud/models/medicamento_model';
import 'package:app_salud/pages/menu.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'env.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicamentoPage extends StatefulWidget {
  @override
  _MedicamentoState createState() => _MedicamentoState();
}

List<MedicamentoModel> medicamentos_items;

TextEditingController dosis_frecuencia = TextEditingController();

class _MedicamentoState extends State<MedicamentoPage> {
  var data;
  bool isLoading = false;
  var email_argument;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushNamed(context, '/menu');
              },
            ),
            title: Text(
              'Medicamentos ',
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
              ),
            )),
        body: Container(
          child: FutureBuilder<List<MedicamentoModel>>(
            future: read_medicamentos(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: ListTile.divideTiles(
                    color: Colors.black26,
                    tiles: snapshot.data
                        .map((data) => ListTile(
                              title: ListTile(
                                leading: Icon(
                                  Icons.arrow_right_rounded,
                                  color: Colors.blue,
                                ),
                                title: Text(data.nombre_comercial,
                                    style: TextStyle(
                                        overflow: TextOverflow.clip,
                                        fontFamily: Theme.of(context)
                                            .textTheme
                                            .headline1
                                            .fontFamily)),
                                subtitle: Text(data.dosis_frecuencia,
                                    style: TextStyle(
                                        fontFamily: Theme.of(context)
                                            .textTheme
                                            .headline1
                                            .fontFamily)),
                                trailing: Wrap(children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    color: Colors.green,
                                    onPressed: () {
                                      _showAlertDialog(data.id_medicamento, 1);
                                    },
                                  ), // icon-1
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    color: Colors.red,
                                    onPressed: () {
                                      _showAlertDialog(data.id_medicamento, 2);
                                    },
                                  ),
                                ]),
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
                      //bottom: 40,
                      //left: size.width * 0.5 - 30,
                    ),
                  );
                } else {
                  return Container(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ListTile(
                          title: Text(
                        'No tiene medicamentos registrados',
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
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
          },
          child: IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/medicamentosAdd');
            },
          ),
        ));
  }

  Future<List<MedicamentoModel>> read_medicamentos() async {
    await getStringValuesSF();

    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/read_medicamentos.php";
    var response = await http.post(url, body: {
      "email": email_argument,
    });

    if (response.statusCode == 200) {
      if (response.body != '') {
        final items = json.decode(response.body).cast<Map<String, dynamic>>();
        medicamentos_items = items.map<MedicamentoModel>((json) {
          return MedicamentoModel.fromJson(json);
        }).toList();
        return medicamentos_items;
      } else {
        isLoading = true;
        return null;
      }
    } else {
      throw Exception('Error al obtener JSON');
    }
  }

  guardarFrecuenciaMedicamento(
      int id_medicamento, String dosis_frecuencia) async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/save_dosis_frecuencia.php";
    var response = await http.post(url, body: {
      "dosis_frecuencia": dosis_frecuencia,
      "id_medicamento": id_medicamento.toString(),
      "id_paciente": id_paciente.toString(),
    });
    data = json.decode(response.body);
    print(response.body);
  }

  void _showAlertDialog(int id_medicamento, int button_pressed) {
    dosis_frecuencia.text = "";
    showDialog(
        context: context,
        builder: (buildcontext) {
          if (button_pressed == 1) {
            return AlertDialog(
              title: Text("Ingrese dosis y frecuencia",
                  style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily)),
              content: TextFormField(
                controller: dosis_frecuencia,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Por favor ingrese los datos';
                  }
                  return null;
                },
                onChanged: (text) {
                  print("Debe completar el campo");
                },
              ),
              actions: <Widget>[
                ElevatedButton(
                  //color: Colors.blue,
                  child: Text(
                    "OK",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                    ),
                  ),
                  onPressed: () {
                    guardarFrecuenciaMedicamento(
                        id_medicamento, dosis_frecuencia.text);
                    Navigator.popAndPushNamed(
                        context, "/medicamentos"); // push it back in

                    //Navigator.pop(context, true);
                  },
                )
              ],
            );
          } else {
            return AlertDialog(
              title: Text("¿Esta seguro de querer eliminar este medicamento?",
                  style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily)),
              actions: <Widget>[
                ElevatedButton(
                    onPressed: () {
                      delete_medicamento(context, id_medicamento);
                    },
                    child: Text("Si")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("No")),
              ],
            );
          }
        });
  }

  delete_medicamento(BuildContext context, var id_medicamento) async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/delete_medicamento.php";
    var response = await http.post(url, body: {
      "id_medicamento": id_medicamento.toString(),
    });

    if (response.statusCode == 200) {
      _alert_informe(context, "Medicamento Eliminado", 1);
      Navigator.popAndPushNamed(context, "/medicamentos");
    } else {
      var mensajeError = 'Error al obtener JSON: ' + response.body;
      _alert_informe(context, mensajeError, 2);
      throw Exception(mensajeError);
    }
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

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email_prefer = await prefs.getString("email_prefer");
    email_argument = email_prefer;
    //rela_paciente = await prefs.getInt("rela_paciente");
    print(email_argument);
  }

  void choiceAction(String choice) {
    if (choice == Constants.Ajustes) {
      Navigator.pushNamed(context, '/ajustes');
    } else if (choice == Constants.Salir) {
      Navigator.pushNamed(context, '/');
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

class Constants {
  static const String Ajustes = 'Ajustes';
  static const String Salir = 'Salir';
  static const List<String> choices = <String>[
    Ajustes,
    Salir,
  ];
}
