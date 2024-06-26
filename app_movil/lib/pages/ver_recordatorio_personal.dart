import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_salud/pages/env.dart';
import 'package:intl/intl.dart';

TextEditingController email = TextEditingController();
TextEditingController email_nuevo = TextEditingController();
TextEditingController password = TextEditingController();
TextEditingController password_nuevo = TextEditingController();

class VerRecordatorioPersonal extends StatefulWidget {
  @override
  _VerRecordatorioState createState() => _VerRecordatorioState();
}

final _formKey_ver_recordatorio = GlobalKey<FormState>();

var id_paciente;
var fecha_limite;
var rela_estado_recordatorio;
var descripcion;
var id_recordatorio;
var estado_text;
var estado_recordatorio;

class _VerRecordatorioState extends State<VerRecordatorioPersonal> {
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

  @override
  Widget build(BuildContext context) {
    Map parametros = ModalRoute.of(context).settings.arguments;
    id_recordatorio = parametros["id_recordatorio"];
    id_paciente = parametros["id_paciente"];
    rela_estado_recordatorio = parametros["estado_recordatorio"];
    descripcion = parametros["descripcion"];
    fecha_limite = parametros["fecha_limite"];
    estado_recordatorio = parametros["estado"];

    return FutureBuilder(
      future: Future.value(
          true), // Simulamos una operación asíncrona que se resuelve inmediatamente con el valor true
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // La operación asíncrona ha terminado
          return RecordatoriosPersonales();
        } else {
          // La operación aún no ha terminado, mostramos un indicador de carga
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Color.fromRGBO(45, 175, 168, 1),
              title: Text(
                'Recordatorio Personal',
                style: TextStyle(
                  fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
                ),
              ),
            ),
            body: Center(
              child: CircularProgressIndicator(
                semanticsLabel: "Cargando",
              ),
            ),
          );
        }
      },
    );
  }

  String fechaFormateada;

  Widget RecordatoriosPersonales() {
    final now = DateTime.now();
    var dia;
    var mes;

    if (now.day < 10) {
      dia = '0' + now.day.toString();
    } else {
      dia = now.day.toString();
    }

    if (now.month < 10) {
      mes = '0' + now.month.toString();
    } else {
      mes = now.month.toString();
    }

    String formatter = now.year.toString() + "-" + mes + "-" + dia;

    DateTime fecha_limite1 = DateTime.parse(formatter);
    DateTime fecha_limite2 = DateTime.parse(fecha_limite);

    final difference = fecha_limite2.difference(fecha_limite1).inDays;

    DateFormat dateFormatEntrada = DateFormat("yyyy-MM-dd");
    DateTime fechaEntrada = dateFormatEntrada.parse(fecha_limite);

    DateFormat dateFormatSalida = DateFormat("dd-MM-yyyy");
    fechaFormateada = dateFormatSalida.format(fechaEntrada);

    if (difference < 0) {
      estado_text = "Vencido";
    } else if (difference == 1) {
      estado_text = "Próximo a vencer";
    } else if (difference > 1) {
      estado_text = "Vigente";
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(45, 175, 168, 1),
        title: Text('Recordatorio Personal',
            style: TextStyle(
              fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
            )),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity, // Ancho igual al ancho de la pantalla
            child: Card(
              shadowColor: Color.fromRGBO(45, 175, 168, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.all(15),
              elevation: 10,
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Título: $descripcion"),
                        SizedBox(
                          height: 20,
                        ),
                        Text("Fecha Límite: $fechaFormateada "),
                        SizedBox(
                          height: 20,
                        ),
                        Text("Estado : $estado_text "),
                      ])),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Future<void> updateEstadoRecordartorio() async {
    try {
      String URL_base = Env.URL_API;
      var url = URL_base + "/update_recordatorio_personal";

      var response = await _client.post(url, body: {
        "id_recordatorio": id_recordatorio.toString(),
      });

      if (response.statusCode == 200) {
        // La solicitud se completó exitosamente
        var responseData = json.decode(response.body);
        // Aquí puedes agregar cualquier procesamiento adicional de la respuesta si es necesario
      } else {
        // La solicitud falló, puedes manejar el error aquí
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Ocurrió un error durante la solicitud
      print('Error: $e');
    }
  }
}
