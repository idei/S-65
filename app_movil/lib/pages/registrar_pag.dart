import 'package:app_salud/pages/ver_screening.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'env.dart';
import 'dart:convert';
import 'package:email_validator/email_validator.dart';

TextEditingController email = TextEditingController();
TextEditingController passwordNuevo = TextEditingController();
TextEditingController nombre = TextEditingController();
TextEditingController apellido = TextEditingController();
TextEditingController passwordRepetido = TextEditingController();
TextEditingController dni = TextEditingController();

// Define a custom Form widget.
class RegistrarPage extends StatefulWidget {
  @override
  _FormpruebaState createState() => _FormpruebaState();
}

final _formKey = GlobalKey<FormState>();

class _FormpruebaState extends State<RegistrarPage> {
  bool acepto = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
          key: _formKey,
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
              _registrar(context)
            ],
          ),
        ));
  }

  var bandera_register = false;

  register() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/user_register.php";
    var response = await http.post(url, body: {
      "email": email.text,
      "password": passwordNuevo.text,
      "nombre": nombre.text,
      "apellido": apellido.text,
      "dni": dni.text,
    });
    print("Hola register");
    print(response.body);
    var data = json.decode(response.body);
    print(data);
    if (data[0] == "Success") {
      //return;
      Navigator.pushNamed(context, '/form_datos_generales', arguments: {
        'nombre': nombre.text,
        "apellido": apellido.text,
        "dni": dni.text,
        "email": email.text,
        "bandera": 1,
      });

      //loginToast("Bienvenido a Proyecto Salud");
    } else {
      bandera_register = true;
      loginToast(data);
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

  Widget _registrar(BuildContext context) {
    return Container(
      child: Column(children: <Widget>[
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
        _crearBotonSesion(context),
        SizedBox(height: 10),
        _crearBotonRegresar(context),
      ]),
    );
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
          style: TextStyle(fontFamily: 'NunitoR'))
    ]);
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
        decoration: InputDecoration(
            labelText: 'Nombre', labelStyle: TextStyle(fontFamily: 'NunitoR')),
        controller: nombre,
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
            labelText: 'DNI', labelStyle: TextStyle(fontFamily: 'NunitoR')),
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
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            labelText: 'Apellido',
            labelStyle: TextStyle(fontFamily: 'NunitoR')),
        controller: apellido,
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
            labelStyle: TextStyle(fontFamily: 'NunitoR')),
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
            labelStyle: TextStyle(fontFamily: 'NunitoR')),
        controller: passwordRepetido,
      ),
    );
  }

  Widget _Password() {
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
            labelStyle: TextStyle(fontFamily: 'NunitoR')),
        //controller: password1,
      ),
    );
  }

  Widget _crearBotonSesion(BuildContext context) {
    return ElevatedButton(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
        child: Text('REGISTRARME',
            style: TextStyle(
              color: Colors.white,
              fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
            )),
      ),
      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      //color: Theme.of(context).primaryColor,
      //textColor: Colors.white,
      onPressed: () {
        if (_formKey.currentState.validate()) {
          if (passwordNuevo.text == passwordRepetido.text) {
            register();

            //Navigator.pushNamed(context, '/form_datos_generales');
          } else {
            loginToast("Las contraseñas no coinciden");
          }
        } else {
          //loginToast("La contraseña debe tener 6 caracteres como mínimo");
        }
      },
    );
  }

  Widget _crearBotonRegresar(BuildContext context) {
    return ElevatedButton(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
        child: Text('REGRESAR',
            style: TextStyle(
              color: Colors.white,
              fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
            )),
        // color: Colors.lightBlue,
        // textColor: Colors.white,
      ),
      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      //color: Theme.of(context).primaryColor,
      //textColor: Colors.white,
      onPressed: () {
        Navigator.pushNamed(context, '/');
      },
    );
  }
}
