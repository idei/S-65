import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../services/usuario_services.dart';
import 'env.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

var id_paciente;
var usuarioModel;

class RecordatorioPersonal extends StatefulWidget {
  @override
  _RecuperarState createState() => _RecuperarState();
}

final _formKey_recuperar = GlobalKey<FormState>();

class _RecuperarState extends State<RecordatorioPersonal> {
  TextEditingController fechaLimiteController = TextEditingController();
  TextEditingController tituloController = TextEditingController();
  http.Client _client; // Cliente HTTP para realizar las solicitudes

  @override
  void initState() {
    _client = http.Client(); // Inicializar el cliente HTTP
    super.initState();
    fechaLimiteController.text = '';
    tituloController.text = '';
  }

  @override
  Widget build(BuildContext context2) {
    final format = DateFormat("yyyy-MM-dd");
    final initialValue = DateTime.now();

    DateTime value = DateTime.now();
    int changedCount = 0;

    usuarioModel = Provider.of<UsuarioServices>(context);

    id_paciente = usuarioModel.usuario.paciente.id_paciente;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(45, 175, 168, 1),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, '/recordatorio');
            },
          ),
          title: Text('Nuevo Recordatorio Personal',
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
              )),
        ),
        body: Center(
          child: Form(
              key: _formKey_recuperar,
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(children: <Widget>[
                    Text("Ingrese un título",
                        style: TextStyle(
                            fontFamily: Theme.of(context)
                                .textTheme
                                .headline1
                                .fontFamily)),
                    TextFormField(
                      controller: tituloController,
                      validator: (value) {
                        if (value.isEmpty || value.length == 0) {
                          return 'Por favor ingrese título';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        labelText: '',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text("Ingrese la fecha",
                        style: TextStyle(
                            fontFamily: Theme.of(context)
                                .textTheme
                                .headline1
                                .fontFamily)),
                    DateTimeField(
                      controller: fechaLimiteController,
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
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (date) => setState(() {
                        value = date;
                        changedCount++;
                      }),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromRGBO(45, 175, 168, 1),
                        ),
                        child: Container(
                          child: Text('Guardar',
                              style: TextStyle(
                                fontFamily: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    .fontFamily,
                              )),
                        ),
                        onPressed: () {
                          if (_formKey_recuperar.currentState.validate()) {
                            guardarDatos(context);
                          }
                        },
                      ),
                    )
                  ]))),
        ));
  }

  @override
  void dispose() {
    _client.close(); // Cerrar el cliente HTTP cuando la página se destruye
    super.dispose();
  }

  guardarDatos(BuildContext context) async {
    try {
      // Validar campos de entrada
      if (tituloController.text.isEmpty || fechaLimiteController.text.isEmpty) {
        throw Exception('Por favor completa todos los campos.');
      }

      String URL_base = Env.URL_API;
      var url = URL_base + "/new_recordatorio_personal";
      var response = await _client.post(url, body: {
        "id_paciente": id_paciente.toString(),
        "titulo": tituloController.text,
        "fecha_limite": fechaLimiteController.text,
      });

      var responseDecode = jsonDecode(response.body);

      if (response.statusCode == 200 && responseDecode['status'] == "Success") {
        _alert_informe(context, "Recordatorio creado correctamente", 1);
        Navigator.of(context).pushReplacementNamed('/recordatorio');
      } else {
        throw Exception('Error al guardar: ${responseDecode['status']}');
      }
    } catch (e) {
      print('Error al guardar los datos: $e');
      _alert_informe(context, "Error al guardar: $e", 2);
      Navigator.of(context).pushReplacementNamed('/recordatorio');
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
}
