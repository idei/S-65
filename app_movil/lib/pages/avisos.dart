import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'env.dart';

class Avisos_database {
  String descripcion;
  String fecha_limite;
  String url_imagen;
  var estado_leido;
  var id_aviso;
  var id_paciente;
  var rela_creador;
  var rela_medico;

  Avisos_database(
      {this.descripcion,
      this.fecha_limite,
      this.id_aviso,
      this.estado_leido,
      this.id_paciente,
      this.url_imagen,
      this.rela_creador,
      this.rela_medico});

  factory Avisos_database.fromJson(Map<String, dynamic> json) {
    return Avisos_database(
      id_aviso: json['id'],
      descripcion: json['descripcion'],
      fecha_limite: json['fecha_limite'],
      id_paciente: json['rela_paciente'],
      estado_leido: json['estado_leido'],
      url_imagen: json['url_imagen'],
      rela_creador: json['rela_creador'],
      rela_medico: json['rela_medico'],
    );
  }
}

class Avisos extends StatefulWidget {
  @override
  _AvisosState createState() => _AvisosState();
}

List<Avisos_database> recordatorios_items;

class _AvisosState extends State<Avisos> {
  double _animatedHeight = 0.0;
  var data_error;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Avisos_database>>(
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
                //backgroundColor: Color.fromRGBO(157, 19, 34, 1),
                title: Text('Avisos', style: TextStyle(fontFamily: 'Nunito')),
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
                                Navigator.of(context).pushNamed(
                                    '/ver_aviso_general',
                                    arguments: {
                                      "id_aviso": data.id_aviso,
                                      "id_paciente": data.id_paciente,
                                      "descripcion": data.descripcion,
                                      "fecha_limite": data.fecha_limite,
                                      "url_imagen": data.url_imagen,
                                      "rela_estado": data.estado_leido,
                                      "rela_creador": data.rela_creador,
                                      "rela_medico": data.rela_medico
                                    });
                              },
                              child: Card(
                                child: ListTile(
                                  leading: Icon(
                                    Icons.calendar_today,
                                    color: Colors.blue,
                                  ),
                                  title: Text(data.descripcion.toUpperCase(),
                                      maxLines: 2,
                                      style: TextStyle(fontFamily: 'NunitoR')),
                                  subtitle: Text(data.fecha_limite,
                                      style: TextStyle(fontFamily: 'NunitoR')),
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ).toList(),
              ),
            );
          } else {
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
                title: Text('Avisos', style: TextStyle(fontFamily: 'Nunito')),
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
              body: Center(
                child: CircularProgressIndicator(
                  semanticsLabel: "Cargando",
                ),
              ),
            );
          }
        });
  }

  var color;
  var font_bold;

  Widget CardDinamic(data) {
    if (data.rela_creador == 3) {
      if (data.estado_leido == 1) {
        color = Colors.grey[300];
        font_bold = FontWeight.normal;
      } else {
        font_bold = FontWeight.bold;
        color = Colors.grey[50];
      }

      return Card(
        color: color,
        child: ListTile(
          leading: Icon(
            Icons.insert_comment_sharp,
            color: Colors.yellow[700],
          ),
          title: Text(data.descripcion.toUpperCase(),
              maxLines: 2,
              style: TextStyle(
                fontFamily: 'NunitoR',
                fontWeight: font_bold,
              )),
          subtitle: Text(data.fecha_limite,
              style: TextStyle(
                fontFamily: 'NunitoR',
                fontWeight: font_bold,
              )),
        ),
      );
    } else {
      if (data.estado_leido == 1) {
        color = Colors.grey[300];
        font_bold = FontWeight.normal;
      } else {
        font_bold = FontWeight.bold;
        color = Colors.grey[50];
      }
      return Card(
        color: color,
        child: ListTile(
          leading: Icon(
            Icons.article_sharp,
            color: Colors.blue,
          ),
          title: Text(data.descripcion.toUpperCase(),
              maxLines: 2,
              style: TextStyle(
                fontFamily: 'NunitoR',
                fontWeight: font_bold,
              )),
          subtitle: Text(data.fecha_limite,
              style: TextStyle(
                fontFamily: 'NunitoR',
                fontWeight: font_bold,
              )),
        ),
      );
    }
  }

  var id_paciente_argument;

  Future<List<Avisos_database>> read_recordatorios() async {
    await getStringValuesSF();
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/read_avisos.php";
    var response = await http.post(url, body: {
      "id_paciente": id_paciente_argument.toString(),
    });
    data_error = json.decode(response.body);
    print(response.body);

    if (data_error.toString() != 'Error') {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      recordatorios_items = items.map<Avisos_database>((json) {
        return Avisos_database.fromJson(json);
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
    var paciente_prefer = await prefs.getInt("id_paciente");
    id_paciente_argument = paciente_prefer;
    print(id_paciente_argument);
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
