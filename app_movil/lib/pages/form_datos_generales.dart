import 'package:app_salud/models/paciente_model.dart';
import 'package:app_salud/services/departamento_service.dart';
import 'package:app_salud/services/genero_service.dart';
import 'package:app_salud/services/grupo_conviviente_service.dart';
import 'package:app_salud/services/nivel_educativo_service.dart';
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

String rela_departamento = '1';
String rela_genero = '1';
String rela_nivel_instruccion = '1';
String rela_grupo_conviviente = '1';
var return_apellido;
var return_nombre;
var return_email;
var estado_users = 2;
var loadingUsuario = true;
var providerdepto;

class FormDatosGenerales extends StatefulWidget {
  FormDatosGenerales({Key key}) : super(key: key);

  @override
  _FormDatosGeneralesState createState() => _FormDatosGeneralesState();
}

class _FormDatosGeneralesState extends State<FormDatosGenerales> {
  final _formKey_datos_personales = GlobalKey<FormState>();
  final _nombreFieldKey = GlobalKey<FormFieldState<String>>();
  final _apellidoFieldKey = GlobalKey<FormFieldState<String>>();
  final _dniFieldKey = GlobalKey<FormFieldState<String>>();
  final _celularPacienteFieldKey = GlobalKey<FormFieldState<String>>();
  final _fechaNacimientoFieldKey = GlobalKey<FormFieldState<String>>();
  final _relaDeptoFieldKey = GlobalKey<FormFieldState<String>>();
  final _relaGeneroFieldKey = GlobalKey<FormFieldState<String>>();
  final _relaNivelFieldKey = GlobalKey<FormFieldState<String>>();
  final _relaGrupoFieldKey = GlobalKey<FormFieldState<String>>();

  final _nombreContactoFieldKey = GlobalKey<FormFieldState<String>>();
  final _apellidoContactoFieldKey = GlobalKey<FormFieldState<String>>();
  final _celularContactoFieldKey = GlobalKey<FormFieldState<String>>();

  @override
  void initState() {
    super.initState();
    Provider.of<UsuarioServices>(context, listen: false).loadData(context);
  }

