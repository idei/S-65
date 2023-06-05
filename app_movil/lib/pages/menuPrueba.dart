import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

class MenuPrueba extends StatefulWidget {
  //MenuPrueba({Key? key}) : super(key: key);

  @override
  State<MenuPrueba> createState() => _MenuPruebaState();
}

class _MenuPruebaState extends State<MenuPrueba> {
  @override
  Widget build(BuildContext context) {
    final isTablet = Device.get().isTablet;

    const title = 'Grid List';
    return MaterialApp(
        title: title,
        home: Scaffold(
            body: isTablet
                ? Center(child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return Container(
                        height: constraints.maxHeight * 0.8,
                        width: constraints.maxWidth * 0.9,
                        child: GridView.count(
                          crossAxisCount:
                              4, // Define el número de columnas de la grilla
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 1.0,
                          mainAxisSpacing: 50.0,
                          padding: EdgeInsets.all(1.0),
                          children: <Widget>[
                            GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/form_datos_generales');
                                },
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                        radius:
                                            MediaQuery.of(context).size.width /
                                                9.5,
                                        child: Icon(Icons.account_box,
                                            color: Colors.white, size: 110.0)),
                                    SizedBox(height: 8.0),
                                    Text(
                                      "DATOS \nPERSONALES",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                )),
                            GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/datoscli',
                                      arguments: {
                                        //"email": usuarioModel.usuario.emailUser,
                                      });
                                },
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                        radius:
                                            MediaQuery.of(context).size.width /
                                                9.5,
                                        child: Icon(Icons.assignment_late,
                                            color: Colors.white, size: 110.0)),
                                    SizedBox(height: 8.0),
                                    Text(
                                      "DATOS \nCLÍNICOS",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                )),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/antecedentes_personales',
                                    arguments: {
                                      //"email": email_argument,
                                    });
                              },
                              child: Column(
                                children: [
                                  CircleAvatar(
                                      radius:
                                          MediaQuery.of(context).size.width /
                                              9.5,
                                      child: Icon(Icons.assignment_ind,
                                          color: Colors.white, size: 110.0)),
                                  SizedBox(height: 8.0),
                                  Text(
                                    "ANTECEDENTES PERSONALES",
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
                                    context, '/antecedentes_familiares',
                                    arguments: {
                                      "bandera": 0,
                                      //"email": usuarioModel.usuario.emailUser,
                                    });
                              },
                              child: Column(
                                children: [
                                  CircleAvatar(
                                      radius:
                                          MediaQuery.of(context).size.width /
                                              9.5,
                                      child: Icon(Icons.group,
                                          color: Colors.white, size: 110.0)),
                                  SizedBox(height: 8.0),
                                  Text(
                                    "ANTECEDENTES \nFAMILIARES",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/medicamentos');
                              },
                              child: Column(
                                children: [
                                  CircleAvatar(
                                      radius:
                                          MediaQuery.of(context).size.width /
                                              9.5,
                                      child: Icon(Icons.local_pharmacy,
                                          color: Colors.white, size: 110.0)),
                                  SizedBox(height: 8.0),
                                  Text(
                                    "MEDICAMENTOS",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/avisos');
                              },
                              child: Column(
                                children: [
                                  CircleAvatar(
                                      radius:
                                          MediaQuery.of(context).size.width /
                                              9.5,
                                      child: Icon(Icons.priority_high,
                                          color: Colors.white, size: 110.0)),
                                  SizedBox(height: 8.0),
                                  Text(
                                    "AVISOS",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/recordatorio');
                              },
                              child: Column(
                                children: [
                                  CircleAvatar(
                                      radius:
                                          MediaQuery.of(context).size.width /
                                              9.5,
                                      child: Icon(Icons.event_note,
                                          color: Colors.white, size: 110.0)),
                                  SizedBox(height: 8.0),
                                  Text(
                                    "RECORDATORIOS",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/menu_chequeo',
                                    arguments: {
                                      // "email": usuarioModel.usuario.emailUser,
                                      // "id_paciente": id_paciente,
                                    });
                              },
                              child: Column(
                                children: [
                                  CircleAvatar(
                                      radius:
                                          MediaQuery.of(context).size.width /
                                              9.5,
                                      child: Icon(Icons.source_outlined,
                                          color: Colors.white, size: 110.0)),
                                  SizedBox(height: 8.0),
                                  Text(
                                    "CHEQUEOS",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/list_medicos',
                                    arguments: {
                                      // "rela_medico": rela_medico,
                                    });
                              },
                              child: Column(
                                children: [
                                  CircleAvatar(
                                      radius:
                                          MediaQuery.of(context).size.width /
                                              9.5,
                                      child: Icon(
                                          Icons.health_and_safety_outlined,
                                          color: Colors.white,
                                          size: 110.0)),
                                  SizedBox(height: 8.0),
                                  Text(
                                    "MIS MÉDICOS",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/ajustes');
                              },
                              child: Column(
                                children: [
                                  CircleAvatar(
                                      radius:
                                          MediaQuery.of(context).size.width /
                                              9.5,
                                      child: Icon(Icons.settings,
                                          color: Colors.white, size: 110.0)),
                                  SizedBox(height: 8.0),
                                  Text(
                                    "AJUSTES",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                // print(email_prefer);
                                // SharedPreferences prefs =
                                //     await SharedPreferences.getInstance();
                                // prefs.remove('email_prefer');
                                // print(email_prefer);

                                Navigator.pushNamed(context, '/');
                              },
                              child: Column(
                                children: [
                                  CircleAvatar(
                                      radius:
                                          MediaQuery.of(context).size.width /
                                              9.5,
                                      child: Icon(Icons.exit_to_app,
                                          color: Colors.white, size: 110.0)),
                                  SizedBox(height: 8.0),
                                  Text(
                                    "SALIR",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ))
                : Text("PEPE")));
  }

  Widget texto(String entrada) {
    return Text(
      entrada,
      style: TextStyle(
          fontSize: 12.0,
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: Theme.of(context).textTheme.headline1.fontFamily),
    );
  }
}
