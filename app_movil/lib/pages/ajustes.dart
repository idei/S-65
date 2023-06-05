import 'package:flutter/material.dart';
import 'package:app_salud/pages/form_datos_generales.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'env.dart';

TextEditingController email = TextEditingController();
TextEditingController email_nuevo = TextEditingController();
TextEditingController password = TextEditingController();
TextEditingController password_nuevo = TextEditingController();
String email_set_shared;

class AjustesPage extends StatefulWidget {
  @override
  _AjustesState createState() => _AjustesState();
}

final _formKey_ajustes = GlobalKey<FormState>();
final _formKey_email = GlobalKey<FormState>();
final _formKey_pass = GlobalKey<FormState>();

class _AjustesState extends State<AjustesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //backgroundColor: Color.fromRGBO(157, 19, 34, 1),
          title: Text('Ajustes',
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
            key: _formKey_ajustes,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        //primary: Color.fromRGBO(157, 19, 34, 1),
                        ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ModificarEmail(context)),
                      );
                    },
                    child: Text(
                      'Modificar Correo Electrónico',
                      style: (TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily,
                      )),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ModificarPass(context)),
                      );
                    },
                    child: Text('Modificar Contraseña',
                        style: (TextStyle(
                          fontFamily:
                              Theme.of(context).textTheme.headline1.fontFamily,
                        ))),
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

  Widget ModificarEmail(BuildContext context) {
    set_email();
    return Scaffold(
        appBar: AppBar(
          //backgroundColor: Color.fromRGBO(157, 19, 34, 1),
          title: Text('Ajustes',
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
            key: _formKey_email,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(children: <Widget>[
                  TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                        labelText: 'Ingrese Correo Electrónico actual'),
                    validator: (val) => val.isEmpty || !val.contains("@")
                        ? "Por favor ingresar un correo electrónico válido"
                        : null,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      controller: email_nuevo,
                      decoration: InputDecoration(
                          labelText: 'Ingrese Correo Electrónico nuevo'),
                      validator: (val) => val.isEmpty || !val.contains("@")
                          ? "Por favor ingresar un correo electrónico válido"
                          : null,
                      keyboardType: TextInputType.emailAddress),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        //primary: Color.fromRGBO(157, 19, 34, 1),
                        ),
                    onPressed: () {
                      if (_formKey_email.currentState.validate()) {
                        modificar_email(context);
                      }
                    },
                    child: Text('Modificar Correo',
                        style: (TextStyle(
                          fontFamily:
                              Theme.of(context).textTheme.headline1.fontFamily,
                        ))),
                  ),
                ]))));
  }

  set_email() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email_set_shared = prefs.getString("email_prefer");
    print(email_set_shared);
  }

  Widget ModificarPass(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //backgroundColor: Color.fromRGBO(157, 19, 34, 1),
          title: Text('Ajustes',
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
            key: _formKey_pass,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(children: <Widget>[
                  TextFormField(
                    controller: password,
                    decoration:
                        InputDecoration(labelText: 'Ingrese Contraseña actual'),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Por favor ingrese una contraseña";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      controller: password_nuevo,
                      decoration: InputDecoration(
                          labelText: 'Ingrese Contraseña nueva'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Por favor ingrese una contraseña";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        //primary: Color.fromRGBO(157, 19, 34, 1),
                        ),
                    onPressed: () {
                      if (_formKey_pass.currentState.validate()) {
                        modificar_pass(context);
                        //Navigator.pushNamed(context, '/ajustes');
                      }
                    },
                    child: Text('Modificar Contraseña',
                        style: (TextStyle(
                          fontFamily:
                              Theme.of(context).textTheme.headline1.fontFamily,
                        ))),
                  ),
                ]))));
  }
}

var data;

modificar_pass(context) async {
  String URL_base = Env.URL_API;
  var url = URL_base + "/modificar_pass";
  var response = await http.post(url, body: {
    "email": email.text,
    "password": password.text,
    "password_nuevo": password_nuevo.text,
  });

  var jsonDate = json.decode(response.body);

  if (jsonDate["status"] == "Success") {
    Navigator.pushNamed(context, '/ajustes');
  } else {
    print(data["status"]);
  }
}

modificar_email(context) async {
  String URL_base = Env.URL_API;
  var url = URL_base + "/modificar_email";
  var response = await http.post(url, body: {
    "email": email.text,
    "email_nuevo": email_nuevo.text,
  });
  print(response);
  var jsonBody = response.body;
  var jsonDate = json.decode(jsonBody);

  if (jsonDate["status"] == "Success") {
    update_email();

    Navigator.pushNamed(context, '/ajustes');
  } else {
    print(jsonDate["status"]);
  }
  print(jsonDate);
}

update_email() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("email_prefer", email_nuevo.text);
  String salida = prefs.getString("email_prefer");
  print(salida);
}

//update_pass() async {
//SharedPreferences prefs = await SharedPreferences.getInstance();
//prefs.setString("email_prefer", password_nuevo.text);
//String salida = prefs.getString("email_prefer");
//print(salida);
//}

class Constants {
  static const String Ajustes = 'Ajustes';
  static const String Salir = 'Salir';
  static const List<String> choices = <String>[
    Ajustes,
    Salir,
  ];
}
