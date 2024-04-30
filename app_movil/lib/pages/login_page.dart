import 'package:app_salud/models/usuario_model.dart';
import 'package:app_salud/services/departamento_service.dart';
import 'package:app_salud/services/device_utils.dart';
import 'package:app_salud/services/genero_service.dart';
import 'package:app_salud/services/grupo_conviviente_service.dart';
import 'package:app_salud/services/nivel_educativo_service.dart';
import 'package:app_salud/services/usuario_services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../services/session_service.dart';
import 'recuperar_contras.dart';
import 'env.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => _LoginPage();
}

final _formKey_ingresar = ObjectKey("key_login");

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
  var _obscureText = true;
  String _errorMessage;

  http.Client _client; // Cliente HTTP para realizar las solicitudes

  @override
  void initState() {
    _client = http.Client(); // Inicializar el cliente HTTP
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        key: UniqueKey(),
        body: WillPopScope(
          onWillPop: () async {
            Navigator.pushNamed(context, '/');
            return true;
          },
          child: Form(
            key: _formKey_ingresar,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Column(children: <Widget>[
                    Container(
                      child: Image.asset('assets/logo1.png'),
                      height: 110.0,
                    ),
                    InputEmailWidget(),
                    SizedBox(height: 30),
                    InputPasswordWidget(),
                    SizedBox(height: 30),
                    ButtonIniciarSesion(context),
                    SizedBox(height: 10),
                    GestureDetector(
                        child: Text("¿Olvido la contraseña?",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                fontSize: 15,
                                fontFamily: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    .fontFamily)),
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      RecuperarPage()));
                        }),
                    SizedBox(height: 20),
                    ButtonRegresar(context),
                  ]),
                )
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _client.close(); // Cerrar el cliente HTTP cuando la página se destruye
    super.dispose();
  }

  fetchLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final deviceName = await DeviceUtils.getDeviceName();
    var responseBody;

    String URL_base = Env.URL_API;

    var url = URL_base + "/login_paciente";

    var response = await _client.post(url, body: {
      "email": email.text,
      "password": password.text,
    });

    if (response.statusCode == 200) {
      responseBody = json.decode(response.body);
      if (responseBody['status'] == "Success") {
        Map userMap = responseBody;
        var usuarioModel = UsuarioModel.fromJsonLogin(userMap);

        final usuarioService =
            Provider.of<UsuarioServices>(context, listen: false);
        usuarioService.usuario = usuarioModel;

        estado_users = userMap['data']['paciente']['estado_users'];

        authProvider.login();

        await Provider.of<DepartamentoServices>(context, listen: false)
            .loadDepartamentos();
        await Provider.of<GeneroServices>(context, listen: false).loadGeneros();
        await Provider.of<NivelEducativoService>(context, listen: false)
            .loadNivelEducativo();
        await Provider.of<GrupoConvivienteServices>(context, listen: false)
            .loadGrupoConviviente();

        if (estado_users == "2" && responseBody['status'] == "Success") {
          Navigator.pushNamed(
            context,
            '/menu',
          );
        } else {
          if (estado_users == "1") {
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

  consult_preference() async {
    String URL_base = Env.URL_API;
    var url = URL_base + "/consult_preference";
    var response = await http.post(url, body: {"email": email.text});
    var responseDecoder = json.decode(response.body);

    if (responseDecoder['status'] == "Success") {
      estado_clinico = responseDecoder['data']['estado_users'];
      id_paciente = responseDecoder['data']['id_paciente'];
    } else {
      loginToast(responseDecoder['data']);
    }
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
            prefixIcon: Icon(Icons.mail_outline),
            labelText: 'Correo electrónico',
            labelStyle: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily)),
      ),
    );
  }

  _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Widget InputPasswordWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        controller: password,
        enabled: _isEnabled,
        obscureText: _obscureText,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock_outline),
            labelText: 'Contraseña',
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: _togglePasswordVisibility,
            ),
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
        primary: Color.fromRGBO(30, 20, 108, 1),
        maximumSize: const Size(400, 50),
        minimumSize: const Size(250, 40),
      ),
      icon: _isLoading
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: const CircularProgressIndicator(),
            )
          : SizedBox(),
      // : const Icon(Icons.email_outlined),
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
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Color.fromRGBO(30, 20, 108, 1),
        maximumSize: const Size(400, 50),
        minimumSize: const Size(250, 40),
      ),
      onPressed: () {
        Navigator.popAndPushNamed(context, '/');
      },
      child: Text('REGRESAR',
          style: TextStyle(
              color: Colors.white,
              fontFamily: Theme.of(context).textTheme.headline1.fontFamily)),
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

  loginToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }
}
