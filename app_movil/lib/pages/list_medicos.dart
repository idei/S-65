import 'package:app_salud/models/medico_model.dart';
import 'package:app_salud/pages/screening_adlq.dart';
import 'package:app_salud/services/medico_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/usuario_services.dart';
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
var usuarioModel;

class ListMedicos extends StatefulWidget {
  @override
  _ListMedicosState createState() => _ListMedicosState();
}

final _formKey_list_medicos = GlobalKey<_ListMedicosState>();
List<MedicoModel> medicos_items;
bool _isLoading = false;

bool _isCardVisible = false;

class _ListMedicosState extends State<ListMedicos>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Offset> _slideAnimation;

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

  void _handleAccept(String id_medico) async {
    bool resultado = await update_estado_habilitacion("2", id_medico);

    if (resultado) {
      _alert_informe(context, "Médico vinculado correctamente", 1);

      _animationController.forward().then((value) {
        setState(() {
          _isCardVisible = false;
        });
      });
    } else {
      _alert_informe(context, "No se puede vincular el Médico", 2);
    }
  }

  void _handleCancel(String id_medico) async {
    bool resultado = await update_estado_habilitacion("0", id_medico);

    if (resultado) {
      _alert_informe(context, "Médico rechazado correctamente", 1);

      _animationController.forward().then((value) {
        setState(() {
          _isCardVisible = false;
        });
      });
    } else {
      _alert_informe(context, "No se rechazó la vinculación", 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    usuarioModel = Provider.of<UsuarioServices>(context);

    id_paciente = usuarioModel.usuario.paciente.id_paciente;

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
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (BuildContext context, Widget child) {
                    return SlideTransition(
                      position: _slideAnimation,
                      child: _isCardVisible
                          ? Card(
                              child: Column(
                                children: [
                                  Container(
                                    height: 60,
                                    width: double.infinity,
                                    child: Center(
                                        child: ListView(
                                      children: ListTile.divideTiles(
                                        color: Colors.black,
                                        tiles: snapshot.data
                                            .where((element) =>
                                                element.estado_habilitacion ==
                                                "1")
                                            .map((element) {
                                          id_medico = element.rela_medico;
                                          return Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Card(
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text("Apellido y Nombre: " +
                                                            element
                                                                .nombre_medico),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(element
                                                            .apellido_medico),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text("Especialidad: " +
                                                            element
                                                                .especialidad),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    )),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          _handleAccept(id_medico);
                                        },
                                        child: Text('Aceptar'),
                                      ),
                                      SizedBox(width: 10),
                                      ElevatedButton(
                                        onPressed: () {
                                          _handleCancel(id_medico);
                                        },
                                        child: Text('Denegar'),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                ],
                              ),
                            )
                          : SizedBox(),
                    );
                  },
                ),
                SizedBox(height: 5),
                Expanded(
                  child: ListView(
                    children: ListTile.divideTiles(
                      color: Colors.black,
                      tiles: snapshot.data
                          .where((data) => data.estado_habilitacion == "2")
                          .map((data) => ListTile(
                                title: GestureDetector(
                                  onTap: () {},
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.circle,
                                      color: Colors.blue,
                                      size: 15,
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

  update_estado_habilitacion(String estado, String id_medico) async {
    String URL_base = Env.URL_API;
    var url = URL_base + "/update_estado_habilitacion_medico";
    var response = await http.post(
      url,
      body: {
        "id_paciente": id_paciente.toString(),
        "id_medico": id_medico,
        "estado_paciente_medico": estado,
      },
    );

    var responseDecode = jsonDecode(response.body);

    if (response.statusCode == 200 && responseDecode['status'] != 'Vacio') {
      return true;
    } else {
      return false;
    }
  }
}

Future<List<MedicoModel>> fetchMedicos() async {
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

    for (var medicos in responseDecode['data']) {
      medicos_items.add(MedicoModel.fromJson(medicos));
    }

    bool buscarPorNombreMedico(List<MedicoModel> listaMedicos) {
      return listaMedicos.any((medico) => medico.estado_habilitacion == "1");
    }

    if (buscarPorNombreMedico(medicos_items)) {
      _isCardVisible = true;
    } else {
      _isCardVisible = false;
    }

    return medicos_items;
  } else {
    _isLoading = true;
    return null;
  }
}
