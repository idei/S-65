import 'package:app_salud/models/usuario_model.dart';
import 'package:app_salud/services/usuario_services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'recuperar_contras.dart';
import 'env.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => _LoginPage();
}

GlobalKey<FormState> _formKey_ingresar =
    GlobalKey<FormState>(debugLabel: 'GlobalFormKey #Login ');

class _LoginPage extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController nomb_apellido = TextEditingController();

  var estado_users;
  var estado_clinico;
  var id_paciente;
  var tokenId;
  String estado_read_date;
  String estado_login;

  Widget build(BuildContext context) {
    final usuarioService = Provider.of<UsuarioServices>(context);

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
    await consult_preference();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt("id_paciente", id_paciente);
  }

  consult_preference() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/consult_preference.php";
    var response = await http.post(url, body: {"email": email.text});

    var data = json.decode(response.body);

    estado_read_date = data['request'];

    if (estado_read_date == "Success") {
      estado_clinico = data['estado_users'];
      id_paciente = data['id_paciente'];
    } else {
      loginToast("Error en counsult preference");
    }
  }

  fetchLogin() async {
    String URL_base = Env.URL_API;

    var url = URL_base + "/login_paciente";

    var response = await http.post(url, body: {
      "email": email.text,
      "password": password.text,
    });

    var responseBody = json.decode(response.body);

    if (response.statusCode == 200) {
      if (responseBody['status'] == "Success") {
        Map userMap = responseBody;
        var usuarioModel = UsuarioModel.fromJsonLogin(userMap);

        final usuarioService =
            Provider.of<UsuarioServices>(context, listen: false);
        usuarioService.usuario = usuarioModel;

        estado_users = userMap['data']['paciente']['estado_users'];

        if (estado_users == "2" && responseBody['status'] == "Success") {
          set_preference();
          Navigator.pushNamed(
            context,
            '/menu',
          );
        } else {
          if (estado_users == 1) {
            Navigator.pushNamed(
              context,
              '/form_datos_generales',
            );
          }
        }
        loginToast('Cargando información');
      }
      if (responseBody['status'] == 'Fail Session') {
        _alert_informe(context, 'Usuario o contraseña incorrectos', 2);
      }
    } else {
      _alert_informe(context, "Error: " + responseBody['request'], 2);
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

  _alert_informe(context, message, colorNumber) {
    var color;
    colorNumber == 1 ? color = Colors.green[800] : color = Colors.red[600];

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: color,
      content: Text(message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white)),
    ));
  }
}
