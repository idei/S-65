import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'login_page.dart';
import 'package:http/http.dart' as http;
import 'env.dart';
import 'dart:convert';

TextEditingController dni = TextEditingController();

class RecuperarPage extends StatefulWidget {
  @override
  _RecuperarState createState() => _RecuperarState();
}

final _formKey_recuperar = GlobalKey<FormState>();

class _RecuperarState extends State<RecuperarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(30, 20, 108, 1),
          leading: IconButton(
            icon: CircleAvatar(
              radius: MediaQuery.of(context).size.width / 30,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.arrow_back,
                color: Colors.blue,
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, 'ingresar');
            },
          ),
          title: Text('Recuperación de Contraseña',
              style: TextStyle(
                  fontFamily:
                      Theme.of(context).textTheme.headline1.fontFamily)),
        ),
        body: Center(
          child: Form(
              key: UniqueKey(),
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(children: <Widget>[
                    TextFormField(
                      controller: dni,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Por favor ingrese su DNI';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Ingrese su Dni'),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromRGBO(30, 20, 108, 1),
                          textStyle: TextStyle(
                              fontFamily: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  .fontFamily),
                        ),
                        child: Container(
                          child: Text('Recuperar'),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      MostrarPass()));
                        },
                      ),
                    )
                  ]))),
        ));
  }
}

var mensajeRetornado;

Future get_pass() async {
  String URL_base = Env.URL_API;
  var url = URL_base + "/recuperar_pass";
  var response = await http.post(url, body: {
    "dni": dni.text,
  });

  mensajeRetornado = json.decode(response.body);

  if (mensajeRetornado['status'] == "Success") {
    print("Se ha recuperado la contraseña");
  } else {
    loginToast(
        "No se ha recuperado la contraseña : " + mensajeRetornado['status']);
  }

  return true;
}

loginToast(String toast) {
  return Fluttertoast.showToast(
      msg: toast,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white);
}

class MostrarPass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        key: UniqueKey(),
        future: get_pass(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (mensajeRetornado["estado"] == "Error") {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Color.fromRGBO(157, 19, 34, 1),
                  title: Text('Recuperar Contraseña'),
                  actions: <Widget>[],
                ),
                body: Center(
                  child: Text(mensajeRetornado["estado"]),
                ),
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Color.fromRGBO(157, 19, 34, 1),
                  title: Text('Recuperación de Contraseña'),
                  automaticallyImplyLeading: false,
                ),
                body: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text("Su contraseña es: "),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: mensajeRetornado["password"]),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 60.0, vertical: 15.0),
                            child: Text('Volver a Iniciar Sesión'),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        LoginPage()));
                          },
                        )
                      ],
                    )),
              );
            }
          } else {
            return Scaffold(
              key: UniqueKey(),
              appBar: AppBar(
                  backgroundColor: Color.fromRGBO(157, 19, 34, 1),
                  title: Text('Recuperación de Contraseña')),
              body: Center(
                child: CircularProgressIndicator(
                  semanticsLabel: "Cargando",
                ),
              ),
            );
          }
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
