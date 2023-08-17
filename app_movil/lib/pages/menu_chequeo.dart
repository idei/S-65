import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

class MenuChequeoPage extends StatefulWidget {
  @override
  _MenuChequeoState createState() => _MenuChequeoState();
}

var email_argument;
var id_paciente;
var select_screening;
var heightContainer;
var widthContainer;
var childAspectRatioGrid;
var crossAxisSpacingGrid;
var mainAxisSpacingGrid;
var paddingHorizontal;
var paddingVertical;
final isTablet = Device.get().isTablet;

class _MenuChequeoState extends State<MenuChequeoPage> {
  Widget build(BuildContext context) {
    Map parametros = ModalRoute.of(context).settings.arguments;
    if (parametros != null) {
      email_argument = parametros['email'];
      id_paciente = parametros['id_paciente'];
    }

    setParametrosMenu();

    return Scaffold(
      backgroundColor: Color.fromRGBO(30, 20, 108, 1),
      body: Center(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              padding: EdgeInsets.symmetric(
                  horizontal: paddingHorizontal, vertical: paddingVertical),
              height: constraints.maxHeight * heightContainer,
              width: constraints.maxWidth * widthContainer,
              child: GridView.count(
                  crossAxisCount:
                      3, // Define el número de columnas de la grilla
                  childAspectRatio: childAspectRatioGrid,
                  crossAxisSpacing: crossAxisSpacingGrid,
                  mainAxisSpacing: mainAxisSpacingGrid,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        select_screening = "CONDUC";
                        Navigator.pushNamed(context, '/screening', arguments: {
                          "select_screening": select_screening,
                        });
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/comportamiento.png'),
                            radius: MediaQuery.of(context).size.width / 7.5,
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            "CONDUCTUAL",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        select_screening = "SFMS";
                        Navigator.pushNamed(context, '/screening', arguments: {
                          "select_screening": select_screening,
                        });
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                              radius: MediaQuery.of(context).size.width / 7.5,
                              child: Icon(Icons.directions_run_rounded,
                                  color: Colors.white, size: 70.0)),
                          SizedBox(height: 8.0),
                          Text(
                            "FÍSICO",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        select_screening = "QCQ";
                        Navigator.pushNamed(context, '/screening', arguments: {
                          "select_screening": select_screening,
                        });
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage('assets/cognicion.png'),
                            radius: MediaQuery.of(context).size.width / 7.5,
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            "COGNITIVO",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        select_screening = "ÁNIMO";
                        Navigator.pushNamed(context, '/screening', arguments: {
                          "select_screening": select_screening,
                        });
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage('assets/animo.png'),
                            radius: MediaQuery.of(context).size.width / 7.5,
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            "ÁNIMO",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     select_screening = "CDR";
                    //     Navigator.pushNamed(context, '/screening', arguments: {
                    //       "select_screening": select_screening,
                    //     });
                    //   },
                    //   child: Column(
                    //     children: [
                    //       CircleAvatar(
                    //         backgroundImage: AssetImage('assets/cotidiana.png'),
                    //         radius: MediaQuery.of(context).size.width / 7.5,
                    //       ),
                    //       SizedBox(height: 8.0),
                    //       Text(
                    //         "CDR",
                    //         style: TextStyle(
                    //           color: Colors.white,
                    //           fontSize: 14.0,
                    //           fontWeight: FontWeight.w500,
                    //         ),
                    //         textAlign: TextAlign.center,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    GestureDetector(
                      onTap: () {
                        select_screening = "RNUTRI";
                        Navigator.pushNamed(context, '/screening', arguments: {
                          "select_screening": select_screening,
                        });
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage('assets/nutricion.png'),
                            radius: MediaQuery.of(context).size.width / 7.5,
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            "NUTRICIÓN",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        select_screening = "ADLQ";
                        Navigator.pushNamed(context, '/screening_adlq',
                            arguments: {
                              "select_screening": select_screening,
                            });
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                              radius: MediaQuery.of(context).size.width / 7.5,
                              child: Icon(Icons.abc_sharp,
                                  color: Colors.white, size: 70.0)),
                          SizedBox(height: 8.0),
                          Text(
                            "ADLQ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/menu');
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                              radius: MediaQuery.of(context).size.width / 8.5,
                              child: Icon(Icons.arrow_circle_left_outlined,
                                  color: Colors.white, size: 70.0)),
                          SizedBox(height: 8.0),
                          Text(
                            "VOLVER",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ]),
            );
          },
        ),
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

  void setParametrosMenu() {
    if (isTablet) {
      heightContainer = 1;
      widthContainer = 1;
      childAspectRatioGrid = 0.8;
      crossAxisSpacingGrid = 8.0;
      mainAxisSpacingGrid = 5.0;
      paddingHorizontal = 10.0;
      paddingVertical = 40.0;
    } else {
      heightContainer = 0.7;
      widthContainer = 0.9;
      childAspectRatioGrid = 0.73;
      crossAxisSpacingGrid = 10.0;
      mainAxisSpacingGrid = 25.0;
      paddingHorizontal;
      paddingVertical;
    }
  }
}
