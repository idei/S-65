import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:provider/provider.dart';
import '../services/usuario_services.dart';

var id_paciente;

class DatosClinicos extends StatefulWidget {
  @override
  _DatosClinicosState createState() => _DatosClinicosState();
}

String email_prefer;
var usuarioModel;

class _DatosClinicosState extends State<DatosClinicos> {
  @override
  Widget build(BuildContext context) {
    final isTablet = Device.get().isTablet;

    usuarioModel = Provider.of<UsuarioServices>(context);

    id_paciente = usuarioModel.usuario.paciente.id_paciente;

    return Scaffold(
        resizeToAvoidBottomInset: false,
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
          title: Text('Datos Clinicos',
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
              )),
        ),
        body: isTablet
            ? LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                    height: constraints.maxHeight * 0.8,
                    width: constraints.maxWidth * 0.9,
                    child: GridView.count(
                        crossAxisCount:
                            3, // Define el número de columnas de la grilla
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 20.0,
                        mainAxisSpacing: 50.0,
                        padding: EdgeInsets.all(20.0),
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, '/form_datos_clinicos',
                                  arguments: {});
                            },
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius:
                                      MediaQuery.of(context).size.width / 9.3,
                                  child: Icon(Icons.sync_outlined,
                                      color: Colors.white, size: 100.0),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  "REGISTRAR NUEVOS \n DATOS CLÍNICOS",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, '/historial_clinico');
                            },
                            child: Column(
                              children: [
                                CircleAvatar(
                                    radius:
                                        MediaQuery.of(context).size.width / 9.3,
                                    child: Icon(Icons.bar_chart,
                                        color: Colors.white, size: 100.0)),
                                SizedBox(height: 8.0),
                                Text(
                                  "HISTORIAL DE \n DATOS CLÍNICOS",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ]));
              })
            : LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                    height: constraints.maxHeight * 0.8,
                    width: constraints.maxWidth * 0.9,
                    child: GridView.count(
                        crossAxisCount:
                            2, // Define el número de columnas de la grilla
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 1.0,
                        mainAxisSpacing: 50.0,
                        padding: EdgeInsets.all(20.0),
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, '/form_datos_clinicos',
                                  arguments: {});
                            },
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: MediaQuery.of(context).size.width / 8,
                                  child: Icon(Icons.sync_outlined,
                                      color: Colors.white, size: 80.0),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  "REGISTRAR NUEVOS \n DATOS CLÍNICOS",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, '/historial_clinico');
                            },
                            child: Column(
                              children: [
                                CircleAvatar(
                                    radius:
                                        MediaQuery.of(context).size.width / 8,
                                    child: Icon(Icons.bar_chart,
                                        color: Colors.white, size: 80.0)),
                                SizedBox(height: 8.0),
                                Text(
                                  "HISTORIAL\nCLÍNICO",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ]));
              }));
  }

  void choiceAction(String choice) {
    if (choice == Constants.Ajustes) {
      Navigator.pushNamed(context, '/ajustes');
    } else if (choice == Constants.Salir) {
      print('Salir');
    }
  }
}

class Constants {
  static const String Ajustes = 'Ajustes';
  static const String Salir = 'Salir';
  static const List<String> choices = <String>[
    Ajustes,
    Salir,
  ];
}
