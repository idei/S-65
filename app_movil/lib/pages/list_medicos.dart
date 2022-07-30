import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'env.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

var id_paciente;
String nombre_medico;
String apellido_medico;
var especialidad;
var matricula;
var rela_medico;

class ListMedicos extends StatefulWidget {
  @override
  _ListMedicosState createState() => _ListMedicosState();
}

final _formKey = GlobalKey<_ListMedicosState>();
List<MedicoData> studentList;

class _ListMedicosState extends State<ListMedicos> {
  double _animatedHeight = 0.0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MedicoData>>(
      future: getMedicos(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
                leading: new IconButton(
                  icon: new Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pushNamed(context, '/menu');
                  },
                ),
                title: Text(
                  'Mis Médicos',
                  style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontSize: 14.2),
                )),
            body: Center(
              child: CircularProgressIndicator(
                semanticsLabel: "Cargando",
              ),
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
              title: Text(
                'Mis Médicos',
                style: TextStyle(
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily,
                    fontSize: 14.2),
              ),
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
            body: ListView(
              children: ListTile.divideTiles(
                color: Colors.black,
                tiles: snapshot.data
                    .map((data) => ListTile(
                          title: GestureDetector(
                            onTap: () {},
                            child: ListTile(
                              leading: Icon(
                                Icons.arrow_right_rounded,
                                color: Colors.blue,
                              ),
                              title: Text(
                                  data.nombre_medico +
                                      " " +
                                      data.apellido_medico,
                                  style: TextStyle(
                                      fontFamily: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .fontFamily)),
                              subtitle: Text(data.especialidad,
                                  style: TextStyle(
                                      fontFamily: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .fontFamily)),
                              trailing: Wrap(
                                spacing: 10, // space between two icons
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.text_snippet),
                                    color: Colors.green,
                                    onPressed: () {
                                      read_medico(context, data.rela_medico);
                                    },
                                  ), // icon-1
                                ],
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ).toList(),
            ),
          );
        }
      },
    );
  }

  void choiceAction(String choice) {
    if (choice == Constants.Ajustes) {
      Navigator.pushNamed(context, '/ajustes');
    } else if (choice == Constants.Salir) {
      Navigator.pushNamed(context, '/');
    }
  }
}

get_preference() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  id_paciente = prefs.getInt("id_paciente");

  print(prefs);
}

// String id_paciente = "fabricio@gmail.com";
List data_ant_pers = List();

Future<List<MedicoData>> getMedicos() async {
  await get_preference();

  String URL_base = Env.URL_PREFIX;

  var url = URL_base + "/read_list_medicos.php";

  var response = await http.post(
    url,
    body: {
      "id_paciente": id_paciente.toString(),
    },
  );

  if (response.body != "") {
    final items = json.decode(response.body).cast<Map<String, dynamic>>();

    studentList = items.map<MedicoData>((json) {
      return MedicoData.fromJson(json);
    }).toList();

    await new Future.delayed(new Duration(milliseconds: 1000));

    return studentList;
  } else {
    studentList = [];
    return studentList;
  }
}

class ViewPerfilMedico extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, '/list_medicos');
            },
          ),
          title: Text(
            'Perfil del Dr/a ',
            style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
                fontSize: 14.2),
          ),
          actions: <Widget>[
            PopupMenuButton<String>(
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
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(children: <Widget>[
                  CardPerfilMedico(),
                  SizedBox(
                    height: 30,
                  ),
                ]))));
  }
}

class CardPerfilMedico extends StatelessWidget {
  //const MyStatelessWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.person),
              title: Text("$nombre_medico $apellido_medico",
                  style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily)),
              subtitle: Text(
                  'Matricula: $matricula \n Especialidad: $especialidad',
                  style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily)),
            ),
          ],
        ),
      ),
    );
  }
}

read_medico(BuildContext context, var rela_medico) async {
  String URL_base = Env.URL_PREFIX;
  var url = URL_base + "/read_medico.php";
  var response = await http.post(url, body: {
    "rela_paciente": id_paciente.toString(),
  });

  print(response.body);
  var data = json.decode(response.body);

  if (data.length == 0) {
    print("No hay datos");
  } else {
    nombre_medico = data["nombre"];
    apellido_medico = data["apellido"];
    especialidad = data["especialidad"];
    matricula = data["matricula"];
    print(data);
    print(data);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ViewPerfilMedico()),
    );
  }
}

class MedicoData {
  String nombre_medico;
  String apellido_medico;
  String especialidad;
  var rela_medico;

  MedicoData({
    this.nombre_medico,
    this.apellido_medico,
    this.rela_medico,
    this.especialidad,
  });

  factory MedicoData.fromJson(Map<String, dynamic> json) {
    return MedicoData(
      nombre_medico: json['nombre'],
      apellido_medico: json['apellido'],
      rela_medico: json['id'],
      especialidad: json['especialidad'],
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
