import 'package:app_salud/pages/menu.dart';
import 'package:provider/provider.dart';
import '../models/medicamento_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/usuario_services.dart';
import 'env.dart';

class MedicamentoPage extends StatefulWidget {
  @override
  _MedicamentoState createState() => _MedicamentoState();
}

TextEditingController dosis_frecuencia = TextEditingController();

class _MedicamentoState extends State<MedicamentoPage> {
  var data;
  bool isLoading = false;
  var email_argument;
  var usuarioModel;
  var id_paciente;
  double sizeIconEditar;
  double sizeIconDelete;
  double radiusIconEditar;
  double radiusIconDelete;
  double radiusCircle;

  @override
  Widget build(BuildContext context) {
    usuarioModel = Provider.of<UsuarioServices>(context);

    email_argument = usuarioModel.usuario.emailUser;
    id_paciente = usuarioModel.usuario.paciente.id_paciente;

    if (isTablet) {
      sizeIconEditar = 30.0;
      sizeIconDelete = 30.0;
      radiusIconEditar = 28.0;
      radiusIconDelete = 28.0;
      radiusCircle = 0.032;
    } else {
      sizeIconEditar = 16.0;
      sizeIconDelete = 16.0;
      radiusIconEditar = 26.0;
      radiusIconDelete = 26.0;
      radiusCircle = 0.04;
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
                Navigator.pushNamed(context, '/menu');
              },
            ),
            title: Text(
              'Mis Medicamentos',
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
              ),
            )),
        body: Container(
          child: FutureBuilder<List<MedicamentoModel>>(
            future: read_medicamentos(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    semanticsLabel: "Cargando",
                  ),
                );
              } else if (snapshot.hasData) {
                return ListView(
                  children: ListTile.divideTiles(
                      color: Colors.black26,
                      tiles: snapshot.data.map(
                        (data) => Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ListTile(
                            title: Text(data.nombre_comercial,
                                style: TextStyle(
                                    overflow: TextOverflow.clip,
                                    fontFamily: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .fontFamily)),
                            subtitle: Text(data.dosis_frecuencia,
                                style: TextStyle(
                                    fontFamily: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .fontFamily)),
                            trailing: Wrap(children: [
                              // CircleAvatar(
                              //   radius: MediaQuery.of(context).size.width /
                              //       radiusIconEditar,
                              //   backgroundColor: Colors.blue,
                              //   child: IconButton(
                              //     icon: Icon(
                              //       Icons.edit,
                              //       color: Colors.white,
                              //       size: sizeIconEditar,
                              //     ),
                              //     onPressed: () {
                              //       _showAlertDialog(
                              //         int.parse(data.id_medicamento),
                              //         data.dosis_frecuencia,
                              //         1,
                              //       );
                              //     },
                              //   ),
                              // ),
                              CircleAvatar(
                                radius: MediaQuery.of(context).size.width *
                                    radiusCircle, // Ajusta el tamaño según el ancho de la pantalla
                                backgroundColor: Colors.blue,
                                child: FractionallySizedBox(
                                  widthFactor:
                                      0.9, // Controla el tamaño del icono dentro del CircleAvatar
                                  heightFactor:
                                      0.9, // Controla el tamaño del icono dentro del CircleAvatar
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size:
                                          sizeIconEditar, // Ajusta el tamaño del icono según tus necesidades
                                    ),
                                    onPressed: () {
                                      _showAlertDialog(
                                        data.id_medicamento,
                                        data.dosis_frecuencia,
                                        1,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 25,
                              ),
                              CircleAvatar(
                                radius: MediaQuery.of(context).size.width *
                                    radiusCircle, // Ajusta el tamaño según el ancho de la pantalla
                                backgroundColor: Colors.red,
                                child: FractionallySizedBox(
                                  widthFactor:
                                      0.9, // Controla el tamaño del icono dentro del CircleAvatar
                                  heightFactor:
                                      0.9, // Controla el tamaño del icono dentro del CircleAvatar
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size:
                                          sizeIconDelete, // Ajusta el tamaño del icono según tus necesidades
                                    ),
                                    onPressed: () {
                                      _showAlertDialog(
                                        int.parse(data.id_medicamento),
                                        data.dosis_frecuencia,
                                        2,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              //-------------------
                              // CircleAvatar(
                              //   radius: MediaQuery.of(context).size.width /
                              //       radiusIconDelete,
                              //   backgroundColor: Colors.red,
                              //   child: IconButton(
                              //     icon: Icon(
                              //       Icons.delete,
                              //       size: sizeIconDelete,
                              //     ),
                              //     color: Colors.white,
                              //     onPressed: () {
                              //       _showAlertDialog(
                              //         int.parse(data.id_medicamento),
                              //         data.dosis_frecuencia,
                              //         2,
                              //       );
                              //     },
                              //   ),
                              // ),
                            ]),
                          ),
                        ),
                      )).toList(),
                );
              } else {
                return Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListTile(
                        title: Text(
                      'No tiene medicamentos registrados',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily:
                              Theme.of(context).textTheme.headline1.fontFamily),
                    )),
                  ],
                ));
              }

              // if (snapshot.hasData) {
              //   return ListView(
              //     children: ListTile.divideTiles(
              //       color: Colors.black26,
              //       tiles: snapshot.data
              //           .map((data) => ListTile(
              //                 title: ListTile(
              //                   leading: Icon(
              //                     Icons.arrow_right_rounded,
              //                     color: Colors.blue,
              //                     size: 38.0,
              //                   ),
              //                   title: Text(data.nombre_comercial,
              //                       style: TextStyle(
              //                           overflow: TextOverflow.clip,
              //                           fontFamily: Theme.of(context)
              //                               .textTheme
              //                               .headline1
              //                               .fontFamily)),
              //                   subtitle: Text(data.dosis_frecuencia,
              //                       style: TextStyle(
              //                           fontFamily: Theme.of(context)
              //                               .textTheme
              //                               .headline1
              //                               .fontFamily)),
              //                   trailing: Wrap(children: [
              //                     CircleAvatar(
              //                       radius: MediaQuery.of(context).size.width /
              //                           radiusIconEditar,
              //                       backgroundColor: Colors.blue,
              //                       child: IconButton(
              //                         icon: Icon(
              //                           Icons.edit,
              //                           color: Colors.white,
              //                           size: sizeIconEditar,
              //                         ),
              //                         onPressed: () {
              //                           _showAlertDialog(
              //                             int.parse(data.id_medicamento),
              //                             data.dosis_frecuencia,
              //                             1,
              //                           );
              //                         },
              //                       ),
              //                     ),
              //                     SizedBox(
              //                       width: 25,
              //                     ),
              //                     CircleAvatar(
              //                       radius: MediaQuery.of(context).size.width /
              //                           radiusIconDelete,
              //                       backgroundColor: Colors.red,
              //                       child: IconButton(
              //                         icon: Icon(
              //                           Icons.delete,
              //                           size: sizeIconDelete,
              //                         ),
              //                         color: Colors.white,
              //                         onPressed: () {
              //                           _showAlertDialog(
              //                             int.parse(data.id_medicamento),
              //                             data.dosis_frecuencia,
              //                             2,
              //                           );
              //                         },
              //                       ),
              //                     ),
              //                   ]),
              //                 ),
              //               ))
              //           .toList(),
              //     ).toList(),
              //   );
              // } else {
              //   if (!isLoading) {
              //     return Container(
              //       alignment: Alignment.center,
              //       child: Positioned(
              //         child: _isLoadingIcon(),
              //       ),
              //     );
              //   } else {
              //     return Container(
              //         child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         ListTile(
              //             title: Text(
              //           'No tiene medicamentos registrados',
              //           textAlign: TextAlign.center,
              //           style: TextStyle(
              //               fontWeight: FontWeight.bold,
              //               fontFamily: Theme.of(context)
              //                   .textTheme
              //                   .headline1
              //                   .fontFamily),
              //         )),
              //       ],
              //     ));
              //   }
              // }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
          },
          child: IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/medicamentosAdd');
            },
          ),
        ));
  }

  Future<List<MedicamentoModel>> read_medicamentos() async {
    //String URL_base = Env.URL_PREFIX;
    String URL_base = Env.URL_API;
    var url = URL_base + "/medicamentos";
    var responseDecode;

    var response = await http.post(url, body: {
      "id_paciente": id_paciente.toString(),
    });

    if (response.statusCode == 200) {
      responseDecode = jsonDecode(response.body);
      if (responseDecode['status'] != "Vacio") {
        final List<MedicamentoModel> listMedicamentos = [];

        for (var medicamentos in responseDecode['data']) {
          listMedicamentos.add(MedicamentoModel.fromJson(medicamentos));
        }
        return listMedicamentos;
      } else {
        isLoading = true;
        return null;
      }
    } else {
      throw Exception('Error al obtener JSON');
    }
  }

  guardarFrecuenciaMedicamento(
      int id_medicamento, String dosis_frecuencia) async {
    String URL_base = Env.URL_API;
    var url = URL_base + "/save_dosis_frecuencia";
    var response = await http.post(url, body: {
      "dosis_frecuencia": dosis_frecuencia,
      "id_medicamento": id_medicamento.toString(),
      "id_paciente": id_paciente.toString(),
    });
    data = json.decode(response.body);
    print(response.body);
  }

  void _showAlertDialog(
      int id_medicamento, String data_frecuencia, int button_pressed) {
    dosis_frecuencia.text = data_frecuencia.toString();
    showDialog(
        context: context,
        builder: (buildcontext) {
          if (button_pressed == 1) {
            return AlertDialog(
              title: Text("Ingrese dosis y frecuencia",
                  style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily)),
              content: TextFormField(
                controller: dosis_frecuencia,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Por favor ingrese los datos';
                  }
                  return null;
                },
                onChanged: (text) {
                  print("Debe completar el campo");
                },
              ),
              actions: <Widget>[
                Center(
                  child: ElevatedButton(
                    child: Text(
                      "Guardar",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily,
                      ),
                    ),
                    onPressed: () {
                      guardarFrecuenciaMedicamento(
                          id_medicamento, dosis_frecuencia.text);
                      Navigator.popAndPushNamed(context, "/medicamentos");
                    },
                  ),
                )
              ],
            );
          } else {
            return AlertDialog(
              title: Text("¿Esta seguro de querer eliminar este medicamento?",
                  style: TextStyle(
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily)),
              actions: <Widget>[
                ElevatedButton(
                    onPressed: () {
                      delete_medicamento(context, id_medicamento);
                    },
                    child: Text("Si")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("No")),
              ],
            );
          }
        });
  }

  delete_medicamento(BuildContext context, var id_medicamento) async {
    String URL_base = Env.URL_API;
    var url = URL_base + "/delete_medicamento";
    var response = await http.post(url, body: {
      "id_medicamento": id_medicamento.toString(),
      "id_paciente": id_paciente.toString(),
    });

    if (response.statusCode == 200) {
      _alert_informe(context, "Medicamento Eliminado", 1);
      Navigator.popAndPushNamed(context, "/medicamentos");
    } else {
      var mensajeError = 'Error al obtener JSON: ' + response.body;
      _alert_informe(context, mensajeError, 2);
      throw Exception(mensajeError);
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
