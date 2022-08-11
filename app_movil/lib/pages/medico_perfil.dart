import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/opciones_navbar.dart';
import 'env.dart';
import 'package:http/http.dart' as http;

var id_paciente;
String nombre_medico;
String apellido_medico;
var especialidad;
var matricula;
var rela_medico;

class MedicoPerfil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map parametros = ModalRoute.of(context).settings.arguments;

    id_paciente = parametros['id_paciente'];
    rela_medico = parametros['rela_medico'];
    nombre_medico = parametros['nombre_medico'];
    apellido_medico = parametros['apellido_medico'];
    especialidad = parametros['especialidad'];
    matricula = parametros['matricula'];

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamed(context, '/list_medicos');
            },
          ),
          title: Text(
            'Perfil del Dr/a ',
            style: TextStyle(
              fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
            ),
          ),
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
        body: FutureBuilder(
          future: read_medico(context, rela_medico),
          builder: (context, snapshot) {
            return Form(
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView(children: <Widget>[
                      CardPerfilMedico(),
                      SizedBox(
                        height: 30,
                      ),
                    ])));
          },
        ));
  }
}

class CardPerfilMedico extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.person),
              title: Text("$nombre_medico $apellido_medico",
                  style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily)),
              subtitle: Text(
                  'Matricula: $matricula \n Especialidad: $especialidad',
                  style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily)),
            ),
          ],
        ),
      ),
    );
  }
}

read_medico(BuildContext context, var rela_medico) async {
  // String URL_base = Env.URL_PREFIX;
  // var url = URL_base + "/read_medico.php";
  // var response = await http.post(url, body: {
  //   "rela_paciente": id_paciente.toString(),
  // });

  // print(response.body);
  // var data = json.decode(response.body);

  // if (response.statusCode == 200) {
  //   nombre_medico = data["nombre"];
  //   apellido_medico = data["apellido"];
  //   especialidad = data["especialidad"];
  //   matricula = data["matricula"];
  // }
}
