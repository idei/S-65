import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'login_page.dart';
import 'package:http/http.dart' as http;
import 'env.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

TextEditingController fecha_limite = TextEditingController();
TextEditingController titulo = TextEditingController();
var email;

class RecordatorioPersonal extends StatefulWidget {
  @override
  _RecuperarState createState() => _RecuperarState();
}

final _formKey_recuperar = GlobalKey<FormState>();

class _RecuperarState extends State<RecordatorioPersonal> {
  @override
  Widget build(BuildContext context2) {
    final format = DateFormat("yyyy-MM-dd");
    final initialValue = DateTime.now();

    DateTime value = DateTime.now();
    int changedCount = 0;

    return Scaffold(
        appBar: AppBar(
          title: Text('Nuevo Recordatorio Personal',
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
              )),
          actions: <Widget>[],
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
                      controller: titulo,
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
                      controller: fecha_limite,
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
                    ElevatedButton(
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
                          guardar_datos(context);
                        }
                      },
                    )
                  ]))),
        ));
  }
}

getStringValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String email_prefer = prefs.getString("email_prefer");

  email = email_prefer;
  print(email);
}

guardar_datos(context) async {
  await getStringValuesSF();
  String URL_base = Env.URL_API;
  var url = URL_base + "/new_recordatorio_personal";
  var response = await http.post(url, body: {
    "email": email,
    "titulo": titulo.text,
    "fecha_limite": fecha_limite.text,
  });

  var responseDecode = jsonDecode(response.body);

  if (response.statusCode == 200 && responseDecode['status'] == "Success") {
    _alert_informe(context, "Recordatorio creado correctamente", 1);
    Navigator.of(context).pushReplacementNamed('/recordatorio');
  } else {
    _alert_informe(context, "Error al guardar: ${responseDecode['status']}", 2);
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
