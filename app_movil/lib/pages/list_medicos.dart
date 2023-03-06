import 'package:app_salud/models/medico_model.dart';
import 'package:app_salud/services/medico_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/opciones_navbar.dart';
import '../services/usuario_services.dart';
import 'env.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

var id_paciente;
String nombre_medico;
String apellido_medico;
var especialidad;
var matricula;
var rela_medico;
var medicoModel;

class ListMedicos extends StatefulWidget {
  @override
  _ListMedicosState createState() => _ListMedicosState();
}

final _formKey_list_medicos = GlobalKey<_ListMedicosState>();
List<MedicoModel> medicos_items;
bool _isLoading = false;

class _ListMedicosState extends State<ListMedicos> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    medicoModel = Provider.of<MedicoServices>(context);

    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/menu');
          },
        ),
        title: Text(
          'Mis Médicos',
          style: TextStyle(
            fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
          ),
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: choiceAction,
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
      body: FutureBuilder<List<MedicoModel>>(
        future: fetchMedicos(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            if (!_isLoading) {
              return Center(
                child: CircularProgressIndicator(
                  semanticsLabel: "Cargando",
                ),
              );
            } else {
              return Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                      title: Text(
                    'No tiene médicos vinculados',
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
          } else {
            return ListView(
              children: ListTile.divideTiles(
                color: Colors.black,
                tiles: snapshot.data
                    .map((data) => ListTile(
                          title: GestureDetector(
                            onTap: () {},
                            child: ListTile(
                              leading: Icon(
                                Icons.arrow_right_rounded,
                                color: Colors.blue,
                              ),
                              title: Text(
                                  data.nombre_medico +
                                      " " +
                                      data.apellido_medico,
                                  style: TextStyle(
                                      fontFamily: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .fontFamily)),
                              subtitle: Text(data.especialidad,
                                  style: TextStyle(
                                      fontFamily: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .fontFamily)),
                              trailing: Wrap(
                                spacing: 10, // space between two icons
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.text_snippet),
                                    color: Colors.green,
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, '/medico_perfil',
                                          arguments: {
                                            'id_paciente': id_paciente,
                                            'rela_medico': data.rela_medico,
                                            'especialidad': data.especialidad,
                                            'nombre_medico': data.nombre_medico,
                                            'apellido_medico':
                                                data.apellido_medico,
                                            'matricula': data.matricula
                                          });
                                    },
                                  ), // icon-1
                                ],
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ).toList(),
            );
          }
        },
      ),
    );
  }

  void choiceAction(String choice) {
    if (choice == Constants.Ajustes) {
      Navigator.pushNamed(context, '/ajustes');
    } else if (choice == Constants.Salir) {
      Navigator.pushNamed(context, '/');
    }
  }
}

get_preference() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  id_paciente = prefs.getInt("id_paciente");
}

Future<List<MedicoModel>> fetchMedicos() async {
  await get_preference();

  String URL_base = Env.URL_API;
  var url = URL_base + "/read_list_medicos";
  var response = await http.post(
    url,
    body: {
      "id_paciente": id_paciente.toString(),
    },
  );

  var responseDecode = jsonDecode(response.body);

  if (response.statusCode == 200 && responseDecode['status'] != 'Vacio') {
    final List<MedicoModel> medicos_items = [];

    for (var medicamentos in responseDecode['data']) {
      medicos_items.add(MedicoModel.fromJson(medicamentos));
    }
    return medicos_items;
  } else {
    _isLoading = true;
    return null;
  }
}
