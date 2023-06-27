import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_salud/pages/menu.dart';

String ruta_incial;

class HomePage extends StatefulWidget {
  static final pageName = 'home';

  _FormpruebaState createState() => _FormpruebaState();
}

GlobalKey<FormState> _formKey_home = GlobalKey<FormState>();

class _FormpruebaState extends State<HomePage> {
  AsyncSnapshot snapshot;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: test_datos(),
        builder: (BuildContext context, snapshot) {
          print(snapshot.connectionState);
          print(snapshot.hasData);
          print(snapshot.data);
          if (snapshot.hasData != null) {
            if (ruta_incial == null) {
              return HomeInicio();
            } else {
              return MenuPage();
            }
          } else {
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Scaffold(
                  body: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircularProgressIndicator(
                              semanticsLabel: 'Linear progress indicator',
                            ),
                            Text(
                              'Cargando información necesaria',
                            ),
                          ],
                        ),
                      )),
                ));
          }
          //return CircularProgressIndicator();
        });
  }
}

Future test_datos() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String get_ruta = await prefs.getString("email_prefer");
  if (get_ruta == null) {
    return ruta_incial = null;
  } else {
    await Future.delayed(const Duration(seconds: 2));
    return ruta_incial = '/menu';
  }
}

class HomeInicio extends StatefulWidget {
  @override
  Otras_drogasWidgetState createState() => Otras_drogasWidgetState();
}

class Otras_drogasWidgetState extends State<HomeInicio> {
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Card(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Image.asset('assets/logo1.png'),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
              ),
              MaterialButton(
                minWidth: 200.0,
                height: 40.0,
                onPressed: () {
                  Navigator.pushNamed(context, 'ingresar');
                },
                color: Color.fromRGBO(30, 20, 108, 1),
                child: Text('INGRESAR',
                    style:
                        TextStyle(color: Colors.white, fontFamily: 'Nunito')),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
              ),
              MaterialButton(
                minWidth: 200.0,
                height: 40.0,
                onPressed: () {
                  Navigator.pushNamed(context, 'registrar');
                },
                color: Color.fromRGBO(30, 20, 108, 1),
                child: Text('REGISTRARME',
                    style:
                        TextStyle(color: Colors.white, fontFamily: 'Nunito')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
