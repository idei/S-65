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

  static List<Medicamentos_database> list_medicamentos_vademecum;

  bool loading = true;

  var usuarioModel;

  void read_vademecum() async {
    try {
      String URL_base = Env.URL_API;
      var url = URL_base + "/vademecum";
      var response = await http.post(url, body: {});

      var responseDecode = jsonDecode(response.body);

      if (response.statusCode == 200 && responseDecode['status'] != "Vacio") {
        list_medicamentos_vademecum = loadMedicamento(responseDecode);
        setState(() {
          loading = false;
        });
      } else {
        if (responseDecode['status'] != "Vacio") {
          print(responseDecode['status']);
        }
      }
    } catch (e) {
      print("Error getting medicamentos.");
    }
  }

  static List<Medicamentos_database> loadMedicamento(var jsonString) {
    final List<Medicamentos_database> listMedicamentos = [];

    for (var medicamentos in jsonString['data']) {
      listMedicamentos.add(Medicamentos_database.fromJson(medicamentos));
    }
    return listMedicamentos;
  }

  @override
  void initState() {
    read_vademecum();
    super.initState();
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

  bool _isChecked = false; // Valor seleccionado por defecto
  bool _isExpanded = false;
  bool _isExpandedBuscador = true;

  @override
  Widget build(BuildContext context) {
    usuarioModel = Provider.of<UsuarioServices>(context);
    id_paciente = usuarioModel.usuario.paciente.id_paciente;
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
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
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
                        AutoCompleteTextField<Medicamentos_database>(
                      key: key,
                      clearOnSubmit: false,
                      suggestions: list_medicamentos_vademecum,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontFamily:
                              Theme.of(context).textTheme.headline1.fontFamily),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
                        hintText: "Ingrese el nombre del medicamento",
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
                        return a.nombre_comercial.compareTo(b.nombre_comercial);
                      },
                      itemSubmitted: (item) {
                        setState(() {
                          searchTextField.textField.controller.text =
                              item.nombre_comercial;
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
            // Container(
            //   alignment: Alignment.centerLeft,
            //   child: CheckboxListTile(
            //     contentPadding:
            //         EdgeInsets.zero, // Ajusta el relleno alrededor del título
            //     title: Text('¿No encuentra su medicamento?'),
            //     value: _isChecked,
            //     onChanged: (bool value) {
            //       setState(() {
            //         _isChecked = value;
            //        // _isExpanded = value;
            //         //_isExpandedBuscador = !value;
            //       });
            //     },
            //   ),
            // ),
            // AnimatedContainer(
            //   duration: Duration(milliseconds: 400),
            //   height: _isExpanded ? 100.0 : 0.0,
            //   child: TextFormField(
            //     decoration: InputDecoration(
            //       labelText: 'Ingrese el nombre del medicamento',
            //     ),
            //   ),
            // ),
            SizedBox(height: 40.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(),
              onPressed: () {
                guardar_medicamento(int.parse(data_id));
              },
              child: Text('Aceptar',
                  style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily)),
            )
          ],
        ),
      ),
    );
  }

  var data_id;

  var data_error;
  var email_argument;
  var id_paciente;

  guardar_medicamento(int data_id) async {
    String URL_base = Env.URL_API;
    var url = URL_base + "/save_medicamento";
    var response = await http.post(url, body: {
      "id_paciente": id_paciente.toString(),
      "id_medicamento": data_id.toString(),
    });

    if (response.statusCode == 200) {
      _alert_informe(context, "Medicamento Agregado", 1);
      Navigator.pushNamed(context, '/medicamentos');
    } else {
      var mensajeError = 'Error al obtener JSON: ' + response.body;
      _alert_informe(context, mensajeError, 2);
      throw Exception(mensajeError);
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
