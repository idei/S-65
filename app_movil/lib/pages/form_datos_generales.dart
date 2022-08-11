import 'dart:ffi';

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

class _FormpruebaState extends State<Formprueba> {
  final myController = TextEditingController();
  final pageName = '/form_datos_generales';

  @override
  void initState() {
    super.initState();

    myController.addListener(_printLatestValue);
    //loadingData();
  }

  @override
  void dispose() {
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

    final size = MediaQuery.of(context).size;

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
    } else {
      email_argument = parametros['email'];
      print(email_argument);
      getStringValuesSF();
      print(email_argument);
      //getStringValuesSF();
      //read_datos_paciente();
      //getAllDepartamentos();
    }

    setState(() {
      loadingData();
    });

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
        body: Center(
          child: SingleChildScrollView(
            child: FutureBuilder(
              future: loadingData(),
              builder: (context, snapshot) {
                if (isDepto) {
                  return Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: apellido,
                            decoration: InputDecoration(
                                labelText: 'Apellido',
                                labelStyle: TextStyle(
                                    fontFamily: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .fontFamily,
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
                          SizedBox(height: 10.0),
                          DateTimeField(
                            decoration: InputDecoration(
                              labelText: 'Fecha de Nacimiento',
                            ),
                            controller: fecha_nacimiento,
                            format: format,
                            onShowPicker: (context, currentValue) {
                              return showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1900),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(2100));
                            },
                            validator: (date) =>
                                date == null ? 'Invalid date' : null,
                            initialValue: initialValue,
                            onChanged: (date) => setState(() {
                              value = date;
                              changedCount++;
                            }),
                          ),
                          SizedBox(height: 10.0),
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
                          Container(
                            alignment: Alignment.center,
                            child: ElevatedButton.icon(
                              icon: _isLoading
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: const CircularProgressIndicator(),
                                    )
                                  : const Icon(Icons.save_alt),
                              style: ElevatedButton.styleFrom(
                                textStyle: TextStyle(
                                    fontFamily: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .fontFamily),
                              ),
                              onPressed: () {
                                if (_formKey.currentState.validate() &&
                                    !_isLoading) {
                                  _startLoading();
                                } else {
                                  null;
                                }
                              },
                              label: Text('Guardar Datos',
                                  style: TextStyle(
                                    fontFamily: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .fontFamily,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Cargando...",
                          style: TextStyle(
                            fontFamily: Theme.of(context)
                                .textTheme
                                .headline1
                                .fontFamily,
                          ),
                        )
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ));
  }

  showDialogMessage() async {
    await Future.delayed(Duration(microseconds: 1));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              height: 80,
              width: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Guardando Datos",
                    style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  guardarDatos() async {
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

    if (response.statusCode == 200) {
      _alert_informe(context, "Datos Guardados Exitosamente", 1);

      Navigator.pushNamed(context, '/menu', arguments: {
        'email': email_argument,
      });
    } else {
      _alert_informe(context, "Error al guardar: " + response.body, 2);
    }
  }

  bool _isLoading = false;
  void _startLoading() async {
    setState(() {
      _isLoading = true;
    });

    showDialogMessage();

    await guardarDatos();

    setState(() {
      _isLoading = false;
    });
  }

  void choiceAction(String choice) {
    if (choice == Constants.Ajustes) {
      Navigator.pushNamed(context, '/ajustes');
    } else if (choice == Constants.Salir) {
      Navigator.pushNamed(context, '/');
    }
  }
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

loadingData() async {
  await getDataPaciente();
  await getAllDepartamentos();
  await getAllGeneros();
  await getAllNivelesEducativos();
  await getAllGrupoConviviente();
}

List dataDepartamento;
bool isDepto = false;
List dataGenero;
bool isGenero = false;
List dataNivelEducativo;
bool isNiveleducativo = false;
List dataGrupoConviviente;
bool isGrupoConviviente = false;

getAllDepartamentos() async {
  String URL_base = Env.URL_PREFIX;
  var url = URL_base + "/departamentos.php";
  var response = await http.post(url, body: {});

  if (response.statusCode == 200) {
    dataDepartamento = json.decode(response.body);
    isDepto = true;
  }
}

getAllGeneros() async {
  String URL_base = Env.URL_PREFIX;
  var url = URL_base + "/generos.php";
  var response = await http.post(url, body: {});

  if (response.statusCode == 200) {
    dataGenero = json.decode(response.body);
    isGenero = true;
  }
}

getAllNivelesEducativos() async {
  String URL_base = Env.URL_PREFIX;
  var url = URL_base + "/niveles_educ.php";
  var response = await http.post(url, body: {});
  if (response.statusCode == 200) {
    dataNivelEducativo = json.decode(response.body);
    isNiveleducativo = true;
  }
}

getAllGrupoConviviente() async {
  String URL_base = Env.URL_PREFIX;
  var url = URL_base + "/grupo_conviviente.php";
  var response = await http.post(url, body: {});
  if (response.statusCode == 200) {
    dataGrupoConviviente = json.decode(response.body);
    isGrupoConviviente = true;
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

var rela_departamento = "";
var rela_genero;
var rela_nivel_instruccion;
var rela_grupo_conviviente;
var return_apellido;
var return_nombre;
var return_email;
var estado_users = 2;
var rela_users = 0;

getDataPaciente() async {
  String URL_base = Env.URL_PREFIX;
  var url = URL_base + "/user_read_datos_personales.php";
  var response = await http.post(url, body: {
    "email": email_argument,
  });
  var data = json.decode(response.body);

  if (response.statusCode == 200) {
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        hint: Text("Departamento"),
        value: rela_departamento,
        items: dataDepartamento.map(
          (item) {
            return DropdownMenuItem<String>(
              child: Text(item['nombre']),
              value: item['id'].toString(),
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        hint: Text("Géneros"),
        value: rela_genero,
        items: dataGenero.map(
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
  _FormNivelEducativoState createState() => _FormNivelEducativoState();
}

class _FormNivelEducativoState extends State<FormNivelEducativo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        hint: Text("Nivel Educativo Alcanzado"),
        value: rela_nivel_instruccion,
        items: dataNivelEducativo.map(
          (list) {
            return DropdownMenuItem<String>(
              child: Text(list['nombre_nivel']),
              value: list['id'].toString(),
            );
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        hint: Text("Grupo Conviviente"),
        value: rela_grupo_conviviente,
        items: dataGrupoConviviente.map(
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
