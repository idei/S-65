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

var email_argument;
var userModel;
var rela_users;
var usuarioModel;

String rela_departamento;
String rela_genero;
String rela_nivel_instruccion;
String rela_grupo_conviviente;
var return_apellido;
var return_nombre;
var return_email;
var estado_users = 2;
var loadingUsuario = true;
var providerdepto;
var id_paciente;

class FormDatosGenerales extends StatefulWidget {
  FormDatosGenerales({Key key}) : super(key: key);

  @override
  _FormDatosGeneralesState createState() => _FormDatosGeneralesState();
}

class _FormDatosGeneralesState extends State<FormDatosGenerales> {
  var formKey_datos_personales = GlobalKey<FormState>();
  var nombreFieldKey = GlobalKey<FormFieldState<String>>();
  var apellidoFieldKey = GlobalKey<FormFieldState<String>>();
  var dniFieldKey = GlobalKey<FormFieldState<String>>();
  var celularPacienteFieldKey = GlobalKey<FormFieldState<String>>();
  var fechaNacimientoFieldKey = GlobalKey<FormFieldState<DateFormat>>();
  var relaDeptoFieldKey = GlobalKey<FormFieldState<String>>();
  var relaGeneroFieldKey = GlobalKey<FormFieldState<String>>();
  var relaNivelFieldKey = GlobalKey<FormFieldState<String>>();
  var relaGrupoFieldKey = GlobalKey<FormFieldState<String>>();

  var currentfecha;
  var nombreContactoFieldKey = GlobalKey<FormFieldState<String>>();
  var apellidoContactoFieldKey = GlobalKey<FormFieldState<String>>();
  var celularContactoFieldKey = GlobalKey<FormFieldState<String>>();
  var isGrupoConviviente;

  TextEditingController _dateController = TextEditingController();

