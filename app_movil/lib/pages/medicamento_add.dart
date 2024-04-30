import 'package:app_salud/models/medicamento_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:app_salud/pages/env.dart';
import 'package:provider/provider.dart';

import '../models/medicamentos_model.dart';
import '../services/usuario_services.dart';

class MedicamentoAddPage extends StatefulWidget {
  MedicamentoAddPage() : super();

  final String title = "Buscador";
  @override
  _MedicamentoAddPageState createState() => _MedicamentoAddPageState();
}

class _MedicamentoAddPageState extends State<MedicamentoAddPage> {
  AutoCompleteTextField searchTextField;

  GlobalKey<AutoCompleteTextFieldState<Medicamentos_database>> key =
      GlobalKey();
  GlobalKey<FormState> _formKey_add_medicamento = GlobalKey<FormState>();

  static List<Medicamentos_database> list_medicamentos_vademecum;

  bool loading = true;

  var usuarioModel;

  http.Client _client_add; // Cliente HTTP para realizar las solicitudes
  http.Client
      _client_read_vademecum; // Cliente HTTP para realizar las solicitudes

  @override
  void initState() {
    _client_add = http.Client(); // Inicializar el cliente HTTP
    _client_read_vademecum = http.Client(); // Inicializar el cliente HTTP
    read_vademecum();
    super.initState();
  }

  @override
  void dispose() {
    _client_add.close(); // Cerrar el cliente HTTP cuando la página se destruye
    _client_read_vademecum
        .close(); // Cerrar el cliente HTTP cuando la página se destruye
    super.dispose();
  }

  Widget row(Medicamentos_database user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          user.nombre_comercial,
          style: TextStyle(
              fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
              fontSize: 18),
        ),
        SizedBox(
          width: 10.0,
        ),
        Text(
          user.presentacion,
        ),
      ],
    );
  }

//   Future<List<MedicamentoModel>> readVademecum() async {
//   try {
//     String baseURL = Env.URL_API;
//     var url = Uri.parse('$baseURL/vademecum');
//     var response = await _client_add.post(url, body: {});

//     if (response.statusCode == 200) {
//       var responseData = jsonDecode(response.body);
//       if (responseData['status'] != "Vacio") {
//         return loadMedicamentos(responseData);
//       } else {
//         print("El servidor devolvió una respuesta vacía.");
//         return [];
//       }
//     } else {
//       print("El servidor respondió con un estado de error: ${response.statusCode}");
//       return [];
//     }
//   } catch (e) {
//     print("Error al obtener medicamentos: $e");
//     return [];
//   }
// }

