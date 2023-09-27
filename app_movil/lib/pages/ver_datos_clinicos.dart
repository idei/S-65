import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../services/usuario_services.dart';
import 'env.dart';

class VerDatosClinicos extends StatefulWidget {
  final pageName = '/form_datos_clinicos';

  @override
  _VerDatosClinicosState createState() => _VerDatosClinicosState();
}

class _VerDatosClinicosState extends State<VerDatosClinicos> {
  List dataRespuestas;

  GlobalKey<FormState> _formKey_ver_datos_clinicos = GlobalKey<FormState>();

  var usuarioModel;
  var id_paciente;
  var id_dato_clinico;
  var otras_drogas_text;
  var consume_alcohol_text;
  var fuma_tabaco_text;
  var consume_marihuana_text;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    usuarioModel = Provider.of<UsuarioServices>(context);
    id_paciente = usuarioModel.usuario.paciente.id_paciente;

    Map parametros = ModalRoute.of(context).settings.arguments;
    if (parametros != null) {
      id_dato_clinico = parametros['id_dato_clinico'];
    }

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
              Navigator.pushNamed(context, '/historial_clinico');
            },
          ),
          title: Text('Datos Clínicos',
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
              )),
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: getAllRespuesta(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Map<String, dynamic> datosClinicos = snapshot.data;

                Map<String, String> respuestas_opciones = {
                  "1": "Si",
                  "2": "No",
                  "902": "A veces (una vez al mes)",
                  "903": "Con frecuencia (una vez por semana)",
                  "904": "Siempre (casi todos los días)",
                };

                otras_drogas_text =
                    respuestas_opciones[datosClinicos['otras_drogas']] ??
                        "Desconocido";
                consume_alcohol_text =
                    respuestas_opciones[datosClinicos['consume_alcohol']] ??
                        "Desconocido";
                consume_marihuana_text =
                    respuestas_opciones[datosClinicos['consume_marihuana']] ??
                        "Desconocido";
                fuma_tabaco_text =
                    respuestas_opciones[datosClinicos['fuma_tabaco']] ??
                        "Desconocido";

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Presión Alta : " +
                                      datosClinicos['presion_alta'],
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .fontFamily,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Presión Baja: " +
                                      datosClinicos['presion_baja'],
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .fontFamily),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                    "Pulso (por minuto): " +
                                        datosClinicos['pulso'],
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontFamily: Theme.of(context)
                                            .textTheme
                                            .headline1
                                            .fontFamily)),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Peso(kg): " + datosClinicos['peso'],
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .fontFamily),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Talla / Altura (mts): " +
                                      datosClinicos['talla'],
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .fontFamily),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Circunferencia de Cintura (cm): " +
                                      datosClinicos['circunferencia_cintura'],
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .fontFamily),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Container(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "¿Consume Alcohol?: $consume_alcohol_text.",
                            textAlign: TextAlign
                                .justify, // Alinea el texto y justifica el texto
                            style: TextStyle(
                                fontSize: 17,
                                fontFamily: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    .fontFamily),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "¿Fuma Tabaco?: $fuma_tabaco_text .",
                            style: TextStyle(
                                fontSize: 17,
                                fontFamily: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    .fontFamily),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "¿Fuma Marihuana?: $consume_marihuana_text.",
                            style: TextStyle(
                                fontSize: 17,
                                fontFamily: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    .fontFamily),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  "¿Consume otras drogas?: $otras_drogas_text.",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .fontFamily),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListTile(
                        title: Text(
                      'No tiene dato clínico',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontFamily:
                              Theme.of(context).textTheme.headline1.fontFamily),
                    )),
                  ],
                ));
              }
              return Center(
                child: CircularProgressIndicator(
                  semanticsLabel: "Cargando",
                ),
              );
            },
          ),
        ));
  }

  var datos_clinicos;
  Future getAllRespuesta() async {
    String URL_base = Env.URL_API;
    var url = URL_base + "/read_datos_clinicos_paciente";
    var response = await http.post(url, body: {
      "id_paciente": id_paciente,
      "id_dato_clinico": id_dato_clinico,
    });

    if (response.statusCode == 200) {
      var jsonDate = json.decode(response.body);
      if (jsonDate['status'] == 'Success') {
        datos_clinicos = jsonDate['data'];
        return datos_clinicos;
      } else {
        return null;
      }
    } else {
      throw Exception('Error al obtener JSON');
    }
  }

  Widget CardGenerico(StatefulWidget widget, String pregunta) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: EdgeInsets.all(10),
        elevation: 10,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  pregunta,
                  style: TextStyle(
                      fontSize: 17.0,
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                      fontWeight: FontWeight.bold),
                ),
              ),
              widget,
            ],
          ),
        ));
  }
}
