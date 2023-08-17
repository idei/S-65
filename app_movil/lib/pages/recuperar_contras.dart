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

class _RecuperarState extends State<RecuperarPage> {
  final _formKey_recuperar = GlobalKey<FormState>();

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
              key: _formKey_recuperar,
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
                            if (_formKey_recuperar.currentState.validate() &&
                                !_isLoading) {
                              _startLoading();
                            } else {
                              null;
                            }
                          }),
                    )
                  ]))),
        ));
  }

  bool _isLoading = false;
  void _startLoading() async {
    setState(() {
      _isLoading = true;
    });

    await get_pass(context);

    setState(() {
      _isLoading = false;
    });
  }
}

var mensajeRetornado;

Future get_pass(BuildContext context) async {
  String URL_base = Env.URL_API;
  var url = URL_base + "/recuperar_pass";
  var response = await http.post(url, body: {
    "dni": dni.text,
  });

  mensajeRetornado = json.decode(response.body);

  if (mensajeRetornado['status'] == "Success") {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => MostrarPass()));
  } else {
    loginToast(
        "No se ha recuperado la contraseña : " + mensajeRetornado['status']);
  }
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
    final _formKey_mostrar_pass = GlobalKey<FormState>();
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
        title: Text('Recuperar Contraseña',
            style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily)),
      ),
      key: UniqueKey(),
      body: Center(
        child:
            Text("Su contraseña es: " + mensajeRetornado["data"]["password"]),
      ),
    );
  }
}
