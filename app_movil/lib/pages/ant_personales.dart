import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'env.dart';
import 'package:app_salud/pages/ajustes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Studentdata {
  String studentName;

  Studentdata({this.studentName});

  factory Studentdata.fromJson(Map<String, dynamic> json) {
    return Studentdata(studentName: json['nombre_evento']);
  }
}

class AntecedentesPerPage extends StatefulWidget {
  @override
  _AntecedentesPerState createState() => _AntecedentesPerState();
}

String email;
final _formKey = GlobalKey<_AntecedentesPerState>();

class _AntecedentesPerState extends State<AntecedentesPerPage> {
  double _animatedHeight = 0.0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Studentdata>>(
      future: fetchStudents(),
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
                'Antecedentes Personales Registrados',
                style: TextStyle(fontFamily: 'Nunito', fontSize: 14.2),
              ),
              //backgroundColor: Color.fromRGBO(157, 19, 34, 1),
              //backgroundColor: Color.fromRGBO(157, 19, 34, 1),
            ),
            body: Center(
              child: CircularProgressIndicator(
                semanticsLabel: "Cargando",
              ),
            ),
            floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, '/form_antecedentes_personales');
                    },
                    child: CircleAvatar(
                      radius: MediaQuery.of(context).size.width / 8.3,
                      //backgroundColor: Color.fromRGBO(157, 19, 34, 1),
                      //backgroundColor: Color.fromRGBO(157, 19, 34, 1),
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
                              fontFamily: 'NunitoR'),
                        )
                      ]),
                    ),
                  )
                ]),
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
              title: Text(
                'Antecedentes Personales Registrados',
                style: TextStyle(fontFamily: 'Nunito', fontSize: 14.2),
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
                          title: Text(data.studentName,
                              style: TextStyle(fontFamily: 'NunitoR')),
                        ))
                    .toList(),
              ).toList(),
            ),
            floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, '/form_antecedentes_personales');
                    },
                    child: CircleAvatar(
                      radius: MediaQuery.of(context).size.width / 8.3,
                      //backgroundColor: Color.fromRGBO(157, 19, 34, 1),
                      //backgroundColor: Color.fromRGBO(157, 19, 34, 1),
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
                              fontFamily: 'Nunito'),
                        )
                      ]),
                    ),
                  )
                ]),
          );
        }
      },
    );
  }

  void choiceAction(String choice) {
    if (choice == Constants.Ajustes) {
      Navigator.pushNamed(context, '/ajustes');
    } else if (choice == Constants.Salir) {
      print('Salir');
    }
  }

  get_preference() async {
    print("Hola");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString("email_prefer");
    print(email);
  }

  //String email = "fabricio@gmail.com";

  Future<List<Studentdata>> fetchStudents() async {
    await get_preference();

    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/read_list.php";
    var response = await http.post(url, body: {"email": email});
    print(response.body);
    if (response.body != "") {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();

      List<Studentdata> studentList = items.map<Studentdata>((json) {
        return Studentdata.fromJson(json);
      }).toList();

      await new Future.delayed(new Duration(milliseconds: 1000));

      return studentList;
    } else {
      return null;
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
