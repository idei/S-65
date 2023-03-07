import 'package:app_salud/models/paciente_model.dart';
import 'package:app_salud/models/usuario_model.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../services/usuario_services.dart';
import 'env.dart';

String post_nombre;
String post_apellido;
String post_dni;
String post_email;
var email_argument;
var userModel;
var rela_users;
var usuarioModel;

class Formprueba extends StatefulWidget {
  @override
  _FormpruebaState createState() => _FormpruebaState();
}

class _FormpruebaState extends State<Formprueba> {
  final myController = TextEditingController();
  final pageName = '/form_datos_generales';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey_datos_personales = GlobalKey<FormState>();

    usuarioModel = Provider.of<UsuarioServices>(context);

    rela_users = usuarioModel.usuario.paciente.rela_users;
    email_argument = usuarioModel.usuario.emailUser;

    final format = DateFormat("dd-MM-yyyy");
    final initialValue = DateTime.now();
    bool autoValidate = false;
    DateTime value = DateTime.now();
    int changedCount = 0;

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, '/menu');
            },
          ),
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
            child: FutureBuilder<PacienteModel>(
              future: getDataPaciente(usuarioModel),
              builder: (context, snapshot) {
                if (isGenero &&
                    isDepto &&
                    isGrupoConviviente &&
                    isNiveleducativo &&
                    snapshot.hasData) {
                  return Form(
                    key: _formKey_datos_personales,
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
                                if (_formKey_datos_personales.currentState
                                        .validate() &&
                                    !_isLoading) {
                                  _startLoading(usuarioModel);
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

  guardarDatos(UsuarioServices usuarioModel) async {
    String URL_base = Env.URL_API;
    var url = URL_base + "/save_datos_personales";

    var response = await http.post(url, body: {
      "nombre": nombre.text,
      "apellido": apellido.text,
      "dni": dni.text,
      "fecha_nacimiento": fecha_nacimiento.text.toString(),
      "email": email_argument.toString(),
      "rela_genero": rela_genero.toString(),
      "rela_departamento": rela_departamento.toString(),
      "rela_nivel_instruccion": rela_nivel_instruccion.toString(),
      "rela_grupo_conviviente": rela_grupo_conviviente.toString(),
      "celular": celular.text,
      "contacto": contacto.text,
      "estado_users": estado_users.toString(),
      "rela_users": rela_users.toString(),
    });

    var responseDecoder = json.decode(response.body);

    if (response.statusCode == 200 && responseDecoder["status"] == 'Success') {
      var userMap = json.decode(response.body);

      usuarioModel.usuario.paciente =
          PacienteModel.fromJsonFromRegisterComplete(userMap['data']);

      _alert_informe(context, "Datos Guardados Exitosamente", 1);

      Navigator.pushNamed(context, '/menu', arguments: {
        'email': email_argument,
      });
    } else {
      _alert_informe(context, "Error al guardar: " + response.body, 2);
    }
  }

  bool _isLoading = false;
  void _startLoading(UsuarioServices usuarioModel) async {
    setState(() {
      _isLoading = true;
    });

    showDialogMessage();

    await guardarDatos(usuarioModel);

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

loadingSelectData() async {
  if (!isDepto && !isGenero && !isGrupoConviviente && !isNiveleducativo) {
    await getAllDepartamentos();
    await getAllGeneros();
    await getAllNivelesEducativos();
    await getAllGrupoConviviente();
  }
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
  String URL_base = Env.URL_API;
  var url = URL_base + "/deptos_generos";
  var response = await http.post(url, body: {"tipo": "1"});
  var responseBody = json.decode(response.body);

  if (response.statusCode == 200) {
    if (responseBody['status'] == "Success") {
      dataDepartamento = responseBody['data'];
      isDepto = true;
    } else {
      print(responseBody['status']);
    }
  }
}

getAllGeneros() async {
  String URL_base = Env.URL_API;
  var url = URL_base + "/deptos_generos";
  var response = await http.post(url, body: {"tipo": "2"});
  var responseBody = json.decode(response.body);

  if (response.statusCode == 200) {
    if (responseBody['status'] == "Success") {
      dataGenero = responseBody['data'];
      isGenero = true;
    } else {
      print(responseBody['status']);
    }
  }
}

getAllNivelesEducativos() async {
  String URL_base = Env.URL_API;
  var url = URL_base + "/deptos_generos";
  var response = await http.post(url, body: {"tipo": "3"});
  var responseBody = json.decode(response.body);
  if (response.statusCode == 200) {
    if (responseBody['status'] == "Success") {
      dataNivelEducativo = responseBody['data'];
      isNiveleducativo = true;
    } else {
      print(responseBody['status']);
    }
  }
}

getAllGrupoConviviente() async {
  String URL_base = Env.URL_API;
  var url = URL_base + "/deptos_generos";
  var response = await http.post(url, body: {"tipo": "4"});
  var responseBody = json.decode(response.body);
  if (response.statusCode == 200) {
    if (responseBody['status'] == "Success") {
      dataGrupoConviviente = responseBody['data'];
      isGrupoConviviente = true;
    } else {
      print(responseBody['status']);
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

String rela_departamento = '1';
String rela_genero = '1';
String rela_nivel_instruccion = '1';
String rela_grupo_conviviente = '1';
var return_apellido;
var return_nombre;
var return_email;
var estado_users = 2;

Future<PacienteModel> getDataPaciente(UsuarioServices usuarioModel) async {
  if (usuarioModel.existeUsuarioModel) {
    await loadingSelectData();

    rela_departamento = usuarioModel.usuario.paciente.rela_departamento;
    rela_nivel_instruccion =
        usuarioModel.usuario.paciente.rela_nivel_instruccion;
    rela_grupo_conviviente =
        usuarioModel.usuario.paciente.rela_grupo_conviviente;
    rela_genero = usuarioModel.usuario.paciente.rela_genero;
    rela_users = usuarioModel.usuario.paciente.rela_users;
    nombre.text = usuarioModel.usuario.paciente.nombre;
    apellido.text = usuarioModel.usuario.paciente.apellido;
    fecha_nacimiento.text = usuarioModel.usuario.paciente.fecha_nacimiento;
    dni.text = usuarioModel.usuario.paciente.dni.toString();
    celular.text = usuarioModel.usuario.paciente.celular;
    contacto.text = usuarioModel.usuario.paciente.contacto;
    rela_users = usuarioModel.usuario.paciente.rela_users;

    return usuarioModel.usuario.paciente;
  } else {
    return null;
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
        value: rela_departamento.isNotEmpty ? rela_departamento : null,
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
        value: rela_genero.isNotEmpty ? rela_genero : null,
        items: dataGenero.map(
          (list) {
            return DropdownMenuItem<String>(
              child: Text(list['nombre']),
              value: list['id'].toString(),
            );
          },
        ).toList(),
        onChanged: (String Value) {
          setState(() {
            rela_genero = Value;
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
        value:
            rela_nivel_instruccion.isNotEmpty ? rela_nivel_instruccion : null,
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
        value:
            rela_grupo_conviviente.isNotEmpty ? rela_grupo_conviviente : null,
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
