import 'package:flutter/material.dart';

class IbupiracPage extends StatefulWidget {
  @override
  _IbupiracState createState() => _IbupiracState();
}

class _IbupiracState extends State<IbupiracPage> {
  double _animatedHeight = 0.0;
  @override
  Widget build(BuildContext context) {
    final _formKey_ibu = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Ibupirac'),
        actions: <Widget>[],
        backgroundColor: Colors.lightBlue,
      ),
      body: Center(
        child: MyStatefulWidget(),
      ),
      // ListView(
      //   children: ListTile.divideTiles(
      //     context: context,
      //     tiles: [
      //       ListTile(
      //         title: Text('Diario'),
      //         subtitle: Text('Presionar para cambiar'),
      //         onTap: () {},
      //       ),
      //     ],
      //   ).toList(),
      // )
    );
  }

  void choiceAction(String choice) {
    if (choice == Constants.Ajustes) {
      Navigator.pushNamed(context, '/ajustes');
    } else if (choice == Constants.Salir) {
      Navigator.pushNamed(context, '/');
    }
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  String dropdownValue = 'Cada 6 horas';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      // icon: Icon(Icons.arrow_downward),
      // iconSize: 24,
      // elevation: 16,
      // style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.blue,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>[
        'Cada 6 horas',
        'Cada 8 horas',
        'Cada 12 horas',
        'Cada 24 horas'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
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
