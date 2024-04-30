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

  http.Client _client; // Cliente HTTP para realizar las solicitudes

  @override
  void initState() {
    _client = http.Client(); // Inicializar el cliente HTTP
    super.initState();
  }

  @override
  void dispose() {
    _client.close(); // Cerrar el cliente HTTP cuando la página se destruye
    super.dispose();
  }

  var datos_clinicos;
  Future getAllResponseDatosClinicos() async {
    String URL_base = Env.URL_API;
    var jsonDate;
    var url = URL_base + "/read_dato_clinico_paciente";

    var response = await _client.post(url, body: {
      "id_paciente": id_paciente.toString(),
      "id_dato_clinico": id_dato_clinico,
    });

    if (response.statusCode == 200) {
      jsonDate = json.decode(response.body);
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

  @override
  Widget build(BuildContext context) {
    usuarioModel = Provider.of<UsuarioServices>(context);
    id_paciente = usuarioModel.usuario.paciente.id_paciente;

    Map parametros = ModalRoute.of(context).settings.arguments;
    if (parametros != null) {
      id_dato_clinico = parametros['id_dato_clinico'];
    }

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
            future: getAllResponseDatosClinicos(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Muestra un indicador de carga mientras se espera la respuesta
              } else if (snapshot.hasError) {
                return Text(
                    'Error: ${snapshot.error}'); // Muestra un mensaje de error si ocurre un error
              } else if (snapshot.hasData) {
                List<dynamic> datosClinicosList =
                    snapshot.data; // Obtén la lista de datos clínicos
                Map<String, String> respuestas_opciones = {
                  "1": "Si",
                  "2": "No",
                  "902": "A veces (una vez al mes)",
                  "903": "Con frecuencia (una vez por semana)",
                  "904": "Siempre (casi todos los días)",
                };

                return Column(
                  children: datosClinicosList.map((datosClinicos) {
                    // Por ejemplo, puedes mostrar el nombre de cada dato clínico en un Text widget
                    return Column(
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
                            "¿Consume Alcohol?:" +
                                    respuestas_opciones[
                                        datosClinicos['consume_alcohol']
                                            .toString()] ??
                                "Desconocido",
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
                            "¿Fuma Tabaco?: " +
                                    respuestas_opciones[
                                        datosClinicos['fuma_tabaco']
                                            .toString()] ??
                                "Desconocido",
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
                            "¿Fuma Marihuana?: " +
                                    respuestas_opciones[
                                        datosClinicos['consume_marihuana']
                                            .toString()] ??
                                "Desconocido",
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
                                  "¿Consume otras drogas?: " +
                                          respuestas_opciones[
                                              datosClinicos['otras_drogas']
                                                  .toString()] ??
                                      "Desconocido",
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
                    );
                  }).toList(),
                );
              } else {
                return Text(
                    'No hay datos disponibles'); // Muestra un mensaje si no hay datos disponibles
              }
            },
          ),
        ),
      );
    });
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
