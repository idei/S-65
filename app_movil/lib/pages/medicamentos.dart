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

List<MedicamentosDatabase> medicamentos_items;

TextEditingController dosis_frecuencia = TextEditingController();

class _MedicamentoState extends State<MedicamentoPage> {
  var data_error;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MedicamentosDatabase>>(
        future: read_medicamentos(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                  leading: new IconButton(
                    icon: new Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pushNamed(context, '/menu');
                    },
                  ),
                  //backgroundColor: Color.fromRGBO(157, 19, 34, 1),
                  //backgroundColor: Color.fromRGBO(157, 19, 34, 1),
                  title: Text('Medicamentos',
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
                                onTap: () {},
                                child: ListTile(
                                  leading: Icon(
                                    Icons.medical_services,
                                    color: Colors.blue,
                                  ),
                                  title: Text(data.nombre_comercial,
                                      style: TextStyle(
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
                                  trailing: Wrap(
                                    spacing: 10, // space between two icons
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        color: Colors.green,
                                        onPressed: () {
                                          _showAlertDialog(
                                              data.id_medicamento, 1);
                                        },
                                      ), // icon-1
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        color: Colors.red,
                                        onPressed: () {
                                          _showAlertDialog(
                                              data.id_medicamento, 2);
                                        },
                                      ), // icon-2
                                    ],
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
                      Navigator.pushNamed(context, '/medicamentosAdd');
                    },
                  ),
                ));
          } else {
            return Scaffold(
                appBar: AppBar(
                  //backgroundColor: Color.fromRGBO(157, 19, 34, 1),
                  title: Text('Medicamentos',
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
        });
  }

  var email_argument;

  Future<List<MedicamentosDatabase>> read_medicamentos() async {
    await getStringValuesSF();

    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/read_medicamentos.php";
    var response = await http.post(url, body: {
      "email": email_argument,
    });
    data_error = json.decode(response.body);
    print("response ");
    print(response.body);

    if (data_error.toString() != 'Error') {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      medicamentos_items = items.map<MedicamentosDatabase>((json) {
        return MedicamentosDatabase.fromJson(json);
      }).toList();
      return medicamentos_items;
    }
    await new Future.delayed(new Duration(milliseconds: 500));
    medicamentos_items = [];
    return medicamentos_items;
    //}
  }

  guardar_frecuencia(int id_medicamento, String dosis_frecuencia) async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/save_dosis_frecuencia.php";
    var response = await http.post(url, body: {
      "dosis_frecuencia": dosis_frecuencia,
      "id_medicamento": id_medicamento.toString(),
      "id_paciente": id_paciente.toString(),
    });
    data_error = json.decode(response.body);
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
                    guardar_frecuencia(id_medicamento, dosis_frecuencia.text);
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
                      print("Eliminar2");
                      delete_medicamento(context, id_medicamento);
                      Navigator.popAndPushNamed(context, "/medicamentos");
                    },
                    child: Text("Si")),
                ElevatedButton(
                    onPressed: () {
                      print("Eliminar3");
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

    print(response.body);
    var data = json.decode(response.body);
    if (data.toString() != 'Medicamento eliminado') {
      print(data.toString());
    } else {
      print(data.toString());
      Navigator.popAndPushNamed(context, "/medicamentos");
      //Navigator.pop(context, true);
    }
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

class MedicamentosDatabase {
  String dosis_frecuencia;
  String nombre_comercial;
  String presentacion;
  var rela_paciente;
  var rela_medicamento;
  var id_medicamento;

  MedicamentosDatabase(
      {this.dosis_frecuencia,
      this.rela_paciente,
      this.rela_medicamento,
      this.id_medicamento,
      this.nombre_comercial,
      this.presentacion});

  factory MedicamentosDatabase.fromJson(Map<String, dynamic> json) {
    return MedicamentosDatabase(
        id_medicamento: json['id_medicamento'],
        dosis_frecuencia: json['dosis_frecuencia'],
        rela_paciente: json['rela_paciente'],
        rela_medicamento: json['rela_medicamento'],
        nombre_comercial: json['nombre_comercial'],
        presentacion: json['presentacion']);
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
