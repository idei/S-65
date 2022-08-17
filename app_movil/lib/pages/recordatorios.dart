import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recordatorio_model.dart';
import 'env.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecordatorioPage extends StatefulWidget {
  @override
  _RecordatorioState createState() => _RecordatorioState();
}

final _formKey_recordatorios = GlobalKey<_RecordatorioState>();
List<RecordatoriosModel> recordatorios_items;
bool _isLoading = false;

class _RecordatorioState extends State<RecordatorioPage> {
  var data_error;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/menu');
          },
        ),
        title: Text('Recordatorios',
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
      body: FutureBuilder<List<RecordatoriosModel>>(
          future: read_recordatorios(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
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
              );
            } else {
              if (!_isLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    semanticsLabel: "Cargando",
                  ),
                );
              } else {
                return Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListTile(
                        title: Text(
                      'No tiene recordatorios',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontFamily:
                              Theme.of(context).textTheme.headline1.fontFamily),
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
            Navigator.pushNamed(context, '/new_recordatorio_personal');
          },
        ),
      ),
    );
  }

  var color;
  var font_bold;

  Widget CardDinamic(data) {
    final now = DateTime.now();
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
            style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily)),
        subtitle: Text(data.fecha_limite,
            style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily)),
      ),
    );
  }

  var email_argument;

  Future<List<RecordatoriosModel>> read_recordatorios() async {
    await getStringValuesSF();

    var responseDecode;
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/read_recordatorios.php";
    var response = await http.post(url, body: {
      "email": email_argument,
    });
    responseDecode = json.decode(response.body);

    if (response.statusCode == 200 && responseDecode != "Vacio") {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      recordatorios_items = items.map<RecordatoriosModel>((json) {
        return RecordatoriosModel.fromJson(json);
      }).toList();
      return recordatorios_items;
    } else {
      _isLoading = true;
      return null;
    }
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

class Constants {
  static const String Ajustes = 'Ajustes';
  static const String Salir = 'Salir';
  static const List<String> choices = <String>[
    Ajustes,
    Salir,
  ];
}
