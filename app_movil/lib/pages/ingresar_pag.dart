import 'package:app_salud/pages/ajustes.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'recuperar_contras.dart';
import 'env.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'DashBoard.dart';

// Define a custom Form widget.
class IngresarPage extends StatefulWidget {
  @override
  _FormpruebaState createState() => _FormpruebaState();
}

final _formKey_ingresar = GlobalKey<FormState>();

class _FormpruebaState extends State<IngresarPage> {
//class IngresarPage extends StatelessWidget {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController nomb_apellido = TextEditingController();

  var estado_users;
  var estado_clinico;
  var id_paciente;
  String estado_read_date;

  String estado_login;

  Widget build(BuildContext context1) {
    return Scaffold(
        body: Form(
      key: _formKey_ingresar,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _login(context1),
        ],
      ),
    ));
  }

  set_preference() async {
    print("set prefe");
    await consult_preference();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.clear();

    prefs.setString("email_prefer", email.text);
    prefs.setInt("estado_clinico", estado_clinico);
    prefs.setInt("id_paciente", id_paciente);

    print(prefs);
  }

  consult_preference() async {
    print("consult prefe");
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/consult_preference.php";
    var response = await http.post(url, body: {"email": email.text});
    print(email.text);
    print("response");
    print(response.body);
    var data = json.decode(response.body);
    print("data");
    print(data);

    estado_read_date = data['estado_read_date'];

    if (estado_read_date == "Success") {
      estado_clinico = data['estado_users'];
    } else {
      loginToast("Error en counsult preference");
    }
  }

  login() async {
    print("Login");
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/user_login.php";
    var response = await http.post(url, body: {
      "email": email.text,
      "password": password.text,
    });
    print(response.body);
    var data = json.decode(response.body);
    print(data);

    estado_login = data['estado_login'];
    id_paciente = data['id_paciente'];

    if (estado_login == "Success") {
      estado_users = data['estado_users'];

      if (estado_users == 2 && estado_login == "Success") {
        set_preference();
        print(email.text);
        Navigator.pushNamed(context, '/menu',
            arguments: {"email": email.text, "id_paciente": id_paciente});
      } else {
        if (estado_users == 1 && estado_login == "Success") {
          Navigator.pushNamed(context, '/form_datos_generales', arguments: {
            "email": email.text,
            "id_paciente": data['estado_users']
          });
        }
      }

      loginToast(estado_login);
    } else {
      loginToast(estado_login + ": Usuario o contraseña incorrectos");
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

  Widget _login(BuildContext context) {
    return Container(
      child: Column(children: <Widget>[
        Container(
          child: Image.asset('assets/logo1.png'),
          height: 110.0,
        ),
        _crearEmail(),
        SizedBox(height: 30),
        _crearPassword(),
        SizedBox(height: 30),
        _crearBotonSesion(context),
        SizedBox(height: 10),
        GestureDetector(
            child: Text("¿Olvido la contraseña?",
                style: TextStyle(fontFamily: 'NunitoR')),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => RecuperarPage()));
              //Navigator.pushNamed(context, '/recuperar');
            }), // do what you need to do when "Click here" gets clicked

        SizedBox(height: 20),
        _crearBotonRegresar(context),
      ]),
    );
  }

  Widget _crearEmail() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        controller: email,
        validator: (value) => EmailValidator.validate(value)
            ? null
            : "Por favor ingresar un correo electrónico válido",
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            labelText: 'Correo electrónico',
            labelStyle: TextStyle(fontFamily: 'NunitoR')),
      ),
    );
  }

  Widget _crearPassword() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'Por favor ingrese una contraseña';
          }
          return null;
        },
        controller: password,
        obscureText: true,
        decoration: InputDecoration(
            labelText: 'Contraseña',
            labelStyle: TextStyle(fontFamily: 'NunitoR')),
      ),
    );
  }

  Widget _crearBotonSesion(BuildContext context) {
    return ElevatedButton(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 15.0),
        child: Text('INICIAR SESION',
            style: TextStyle(color: Colors.white, fontFamily: 'Nunito')),
      ),
      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      style: ButtonStyle(
          //backgroundColor: Theme.of(context).primaryColor,
          //textStyle: Colors.white,
          ),

      //textColor: Colors.white,
      onPressed: () {
        //if (_formKey_ingresar.currentState.validate()) {
        login();
        if (estado_users == 2 && estado_login == "Success menu") {
          Navigator.pushNamed(context, '/menu');
          //} else {
          if (estado_users == 1 && estado_login == "Success datos") {
            Navigator.pushNamed(context, '/menu');
          }
        }
        //}

        //Navigator.pushNamed(context, 'datospersonales');
      },
    );
  }

  Widget _crearBotonRegresar(BuildContext context) {
    return RaisedButton(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
        child: Text('REGRESAR',
            style: TextStyle(color: Colors.white, fontFamily: 'Nunito')),
      ),
      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      color: Theme.of(context).primaryColor,
      textColor: Colors.white,
      onPressed: () {
        Navigator.pushNamed(context, '/');
      },
    );
  }
}
