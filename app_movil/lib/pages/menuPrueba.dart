import 'package:flutter/material.dart';

class MenuPrueba extends StatefulWidget {
  //MenuPrueba({Key? key}) : super(key: key);

  @override
  State<MenuPrueba> createState() => _MenuPruebaState();
}

class _MenuPruebaState extends State<MenuPrueba> {
  @override
  Widget build(BuildContext context) {
    const title = 'Grid List';
    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: GridView.count(
          crossAxisCount: 3, // Define el número de columnas de la grilla
          childAspectRatio: 0.75,
          crossAxisSpacing: 1.0,
          mainAxisSpacing: 10.0,
          padding: EdgeInsets.all(10.0),
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/form_datos_generales');
              },
              child: Column(children: [
                CircleAvatar(
                  radius: MediaQuery.of(context).size.height / 13,
                  child:
                      Icon(Icons.account_box, color: Colors.white, size: 80.0),
                ),
                SizedBox(height: 8.0),
                Text(
                  "DATOS \nPERSONALES",
                  style: TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
              ]),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/form_datos_generales');
              },
              child: Column(children: [
                CircleAvatar(
                  radius: MediaQuery.of(context).size.height / 13,
                  child:
                      Icon(Icons.account_box, color: Colors.white, size: 80.0),
                ),
                SizedBox(height: 8.0),
                Text(
                  "ANTECEDENTES \nFAMILIARES",
                  style: TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
              ]),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/form_datos_generales');
              },
              child: Column(children: [
                CircleAvatar(
                  radius: MediaQuery.of(context).size.height / 13,
                  child:
                      Icon(Icons.account_box, color: Colors.white, size: 80.0),
                ),
                SizedBox(height: 8.0),
                Text(
                  "ANTECEDENTES \nPERSONALES",
                  style: TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
              ]),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/form_datos_generales');
              },
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: MediaQuery.of(context).size.height / 15,
                      child: Icon(Icons.account_box,
                          color: Colors.white, size: 70.0),
                    ),
                    SizedBox(height: 8.0),
                    Text("hola", style: TextStyle(fontSize: 16.0)),
                  ]),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/form_datos_generales');
              },
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: MediaQuery.of(context).size.width / 8.1,
                      child: Icon(Icons.account_box,
                          color: Colors.white, size: 70.0),
                    ),
                    SizedBox(height: 10.0),
                    Text("hola", style: TextStyle(fontSize: 16.0)),
                  ]),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/form_datos_generales');
              },
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: MediaQuery.of(context).size.width / 8.1,
                      child: Icon(Icons.account_box,
                          color: Colors.white, size: 70.0),
                    ),
                    SizedBox(height: 10.0),
                    Text("hola", style: TextStyle(fontSize: 16.0)),
                  ]),
            ),
          ],
        ),
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
