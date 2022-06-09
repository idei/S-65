import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'env.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class RecordatorioPage extends StatefulWidget {
  @override
  _RecordatorioState createState() => _RecordatorioState();
}

final _formKey = GlobalKey<_RecordatorioState>();
List<Recordatorios_database> recordatorios_items;

class _RecordatorioState extends State<RecordatorioPage> {
  double _animatedHeight = 0.0;
  var data_error;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Recordatorios_database>>(
        future: read_recordatorios(),
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
                  title: Text('Recordatorios',
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
                                    if (data.estado_recordatorio == 0) {
                                      Navigator.of(context).pushNamed(
                                          '/ver_recordatorio_personal',
                                          arguments: {
                                            "id_recordatorio":
                                                data.id_recordatorio,
                                            "id_paciente": data.id_paciente,
                                            "descripcion": data.descripcion,
                                            "fecha_limite": data.fecha_limite,
                                            "estado_recordatorio":
                                                data.estado_recordatorio,
                                          });
                                    } else {
                                      Navigator.of(context).pushNamed(
                                          '/ver_recordatorio_screening',
                                          arguments: {
                                            "id_recordatorio":
                                                data.id_recordatorio,
                                            "id_paciente": data.id_paciente,
                                            "descripcion": data.descripcion,
                                            "fecha_limite": data.fecha_limite,
                                            "estado_recordatorio":
                                                data.estado_recordatorio,
                                          });
                                    }
                                  },
                                  child: CardDinamic(data)),
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
                      Navigator.pushNamed(
                          context, '/new_recordatorio_personal');
                    },
                    //color: Color.fromRGBO(157, 19, 34, 1),
                  ),
                ));
          } else {
            return Scaffold(
                appBar: AppBar(
                  //backgroundColor: Color.fromRGBO(157, 19, 34, 1),
                  title: Text('Recordatorios',
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
                      Navigator.pushNamed(
                          context, '/new_recordatorio_personal');
                    },
                  ),
                ));
          }
        });
  }

  var color;
  var font_bold;

  Widget CardDinamic(data) {
    final now = new DateTime.now();
    var dia;
    var mes;

    if (now.day < 10) {
      dia = '0' + now.day.toString();
    } else {
      dia = now.day.toString();
    }

    if (now.month < 10) {
      mes = '0' + now.month.toString();
    } else {
      mes = now.month.toString();
    }

    String formatter = now.year.toString() + "-" + mes + "-" + dia;
    //String formatter = DateFormat('yMd').format(now);
    print(formatter);
    DateTime fecha_limite1 = DateTime.parse(formatter);
    DateTime fecha_limite = DateTime.parse(data.fecha_limite);

    final difference = fecha_limite.difference(fecha_limite1).inDays;
    print(difference);

    if (difference < 0) {
      color = Colors.red;
      font_bold = FontWeight.bold;
    } else if (difference == 1) {
      color = Colors.yellow;
      font_bold = FontWeight.bold;
    } else if (difference > 1) {
      color = Colors.green;
      font_bold = FontWeight.bold;
    }

    return Card(
      child: ListTile(
        leading: Icon(
          Icons.today,
          color: color,
        ),
        title: Text(data.descripcion.toUpperCase(),
            style: TextStyle(fontFamily: 'NunitoR')),
        subtitle:
            Text(data.fecha_limite, style: TextStyle(fontFamily: 'NunitoR')),
      ),
    );
  }

  var email_argument;

  Future<List<Recordatorios_database>> read_recordatorios() async {
    await getStringValuesSF();

    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/read_recordatorios.php";
    var response = await http.post(url, body: {
      "email": email_argument,
    });
    data_error = json.decode(response.body);
    print(response.body);

    if (data_error.toString() != 'Error') {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      recordatorios_items = items.map<Recordatorios_database>((json) {
        return Recordatorios_database.fromJson(json);
      }).toList();
      return recordatorios_items;
    }
    await new Future.delayed(new Duration(milliseconds: 500));
    recordatorios_items = [];
    return recordatorios_items;
    //}
  }

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email_prefer = await prefs.getString("email_prefer");
    email_argument = email_prefer;
    //id_paciente = await prefs.getInt("id_paciente");
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

class Recordatorios_database {
  String descripcion;
  String fecha_limite;
  var id_recordatorio;
  var id_paciente;
  var estado_recordatorio;

  Recordatorios_database({
    this.descripcion,
    this.fecha_limite,
    this.id_recordatorio,
    this.id_paciente,
    this.estado_recordatorio,
  });

  factory Recordatorios_database.fromJson(Map<String, dynamic> json) {
    return Recordatorios_database(
      id_recordatorio: json['id'],
      descripcion: json['descripcion'],
      fecha_limite: json['fecha_limite'],
      id_paciente: json['rela_paciente'],
      estado_recordatorio: json['rela_estado_recordatorio'],
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
