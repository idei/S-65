import 'package:app_salud/models/usuario_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:open_file/open_file.dart' as open_file;
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:http/http.dart' as http;
import '../models/datos_clinicos_model.dart';
import '../services/usuario_services.dart';
import 'env.dart';
import 'dart:convert';

TextEditingController email = TextEditingController();
TextEditingController email_nuevo = TextEditingController();
TextEditingController password = TextEditingController();
TextEditingController password_nuevo = TextEditingController();
String email_set_shared;
bool _isLoading = false;
bool _isEnabled = true;
var usuarioModel;
var id_paciente;

class HistorialClinico extends StatefulWidget {
  @override
  _AjustesState createState() => _AjustesState();
}

final _formKey_historial_clinico = GlobalKey<FormState>();

class _AjustesState extends State<HistorialClinico> {
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
              Navigator.pushNamed(context, '/datoscli');
            },
          ),
          title: Text('Historial Clínico',
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
                fontWeight: FontWeight.bold,
              )),
        ),
        body:
            // Column(
            //   children: [
            FutureBuilder<List<DatosClinicos>>(
                future: read_datos_clinicos(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                      children: ListTile.divideTiles(
                        color: Colors.black,
                        tiles: snapshot.data
                            .map((data) => ListTile(
                                  title: GestureDetector(
                                      onTap: () {
                                        // Navigator.of(context).pushNamed(
                                        //     '/ver_recordatorio_personal',
                                        //     arguments: {
                                        //       "id_recordatorio":
                                        //           data.id_recordatorio,
                                        //       "id_paciente": data.id_paciente,
                                        //       "descripcion": data.descripcion,
                                        //       "fecha_limite": data.fecha_limite,
                                        //       "estado_recordatorio":
                                        //           data.estado_recordatorio,
                                        //       "estado": estado,
                                        //     });
                                      },
                                      child: CardDinamic(data)),
                                ))
                            .toList(),
                      ).toList(),
                    );
                  } else {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Container(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ListTile(
                              title: Text(
                            'No tiene datos clínicos',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                fontFamily: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    .fontFamily),
                          )),
                        ],
                      ));
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        semanticsLabel: "Cargando",
                      ),
                    );
                  }
                }
                //}
                ),
        // Padding(
        //     padding: const EdgeInsets.all(16.0),
        //     child: ListView(children: <Widget>[
        //       ElevatedButton.icon(
        //         icon: _isLoading
        //             ? Padding(
        //                 padding: const EdgeInsets.symmetric(
        //                     horizontal: 10, vertical: 5),
        //                 child: const CircularProgressIndicator(),
        //               )
        //             : const Icon(Icons.download),
        //         style: ElevatedButton.styleFrom(
        //           primary: Theme.of(context).primaryColor,
        //         ),
        //         onPressed: () {
        //           _isLoading ? null : _startLoading();
        //         },
        //         label: Text(
        //             _isLoading
        //                 ? 'Cargando...'
        //                 : 'Exportar Historial Clínico',
        //             style: TextStyle(
        //                 color: Colors.white,
        //                 fontFamily: Theme.of(context)
        //                     .textTheme
        //                     .headline1
        //                     .fontFamily)),
        //       ),
        //       SizedBox(
        //         height: 20,
        //       ),
        //     ])),
        //],
        //)
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _isLoading ? null : _startLoading();
          },
          child: IconButton(
            icon: _isLoading
                ? Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: const CircularProgressIndicator(),
                  )
                : const Icon(Icons.download_sharp, color: Colors.white),
            // onPressed: () {
            //   Navigator.pushNamed(context, '/ver_datos_clinicos');
            // },
          ),
        ));
  }

  var color;
  var font_bold;
  var estado;

  Widget CardDinamic(data) {
    // final now = DateTime.now();
    // var dia;
    // var mes;

    // if (now.day < 10) {
    //   dia = '0' + now.day.toString();
    // } else {
    //   dia = now.day.toString();
    // }

    // if (now.month < 10) {
    //   mes = '0' + now.month.toString();
    // } else {
    //   mes = now.month.toString();
    // }

    // String formatter = now.year.toString() + "-" + mes + "-" + dia;
    // print(formatter);
    // DateTime fecha_limite1 = DateTime.parse(formatter);
    // DateTime fecha_limite = DateTime.parse(data.fecha_limite);

    // final difference = fecha_limite.difference(fecha_limite1).inDays;
    // print(difference);

    // if (difference < 0) {
    //   color = Colors.red;
    //   font_bold = FontWeight.bold;
    // } else if (difference == 1) {
    //   color = Colors.yellow;
    //   font_bold = FontWeight.bold;
    // } else if (difference > 1) {
    //   color = Colors.green;
    //   font_bold = FontWeight.bold;
    // }

    return Card(
      child: ListTile(
        leading: Container(
          width: 90,
          height: 30,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Text(
              data.fecha_alta,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/ver_datos_clinicos',
                  arguments: {"id_dato_clinico": data.id});
            },
            child: Text("Ver"),
          ),
        ),
        // title: Text(data.descripcion.toUpperCase(),
        //     maxLines: 4,
        //     style: TextStyle(
        //         fontFamily: Theme.of(context).textTheme.headline1.fontFamily)),
        // subtitle: Text(data.fecha_limite,
        //     style: TextStyle(
        //         fontFamily: Theme.of(context).textTheme.headline1.fontFamily)),
      ),
    );
  }

  void _startLoading() async {
    setState(() {
      _isLoading = true;
      _isEnabled = false;
    });

    await getStringValuesSF();

    setState(() {
      _isLoading = false;
      _isEnabled = true;
    });

    if (data != "Error") {
      pdf_table();
    } else {
      _alert_informe(context, 'No tiene datos clínicos registrados', 2);
    }
  }
}

