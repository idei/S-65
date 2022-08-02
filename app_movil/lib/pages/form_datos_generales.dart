import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'env.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

String post_nombre;
String post_apellido;
String post_dni;
String post_email;
var email_argument;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Datos Generales',
      home: Formprueba(),
    );
  }
}

// Define a custom Form widget.
class Formprueba extends StatefulWidget {
  @override
  _FormpruebaState createState() => _FormpruebaState();
}

getStringValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String email_prefer = prefs.getString("email_prefer");
  email_argument = email_prefer;
  print("email");
  print(email_argument);
}

// Define a corresponding State class.
// This class holds data related to the Form.
class _FormpruebaState extends State<Formprueba> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();
  final pageName = '/form_datos_generales';

  @override
  void initState() {
    super.initState();

    myController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    myController.dispose();
    super.dispose();
  }

  _printLatestValue() {
    print("Second text field: ${myController.text}");
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final format = DateFormat("dd-MM-yyyy");
    final initialValue = DateTime.now();
    bool autoValidate = false;
    DateTime value = DateTime.now();
    int changedCount = 0;
    String dropdownValue = 'One';

    Map parametros = ModalRoute.of(context).settings.arguments;
    // getStringValuesSF();

    if (parametros['bandera'] == 1) {
      post_nombre = parametros['nombre'];
      post_apellido = parametros['apellido'];
      post_dni = parametros['dni'];
      email_argument = parametros['email'];
      print(email_argument);

      nombre.text = post_nombre;
      apellido.text = post_apellido;
      dni.text = post_dni;
      print("dni");
      //email.text = post_email;
    } else {
      email_argument = parametros['email'];
      // email_argument = parametros['email'];
      print(email_argument);
      getStringValuesSF();
      print(email_argument);
      //getStringValuesSF();
      read_datos_paciente();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Datos Generales',
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
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: <Widget>[
                TextFormField(
                  controller: apellido,
                  decoration: InputDecoration(
                      labelText: 'Apellido',
                      labelStyle: TextStyle(
                          fontFamily:
                              Theme.of(context).textTheme.headline1.fontFamily,
                          fontWeight: FontWeight.bold)),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Por favor ingrese el apellido';
                    }
                    return null;
                  },
                  onChanged: (text) {
                    print("Debe completar el campo");
                  },
                ),
                TextFormField(
                  controller: nombre,
                  decoration: InputDecoration(
                      labelText: 'Nombre',
                      labelStyle: TextStyle(
                          fontFamily: Theme.of(context)
                              .textTheme
                              .headline1
                              .fontFamily)),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Por favor ingrese el nombre';
                    }
                    return null;
                  },
                  onChanged: (text) {
                    print("Debe completar el campo");
                  },
                ),
                TextFormField(
                  controller: dni,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'DNI',
                      labelStyle: TextStyle(
                          fontFamily: Theme.of(context)
                              .textTheme
                              .headline1
                              .fontFamily)),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Por favor ingrese el DNI';
                    }
                    return null;
                  },
                  onChanged: (text) {
                    print("Debe completar el campo");
                  },
                ),
                SizedBox(height: 20.0),
                Text('Fecha de Nacimiento',
                    style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily)),
                DateTimeField(
                  controller: fecha_nacimiento,
                  format: format,
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100));
                  },
                  validator: (date) => date == null ? 'Invalid date' : null,
                  initialValue: initialValue,
                  onChanged: (date) => setState(() {
                    value = date;
                    changedCount++;
                  }),
                ),
                SizedBox(height: 20.0),
                FormGenero(),
                SizedBox(height: 10.0),
                FormNivelEducativo(),
                SizedBox(height: 10.0),
                FormGrupoConviviente(),
                TextFormField(
                  controller: celular,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Celular',
                      labelStyle: TextStyle(
                          fontFamily: Theme.of(context)
                              .textTheme
                              .headline1
                              .fontFamily)),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Por favor ingrese un número de teléfono';
                    }
                    return null;
                  },
                  onChanged: (text) {
                    print("Debe completar el campo");
                  },
                ),
                /*
                TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                      labelText: 'Correo Electrónico',
                      hintText: "ejemplo@gmail.com"),
                  validator: (value) => EmailValidator.validate(value)
                      ? null
                      : "Por favor ingresar un correo electrónico válido",
                  onChanged: (text) {
                    print("Debe completar el campo");
                  },
                ),*/
                TextFormField(
                  controller: contacto,
                  decoration: InputDecoration(
                      labelText: 'Contacto',
                      labelStyle: TextStyle(
                          fontFamily: Theme.of(context)
                              .textTheme
                              .headline1
                              .fontFamily)),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Por favor ingrese el contacto';
                    }
                    return null;
                  },
                  onChanged: (text) {
                    print("Debe completar el campo");
                  },
                ),
                SizedBox(height: 10.0),
                FormDepartamentos(),
                SizedBox(height: 15.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    //primary: Color.fromRGBO(157, 19, 34, 1),
                    textStyle: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily),
                  ),
                  onPressed: () {
                    // Validate returns true if the form is valid, or false
                    // otherwise.
                    if (_formKey.currentState.validate()) {
                      // If the form is valid, display a Snackbar.
                      //Scaffold.of(context).showSnackBar(
                      //  SnackBar(content: Text('Procesando información')));
                      guardar_datos();
                      Navigator.pushNamed(context, '/menu', arguments: {
                        'email': email_argument,
                      });
                    }
                  },
                  child: Text('Guardar Datos',
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily,
                      )),
                ),
              ],
            ),
          ),
        ));
  }

  void choiceAction(String choice) {
    if (choice == Constants.Ajustes) {
      Navigator.pushNamed(context, '/ajustes');
    } else if (choice == Constants.Salir) {
      Navigator.pushNamed(context, '/');
    }
  }
}

