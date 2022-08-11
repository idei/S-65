import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'recuperar_contras.dart';
import 'env.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => _LoginPage();
}

GlobalKey<FormState> _formKey_ingresar = GlobalKey<FormState>();

class _LoginPage extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController nomb_apellido = TextEditingController();

  var estado_users;
  var estado_clinico;
  var id_paciente;
  String estado_read_date;
  String estado_login;

  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: _formKey_ingresar,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          LoginWidget(context),
        ],
      ),
    ));
  }

  set_preference() async {
    print("set prefe");
    await consult_preference();
    SharedPreferences prefs = await SharedPreferences.getInstance();

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

  fetchLogin() async {
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

    setState(() {
      AlertDialog(
        title: Text('Cargando'),
      );
    });

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

  Widget LoginWidget(BuildContext context1) {
    return Container(
      child: Column(children: <Widget>[
        Container(
          child: Image.asset('assets/logo1.png'),
          height: 110.0,
        ),
        InputEmailWidget(),
        SizedBox(height: 30),
        InputPasswordWidget(),
        SizedBox(height: 30),
        ButtonIniciarSesion(context1),
        SizedBox(height: 10),
        GestureDetector(
            child: Text("¿Olvido la contraseña?",
                style: TextStyle(
                    fontFamily:
                        Theme.of(context1).textTheme.headline1.fontFamily)),
            onTap: () {
              Navigator.pushReplacement(
                  context1,
                  MaterialPageRoute(
                      builder: (BuildContext context) => RecuperarPage()));
            }),
        SizedBox(height: 20),
        ButtonRegresar(context1),
      ]),
    );
  }

  Widget InputEmailWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        controller: email,
        enabled: _isEnabled,
        validator: (value) => EmailValidator.validate(value)
            ? null
            : "Por favor ingresar un correo electrónico válido",
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            labelText: 'Correo electrónico',
            labelStyle: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily)),
      ),
    );
  }

  Widget InputPasswordWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        controller: password,
        enabled: _isEnabled,
        obscureText: true,
        decoration: InputDecoration(
            labelText: 'Contraseña',
            labelStyle: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily)),
        validator: (value) {
          if (value.isEmpty) {
            return 'Por favor ingrese una contraseña';
          }
          return null;
        },
      ),
    );
  }

  bool _isLoading = false;
  bool _isEnabled = true;

  Widget ButtonIniciarSesion(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        maximumSize: const Size(400, 50),
        minimumSize: const Size(250, 40),
      ),
      icon: _isLoading
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: const CircularProgressIndicator(),
            )
          : const Icon(Icons.email_outlined),
      label: Text(_isLoading ? 'Cargando...' : 'INICIAR SESION',
          style: TextStyle(
              color: Colors.white,
              fontFamily: Theme.of(context).textTheme.headline1.fontFamily)),
      onPressed: _isLoading ? null : _startLoading,
    );
  }

  void _startLoading() async {
    setState(() {
      _isLoading = true;
      _isEnabled = false;
    });

    await fetchLogin();

    setState(() {
      _isLoading = false;
      _isEnabled = true;
    });

    if (estado_users == 2 && estado_login == "Success menu") {
      Navigator.pushNamed(context, '/menu');

      if (estado_users == 1 && estado_login == "Success datos") {
        Navigator.pushNamed(context, '/menu');
      }
    }
  }

  Widget ButtonRegresar(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(Icons.arrow_circle_left_outlined),
      label: Text('REGRESAR',
          style: TextStyle(
              color: Colors.white,
              fontFamily: Theme.of(context).textTheme.headline1.fontFamily)),
      style: ElevatedButton.styleFrom(
        maximumSize: const Size(400, 50),
        minimumSize: const Size(250, 40),
      ),
      onPressed: () {
        Navigator.popAndPushNamed(context, '/');
      },
    );
  }
}