  ValueNotifier<bool> _showAdditionalFieldsNotifier =
      ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    Provider.of<UsuarioServices>(context, listen: false).loadData(context);
    rela_departamento = '1';
    rela_genero = '1';
    rela_nivel_instruccion = '1';
    rela_grupo_conviviente = '';
  }

  @override
  void dispose() {
    _showAdditionalFieldsNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    usuarioModel = Provider.of<UsuarioServices>(context);

    if (rela_grupo_conviviente == "") {
      rela_grupo_conviviente =
          usuarioModel.usuario.paciente.rela_grupo_conviviente;
      if (rela_grupo_conviviente == "1") {
        _showAdditionalFieldsNotifier.value = false;
      } else {
        _showAdditionalFieldsNotifier.value = true;
      }
    } else {
      if (rela_grupo_conviviente == "1") {
        _showAdditionalFieldsNotifier.value = false;
      } else {
        _showAdditionalFieldsNotifier.value = true;
      }
    }

    rela_users = usuarioModel.usuario.paciente.rela_users;
    id_paciente = usuarioModel.usuario.paciente.id_paciente;
    email_argument = usuarioModel.usuario.emailUser;

    isGrupoConviviente;
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
        body: Consumer5<UsuarioServices, DepartamentoServices, GeneroServices,
            NivelEducativoService, GrupoConvivienteServices>(
          builder: (context, provider, provider2, provider3, provider4,
              provider5, _) {
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

            List<DropdownMenuItem<String>> myDropdownMenuItemsNivelEducativo =
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

            List<DropdownMenuItem<String>> myDropdownMenuItemsGrupoConvivencia =
                provider5.formDataList.map(
              (item) {
                if (provider5.isLoadingGrupos) {
                  // if (provider.usuario.paciente.rela_grupo_conviviente !=
                  //     "null") {
                  //   rela_grupo_conviviente =
                  //       provider.usuario.paciente.rela_grupo_conviviente;
                  //   if (rela_grupo_conviviente == '1') {
                  //     _showAdditionalFieldsNotifier.value = false;
                  //   } else {
                  //     _showAdditionalFieldsNotifier.value = true;
                  //   }
                  // }

                  // if (rela_grupo_conviviente == '1') {
                  //   _showAdditionalFieldsNotifier.value = false;
                  // } else {
                  //   _showAdditionalFieldsNotifier.value = true;
                  // }
                  return DropdownMenuItem<String>(
                    value: item.idGrupo.toString(),
                    child: Text(item.nombreGrupo),
                  );
                }
              },
            ).toList();

            return SingleChildScrollView(
              child: Form(
                key: formKey_datos_personales,
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        TextFormField(
                          key: apellidoFieldKey,
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
                          key: nombreFieldKey,
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
                          key: dniFieldKey,
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
                          // controller: _dateController,
                          key: fechaNacimientoFieldKey,
                          decoration: InputDecoration(
                            labelText: 'Fecha de Nacimiento',
                          ),
                          initialValue:
                              provider.usuario.paciente.fecha_nacimiento,
                          onSaved: (value) => provider
                              .usuario.paciente.fecha_nacimiento = value,
                          // format: DateFormat('dd-MM-yyyy'),
                          format: DateFormat('yyyy-MM-dd'),
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
                            currentfecha = value;
                            //_dateController.text = value.toString();
                            value = value;
                            changedCount++;
                          }),
                        ),
                        SizedBox(height: 10.0),
                        TextFormField(
                          key: celularPacienteFieldKey,
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
                            key: relaGeneroFieldKey,
                            hint: Text("Género"),
                            value: rela_genero.isNotEmpty ? rela_genero : null,
                            items: myDropdownMenuItemsGenero,
                            onChanged: (String newValue) {
                              setState(() {
                                rela_genero = newValue;
                              });
                            }),
                        SizedBox(height: 10.0),
                        DropdownButtonFormField<String>(
                            key: relaDeptoFieldKey,
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
                            key: relaNivelFieldKey,
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
                            key: relaGrupoFieldKey,
                            hint: Text("Relación con Paciente"),
                            value: rela_grupo_conviviente.isNotEmpty
                                ? rela_grupo_conviviente
                                : null,
                            items: myDropdownMenuItemsGrupoConvivencia,
                            onChanged: (String newValue) {
                              setState(() {
                                rela_grupo_conviviente = newValue;
                                if (newValue == "1") {
                                  _showAdditionalFieldsNotifier.value = false;
                                } else {
                                  _showAdditionalFieldsNotifier.value = true;
                                }
                              });
                            }),
                        SizedBox(height: 10.0),
                        ValueListenableBuilder<bool>(
                          valueListenable: _showAdditionalFieldsNotifier,
                          builder: (context, value, child) {
                            return Visibility(
                              visible: _showAdditionalFieldsNotifier.value,
                              maintainSize:
                                  false, // Esto evita que mantenga el espacio incluso cuando está oculto
                              child: AnimatedOpacity(
                                opacity: _showAdditionalFieldsNotifier.value
                                    ? 1.0
                                    : 0.0,
                                duration: Duration(
                                    milliseconds:
                                        500), // Duración de la animación en milisegundos
                                curve:
                                    Curves.easeInOut, // Curva de la animación

                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    child: Column(children: [
                                      TextFormField(
                                        key: nombreContactoFieldKey,
                                        initialValue: provider
                                            .usuario.paciente.nombre_contacto,
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
                                      SizedBox(height: 10.0),
                                      TextFormField(
                                        key: apellidoContactoFieldKey,
                                        initialValue: provider
                                            .usuario.paciente.apellido_contacto,
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
                                        key: celularContactoFieldKey,
                                        initialValue: provider
                                            .usuario.paciente.celular_contacto,
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
                                    ]),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 40.0),
                        Center(
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
                              if (formKey_datos_personales.currentState
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
          },
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
    String nombre_paciente = nombreFieldKey.currentState.value;
    String apellido_paciente = apellidoFieldKey.currentState.value;
    String celular_paciente = celularPacienteFieldKey.currentState.value;
    String dni_paciente = dniFieldKey.currentState.value;
    String rela_depto = relaDeptoFieldKey.currentState.value;
    String rela_genero = relaGeneroFieldKey.currentState.value;
    String rela_nivel = relaNivelFieldKey.currentState.value;
    String rela_grupo = relaGrupoFieldKey.currentState.value;

    String nombre_contacto;
    String apellido_contacto;
    String celular_contacto;

    if (rela_grupo == "1") {
      nombre_contacto = "";
      apellido_contacto = "";
      celular_contacto = "";
    } else {
      nombre_contacto = nombreContactoFieldKey.currentState.value;
      apellido_contacto = apellidoContactoFieldKey.currentState.value;
      celular_contacto = celularContactoFieldKey.currentState.value;
    }

    DateTime fecha_paciente;

    if (usuarioModel.usuario.paciente.fecha_nacimiento.toString() == "null") {
      fecha_paciente = currentfecha;
    } else {
      fecha_paciente = currentfecha;
    }

    String pepe = fecha_paciente.toString();

    String URL_base = Env.URL_API;
    var url = URL_base + "/save_datos_personales";

    var response = await http.post(url, body: {
      "id_paciente": id_paciente,
      "nombre": nombre_paciente,
      "apellido": apellido_paciente,
      "dni": dni_paciente,
      "fecha_nacimiento": pepe,
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