TextEditingController apellido = TextEditingController();
TextEditingController nombre = TextEditingController();
TextEditingController fecha_nacimiento = TextEditingController();
TextEditingController genero = TextEditingController();
TextEditingController email = TextEditingController();
TextEditingController dni = TextEditingController();
TextEditingController celular = TextEditingController();
TextEditingController contacto = TextEditingController();

var rela_departamento;
var rela_genero;
var rela_nivel_instruccion;
var rela_grupo_conviviente;
var return_apellido;
var return_nombre;
var return_email;
var estado_users = 2;
var rela_users = 0;

guardar_datos() async {
  String URL_base = Env.URL_PREFIX;
  var url = URL_base + "/user_datos_personales.php";
  print(celular.text);
  print(email_argument);
  var response = await http.post(url, body: {
    "nombre": nombre.text,
    "apellido": apellido.text,
    "email": email_argument.toString(),
    "dni": dni.text,
    "fecha_nacimiento": fecha_nacimiento.text,
    "rela_genero": rela_genero,
    "rela_departamento": rela_departamento.toString(),
    "rela_nivel_instruccion": rela_nivel_instruccion.toString(),
    "rela_grupo_conviviente": rela_grupo_conviviente.toString(),
    "celular": celular.text,
    "contacto": contacto.text,
    "estado_users": estado_users.toString(),
    "rela_users": rela_users.toString(),
  });
  print("response.body");
  print(response.body);
  var data = json.decode(response.body);
  // print(data);
  if (data == "Success") {
    print("Success del guardar");
    //loginToast("Bienvenido a Proyecto Salud");
  } else {
    print("Nooo");
    //loginToast(data);
  }
}

read_datos_paciente() async {
  String URL_base = Env.URL_PREFIX;
  var url = URL_base + "/user_read_datos_personales.php";
  var response = await http.post(url, body: {
    "email": email_argument,
  });
  // print(response.body);
  var data = json.decode(response.body);

  //print(data);
  if (data["estado_users"] == "Success") {
    rela_departamento = data["rela_departamento"].toString();
    rela_nivel_instruccion = data["rela_nivel_instruccion"].toString();
    rela_grupo_conviviente = data["rela_grupo_conviviente"].toString();
    nombre.text = data["nombre"];
    apellido.text = data["apellido"];
    fecha_nacimiento.text = data["fecha_nacimiento"];
    dni.text = data["dni"].toString();
    rela_genero = data["rela_genero"].toString();
    genero.text = data["genero"];
    celular.text = data["celular"].toString();
    contacto.text = data["contacto"];
  } else {
    //loginToast(data);
  }
}

// ----------------------- WIDGET DEPARTAMENTOS -----------------------------------------------------------------------------------

