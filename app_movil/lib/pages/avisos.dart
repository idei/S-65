import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/avisos_model.dart';
import '../models/opciones_navbar.dart';
import 'env.dart';

class Avisos extends StatefulWidget {
  @override
  _AvisosState createState() => _AvisosState();
}

List<AvisosModel> avisos_items;
bool _isLoading = false;

class _AvisosState extends State<Avisos> {
  var responseDecode;
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
        title: Text('Mis Avisos',
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
      body: FutureBuilder<List<AvisosModel>>(
          future: read_avisos(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
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
                                      style: TextStyle(
                                          fontFamily: Theme.of(context)
                                              .textTheme
                                              .headline1
                                              .fontFamily)),
                                  subtitle: Text(data.fecha_limite,
                                      style: TextStyle(
                                          fontFamily: Theme.of(context)
                                              .textTheme
                                              .headline1
                                              .fontFamily)),
                                ),
                              ),
                            ),
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
                      'No tiene avisos',
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
    );
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
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
                fontWeight: font_bold,
              )),
          subtitle: Text(data.fecha_limite,
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
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
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
                fontWeight: font_bold,
              )),
          subtitle: Text(data.fecha_limite,
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
                fontWeight: font_bold,
              )),
        ),
      );
    }
  }

  var id_paciente_argument;

  Future<List<AvisosModel>> read_avisos() async {
    await getStringValuesSF();
    String URL_base = Env.URL_API;
    var url = URL_base + "/avisos_paciente";
    var response = await http.post(url, body: {
      "id_paciente": id_paciente_argument.toString(),
    });
    responseDecode = json.decode(response.body);

    if (response.statusCode == 200 && responseDecode['status'] != 'Vacio') {
      final List<AvisosModel> avisos_items = [];

      for (var avisos in responseDecode['data']) {
        avisos_items.add(AvisosModel.fromJson(avisos));
      }

      return avisos_items;
    } else {
      _isLoading = true;
      return null;
    }
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