  @override
  Widget build(BuildContext context) {
    usuarioModel = Provider.of<UsuarioServices>(context);

    rela_users = usuarioModel.usuario.paciente.rela_users;
    email_argument = usuarioModel.usuario.emailUser;

    int changedCount = 0;

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: CircleAvatar(
              radius: MediaQuery.of(context).size.width / 30,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.arrow_back,
                color: Colors.blue,
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/menu');
            },
          ),
          title: Text('Datos Personales',
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
              )),
        ),
        body: Center(
          child: Consumer5<UsuarioServices, DepartamentoServices,
              GeneroServices, NivelEducativoService, GrupoConvivienteServices>(
            builder: (context, provider, provider2, provider3, provider4,
                provider5, _) {
              if (provider2.isLoadingDeptos) {
                List<DropdownMenuItem<String>> myDropdownMenuItemsDeptos =
                    provider2.formDataList.map(
                  (item) {
                    if (provider2.isLoadingDeptos) {
                      return DropdownMenuItem<String>(
                        value: item.idDepartamento.toString(),
                        child: Text(item.nombreDepartamento),
                      );
                    }
                  },
                ).toList();

                List<DropdownMenuItem<String>> myDropdownMenuItemsGenero =
                    provider3.formDataList.map(
                  (item) {
                    if (provider3.isLoadingGenero) {
                      return DropdownMenuItem<String>(
                        value: item.idGenero.toString(),
                        child: Text(item.nombreGenero),
                      );
                    }
                  },
                ).toList();

                List<DropdownMenuItem<String>>
                    myDropdownMenuItemsNivelEducativo =
                    provider4.formDataList.map(
                  (item) {
                    if (provider4.isLoadingNivelEducativo) {
                      return DropdownMenuItem<String>(
                        value: item.idNivelEducativo.toString(),
                        child: Text(item.nombreNivelEducativo),
                      );
                    }
                  },
                ).toList();

                List<DropdownMenuItem<String>>
                    myDropdownMenuItemsGrupoConvivencia =
                    provider5.formDataList.map(
                  (item) {
                    if (provider5.isLoadingGrupos) {
                      return DropdownMenuItem<String>(
                        value: item.idGrupo.toString(),
                        child: Text(item.nombreGrupo),
                      );
                    }
                  },
                ).toList();

                return SingleChildScrollView(
                  child: Form(
                    key: _formKey_datos_personales,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            TextFormField(
                              key: _apellidoFieldKey,
                              initialValue: provider.usuario.paciente.apellido,
                              onSaved: (value) =>
                                  provider.usuario.paciente.apellido = value,
                              decoration: InputDecoration(
                                  labelText: 'Apellido',
                                  labelStyle: TextStyle(
                                    fontFamily: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .fontFamily,
                                  )),
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
                              key: _nombreFieldKey,
                              initialValue: provider.usuario.paciente.nombre,
                              onSaved: (value) =>
                                  provider.usuario.paciente.nombre = value,
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
                              key: _dniFieldKey,
                              initialValue: provider.usuario.paciente.dni,
                              onSaved: (value) =>
                                  provider.usuario.paciente.dni = value,
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
                              key: _fechaNacimientoFieldKey,
                              decoration: InputDecoration(
                                labelText: 'Fecha de Nacimiento',
                              ),
                              initialValue:
                                  provider.usuario.paciente.fecha_nacimiento,
                              onSaved: (value) => provider
                                  .usuario.paciente.fecha_nacimiento = value,
                              format: DateFormat('dd-MM-yyyy'),
                              onShowPicker: (context, currentValue) {
                                return showDatePicker(
                                    locale: const Locale("es", "ES"),
                                    context: context,
                                    firstDate: DateTime(1900),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime(2100));
                              },
                              validator: (date) =>
                                  date == null ? 'Invalid date' : null,
                              onChanged: (value) => setState(() {
                                value = value;
                                changedCount++;
                              }),
                            ),
                            SizedBox(height: 10.0),
                            TextFormField(
                              key: _celularPacienteFieldKey,
                              initialValue: provider.usuario.paciente.celular,
                              onSaved: (value) =>
                                  provider.usuario.paciente.celular = value,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  labelText: 'Número de celular',
                                  labelStyle: TextStyle(
                                      fontFamily: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .fontFamily)),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Por favor ingrese el número de teléfono del contacto';
                                }
                                return null;
                              },
                              onChanged: (text) {
                                print("Debe completar el campo");
                              },
                            ),
                            SizedBox(height: 10.0),
                            DropdownButtonFormField<String>(
                                key: _relaGeneroFieldKey,
                                hint: Text("Género"),
                                value:
                                    rela_genero.isNotEmpty ? rela_genero : null,
                                items: myDropdownMenuItemsGenero,
                                onChanged: (String newValue) {
                                  setState(() {
                                    rela_genero = newValue;
                                  });
                                }),
                            SizedBox(height: 10.0),
                            DropdownButtonFormField<String>(
                                key: _relaDeptoFieldKey,
                                hint: Text("Departamento"),
                                value: rela_departamento.isNotEmpty
                                    ? rela_departamento
                                    : null,
                                items: myDropdownMenuItemsDeptos,
                                onChanged: (String newValue) {
                                  setState(() {
                                    rela_departamento = newValue;
                                  });
                                }),
                            SizedBox(height: 15.0),
                            DropdownButtonFormField<String>(
                                key: _relaNivelFieldKey,
                                hint: Text("Nivel Educativo"),
                                value: rela_nivel_instruccion.isNotEmpty
                                    ? rela_nivel_instruccion
                                    : null,
                                items: myDropdownMenuItemsNivelEducativo,
                                onChanged: (String newValue) {
                                  setState(() {
                                    rela_nivel_instruccion = newValue;
                                  });
                                }),
                            SizedBox(height: 25.0),
                            Container(
                              padding: EdgeInsets.all(8),
                              color: Color.fromARGB(134, 190, 218, 241),
                              child: Center(
                                child: Text(
                                  'GRUPO CONVIVIENTE',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10.0),
                            DropdownButtonFormField<String>(
                                key: _relaGrupoFieldKey,
                                hint: Text("Relación con Paciente"),
                                value: rela_grupo_conviviente.isNotEmpty
                                    ? rela_grupo_conviviente
                                    : null,
                                items: myDropdownMenuItemsGrupoConvivencia,
                                onChanged: (String newValue) {
                                  setState(() {
                                    rela_grupo_conviviente = newValue;
                                  });
                                }),
                            TextFormField(
                              key: _nombreContactoFieldKey,
                              initialValue:
                                  provider.usuario.paciente.nombre_contacto,
                              decoration: InputDecoration(
                                  labelText: 'Nombre del Contacto',
                                  labelStyle: TextStyle(
                                      fontFamily: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .fontFamily)),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Por favor ingrese el nombre del contacto';
                                }
                                return null;
                              },
                              onChanged: (text) {
                                print("Debe completar el campo");
                              },
                            ),
                            TextFormField(
                              key: _apellidoContactoFieldKey,
                              initialValue:
                                  provider.usuario.paciente.apellido_contacto,
                              decoration: InputDecoration(
                                  labelText: 'Apellido del contacto',
                                  labelStyle: TextStyle(
                                      fontFamily: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .fontFamily)),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Por favor ingrese el apellido del contacto';
                                }
                                return null;
                              },
                              onChanged: (text) {
                                print("Debe completar el campo");
                              },
                            ),
                            SizedBox(height: 10.0),
                            TextFormField(
                              key: _celularContactoFieldKey,
                              initialValue:
                                  provider.usuario.paciente.celular_contacto,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  labelText: 'Celular del contacto',
                                  labelStyle: TextStyle(
                                      fontFamily: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .fontFamily)),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Por favor ingrese el número de teléfono del contacto';
                                }
                                return null;
                              },
                              onChanged: (text) {
                                print("Debe completar el campo");
                              },
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              alignment: Alignment.center,
                              child: ElevatedButton.icon(
                                icon: _isLoading
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child:
                                            const CircularProgressIndicator(),
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
                                      fontSize: 16.0,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                          fontFamily:
                              Theme.of(context).textTheme.headline1.fontFamily,
                        ),
                      )
                    ],
                  ),
                );
              }
            },
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
    String nombre_paciente = _nombreFieldKey.currentState.value;
    String apellido_paciente = _apellidoFieldKey.currentState.value;
    String celular_paciente = _celularPacienteFieldKey.currentState.value;
    String fecha_paciente =
        usuarioModel.usuario.paciente.fecha_nacimiento.toString();
    String dni_paciente = _dniFieldKey.currentState.value;
    String rela_depto = _relaDeptoFieldKey.currentState.value;
    String rela_genero = _relaGeneroFieldKey.currentState.value;
    String rela_nivel = _relaNivelFieldKey.currentState.value;
    String rela_grupo = _relaGrupoFieldKey.currentState.value;
    String nombre_contacto = _nombreContactoFieldKey.currentState.value;
    String apellido_contacto = _apellidoContactoFieldKey.currentState.value;
    String celular_contacto = _celularContactoFieldKey.currentState.value;

    String URL_base = Env.URL_API;
    var url = URL_base + "/save_datos_personales";

    var response = await http.post(url, body: {
      "nombre": nombre_paciente,
      "apellido": apellido_paciente,
      "dni": dni_paciente,
      "fecha_nacimiento": fecha_paciente,
      "email": email_argument.toString(),
      "rela_genero": rela_genero,
      "rela_departamento": rela_depto,
      "rela_nivel_instruccion": rela_nivel,
      "rela_grupo_conviviente": rela_grupo,
      "celular": celular_paciente,
      "nombre_contacto": nombre_contacto,
      "apellido_contacto": apellido_contacto,
      "celular_contacto": celular_contacto,
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
  var url = URL_base + "/deptos_generos_patologias";
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
  var url = URL_base + "/deptos_generos_patologias";
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
  var url = URL_base + "/deptos_generos_patologias";
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
  var url = URL_base + "/deptos_generos_patologias";
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

class Constants {
  static const String Ajustes = 'Ajustes';
  static const String Salir = 'Salir';
  static const List<String> choices = <String>[
    Ajustes,
    Salir,
  ];
}