getStringValuesSF() async {
  await read_datos_clinicos();
  await read_respuesta();
}

var data_respuesta;

read_respuesta() async {
  String URL_base = Env.URL_API;
  var url = URL_base + "/respuesta";
  var response = await http.post(url, body: {});
  data_respuesta = json.decode(response.body);
  print(response.body);
}

var data;

Future<List<DatosClinicos>> read_datos_clinicos() async {
  String URL_base = Env.URL_API;
  var url = URL_base + "/datos_clinicos";

  var response = await http.post(url, body: {
    "id_paciente": id_paciente.toString(),
  });

  var responseDecoder;

  if (response.statusCode == 200) {
    responseDecoder = json.decode(response.body);

    if (responseDecoder['status'] == "Success") {
      final List<DatosClinicos> listDatosClinicos = [];

      for (var datoClinico in responseDecoder['data']) {
        listDatosClinicos.add(DatosClinicos.fromJson(datoClinico));
      }
      return listDatosClinicos;
    } else {
      return null;
    }
  } else {
    throw Exception('Error al obtener JSON');
  }
}

pdf_table() async {
  var consume_alcohol;
  var consume_marihuana;
  var otras_drogas;
  var fuma_tabaco;

//Create a new PDF document
  PdfDocument document = PdfDocument();

//Create a PdfGrid class
  PdfGrid grid = PdfGrid();

//Add the columns to the grid
  grid.columns.add(count: 11);

//Add header to the grid
  grid.headers.add(1);

//Add the rows to the grid
  PdfGridRow header = grid.headers[0];

  header.cells[0].value = 'Fecha';
  header.cells[1].value = 'Presión Alta';
  header.cells[2].value = 'Presíon Baja';
  header.cells[3].value = 'Pulso';
  header.cells[4].value = 'Peso';
  header.cells[5].value = 'Circunferencia de Cintura';
  header.cells[6].value = 'Talla';
  header.cells[7].value = 'Consume Alcohol';
  header.cells[8].value = 'Consume Marihuana';
  header.cells[9].value = 'Otras Drogas';
  header.cells[10].value = 'Fuma Tabaco';

  for (var datas in data) {
    for (var data_respuestas in data_respuesta['data']) {
      if (datas["consume_alcohol"] == data_respuestas["id"]) {
        consume_alcohol = data_respuestas["respuesta"];
      }
      if (datas["consume_marihuana"] == data_respuestas["id"]) {
        consume_marihuana = data_respuestas["respuesta"];
      }
      if (datas["otras_drogas"] == data_respuestas["id"]) {
        otras_drogas = data_respuestas["respuesta"];
      }
      if (datas["fuma_tabaco"] == data_respuestas["id"]) {
        fuma_tabaco = data_respuestas["respuesta"];
      }
    }
    //Add rows to grid
    PdfGridRow row = grid.rows.add();
    row.cells[0].value = datas["fecha_alta"];
    row.cells[1].value = datas["presion_alta"];
    row.cells[2].value = datas["presion_baja"];
    row.cells[3].value = datas["pulso"];
    row.cells[4].value = datas["peso"];
    row.cells[5].value = datas["circunferencia_cintura"];
    row.cells[6].value = datas["talla"];
    row.cells[7].value = consume_alcohol;
    row.cells[8].value = consume_marihuana;
    row.cells[9].value = otras_drogas;
    row.cells[10].value = fuma_tabaco;
  }

//Set the grid style
  grid.style = PdfGridStyle(
      cellPadding: PdfPaddings(left: 1, right: 1, top: 1, bottom: 1),
      backgroundBrush: PdfBrushes.white,
      textBrush: PdfBrushes.black,
      font: PdfStandardFont(PdfFontFamily.timesRoman, 15));

//Draw the grid
  grid.draw(
      page: document.pages.add(), bounds: const Rect.fromLTWH(0, 0, 0, 0));

//Save and dispose the PDF document
  final List<int> bytes = document.save();
  document.dispose();

  final Directory directory =
      await path_provider.getApplicationDocumentsDirectory();
  final String path = directory.path;
  final File file = File('$path/historia_clinica.pdf');
  await file.writeAsBytes(bytes);
  //Launch the file (used open_file package)
  await open_file.OpenFile.open('$path/historia_clinica.pdf');
}

Future pdf() async {
  // Create a new PDF document.
  final PdfDocument document = PdfDocument();
// Add a PDF page and draw text.
  document.pages.add().graphics.drawString(
      'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 12),
      brush: PdfSolidBrush(PdfColor(0, 0, 0)),
      bounds: const Rect.fromLTWH(0, 0, 150, 20));
// Save the document.
  //File('HelloWorld.pdf').writeAsBytes(document.save());
// Dispose the document.
  //document.dispose();

  final List<int> bytes = document.save();
  //Dispose the document.
  document.dispose();
  //Get the storage folder location using path_provider package.
  final Directory directory =
      await path_provider.getApplicationDocumentsDirectory();
  final String path = directory.path;
  final File file = File('$path/output.pdf');
  await file.writeAsBytes(bytes);
  //Launch the file (used open_file package)
  await open_file.OpenFile.open('$path/output.pdf');
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

class Constants {
  static const String Ajustes = 'Ajustes';
  static const String Salir = 'Salir';
  static const List<String> choices = <String>[
    Ajustes,
    Salir,
  ];
}