class FormDepartamentos extends StatefulWidget {
  FormDepartamentos({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<FormDepartamentos> {
  List data = List();

  getAllName() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/departamentos.php";
    var response = await http.post(url, body: {});
    // print(response);
    var jsonBody = response.body;
    var jsonDate = json.decode(jsonBody);

    setState(() {
      data = jsonDate;
    });

    // print(jsonDate);
  }

  @override
  void initState() {
    super.initState();
    getAllName();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        hint: Text("Departamento"),
        value: rela_departamento,
        /*icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),*/
        items: data.map(
          (list) {
            return DropdownMenuItem<String>(
              child: Text(list['nombre']),
              value: list['id'].toString(),
            );
          },
        ).toList(),
        onChanged: (String newValue) {
          setState(() {
            rela_departamento = newValue;
          });
        });
  }
}

//------------------------------------------------------------------------------------------------------

// ----------------------- WIDGET GENERO -----------------------------------------------------------------------------------

class FormGenero extends StatefulWidget {
  FormGenero({Key key}) : super(key: key);

  @override
  _GeneroWidgetState createState() => _GeneroWidgetState();
}

class _GeneroWidgetState extends State<FormGenero> {
  // ignore: deprecated_member_use
  List data = List();

  Future getAllName() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/generos.php";
    var response = await http.post(url, body: {});
    // print(response);
    var jsonBody = response.body;
    var jsonDate = json.decode(jsonBody);
    if (this.mounted) {
      setState(() {
        data = jsonDate;
      });
    }
    // print(jsonDate);
  }

  @override
  void initState() {
    super.initState();
    getAllName();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        hint: Text("Géneros"),
        value: rela_genero,
        /*icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),*/
        items: data.map(
          (list) {
            return DropdownMenuItem<String>(
              child: Text(list['nombre']),
              value: list['id'].toString(),
            );
          },
        ).toList(),
        onChanged: (String newValue) {
          setState(() {
            rela_genero = newValue;
          });
        });
  }
}

// ----------------------- WIDGET NIVEL EDUCACION -----------------------------------------------------------------------------------

class FormNivelEducativo extends StatefulWidget {
  @override
  _FormpruebaState1 createState() => _FormpruebaState1();
}

class _FormpruebaState1 extends State<FormNivelEducativo> {
  List data = List();

  getAllName() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/niveles_educ.php";
    var response = await http.post(url, body: {});
    //print(response);
    var jsonBody = response.body;
    var jsonDate = json.decode(jsonBody);
    //Excepción arrojada durante la ejecución de la app conectada al Web Hosting

    setState(() {
      data = jsonDate;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllName();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        hint: Text("Nivel Educativo Alcanzado"),
        value: rela_nivel_instruccion,
        items: data.map(
          (list) {
            if (data.length == 0) {
              // return DropdownMenuItem<String>(
              //   child: Text('Cargando...'),
              // );
            } else {
              return DropdownMenuItem<String>(
                child: Text(list['nombre_nivel']),
                value: list['id'].toString(),
              );
            }
          },
        ).toList(),
        onChanged: (String newValue) {
          setState(() {
            rela_nivel_instruccion = newValue;
          });
        });
  }
}

// ----------------------- WIDGET GRUPO CONVIVIENTE -----------------------------------------------------------------------------------

class FormGrupoConviviente extends StatefulWidget {
  @override
  _FormpruebaState3 createState() => _FormpruebaState3();
}

class _FormpruebaState3 extends State<FormGrupoConviviente> {
  List data = List();

  Future getAllName() async {
    String URL_base = Env.URL_PREFIX;
    var url = URL_base + "/grupo_conviviente.php";
    var response = await http.post(url, body: {});
    //print(response);
    var jsonBody = response.body;
    var jsonDate = json.decode(jsonBody);
    if (this.mounted) {
      setState(() {
        data = jsonDate;
      });
    }
    //print(jsonDate);
  }

  @override
  void initState() {
    super.initState();
    getAllName();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        hint: Text("Grupo Conviviente"),
        value: rela_grupo_conviviente,
        /*icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),*/
        items: data.map(
          (list) {
            if (list == null) {
              return DropdownMenuItem<String>(
                child: Text('Cargando...'),
              );
            } else {
              return DropdownMenuItem<String>(
                child: Text(list['nombre']),
                value: list['id'].toString(),
              );
            }
          },
        ).toList(),
        onChanged: (String newValue) {
          setState(() {
            rela_grupo_conviviente = newValue;
          });
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
