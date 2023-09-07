import 'package:app_salud/pages/list_medicos.dart';
import 'package:app_salud/services/usuario_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/session_service.dart';

var email_argument;
var id_paciente;
var heightContainer;
var widthContainer;
var childAspectRatioGrid;
var crossAxisSpacingGrid;
var mainAxisSpacingGrid;
var paddingGrid;
var paddingVertical;
var crossAxisCount;
var radius;
var size;

final isTablet = Device.get().isTablet;

String email_prefer;

class MenuPage extends StatefulWidget {
  @override
  _FormMenuState createState() => _FormMenuState();
}

class _FormMenuState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    final usuarioModel = Provider.of<UsuarioServices>(context);
    final int badgeCount = 5;
    final _formKey_menu = ObjectKey("key_menu");

    final authProvider = Provider.of<AuthProvider>(context);

    setParametrosMenu();

    return WillPopScope(
      onWillPop: () async {
        // Personaliza aquí el comportamiento al presionar el botón de retroceso del dispositivo.
        // Puedes realizar alguna acción, como mostrar un diálogo de confirmación antes de salir de la pantalla.

        // Por ejemplo, muestra un diálogo de confirmación:
        bool confirmExit = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('¿Quieres salir de la aplicación?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false), // No salir
                child: Text('No'),
              ),
              TextButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove('email_prefer');

                  authProvider.logout();

                  Navigator.pushNamed(context, '/');
                },
                child: Text('Sí'),
              ),
            ],
          ),
        );

        return confirmExit ??
            false; // Si el usuario cierra el diálogo sin seleccionar, no saldrá.
      },
      child: Scaffold(
          key: _formKey_menu,
          backgroundColor: Color.fromRGBO(30, 20, 108, 1),
          body: //isTablet
              // Menu si es tablet
              //?
              Center(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                  color: Color.fromRGBO(30, 20, 108, 1),
                  height: constraints.maxHeight * heightContainer,
                  width: constraints.maxWidth * widthContainer,
                  child: GridView.count(
                    crossAxisCount:
                        crossAxisCount, // Define el número de columnas de la grilla
                    childAspectRatio: childAspectRatioGrid,
                    crossAxisSpacing: crossAxisSpacingGrid,
                    mainAxisSpacing: mainAxisSpacingGrid,
                    padding: EdgeInsets.all(paddingGrid),
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/recordatorio');
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: Color.fromRGBO(45, 175, 168, 1),
                              radius:
                                  MediaQuery.of(context).size.width / radius,
                              child: Icon(Icons.event_note,
                                  color: Colors.white, size: size),
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
                              backgroundColor: Color.fromRGBO(45, 175, 168, 1),
                              radius:
                                  MediaQuery.of(context).size.width / radius,
                              child: Icon(Icons.priority_high,
                                  color: Colors.white, size: size),
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
                                  radius: MediaQuery.of(context).size.width /
                                      radius,
                                  child: Icon(Icons.account_box,
                                      color: Colors.white, size: size)),
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
                                  radius: MediaQuery.of(context).size.width /
                                      radius,
                                  child: Icon(Icons.assignment_late,
                                      color: Colors.white, size: size)),
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
                                radius:
                                    MediaQuery.of(context).size.width / radius,
                                child: Icon(Icons.assignment_ind,
                                    color: Colors.white, size: size)),
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
                                radius:
                                    MediaQuery.of(context).size.width / radius,
                                child: Icon(Icons.group,
                                    color: Colors.white, size: size)),
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
                                radius:
                                    MediaQuery.of(context).size.width / radius,
                                child: Icon(Icons.local_pharmacy,
                                    color: Colors.white, size: size)),
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
                          Navigator.pushNamed(context, '/menu_chequeo',
                              arguments: {
                                "email": usuarioModel.usuario.emailUser,
                                "id_paciente": id_paciente,
                              });
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                                radius:
                                    MediaQuery.of(context).size.width / radius,
                                child: Icon(Icons.source_outlined,
                                    color: Colors.white, size: size)),
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
                                radius:
                                    MediaQuery.of(context).size.width / radius,
                                child: Icon(Icons.health_and_safety_outlined,
                                    color: Colors.white, size: size)),
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
                                radius:
                                    MediaQuery.of(context).size.width / radius,
                                child: Icon(Icons.settings,
                                    color: Colors.white, size: size)),
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
                          await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('¿Quieres salir de la aplicación?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.of(context)
                                      .pop(false), // No salir
                                  child: Text('No'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.remove('email_prefer');

                                    authProvider.logout();

                                    Navigator.pushNamed(context, '/');
                                  },
                                  child: Text('Sí'),
                                ),
                              ],
                            ),
                          );
                          // SharedPreferences prefs =
                          //     await SharedPreferences.getInstance();
                          // prefs.remove('email_prefer');

                          // authProvider.logout();

                          // Navigator.pushNamed(context, '/');
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                                radius:
                                    MediaQuery.of(context).size.width / radius,
                                child: Icon(Icons.exit_to_app,
                                    color: Colors.white, size: size)),
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
            ),
          )),
    );
  }

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email_prefer = prefs.getString("email_prefer");
    email_argument = email_prefer;
    id_paciente = prefs.getInt("id_paciente");
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

  void setParametrosMenu() {
    if (isTablet) {
      heightContainer = 0.8;
      widthContainer = 0.9;
      childAspectRatioGrid = 0.8;
      crossAxisSpacingGrid = 10.0;
      mainAxisSpacingGrid = 60.0;
      paddingGrid = 0.0;
      crossAxisCount = 4;
      radius = 9.8;
      size = 90.0;
    } else {
      heightContainer = 0.85;
      widthContainer = 0.9;
      childAspectRatioGrid = 0.78;
      crossAxisSpacingGrid = 7.0;
      mainAxisSpacingGrid = 25.0;
      paddingGrid = 1.0;
      crossAxisCount = 3;
      radius = 7.3;
      size = 70.0;
    }
  }
}
