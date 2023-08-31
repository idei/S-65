import 'package:app_salud/models/medico_model.dart';
import 'package:app_salud/services/medico_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/opciones_navbar.dart';
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

class _ListMedicosState extends State<ListMedicos>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Offset> _slideAnimation;
  bool _isCardVisible = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000), // Duración de la animación
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0, -1), // Desplazamiento hacia arriba
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut, // Curva de animación
    ));
  }

  void _handleAccept() {
    _animationController.forward().then((value) {
      setState(() {
        // Actualizar el estado para eliminar el Card después de la animación
        _isCardVisible = false;
      });

      _alert_informe(context, "Médico vinculado correctamente", 1);
    });
  }

  void _handleCancel() {
    _animationController.forward().then((value) {
      setState(() {
        // Actualizar el estado para eliminar el Card después de la animación
        _isCardVisible = false;
      });

      _alert_informe(context, "Se rechazó la vinculación", 2);
    });
  }

  @override
  Widget build(BuildContext context) {
    medicoModel = Provider.of<MedicoServices>(context);

    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: CircleAvatar(
            radius: MediaQuery.of(context).size.width / 30,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.arrow_back,
              color: Colors.blue,
            ),
          ),
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
            return Column(
              children: [
                // AnimatedBuilder(
                //   animation: _animationController,
                //   builder: (BuildContext context, Widget child) {
                //     return SlideTransition(
                //       position: _slideAnimation,
                //       child: _isCardVisible
                //           ? Card(
                //               child: Column(
                //                 children: [
                //                   Container(
                //                     height: 60,
                //                     width: double.infinity,
                //                     child: Center(
                //                       child: Text(
                //                         'Tiene una solicitud de la Dra Estefania Lucero',
                //                         style: TextStyle(fontSize: 16),
                //                       ),
                //                     ),
                //                   ),
                //                   SizedBox(height: 5),
                //                   Row(
                //                     mainAxisAlignment: MainAxisAlignment.center,
                //                     children: [
                //                       ElevatedButton(
                //                         onPressed: _handleAccept,
                //                         child: Text('Aceptar'),
                //                       ),
                //                       SizedBox(width: 10),
                //                       ElevatedButton(
                //                         onPressed: _handleCancel,
                //                         child: Text('Denegar'),
                //                       ),
                //                     ],
                //                   ),
                //                   SizedBox(height: 5),
                //                 ],
                //               ),
                //             )
                //           : SizedBox(),
                //     );
                //   },
                // ),
                // SizedBox(height: 5),
                Expanded(
                  child: ListView(
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
                                          icon: Icon(
                                            Icons.text_snippet,
                                            size: 30,
                                          ),
                                          color: Colors.green,
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/medico_perfil',
                                                arguments: {
                                                  'id_paciente': id_paciente,
                                                  'rela_medico':
                                                      data.rela_medico,
                                                  'especialidad':
                                                      data.especialidad,
                                                  'nombre_medico':
                                                      data.nombre_medico,
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
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  _alert_informe(context, message, colorNumber) {
    var color;
    colorNumber == 1 ? color = Colors.green[800] : color = Colors.red[600];

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(milliseconds: 2000),
      backgroundColor: color,
      content: Text(message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white)),
    ));
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
