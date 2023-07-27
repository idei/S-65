import 'package:app_salud/pages/ant_familiares.dart';
import 'package:app_salud/pages/list_medicos.dart';
import 'package:app_salud/services/usuario_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

var email_argument;
var id_paciente;

class MenuPage extends StatefulWidget {
  @override
  _FormMenuState createState() => _FormMenuState();
}

String email_prefer;
getStringValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  email_prefer = prefs.getString("email_prefer");
  email_argument = email_prefer;
  id_paciente = prefs.getInt("id_paciente");
}

class _FormMenuState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    final isTablet = Device.get().isTablet;
    final usuarioModel = Provider.of<UsuarioServices>(context);
    final int badgeCount = 5;

    if (usuarioModel.existeUsuarioModel) {
      // print(usuarioModel.usuario);
    }

    return Scaffold(
      key: UniqueKey(),
      backgroundColor: Color.fromRGBO(30, 20, 108, 1),
      body: isTablet
          // Menu si es tablet
          ? Center(child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                  color: Color.fromRGBO(30, 20, 108, 1),
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
                          Navigator.pushNamed(context, '/recordatorio');
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: MediaQuery.of(context).size.width / 9.5,
                              child: Icon(Icons.event_note,
                                  color: Colors.white, size: 90.0),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              "RECORDATORIOS",
                              style: TextStyle(
                                color: Colors.white,
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
                              radius: MediaQuery.of(context).size.width / 9.5,
                              child: Icon(Icons.priority_high,
                                  color: Colors.white, size: 90.0),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              "AVISOS",
                              style: TextStyle(
                                color: Colors.white,
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
                                context, '/form_datos_generales');
                          },
                          child: Column(
                            children: [
                              CircleAvatar(
                                  radius:
                                      MediaQuery.of(context).size.width / 9.5,
                                  child: Icon(Icons.account_box,
                                      color: Colors.white, size: 90.0)),
                              SizedBox(height: 8.0),
                              Text(
                                "DATOS \nPERSONALES",
                                style: TextStyle(
                                  color: Colors.white,
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
                                  "email": usuarioModel.usuario.emailUser,
                                });
                          },
                          child: Column(
                            children: [
                              CircleAvatar(
                                  radius:
                                      MediaQuery.of(context).size.width / 9.5,
                                  child: Icon(Icons.assignment_late,
                                      color: Colors.white, size: 90.0)),
                              SizedBox(height: 8.0),
                              Text(
                                "DATOS \nCLÍNICOS",
                                style: TextStyle(
                                  color: Colors.white,
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
                                "email": email_argument,
                              });
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                                radius: MediaQuery.of(context).size.width / 9.5,
                                child: Icon(Icons.assignment_ind,
                                    color: Colors.white, size: 90.0)),
                            SizedBox(height: 8.0),
                            Text(
                              "ANTECEDENTES PERSONALES",
                              style: TextStyle(
                                color: Colors.white,
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
                                "email": usuarioModel.usuario.emailUser,
                              });
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                                radius: MediaQuery.of(context).size.width / 9.5,
                                child: Icon(Icons.group,
                                    color: Colors.white, size: 90.0)),
                            SizedBox(height: 8.0),
                            Text(
                              "ANTECEDENTES \nFAMILIARES",
                              style: TextStyle(
                                color: Colors.white,
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
                                radius: MediaQuery.of(context).size.width / 9.5,
                                child: Icon(Icons.local_pharmacy,
                                    color: Colors.white, size: 90.0)),
                            SizedBox(height: 8.0),
                            Text(
                              "MEDICAMENTOS",
                              style: TextStyle(
                                color: Colors.white,
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
                                radius: MediaQuery.of(context).size.width / 9.5,
                                child: Icon(Icons.event_note,
                                    color: Colors.white, size: 90.0)),
                            SizedBox(height: 8.0),
                            Text(
                              "RECORDATORIOS",
                              style: TextStyle(
                                color: Colors.white,
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
                                "email": usuarioModel.usuario.emailUser,
                                "id_paciente": id_paciente,
                              });
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                                radius: MediaQuery.of(context).size.width / 9.5,
                                child: Icon(Icons.source_outlined,
                                    color: Colors.white, size: 90.0)),
                            SizedBox(height: 8.0),
                            Text(
                              "CHEQUEOS",
                              style: TextStyle(
                                color: Colors.white,
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
                                radius: MediaQuery.of(context).size.width / 9.5,
                                child: Icon(Icons.health_and_safety_outlined,
                                    color: Colors.white, size: 90.0)),
                            SizedBox(height: 8.0),
                            Text(
                              "MIS MÉDICOS",
                              style: TextStyle(
                                color: Colors.white,
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
                                radius: MediaQuery.of(context).size.width / 9.5,
                                child: Icon(Icons.settings,
                                    color: Colors.white, size: 90.0)),
                            SizedBox(height: 8.0),
                            Text(
                              "AJUSTES",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.remove('email_prefer');

                          Navigator.pushNamed(context, '/');
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                                radius: MediaQuery.of(context).size.width / 9.5,
                                child: Icon(Icons.exit_to_app,
                                    color: Colors.white, size: 90.0)),
                            SizedBox(height: 8.0),
                            Text(
                              "SALIR",
                              style: TextStyle(
                                color: Colors.white,
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
          // Menu en SmartPhone
          : Center(child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                  height: constraints.maxHeight * 0.85,
                  width: constraints.maxWidth * 0.9,
                  child: GridView.count(
                    crossAxisCount:
                        3, // Define el número de columnas de la grilla
                    childAspectRatio: 0.78,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 25.0,
                    padding: EdgeInsets.all(1.0),
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/recordatorio');
                        },
                        child: Column(
                          children: [
                            Stack(children: [
                              CircleAvatar(
                                backgroundColor:
                                    Color.fromRGBO(45, 175, 168, 1),
                                radius: MediaQuery.of(context).size.width / 7.3,
                                child: Icon(Icons.event_note,
                                    color: Colors.white, size: 70.0),
                              ),
                              if (badgeCount >
                                  0) // Círculo con número si el contador es mayor que cero
                                Positioned(
                                  top: -0.6,
                                  right: -0.5,
                                  child: Container(
                                    width: 18,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red[700],
                                    ),
                                    child: Text(" " + badgeCount.toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                ),
                            ]),
                            SizedBox(height: 8.0),
                            Text(
                              "RECORDATORIOS",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
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
                            Stack(children: [
                              CircleAvatar(
                                backgroundColor:
                                    Color.fromRGBO(45, 175, 168, 1),
                                radius: MediaQuery.of(context).size.width / 7.3,
                                child: Icon(Icons.priority_high,
                                    color: Colors.white, size: 70.0),
                              ),
                              Positioned(
                                top: -0.6,
                                right: -0.5,
                                child: Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red[800],
                                  ),
                                ),
                              ),
                            ]),
                            SizedBox(height: 8.0),
                            Text(
                              "AVISOS",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
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
                                context, '/form_datos_generales');
                          },
                          child: Column(
                            children: [
                              CircleAvatar(
                                  radius:
                                      MediaQuery.of(context).size.width / 7.3,
                                  child: Icon(Icons.account_box,
                                      color: Colors.white, size: 70.0)),
                              SizedBox(height: 8.0),
                              Text(
                                "DATOS \nPERSONALES",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
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
                                  "email": usuarioModel.usuario.emailUser,
                                });
                          },
                          child: Column(
                            children: [
                              CircleAvatar(
                                  radius:
                                      MediaQuery.of(context).size.width / 7.3,
                                  child: Icon(Icons.assignment_late,
                                      color: Colors.white, size: 70.0)),
                              SizedBox(height: 8.0),
                              Text(
                                "DATOS \nCLÍNICOS",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
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
                                "email": email_argument,
                              });
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                                radius: MediaQuery.of(context).size.width / 7.3,
                                child: Icon(Icons.assignment_ind,
                                    color: Colors.white, size: 70.0)),
                            SizedBox(height: 8.0),
                            Text(
                              "ANTECEDENTES PERSONALES",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
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
                                "email": usuarioModel.usuario.emailUser,
                              });
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                                radius: MediaQuery.of(context).size.width / 7.3,
                                child: Icon(Icons.group,
                                    color: Colors.white, size: 70.0)),
                            SizedBox(height: 8.0),
                            Text(
                              "ANTECEDENTES \nFAMILIARES",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
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
                                radius: MediaQuery.of(context).size.width / 7.3,
                                child: Icon(Icons.local_pharmacy,
                                    color: Colors.white, size: 70.0)),
                            SizedBox(height: 8.0),
                            Text(
                              "MEDICAMENTOS",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
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
                                "email": usuarioModel.usuario.emailUser,
                                "id_paciente": id_paciente,
                              });
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                                radius: MediaQuery.of(context).size.width / 7.3,
                                child: Icon(Icons.source_outlined,
                                    color: Colors.white, size: 70.0)),
                            SizedBox(height: 8.0),
                            Text(
                              "CHEQUEOS",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
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
                                "rela_medico": rela_medico,
                              });
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                                radius: MediaQuery.of(context).size.width / 7.3,
                                child: Icon(Icons.health_and_safety_outlined,
                                    color: Colors.white, size: 70.0)),
                            SizedBox(height: 8.0),
                            Text(
                              "MIS MÉDICOS",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
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
                                radius: MediaQuery.of(context).size.width / 7.3,
                                child: Icon(Icons.settings,
                                    color: Colors.white, size: 70.0)),
                            SizedBox(height: 8.0),
                            Text(
                              "AJUSTES",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.remove('email_prefer');

                          Navigator.pushNamed(context, '/');
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                                radius: MediaQuery.of(context).size.width / 7.3,
                                child: Icon(Icons.exit_to_app,
                                    color: Colors.white, size: 70.0)),
                            SizedBox(height: 8.0),
                            Text(
                              "SALIR",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
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
            )),
    );
  }

  Widget texto(String entrada) {
    return Text(
      entrada,
      style: TextStyle(
          fontSize: 12.0,
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontFamily: Theme.of(context).textTheme.headline1.fontFamily),
    );
  }
}
