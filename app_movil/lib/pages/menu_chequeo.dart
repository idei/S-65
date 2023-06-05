import 'package:flutter/material.dart';

class MenuChequeoPage extends StatefulWidget {
  @override
  _MenuChequeoState createState() => _MenuChequeoState();
}

var email_argument;
var id_paciente;
var select_screening;

class _MenuChequeoState extends State<MenuChequeoPage> {
  Widget build(BuildContext context) {
    Map parametros = ModalRoute.of(context).settings.arguments;
    if (parametros != null) {
      email_argument = parametros['email'];
      id_paciente = parametros['id_paciente'];
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/menu');
          },
        ),
        title: Text(
          "Seleccionar Chequeo",
          style: TextStyle(
              fontFamily: Theme.of(context).textTheme.headline1.fontFamily),
        ),
        actions: <Widget>[],
      ),
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
                        select_screening = "CONDUC";
                        Navigator.pushNamed(context, '/screening', arguments: {
                          "select_screening": select_screening,
                        });
                      },
                      child: CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/comportamiento.png'),
                        radius: MediaQuery.of(context).size.width / 7.3,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    texto('CONDUCTUAL'),
                    SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: () {
                        select_screening = "SFMS";
                        Navigator.pushNamed(context, '/screening', arguments: {
                          "select_screening": select_screening,
                        });
                      },
                      child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width / 7.3,
                          //backgroundColor: Color.fromRGBO(100, 20, 28, 1),
                          child: Icon(Icons.directions_walk,
                              color: Colors.white, size: 70.0)),
                    ),
                    SizedBox(height: 10.0),
                    texto('FÍSICO'),
                    SizedBox(height: 20.0),
                    // GestureDetector(
                    //   onTap: () {
                    //     select_screening = "DIAB";
                    //     Navigator.pushNamed(context, '/screening', arguments: {
                    //       "select_screening": select_screening,
                    //     });
                    //   },
                    //   child: CircleAvatar(
                    //       radius: MediaQuery.of(context).size.width / 7.3,
                    //       //backgroundColor: Color.fromRGBO(100, 20, 28, 1),
                    //       child: Icon(Icons.emoji_people_rounded,
                    //           color: Colors.white, size: 70.0)),
                    // ),
                    // SizedBox(height: 10.0),
                    // texto('DIABETES'),
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
                        select_screening = "QCQ";
                        Navigator.pushNamed(context, '/screening', arguments: {
                          "select_screening": select_screening,
                        });
                        //do what you want here
                      },
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/cognicion.png'),
                        radius: MediaQuery.of(context).size.width / 7.3,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    texto('COGNITIVO'),
                    SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: () {
                        select_screening = "ÁNIMO";
                        Navigator.pushNamed(context, '/screening', arguments: {
                          "select_screening": select_screening,
                        });
                      },
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/animo.png'),
                        radius: MediaQuery.of(context).size.width / 7.3,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    texto('ANIMO'),
                    SizedBox(height: 20.0),
                    // GestureDetector(
                    //   onTap: () {
                    //     select_screening = "ENCRO";
                    //     Navigator.pushNamed(context, '/screening', arguments: {
                    //       "select_screening": select_screening,
                    //     });
                    //   },
                    //   child: CircleAvatar(
                    //     //backgroundColor: Color.fromRGBO(157, 19, 34, 1),
                    //     backgroundImage: AssetImage('assets/animo.png'),
                    //     radius: MediaQuery.of(context).size.width / 7.3,
                    //   ),
                    // ),
                    // SizedBox(height: 10.0),
                    // texto('ENFERMEDADES'),
                    // texto('CRONICAS'),
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
                        select_screening = "CDR";
                        Navigator.pushNamed(context, '/screening', arguments: {
                          "select_screening": select_screening,
                        });
                      },
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/cotidiana.png'),
                        radius: MediaQuery.of(context).size.width / 7.3,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    texto('CDR'),
                    SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: () {
                        select_screening = "RNUTRI";
                        Navigator.pushNamed(context, '/screening', arguments: {
                          "select_screening": select_screening,
                        });
                      },
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/nutricion.png'),
                        radius: MediaQuery.of(context).size.width / 7.3,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    texto('NUTRICIÓN'),
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
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: Theme.of(context).textTheme.headline1.fontFamily),
    );
  }
}
