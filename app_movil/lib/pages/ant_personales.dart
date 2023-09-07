import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../services/usuario_services.dart';
import 'env.dart';

class AntecedentesPersonalesModel {
  String antecedenteDescripcion;

  AntecedentesPersonalesModel({this.antecedenteDescripcion});

  factory AntecedentesPersonalesModel.fromJson(Map<String, dynamic> json) {
    return AntecedentesPersonalesModel(
        antecedenteDescripcion: json['nombre_evento']);
  }
}

class AntecedentesPerPage extends StatefulWidget {
  @override
  _AntecedentesPerState createState() => _AntecedentesPerState();
}

String email;
var usuarioModel;

class _AntecedentesPerState extends State<AntecedentesPerPage> {
  bool isLoading = false;
  List<AntecedentesPersonalesModel> listAntecPersonales = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    usuarioModel = Provider.of<UsuarioServices>(context);
    final isTablet = Device.get().isTablet;

    email = usuarioModel.usuario.emailUser;

    final size = MediaQuery.of(context).size;

    var sizeCircle;

    if (isTablet) {
      sizeCircle = MediaQuery.of(context).size.width / 13.3;
    } else {
      sizeCircle = MediaQuery.of(context).size.width / 8.3;
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
            'Mis Antecedentes Personales',
            style: TextStyle(
              fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
            ),
          )),
      body: Container(
        child: FutureBuilder<List<AntecedentesPersonalesModel>>(
          future: fetchAntecedentesPersonales(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  semanticsLabel: "Cargando",
                ),
              );
            } else if (snapshot.hasData) {
              return Hero(
                tag: "icono",
                child: ListView(
                  children: ListTile.divideTiles(
                    color: Colors.black26,
                    tiles: snapshot.data
                        .map((data) => ListTile(
                              title: GestureDetector(
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.circle,
                                      color: Colors.blue,
                                      size: 10.0,
                                    ),
                                    title: Text(data.antecedenteDescripcion,
                                        style: TextStyle(
                                            fontFamily: Theme.of(context)
                                                .textTheme
                                                .headline1
                                                .fontFamily)),
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ).toList(),
                ),
              );
            } else {
              return Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                      title: Text(
                    'No tiene antecedentes personales',
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

            // if (snapshot.hasData) {
            //   return Hero(
            //     tag: "icono",
            //     child: ListView(
            //       children: ListTile.divideTiles(
            //         color: Colors.black26,
            //         tiles: snapshot.data
            //             .map((data) => ListTile(
            //                   title: GestureDetector(
            //                     onTap: () {},
            //                     child: ListTile(
            //                       leading: Icon(
            //                         Icons.arrow_right_rounded,
            //                         color: Colors.blue,
            //                       ),
            //                       title: Text(data.antecedenteDescripcion,
            //                           style: TextStyle(
            //                               fontFamily: Theme.of(context)
            //                                   .textTheme
            //                                   .headline1
            //                                   .fontFamily)),
            //                     ),
            //                   ),
            //                 ))
            //             .toList(),
            //       ).toList(),
            //     ),
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
            //           'No tiene antecedentes personales',
            //           textAlign: TextAlign.center,
            //           style: TextStyle(
            //               fontWeight: FontWeight.bold,
            //               color: Colors.black87,
            //               fontFamily:
            //                   Theme.of(context).textTheme.headline1.fontFamily),
            //         )),
            //       ],
            //     ));
            //   }
            // }
          },
        ),
      ),
      floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/form_antecedentes_personales',
                    arguments: {
                      "email": email,
                    });
              },
              child: CircleAvatar(
                radius: sizeCircle,
                child: new Column(children: <Widget>[
                  SizedBox(height: 20.0),
                  Icon(Icons.edit, color: Colors.white, size: 30.0),
                  SizedBox(height: 6.0),
                  Text(
                    'Editar',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontFamily:
                          Theme.of(context).textTheme.headline1.fontFamily,
                    ),
                  )
                ]),
              ),
            )
          ]),
    );
  }

  Future<List<AntecedentesPersonalesModel>>
      fetchAntecedentesPersonales() async {
    String URL_base = Env.URL_API;
    var url = URL_base + "/antecedentes_personales_paciente";
    var response = await http.post(url, body: {"email": email});
    var responseDecode = jsonDecode(response.body);

    if (response.statusCode == 200 && responseDecode['status'] != "Vacio") {
      final List<AntecedentesPersonalesModel> listAntecPersonales = [];

      for (var antecedentes in responseDecode['data']) {
        listAntecPersonales
            .add(AntecedentesPersonalesModel.fromJson(antecedentes));
      }

      return listAntecPersonales;
    } else {
      isLoading = true;
      return null;
    }
  }
}

class _isLoadingIcon extends StatelessWidget {
  const _isLoadingIcon({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 60,
      width: 60,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
      child: const CircularProgressIndicator(color: Colors.blue),
    );
  }
}
