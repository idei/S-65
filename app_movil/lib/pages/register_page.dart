import 'package:app_salud/models/usuario_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../services/departamento_service.dart';
import '../services/genero_service.dart';
import '../services/grupo_conviviente_service.dart';
import '../services/nivel_educativo_service.dart';
import '../services/session_service.dart';
import '../services/usuario_services.dart';
import 'env.dart';
import 'dart:convert';
import 'package:email_validator/email_validator.dart';

final emailPaciente = TextEditingController();
final passwordNuevo = TextEditingController();
final nombrePaciente = TextEditingController();
final apellidoPaciente = TextEditingController();
final passwordRepetido = TextEditingController();
final dni = TextEditingController();

// Define a custom Form widget.
class RegisterPage extends StatefulWidget {
  @override
  _FormRegisterState createState() => _FormRegisterState();
}

final _formKey_registrar = GlobalKey<FormState>();

class _FormRegisterState extends State<RegisterPage> {
  bool acepto = false;

  @override
  void initState() {
    emailPaciente.text = '';
    passwordNuevo.text = '';
    nombrePaciente.text = '';
    apellidoPaciente.text = '';
    passwordRepetido.text = '';
    dni.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: UniqueKey(),
        resizeToAvoidBottomInset: false,
        body: Form(
          key: _formKey_registrar,
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
                  CheckBoxCondiciones(),
                  SizedBox(height: 10),
                  _crearBotonRegistrar(context),
                  SizedBox(height: 10),
                  _crearBotonRegresar(context),
                  SizedBox(height: 20),
                ])
              ],
            ),
          ),
        ));
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
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              fontSize: 15,
              fontFamily: Theme.of(context).textTheme.headline1.fontFamily)),
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
          // Utilizar una expresión regular para validar que tenga más de 6 dígitos
          if (!RegExp(r'^[0-9]{7,}$').hasMatch(value)) {
            return 'El DNI debe tener al menos 7 dígitos';
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

  _alert_informe(context, message, colorNumber) {
    var color;
    colorNumber == 1 ? color = Colors.green[800] : color = Colors.red[600];

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(milliseconds: 2000),
      backgroundColor: color,
      content: Text(message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white)),
    ));
  }

  var _obscureTextPass = true;
  var _obscureTextRepeatPass = true;

  _togglePasswordVisibility() {
    setState(() {
      _obscureTextPass = !_obscureTextPass;
    });
  }

  _togglePasswordRepeatVisibility() {
    setState(() {
      _obscureTextRepeatPass = !_obscureTextRepeatPass;
    });
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
        obscureText: _obscureTextPass,
        decoration: InputDecoration(
          labelText: 'Contraseña',
          labelStyle: TextStyle(
              fontFamily: Theme.of(context).textTheme.headline1.fontFamily),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureTextPass ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: _togglePasswordVisibility,
          ),
        ),
        controller: passwordNuevo,
      ),
    );
  }

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
        obscureText: _obscureTextRepeatPass,
        decoration: InputDecoration(
          labelText: 'Repetir Contraseña',
          labelStyle: TextStyle(
              fontFamily: Theme.of(context).textTheme.headline1.fontFamily),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureTextRepeatPass ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: _togglePasswordRepeatVisibility,
          ),
        ),
        controller: passwordRepetido,
      ),
    );
  }

  bool _isLoading = false;
  bool _isEnabled = true;

  Widget _crearBotonRegistrar(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        primary: Color.fromRGBO(
            30, 20, 108, 1), // Cambia el color de fondo del botón a verde
      ),
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

  Widget _crearBotonRegresar(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        primary: Color.fromRGBO(
            30, 20, 108, 1), // Cambia el color de fondo del botón a verde
      ),
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

  registerPaciente() async {
    String URL_base = Env.URL_API;
    var url = URL_base + "/register_paciente";
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

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.login();

      await Provider.of<DepartamentoServices>(context, listen: false)
          .loadDepartamentos();
      await Provider.of<GeneroServices>(context, listen: false).loadGeneros();
      await Provider.of<NivelEducativoService>(context, listen: false)
          .loadNivelEducativo();
      await Provider.of<GrupoConvivienteServices>(context, listen: false)
          .loadGrupoConviviente();

      Navigator.pushNamed(context, '/form_datos_generales', arguments: {
        'nombre': nombrePaciente.text,
        "apellido": apellidoPaciente.text,
        "dni": dni.text,
        "email": emailPaciente.text,
        "bandera": 1,
      });
    } else {
      if (responseDecoder['status'] == "Vacio") {
        _alert_informe(context, responseDecoder['data'], 2);
      } else {
        var error = response.statusCode + responseDecoder['data'];
        loginToast(error.toString());
      }
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
}

class CheckBoxCondiciones extends StatefulWidget {
  CheckBoxCondiciones({Key key}) : super(key: key);

  @override
  State<CheckBoxCondiciones> createState() => _CheckBoxCondicionesState();
}

class _CheckBoxCondicionesState extends State<CheckBoxCondiciones> {
  bool acepto;

  @override
  void initState() {
    acepto = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              fontSize: 15,
              fontFamily: Theme.of(context).textTheme.headline1.fontFamily)),
    ]);
  }
}
