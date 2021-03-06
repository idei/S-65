import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:open_file/open_file.dart' as open_file;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:http/http.dart' as http;
import 'env.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

TextEditingController email = TextEditingController();
TextEditingController email_nuevo = TextEditingController();
TextEditingController password = TextEditingController();
TextEditingController password_nuevo = TextEditingController();
String email_set_shared;

class HistorialClinico extends StatefulWidget {
  @override
  _AjustesState createState() => _AjustesState();
}

final _formKey = GlobalKey<FormState>();
final _formKey_email = GlobalKey<FormState>();
final _formKey_pass = GlobalKey<FormState>();

class _AjustesState extends State<HistorialClinico> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Historial Clínico',
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
                fontWeight: FontWeight.bold,
              )),
          actions: <Widget>[
            PopupMenuButton<String>(
              itemBuilder: (BuildContext context) {
                return Constants.choices.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            )
          ],
        ),
        body: Form(
            key: _formKey,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      pdf_table();
                    },
                    child: Text(
                      'Exportar Historial Clínico',
                      style: TextStyle(
                          fontFamily:
                              Theme.of(context).textTheme.headline1.fontFamily),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ]))));
  }
}

String email_prefer;
var id_paciente;

getStringValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  email_prefer = prefs.getString("email_prefer");
  id_paciente = prefs.getInt("id_paciente");
  print(email_prefer);

  //Obtengo datos clinicos del paciente
  await read_datos_clinicos();
  await read_respuesta();
}

var data_respuesta;

read_respuesta() async {
  String URL_base = Env.URL_PREFIX;
  var url = URL_base + "/respuesta.php";
  var response = await http.post(url, body: {});
  data_respuesta = json.decode(response.body);
  print(response.body);
}

var data;

read_datos_clinicos() async {
  String URL_base = Env.URL_PREFIX;
  var url = URL_base + "/read_datos_clinicos.php";
  print("id_paciente");
  print(id_paciente);
  var response = await http.post(url, body: {
    "id_paciente": id_paciente.toString(),
  });
  data = json.decode(response.body);
  print(response.body);
}

pdf_table() async {
  var consume_alcohol;
  var consume_marihuana;
  var otras_drogas;
  var fuma_tabaco;

  //Obtengo datos del paciente almacenados en el telefono
  await getStringValuesSF();

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
    for (var data_respuestas in data_respuesta) {
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

class Constants {
  static const String Ajustes = 'Ajustes';
  static const String Salir = 'Salir';
  static const List<String> choices = <String>[
    Ajustes,
    Salir,
  ];
}
