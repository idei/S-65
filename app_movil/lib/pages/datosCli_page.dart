import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

var email_argument;
var id_paciente;

class DatosCli extends StatefulWidget {
  @override
  _DatosCliState createState() => _DatosCliState();
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

// Define a corresponding State class.
// This class holds data related to the Form.
class _DatosCliState extends State<DatosCli> {
  @override
  Widget build(BuildContext context) {
    Map parametros = ModalRoute.of(context).settings.arguments;
    if (parametros != null) {
      email_argument = parametros['email'];
      print("Datos Clinico");
    } else {
      getStringValuesSF();
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/menu');
          },
        ),
        //backgroundColor: Color.fromRGBO(157, 19, 34, 1),
        title: Text('Datos Clinicos',
            style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
                fontWeight: FontWeight.bold)),
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

      body: Container(
        // ThemeData(
        //   primarySwatch: Colors.blue,
        //   primaryColor: const Color(0xFF2196f3),
        //   accentColor: const Color(0xFF2196f3),
        //   canvasColor: const Color(0xFF2949de),
        // ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/form_datos_clinicos',
                            arguments: {
                              "email": email_argument,
                            });
                        //do what you want here
                      },
                      child: CircleAvatar(
                        radius: MediaQuery.of(context).size.width / 7.3,
                        //backgroundColor: Color.fromRGBO(157, 19, 34, 1),
                        //backgroundColor: Color.fromRGBO(157, 19, 34, 1),
                        child: Icon(Icons.sync_outlined,
                            color: Colors.white, size: 70.0),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      "     REGISTRAR \n DATOS CLINICO",
                      style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily:
                              Theme.of(context).textTheme.headline1.fontFamily),
                    ),
                    SizedBox(height: 20.0),
                  ]),
              Padding(
                padding: const EdgeInsets.all(10.0),
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/historial_clinico');
                        //do what you want here
                      },
                      child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width / 7.3,
                          //backgroundColor: Color.fromRGBO(157, 19, 34, 1),
                          //backgroundColor: Color.fromRGBO(157, 19, 34, 1),
                          child: Icon(Icons.bar_chart,
                              color: Colors.white, size: 70.0)),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      "         HISTORIAL\n           CLÍNICO",
                      style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily:
                              Theme.of(context).textTheme.headline1.fontFamily),
                    ),
                    SizedBox(height: 20.0),
                  ]),
            ]),
        padding: const EdgeInsets.fromLTRB(7.0, 17.0, 22.0, 1.0),
        alignment: Alignment.centerLeft,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
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
