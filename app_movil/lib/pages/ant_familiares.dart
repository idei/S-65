import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'env.dart';
import 'package:app_salud/pages/ajustes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AntecedenteModel {
  String antecedenteDescripcion;

  AntecedenteModel({this.antecedenteDescripcion});

  factory AntecedenteModel.fromJson(Map<String, dynamic> json) {
    return AntecedenteModel(antecedenteDescripcion: json['nombre_evento']);
  }
}

class AntecedentesFamPage extends StatefulWidget {
  @override
  _AntecedentesPerState createState() => _AntecedentesPerState();
}

String email;
final _formKey = GlobalKey<_AntecedentesPerState>();

class _AntecedentesPerState extends State<AntecedentesFamPage> {
  bool isLoading = false;
  List<AntecedenteModel> listAntecFamiliares = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map parametros = ModalRoute.of(context).settings.arguments;
    if (parametros != null) {
      email = parametros['email'];
      print(email);
    } else {
      get_preference();
    }

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, '/menu');
            },
          ),
          title: Text(
            'Antecedentes Familiares Registrados ',
            style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
                fontSize: 14.2),
          )),
      body: Container(
        child: FutureBuilder<List<AntecedenteModel>>(
          future: fetchStudents(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: listAntecFamiliares.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title:
                        Text("${snapshot.data[index].antecedenteDescripcion}",
                            style: TextStyle(
                              fontFamily: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  .fontFamily,
                            )),
                  );
                },
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
                    alignment: Alignment.topCenter,
                    child: ListTile(
                        title: Text(
                      'No tiene antecedentes familiares',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily:
                              Theme.of(context).textTheme.headline1.fontFamily),
                    )));
              }
            }
          },
        ),
      ),
      floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/form_antecedentes_familiares',
                    arguments: {
                      "email": email,
                    });
              },
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width / 8.3,
                child: new Column(children: <Widget>[
                  SizedBox(height: 10.0),
                  Icon(Icons.edit, color: Colors.white, size: 40.0),
                  SizedBox(height: 10.0),
                  Text(
                    'Modificar',
                    style: new TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                    ),
                  )
                ]),
              ),
            )
          ]),
    );
  }

  void choiceAction(String choice) {
    if (choice == Constants.Ajustes) {
      Navigator.pushNamed(context, '/ajustes');
    } else if (choice == Constants.Salir) {
      Navigator.pushNamed(context, '/');
    }
  }

  get_preference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString("email_prefer");

    print(prefs);
  }

  Future<List<AntecedenteModel>> fetchStudents() async {
    await get_preference();

    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/read_list_familiares.php";
    var response = await http.post(url, body: {"email": email});
    if (response.body != "") {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();

      listAntecFamiliares = items.map<AntecedenteModel>((json) {
        return AntecedenteModel.fromJson(json);
      }).toList();
      //isLoading = true;
      return listAntecFamiliares;
    } else {
      isLoading = true;
      return null;
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
