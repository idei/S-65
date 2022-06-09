import 'package:flutter/material.dart';

class menuPrueba extends StatefulWidget {
  //menuPrueba({Key? key}) : super(key: key);

  @override
  State<menuPrueba> createState() => _menuPruebaState();
}

class _menuPruebaState extends State<menuPrueba> {
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
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: 3,
          // Generate 100 widgets that display their index in the List.
          children: List.generate(12, (index) {
            return Center(
              child: Card(
                margin: EdgeInsets.all(5.0),
                elevation: 10,
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    debugPrint('Card tapped.');
                  },
                  child: FadeInImage(
                    image: AssetImage('assets/calendario.png'),
                    placeholder: AssetImage('assets/calendario.png'),
                    width: 70.0,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
