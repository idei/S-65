import 'package:app_salud/pages/list_medicos.dart';
import 'package:app_salud/services/usuario_services.dart';
import 'package:flutter/material.dart';
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
  print("menu");
  print(email_argument);
}

class _FormMenuState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    Map parametros = ModalRoute.of(context).settings.arguments;

    final usuarioModel = Provider.of<UsuarioServices>(context);
    if (usuarioModel.existeUsuarioModel) {
      print(usuarioModel.usuario);
    }

    return Scaffold(
      body: Container(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 70.0),
                    GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/form_datos_generales');
                        },
                        child: CircleAvatar(
                            radius: MediaQuery.of(context).size.width / 7.3,
                            child: Icon(Icons.account_box,
                                color: Colors.white, size: 70.0))),
                    SizedBox(height: 10.0),
                    texto('DATOS PERSONALES'),
                    SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/antecedentes_familiares',
                            arguments: {
                              "bandera": 0,
                              "email": usuarioModel.usuario.emailUser,
                            });
                      },
                      child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width / 7.3,
                          child: Icon(Icons.group,
                              color: Colors.white, size: 70.0)),
                    ),
                    SizedBox(height: 10.0),
                    texto('ANTECEDENTES \nFAMILIARES'),
                    SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/recordatorio');
                      },
                      child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width / 7.3,
                          child: Icon(Icons.event_note,
                              color: Colors.white, size: 70.0)),
                    ),
                    SizedBox(height: 10.0),
                    texto('RECORDATORIOS'),
                    SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/list_medicos',
                            arguments: {
                              "rela_medico": rela_medico,
                            });
                      },
                      child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width / 7.3,
                          child: Icon(Icons.priority_high,
                              color: Colors.white, size: 70.0)),
                    ),
                    SizedBox(height: 10.0),
                    texto("MIS DOCTORES"),
                  ]),
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 70.0),
                    GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/datoscli', arguments: {
                            "email": usuarioModel.usuario.emailUser,
                          });
                        },
                        child: CircleAvatar(
                            radius: MediaQuery.of(context).size.width / 7.3,
                            child: Icon(Icons.assignment_late,
                                color: Colors.white, size: 70.0))),
                    SizedBox(height: 10.0),
                    texto('DATOS CLINICOS'),
                    SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/medicamentos');
                      },
                      child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width / 7.3,
                          child: Icon(Icons.local_pharmacy,
                              color: Colors.white, size: 50.0)),
                    ),
                    SizedBox(height: 10.0),
                    texto('MEDICAMENTOS'),
                    SizedBox(height: 35.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/menu_chequeo',
                            arguments: {
                              "email": usuarioModel.usuario.emailUser,
                              "id_paciente": id_paciente,
                            });
                      },
                      child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width / 7.3,
                          child: Icon(Icons.source_outlined,
                              color: Colors.white, size: 70.0)),
                    ),
                    SizedBox(height: 10.0),
                    texto("CHEQUEOS"),
                    SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: () async {
                        print(email_prefer);
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.remove('email_prefer');
                        print(email_prefer);

                        Navigator.pushNamed(context, '/');
                      },
                      child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width / 7.3,
                          child: Icon(Icons.exit_to_app,
                              color: Colors.white, size: 70.0)),
                    ),
                    SizedBox(height: 10.0),
                    texto('SALIR'),
                    SizedBox(height: 5.0),
                  ]),
              Padding(
                padding: const EdgeInsets.all(3.0),
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 70.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/antecedentes_personales',
                            arguments: {
                              "email": email_argument,
                            });
                      },
                      child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width / 7.3,
                          child: Icon(Icons.assignment_ind,
                              color: Colors.white, size: 70.0)),
                    ),
                    SizedBox(height: 10.0),
                    texto(
                      'ANTECEDENTES \nPERSONALES',
                    ),
                    SizedBox(height: 5.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/avisos');
                      },
                      child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width / 7.3,
                          child: Icon(Icons.priority_high,
                              color: Colors.white, size: 70.0)),
                    ),
                    SizedBox(height: 10.0),
                    texto('AVISOS'),
                    SizedBox(height: 35.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/ajustes');
                      },
                      child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width / 7.3,
                          child: Icon(Icons.settings,
                              color: Colors.white, size: 50.0)),
                    ),
                    SizedBox(height: 10.0),
                    texto('AJUSTES'),
                    SizedBox(height: 20.0),
                  ])
            ]),
        padding: const EdgeInsets.fromLTRB(7.0, 17.0, 22.0, 1.0),
        alignment: Alignment.centerLeft,
      ),
    );
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