// List<MedicamentoModel> loadMedicamentos(Map<String, dynamic> jsonData) {
//   List<MedicamentoModel> listMedicamentos = [];
//   for (var data in jsonData['data']) {
//     listMedicamentos.add(MedicamentoModel.fromJson(data));
//   }
//   return listMedicamentos;
// }

  void read_vademecum() async {
    try {
      String URL_base = Env.URL_API;
      var url = URL_base + "/vademecum";
      var response = await _client_read_vademecum.post(url, body: {});

      if (response.statusCode == 200) {
        var responseDecode = jsonDecode(response.body);
        if (responseDecode['status'] != "Vacio") {
          list_medicamentos_vademecum = loadMedicamento(responseDecode);
          setState(() {
            loading = false;
          });
        } else {
          print("El servidor devolvió una respuesta vacía.");
        }
      } else {
        print(
            "El servidor respondió con un estado de error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error al obtener medicamentos: $e");
    }
  }

  static List<Medicamentos_database> loadMedicamento(var jsonString) {
    final List<Medicamentos_database> listMedicamentos = [];

    for (var medicamentos in jsonString['data']) {
      listMedicamentos.add(Medicamentos_database.fromJson(medicamentos));
    }
    return listMedicamentos;
  }

//*********************************************************************************************** */
  //bool _isChecked = false; // Valor seleccionado por defecto
  //bool _isExpanded = false;
  bool _isExpandedBuscador = true;
  TextEditingController dosis = TextEditingController();
  TextEditingController frecuencia = TextEditingController();

  @override
  Widget build(BuildContext context) {
    usuarioModel = Provider.of<UsuarioServices>(context);
    id_paciente = usuarioModel.usuario.paciente.id_paciente;

    return Builder(builder: (context) {
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
              Navigator.pushNamed(context, '/medicamentos');
            },
          ),
          title: Text("Buscador de Medicamentos",
              style: TextStyle(
                  fontFamily:
                      Theme.of(context).textTheme.headline1.fontFamily)),
        ),
        body: Form(
          key: _formKey_add_medicamento,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          loading
                              ? Container(
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator())
                              : AnimatedContainer(
                                  duration: Duration(milliseconds: 400),
                                  height: _isExpandedBuscador ? 100.0 : 0.0,
                                  child: searchTextField =
                                      AutoCompleteTextField<
                                          Medicamentos_database>(
                                    key: key,
                                    clearOnSubmit: false,
                                    suggestions: list_medicamentos_vademecum,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                        fontFamily: Theme.of(context)
                                            .textTheme
                                            .headline1
                                            .fontFamily),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(
                                          10.0, 30.0, 10.0, 20.0),
                                      hintText:
                                          "Ingrese el nombre del medicamento",
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: Theme.of(context)
                                              .textTheme
                                              .headline1
                                              .fontFamily),
                                    ),
                                    itemFilter: (item, query) {
                                      return item.nombre_comercial
                                          .toLowerCase()
                                          .startsWith(query.toLowerCase());
                                    },
                                    itemSorter: (a, b) {
                                      return a.nombre_comercial
                                          .compareTo(b.nombre_comercial);
                                    },
                                    itemSubmitted: (item) {
                                      setState(() {
                                        searchTextField.textField.controller
                                            .text = item.nombre_comercial;
                                        data_id = item.id_medicamento;
                                        print(data_id);
                                      });
                                    },
                                    itemBuilder: (context, item) {
                                      return row(item);
                                    },
                                  ),
                                ),
                          SizedBox(height: 40.0),
                          Center(
                            child: TextFormField(
                              controller: dosis,
                              decoration: InputDecoration(
                                hintText: 'Ingrese dosis',
                                hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .fontFamily),
                              ),
                              maxLength: 25,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Por favor ingrese la dosis';
                                }
                                return null;
                              },
                              onChanged: (text) {
                                print("Debe completar el campo");
                              },
                            ),
                          ),
                          SizedBox(height: 40.0),
                          Center(
                            child: TextFormField(
                              controller: frecuencia,
                              decoration: InputDecoration(
                                hintText: 'Ingrese la frecuencia',
                                hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .fontFamily),
                              ),
                              maxLength: 25,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Por favor ingrese la frecuencia';
                                }
                                return null;
                              },
                              onChanged: (text) {
                                print("Debe completar el campo");
                              },
                            ),
                          ),
                          SizedBox(height: 40.0),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: _isLoading
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: const CircularProgressIndicator(),
                          )
                        : const Icon(Icons.save_alt),
                    style: ElevatedButton.styleFrom(elevation: 8),
                    onPressed: () {
                      if (_formKey_add_medicamento.currentState.validate() &&
                          data_id != null &&
                          !_isLoading) {
                        _startLoading(data_id, dosis.text, frecuencia.text);
                      } else {
                        null;
                      }
                    },
                    label: Text(
                      'Agregar',
                      style: TextStyle(
                          fontFamily:
                              Theme.of(context).textTheme.headline1.fontFamily),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  var data_id;
  var data_error;
  var email_argument;
  var id_paciente;

  bool _isLoading = false;
  void _startLoading(int data_id, String dosis, String frecuencia) async {
    setState(() {
      _isLoading = true;
    });

    await guardar_medicamento(data_id, dosis, frecuencia);

    setState(() {
      _isLoading = false;
    });
  }

  guardar_medicamento(int data_id, String dosis, String frecuencia) async {
    try {
      String URL_base = Env.URL_API;
      var url = URL_base + "/save_medicamento";

      var response = await _client_add.post(url, body: {
        "id_paciente": id_paciente.toString(),
        "id_medicamento": data_id.toString(),
        "dosis": dosis,
        "frecuencia": frecuencia,
      });

      if (response.statusCode == 200) {
        _alert_informe(context, "Medicamento agregado correctamente", 1);
        Navigator.pushNamed(context, '/medicamentos');
      } else {
        var mensajeError = 'Error al guardar el medicamento: ' + response.body;
        _alert_informe(context, mensajeError, 2);
        throw Exception(mensajeError);
      }
    } catch (e) {
      // Error en la ejecución de la función
      print('Error en la función guardar_medicamento: $e');
      _alert_informe(context, "Error al guardar el medicamento", 2);
      throw Exception('Error al guardar el medicamento');
    }
  }

  getStringValuesSF(UsuarioServices usuarioServices) async {
    usuarioModel = Provider.of<UsuarioServices>(context);
    id_paciente = usuarioModel.usuario.paciente.id_paciente;
    email_argument = usuarioModel.usuario.emailUser;
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
