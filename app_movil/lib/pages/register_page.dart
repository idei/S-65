import 'package:app_salud/models/usuario_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../services/usuario_services.dart';
import 'env.dart';
import 'dart:convert';
import 'package:email_validator/email_validator.dart';

TextEditingController emailPaciente = TextEditingController();
TextEditingController passwordNuevo = TextEditingController();
TextEditingController nombrePaciente = TextEditingController();
TextEditingController apellidoPaciente = TextEditingController();
TextEditingController passwordRepetido = TextEditingController();
TextEditingController dni = TextEditingController();

// Define a custom Form widget.
class RegisterPage extends StatefulWidget {
  @override
  _FormRegisterState createState() => _FormRegisterState();
}

GlobalKey<FormState> _formKey_registrar = GlobalKey<FormState>();

class _FormRegisterState extends State<RegisterPage> {
  bool acepto = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
          key: _formKey_registrar,
          child: SingleChildScrollView(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(5.0),
                  ),
                  Container(
                    child: Image.asset('assets/logo1.png'),
                    height: 110.0,
                  ),
                  Column(children: <Widget>[
                    _crearEmail(),
                    SizedBox(height: 10),
                    _crearPassword(),
                    SizedBox(height: 10),
                    _repetirPassword(),
                    SizedBox(height: 10),
                    _crearApellido(),
                    SizedBox(height: 10),
                    _crearNombre(),
                    SizedBox(height: 10),
                    _crearDNI(),
                    SizedBox(height: 10),
                    _crearCheck(),
                    SizedBox(height: 10),
                    _crearBotonRegistrar(context),
                    SizedBox(height: 10),
                    _crearBotonRegresar(context),
                    SizedBox(height: 20),
                  ])
                ],
              ),
            ),
          ),
        ));
  }

  registerPaciente() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/user_register";
    var response = await http.post(url, body: {
      "email": emailPaciente.text,
      "password": passwordNuevo.text,
      "nombre": nombrePaciente.text,
      "apellido": apellidoPaciente.text,
      "dni": dni.text,
    });

    var responseDecoder = json.decode(response.body);

    if (responseDecoder['status'] == "Success" && response.statusCode == 200) {
      Map userMap = json.decode(response.body);
      var newUsuarioModel = UsuarioModel.fromJson(userMap);

      final usuarioService =
          Provider.of<UsuarioServices>(context, listen: false);
      usuarioService.usuario = newUsuarioModel;
      //---------------------------

      Navigator.pushNamed(context, '/form_datos_generales', arguments: {
        'nombre': newUsuarioModel.paciente.nombre,
        "apellido": apellidoPaciente.text,
        "dni": dni.text,
        "email": emailPaciente.text,
        "bandera": 1,
      });
    } else {
      var error = response.statusCode + responseDecoder['data'];
      loginToast(error.toString());
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

  Widget _crearCheck() {
    return Row(children: <Widget>[
      Checkbox(
        value: acepto,
        onChanged: (value) {
          setState(() {
            acepto = value;
          });
        },
      ),
      Text('Acepto términos y condiciones',
          style: TextStyle(
              fontFamily: Theme.of(context).textTheme.headline1.fontFamily))
    ]);
  }

  Widget _crearEmail() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        controller: emailPaciente,
        validator: (value) => EmailValidator.validate(value)
            ? null
            : "Por favor ingresar un correo electrónico válido",
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: 'Correo electrónico',
          labelStyle: TextStyle(
              fontFamily: Theme.of(context).textTheme.headline1.fontFamily),
          hintText: 'ejemplo@gmail.com',
          suffixIcon: Icon(Icons.email_outlined),
          //icon: Icon(Icons.abc)
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'Por favor ingrese un Nombre';
          }
          return null;
        },
        keyboardType: TextInputType.name,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          labelText: 'Nombre',
          labelStyle: TextStyle(
              fontFamily: Theme.of(context).textTheme.headline1.fontFamily),
          suffixIcon: Icon(Icons.person),
        ),
        controller: nombrePaciente,
      ),
    );
    // });
  }

  Widget _crearDNI() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'Por favor ingrese un DNI';
          }
          return null;
        },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'DNI',
          labelStyle: TextStyle(
              fontFamily: Theme.of(context).textTheme.headline1.fontFamily),
          suffixIcon: Icon(Icons.tab_outlined),
        ),
        controller: dni,
      ),
    );
    // });
  }

  Widget _crearApellido() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'Por favor ingrese Apellido';
          }
          return null;
        },
        textCapitalization: TextCapitalization.words,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'Apellido',
          labelStyle: TextStyle(
              fontFamily: Theme.of(context).textTheme.headline1.fontFamily),
          suffixIcon: Icon(Icons.person),
        ),
        controller: apellidoPaciente,
      ),
    );
    // });
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
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Contraseña',
          labelStyle: TextStyle(
              fontFamily: Theme.of(context).textTheme.headline1.fontFamily),
          suffixIcon: Icon(Icons.password),
        ),
        controller: passwordNuevo,
      ),
    );
  }

//modificar
  Widget _repetirPassword() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'Por favor repita la contraseña';
          }
          return null;
        },
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Repetir Contraseña',
          labelStyle: TextStyle(
              fontFamily: Theme.of(context).textTheme.headline1.fontFamily),
          suffixIcon: Icon(Icons.repeat),
        ),
        controller: passwordRepetido,
      ),
    );
  }

  bool _isLoading = false;
  bool _isEnabled = true;

  Widget _crearBotonRegistrar(BuildContext context) {
    return ElevatedButton.icon(
      icon: _isLoading
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: const CircularProgressIndicator(color: Colors.white70),
            )
          : const Icon(Icons.email_outlined),
      label: Container(
        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
        child: Text('REGISTRARME',
            style: TextStyle(
              color: Colors.white,
              fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
            )),
      ),
      onPressed: () {
        if (_formKey_registrar.currentState.validate() && acepto == true) {
          if (passwordNuevo.text == passwordRepetido.text) {
            if (!_isLoading) {
              _startLoading();
            }
          } else {
            loginToast("Las contraseñas no coinciden");
          }
        } else {
          if (!acepto) {
            loginToast("Debe aceptar los términos y condiciones");
          }
        }
      },
    );
  }

  void _startLoading() async {
    setState(() {
      _isLoading = true;
      _isEnabled = false;
    });

    await registerPaciente();

    setState(() {
      _isLoading = false;
      _isEnabled = true;
    });
  }

  Widget _crearBotonRegresar(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(Icons.arrow_back),
      label: Container(
        padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
        child: Text('REGRESAR',
            style: TextStyle(
              color: Colors.white,
              fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
            )),
      ),
      onPressed: () {
        Navigator.popAndPushNamed(context, '/');
      },
    );
  }
}
