import 'package:flutter/material.dart';
import 'package:app_salud/pages/form_datos_generales.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'env.dart';

var id_paciente;
var tipo_screening;
var result_code;

class NewScreening extends StatefulWidget {
  @override
  _NewScreeningState createState() => _NewScreeningState();
}

final _formKey = GlobalKey<FormState>();

getStringValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String email_prefer = prefs.getString("email_prefer");
  email_argument = email_prefer;
  id_paciente = prefs.getInt("id_paciente");
  print(email_argument);
}

class _NewScreeningState extends State<NewScreening> {
  @override
  Widget build(BuildContext context) {
    getStringValuesSF();

    return Scaffold(
        appBar: AppBar(
          title: Text('Nuevo Screening',
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
            )
          ],
        ),
        body: Form(
            key: _formKey,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(children: <Widget>[
                  FormScrinnings(),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(),
                    onPressed: () {
                      consult_code(context);
                    },
                    child: Text('Hacer',
                        style: TextStyle(
                          fontFamily:
                              Theme.of(context).textTheme.headline1.fontFamily,
                        )),
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

consult_code(BuildContext context) async {
  String URL_base = Env.URL_PREFIX;
  var url = URL_base + "/read_code_screening.php";
  var response = await http.post(url, body: {
    "id_screening": tipo_screening.toString(),
  });
  result_code = json.decode(response.body);
  print(result_code);

  if (result_code == "SFMS") {
    Navigator.of(context).pushReplacementNamed('/screening_fisico', arguments: {
      "tipo_screening": tipo_screening,
      "bandera": "screening_nuevo"
    });
  } else {
    if (result_code == "QCQ") {
      Navigator.of(context).pushReplacementNamed('/screening_queja_cognitiva',
          arguments: {
            "tipo_screening": tipo_screening,
            "bandera": "screening_nuevo"
          });
    } else {
      if (result_code == "ANIMO") {
        Navigator.of(context).pushReplacementNamed('/screening_animo',
            arguments: {
              "tipo_screening": tipo_screening,
              "bandera": "screening_nuevo"
            });
      } else {
        if (result_code == "CONDUC") {
          Navigator.of(context).pushReplacementNamed('/screening_conductual',
              arguments: {
                "tipo_screening": tipo_screening,
                "bandera": "screening_nuevo"
              });
        } else {
          if (result_code == "CDR") {
            Navigator.of(context).pushReplacementNamed('/screening_cdr',
                arguments: {
                  "tipo_screening": tipo_screening,
                  "bandera": "screening_nuevo"
                });
          } else {
            if (result_code == "RNUTRI") {
              Navigator.of(context)
                  .pushReplacementNamed('/screening_nutricional', arguments: {
                "tipo_screening": tipo_screening,
                "bandera": "screening_nuevo"
              });
            }
          }
        }
      }
    }
  }
}

// ----------------------- WIDGET SCREENINGS -----------------------------------------------------------------------------------

class FormScrinnings extends StatefulWidget {
  FormScrinnings({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<FormScrinnings> {
  List data = List();

  Future getAllName() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/screenings.php";
    var response = await http.post(url, body: {});
    print(response);
    var jsonBody = response.body;
    var jsonDate = json.decode(jsonBody);
    setState(() {
      data = jsonDate;
    });
    print(jsonDate);
  }

  @override
  void initState() {
    super.initState();
    getAllName();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        hint: Text("Screenings"),
        value: tipo_screening,
        /*icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),*/
        items: data.map(
          (list) {
            return DropdownMenuItem<String>(
              child: Text(list['nombre']),
              value: list['id'].toString(),
            );
          },
        ).toList(),
        onChanged: (String newValue) {
          setState(() {
            tipo_screening = newValue;
          });
        });
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
