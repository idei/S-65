import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/opciones_navbar.dart';
import '../widgets/alert_informe.dart';
import 'env.dart';

var id_paciente;
var id_medico;
var tipo_screening;
var id_recordatorio;
var screening_recordatorio;
var email;

class ScreeningADLQPage extends StatefulWidget {
  @override
  _ScreeningADLQState createState() => _ScreeningADLQState();
}

class _ScreeningADLQState extends State<ScreeningADLQPage> {
  @override
  void initState() {
    super.initState();
    getStringValuesSF();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, '/screening', arguments: {
          "select_screening": "ADLQ",
        });
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: CircleAvatar(
              radius: MediaQuery.of(context).size.width / 30,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.arrow_back,
                color: Colors.blue,
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/screening', arguments: {
                "select_screening": "ADLQ",
              });
            },
          ),
          title: Text('Chequeo de Actividades de la Vida Diaria',
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
              )),
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
            ),
          ],
        ),
        body: FutureBuilder(
          future: getAllRespuestasADLQ(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ColumnWidgetAlimentacion();
            } else {
              return Center(
                child: CircularProgressIndicator(
                  semanticsLabel: "Cargando",
                ),
              );
            }
          },
        ),
      ),
    );
  }

  //Funciones -----------------------------------------------------------

  get_tiposcreening(var codigo_screening) async {
    String URL_base = Env.URL_API;
    var url = URL_base + "/read_tipo_screening";
    var response = await http.post(url, body: {
      "codigo_screening": codigo_screening,
    });
    if (response.statusCode == 200) {
      var datatipo = json.decode(response.body);
      tipo_screening = datatipo["data"];
    } else {
      loginToast("Ocurrió un problema");
      print(tipo_screening);
    }
  }

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email_prefer = prefs.getString("email_prefer");
    email = email_prefer;
    id_paciente = prefs.getInt("id_paciente");

    Map parametros = ModalRoute.of(context).settings.arguments;

    get_tiposcreening(parametros["tipo_screening"]);

    if (parametros["bandera"] == "recordatorio") {
      screening_recordatorio = true;
      id_recordatorio = parametros["id_recordatorio"];
      id_paciente = id_paciente;
      id_medico = parametros["id_medico"];
      tipo_screening = parametros["tipo_screening"];
    } else {
      if (parametros["bandera"] == "screening_nuevo") {
        screening_recordatorio = false;
        id_paciente = id_paciente;
        id_recordatorio = null;
        id_medico = null;
        //tipo_screening = parametros["tipo_screening"];
      }
    }
  }

  Future<List> getAllRespuestasADLQ() async {
    var response;

    String URL_base = Env.URL_API;
    var url = URL_base + "/tipo_respuesta_adlq";

    response = await http.post(url, body: {});

    var jsonData = json.decode(response.body);

    if (response.statusCode == 200) {
      return itemsRespuestasADLQ = jsonData['data'];
    } else {
      return null;
    }
  }

  void choiceAction(String choice) {
    if (choice == Constants.Ajustes) {
      Navigator.pushNamed(context, '/ajustes');
    } else if (choice == Constants.Salir) {
      Navigator.pushNamed(context, '/');
    }
  }
}

class CustomDivider extends StatelessWidget {
  var text;
  var color;

  CustomDivider({this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Expanded(
              child: Divider(
            thickness: 5,
            color: color,
          )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
              child: Divider(
            thickness: 5,
            color: color,
          )),
        ],
      ),
    );
  }
}

List itemsRespuestasADLQ;

class ColumnWidgetAlimentacion extends StatefulWidget {
  const ColumnWidgetAlimentacion({
    Key key,
  }) : super(key: key);
  @override
  State<ColumnWidgetAlimentacion> createState() =>
      _ColumnWidgetAlimentacionState();
}

class _ColumnWidgetAlimentacionState extends State<ColumnWidgetAlimentacion> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => alert_screenings_generico(
        context,
        "Chequeo Actividades de la Vida Diaria",
        "El ADLQ es un cuestionario de ACTIVIDADES DE LA VIDA DIARIA que idealmente debe ser respondida por un familiar cercano, cuidador o persona de referencia para poder informar adecuadamente sobre el desenvolvimiento de la persona en diferentes aspectos de la vida diaria al momento actual. Consigna: seleccione la opción que mejor describa a la persona al día de la fecha"));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Container(
          padding: EdgeInsets.only(top: 20.0),
          child: CustomDivider(
            text: 'ACTIVIDADES DE AUTOCUIDADO',
            color: Colors.red,
          ),
        ),
        Card(
          shadowColor: Colors.red,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Alimentarse',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily),
                  ),
                ),
                Alimentarse(),
              ],
            ),
          ),
        ),
        //Divider(height: 5.0, color: Colors.black),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.red,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text('Vestirse',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: Theme.of(context)
                              .textTheme
                              .headline1
                              .fontFamily)),
                ),
                Vestirse(),
              ],
            ),
          ),
        ),
        //Divider(height: 5.0, color: Colors.black),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.red,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text('Baño',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: Theme.of(context)
                              .textTheme
                              .headline1
                              .fontFamily)),
                ),
                Bano(),
              ],
            ),
          ),
        ),
        //Divider(height: 5.0, color: Colors.black),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.red,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text('Evacuación',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: Theme.of(context)
                              .textTheme
                              .headline1
                              .fontFamily)),
                ),
                Evacuacion(),
              ],
            ),
          ),
        ),
        //Divider(height: 5.0, color: Colors.black),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.red,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text('Tomar la Medicación',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: Theme.of(context)
                              .textTheme
                              .headline1
                              .fontFamily)),
                ),
                TomarMedic(),
              ],
            ),
          ),
        ),
        //Divider(height: 5.0, color: Colors.black),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.red,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Interés en su aspecto personal',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily),
                  ),
                ),
                AspectoPersonal(),
              ],
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Column(
          children: [
            Container(
              child: CustomDivider(
                text: 'CUIDADO Y MANEJO DEL HOGAR',
                color: Colors.green,
              ),
            ),
            Card(
              shadowColor: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.all(15),
              elevation: 10,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Preparación de comidas, cocinar',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: Theme.of(context)
                                .textTheme
                                .headline1
                                .fontFamily),
                      ),
                    ),
                    PreparaComida(),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.green,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Poner la Mesa',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily),
                  ),
                ),
                PonerMesa(),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.green,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Cuidados del Hogar',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily),
                  ),
                ),
                CuidadoHogar(),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.green,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Mantenimiento del Hogar',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily),
                  ),
                ),
                MantenimientoHogar(),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.green,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Arreglos del Hogar',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily),
                  ),
                ),
                ArreglosHogar(),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.green,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Lavado de Ropa',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily),
                  ),
                ),
                LavadoRopa(),
              ],
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Column(
          children: [
            Container(
                child: CustomDivider(
              text: 'EMPLEO Y RECREACIÓN',
              color: Colors.blue,
            )),
            Card(
              shadowColor: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.all(15),
              elevation: 10,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Empleo',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: Theme.of(context)
                                .textTheme
                                .headline1
                                .fontFamily),
                      ),
                    ),
                    Empleo(),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Recreación',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily),
                  ),
                ),
                Recreacion(),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Reuniones (eventos laborales)',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily),
                  ),
                ),
                Reuniones(),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Viajes',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily),
                  ),
                ),
                Viajes(),
              ],
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Column(
          children: [
            Container(
              child: CustomDivider(
                text: 'COMPRAS Y DINERO',
                color: Colors.yellow,
              ),
            ),
            Card(
              shadowColor: Colors.yellow,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.all(15),
              elevation: 10,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Comprar Comida',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: Theme.of(context)
                                .textTheme
                                .headline1
                                .fontFamily),
                      ),
                    ),
                    ComprarComida(),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.yellow,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Manejo de Efectivo',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily),
                  ),
                ),
                ManejoEfectivo(),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.yellow,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Manejo de Finanzas',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily),
                  ),
                ),
                ManejoFinanzas(),
              ],
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Column(
          children: [
            CustomDivider(
              text: 'VIAJAR',
              color: Colors.deepPurple,
            ),
            Card(
              shadowColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.all(15),
              elevation: 10,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Transporte Público',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: Theme.of(context)
                                .textTheme
                                .headline1
                                .fontFamily),
                      ),
                    ),
                    TransportePublico(),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.deepPurple,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Conducir',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily),
                  ),
                ),
                Conducir(),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.deepPurple,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Movilidad en el Barrio',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily),
                  ),
                ),
                MovilidadBarrio(),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.deepPurple,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Viajar fuera del ambiente familiar (conocido)',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily),
                  ),
                ),
                ViajarFueraAmbiente(),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Column(
          children: [
            Container(
                child: CustomDivider(
                    text: 'COMUNICACIÓN', color: Colors.deepOrange)),
            Card(
              shadowColor: Colors.deepOrange,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.all(15),
              elevation: 10,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Uso del teléfono',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: Theme.of(context)
                                .textTheme
                                .headline1
                                .fontFamily),
                      ),
                    ),
                    UsoTelefono(),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.deepOrange,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Conversación',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily),
                  ),
                ),
                Conversacion(),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.deepOrange,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Comprensión',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily),
                  ),
                ),
                Comprension(),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.deepOrange,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Lectura',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily),
                  ),
                ),
                Lectura(),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Card(
          shadowColor: Colors.deepOrange,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(15),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Escritura',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily),
                  ),
                ),
                Escritura(),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        ElevatedButton.icon(
          icon: _isLoading
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: const CircularProgressIndicator(),
                )
              : const Icon(Icons.save_alt),
          style: ElevatedButton.styleFrom(
            textStyle: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily),
          ),
          onPressed: () => !_isLoading ? _startLoading() : null,
          label: Text('GUARDAR',
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
                fontWeight: FontWeight.bold,
              )),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
      ]),
    );
  }

  bool _isLoading = false;
  void _startLoading() async {
    setState(() {
      _isLoading = true;
    });

    await guardarDatosADLQ();

    setState(() {
      _isLoading = false;
    });
  }

  guardarDatosADLQ() async {
    if (id_alimentacion == null)
      loginToast("Debe responder todas las preguntas");
    if (id_vestimenta == null) loginToast("Debe responder todas las preguntas");
    if (id_arreglos_hogar == null)
      loginToast("Debe responder todas las preguntas");
    if (id_aspecto_personal == null)
      loginToast("Debe responder todas las preguntas");
    if (id_bano == null) loginToast("Debe responder todas las preguntas");
    if (id_comprar_comida == null)
      loginToast("Debe responder todas las preguntas");
    if (id_comprension == null)
      loginToast("Debe responder todas las preguntas");
    if (id_conducir == null) loginToast("Debe responder todas las preguntas");
    if (id_conversacion == null)
      loginToast("Debe responder todas las preguntas");
    if (id_cuidado_hogar == null)
      loginToast("Debe responder todas las preguntas");
    if (id_empleo == null) loginToast("Debe responder todas las preguntas");
    if (id_escritura == null) loginToast("Debe responder todas las preguntas");
    if (id_evacuacion == null) loginToast("Debe responder todas las preguntas");
    if (id_lavado_ropa == null)
      loginToast("Debe responder todas las preguntas");
    if (id_lectura == null) loginToast("Debe responder todas las preguntas");
    if (id_manejo_efectivo == null)
      loginToast("Debe responder todas las preguntas");
    if (id_manejo_finanzas == null)
      loginToast("Debe responder todas las preguntas");
    if (id_mantenimiento_hogar == null)
      loginToast("Debe responder todas las preguntas");
    if (id_movilidad_barrio == null)
      loginToast("Debe responder todas las preguntas");
    if (id_poner_mesa == null) loginToast("Debe responder todas las preguntas");
    if (id_prepara_comida == null)
      loginToast("Debe responder todas las preguntas");
    if (id_recreacion == null) loginToast("Debe responder todas las preguntas");
    if (id_reuniones == null) loginToast("Debe responder todas las preguntas");
    if (id_tomar_medicacion == null)
      loginToast("Debe responder todas las preguntas");
    if (id_transporte_publico == null)
      loginToast("Debe responder todas las preguntas");
    if (id_uso_telefono == null)
      loginToast("Debe responder todas las preguntas");
    if (id_viaje_fuera_ambiente == null)
      loginToast("Debe responder todas las preguntas");
    if (id_viajes == null) loginToast("Debe responder todas las preguntas");

    String URL_base = Env.URL_API;
    var url = URL_base + "/respuesta_screening_adlq";
    var response = await http.post(url, body: {
      "id_paciente": id_paciente.toString(),
      "id_medico": id_medico.toString(),
      "id_recordatorio": id_recordatorio.toString(),
      "tipo_screening": tipo_screening,
      "id_alimentacion": id_alimentacion.toString(),
      "id_vestimenta": id_vestimenta.toString(),
      "id_arreglos_hogar": id_arreglos_hogar.toString(),
      "id_aspecto_personal": id_aspecto_personal.toString(),
      "id_bano": id_bano.toString(),
      "id_comprar_comida": id_comprar_comida.toString(),
      "id_comprension": id_comprension.toString(),
      "id_conducir": id_conducir.toString(),
      "id_conversacion": id_conversacion.toString(),
      "id_cuidado_hogar": id_cuidado_hogar.toString(),
      "id_empleo": id_empleo.toString(),
      "id_escritura": id_escritura.toString(),
      "id_evacuacion": id_evacuacion.toString(),
      "id_lavado_ropa": id_lavado_ropa.toString(),
      "id_lectura": id_lectura.toString(),
      "id_manejo_efectivo": id_manejo_efectivo.toString(),
      "id_manejo_finanzas": id_manejo_finanzas.toString(),
      "id_mantenimiento_hogar": id_mantenimiento_hogar.toString(),
      "id_movilidad_barrio": id_movilidad_barrio.toString(),
      "id_poner_mesa": id_poner_mesa.toString(),
      "id_prepara_comida": id_prepara_comida.toString(),
      "id_recreacion": id_recreacion.toString(),
      "id_reuniones": id_reuniones.toString(),
      "id_tomar_medicacion": id_tomar_medicacion.toString(),
      "id_transporte_publico": id_transporte_publico.toString(),
      "id_uso_telefono": id_uso_telefono.toString(),
      "id_viaje_fuera_ambiente": id_viaje_fuera_ambiente.toString(),
      "id_viajes": id_viajes.toString(),
    });

    if (response.statusCode == 200) {
      var responseDecoder = json.decode(response.body);

      if (responseDecoder['status'] == "Success") {
        Navigator.pushNamed(context, '/screening', arguments: {
          "select_screening": "ADLQ",
        });
        _scaffold_messenger(context, "Screening Registrado", 1);
      } else {
        _scaffold_messenger(context, "No se pudo guardar el Chequeo", 2);
      }
    }
  }
}

showDialogMessage(context) async {
  await Future.delayed(Duration(microseconds: 1));
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 80,
            width: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Guardando Información",
                  style: TextStyle(
                    fontFamily:
                        Theme.of(context).textTheme.headline1.fontFamily,
                  ),
                )
              ],
            ),
          ),
        );
      });
}

loginToast(String toast) {
  return Fluttertoast.showToast(
      msg: toast,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white);
}

_scaffold_messenger(context, message, colorNumber) {
  var color;
  colorNumber == 1 ? color = Colors.green[800] : color = Colors.red[600];

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: color,
    content: Text(message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white)),
  ));
}

//******************Respuestas************************

// Alimentarse *******************

var id_alimentacion;

class Alimentarse extends StatefulWidget {
  @override
  AlimentacionWidgetState createState() => AlimentacionWidgetState();
}

class AlimentacionWidgetState extends State<Alimentarse> {
  @override
  void initState() {
    id_alimentacion = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasADLQ
            .map(
              (list) => list['code'] == "ADLQ1" ||
                      list['code'] == "ADLQ2" ||
                      list['code'] == "ADLQ3" ||
                      list['code'] == "ADLQ5" ||
                      list['code'] == "ADLQ600"
                  ? RadioListTile(
                      groupValue: id_alimentacion,
                      title: Text(
                        list['respuesta'],
                        style: TextStyle(
                          fontFamily:
                              Theme.of(context).textTheme.headline1.fontFamily,
                        ),
                      ),
                      value: list['id'].toString(),
                      onChanged: (val) {
                        setState(() {
                          debugPrint('VAL = $val');
                          id_alimentacion = val;
                        });
                      },
                    )
                  : SizedBox(),
            )
            .toList(),
      ),
    );
  }
}

// Vestirse *******************

List itemsVestimenta;
var id_vestimenta;

class Vestirse extends StatefulWidget {
  @override
  VestirseWidgetState createState() => VestirseWidgetState();
}

class VestirseWidgetState extends State<Vestirse> {
  @override
  void initState() {
    id_vestimenta = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasADLQ
            .map(
              (list) => list['code'] == "ADLQ1" ||
                      list['code'] == "ADLQ7" ||
                      list['code'] == "ADLQ8" ||
                      list['code'] == "ADLQ9" ||
                      list['code'] == "ADLQ600"
                  ? RadioListTile(
                      groupValue: id_vestimenta,
                      title: Text(
                        list['respuesta'],
                        style: TextStyle(
                          fontFamily:
                              Theme.of(context).textTheme.headline1.fontFamily,
                        ),
                      ),
                      value: list['id'].toString(),
                      onChanged: (val) {
                        setState(() {
                          debugPrint('VAL = $val');
                          id_vestimenta = val;
                        });
                      },
                    )
                  : SizedBox(),
            )
            .toList(),
      ),
    );
  }
}

// Bano *******************

var id_bano;

class Bano extends StatefulWidget {
  @override
  BanoWidgetState createState() => BanoWidgetState();
}

class BanoWidgetState extends State<Bano> {
  @override
  void initState() {
    id_bano = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasADLQ
            .map((list) => list['code'] == "ADLQ1" ||
                    list['code'] == "ADLQ10" ||
                    list['code'] == "ADLQ11" ||
                    list['code'] == "ADLQ12" ||
                    list['code'] == "ADLQ600"
                ? RadioListTile(
                    groupValue: id_bano,
                    title: Text(
                      list['respuesta'],
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily,
                      ),
                    ),
                    value: list['id'].toString(),
                    onChanged: (val) {
                      setState(() {
                        debugPrint('VAL = $val');
                        id_bano = val;
                      });
                    },
                  )
                : SizedBox())
            .toList(),
      ),
    );
  }
}

// Evacuacion *******************

var id_evacuacion;

class Evacuacion extends StatefulWidget {
  @override
  EvacuacionWidgetState createState() => EvacuacionWidgetState();
}

class EvacuacionWidgetState extends State<Evacuacion> {
  @override
  void initState() {
    id_evacuacion = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasADLQ
            .map((list) => list['code'] == "ADLQ13" ||
                    list['code'] == "ADLQ14" ||
                    list['code'] == "ADLQ16" ||
                    list['code'] == "ADLQ17" ||
                    list['code'] == "ADLQ600"
                ? RadioListTile(
                    groupValue: id_evacuacion,
                    title: Text(
                      list['respuesta'],
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily,
                      ),
                    ),
                    value: list['id'].toString(),
                    onChanged: (val) {
                      setState(() {
                        debugPrint('VAL = $val');
                        id_evacuacion = val;
                      });
                    },
                  )
                : SizedBox())
            .toList(),
      ),
    );
  }
}

// Toma Medicacion *******************

var id_tomar_medicacion;

class TomarMedic extends StatefulWidget {
  @override
  TomarMedicWidgetState createState() => TomarMedicWidgetState();
}

class TomarMedicWidgetState extends State<TomarMedic> {
  @override
  void initState() {
    id_tomar_medicacion = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasADLQ
            .map((list) => list['code'] == "ADLQ18" ||
                    list['code'] == "ADLQ19" ||
                    list['code'] == "ADLQ20" ||
                    list['code'] == "ADLQ21" ||
                    list['code'] == "ADLQ22" ||
                    list['code'] == "ADLQ600"
                ? RadioListTile(
                    groupValue: id_tomar_medicacion,
                    title: Text(
                      list['respuesta'],
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily,
                      ),
                    ),
                    value: list['id'].toString(),
                    onChanged: (val) {
                      setState(() {
                        debugPrint('VAL = $val');
                        id_tomar_medicacion = val;
                      });
                    },
                  )
                : SizedBox())
            .toList(),
      ),
    );
  }
}

// Aspecto Personal *******************

var id_aspecto_personal;

class AspectoPersonal extends StatefulWidget {
  @override
  AspectoPersonalWidgetState createState() => AspectoPersonalWidgetState();
}

class AspectoPersonalWidgetState extends State<AspectoPersonal> {
  @override
  void initState() {
    id_aspecto_personal = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasADLQ
            .map((list) => list['code'] == "ADLQ23" ||
                    list['code'] == "ADLQ24" ||
                    list['code'] == "ADLQ25" ||
                    list['code'] == "ADLQ26" ||
                    list['code'] == "ADLQ600"
                ? RadioListTile(
                    groupValue: id_aspecto_personal,
                    title: Text(
                      list['respuesta'],
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily,
                      ),
                    ),
                    value: list['id'].toString(),
                    onChanged: (val) {
                      setState(() {
                        debugPrint('VAL = $val');
                        id_aspecto_personal = val;
                      });
                    },
                  )
                : SizedBox())
            .toList(),
      ),
    );
  }
}

// Preparacion de Comida *******************

var id_prepara_comida;

class PreparaComida extends StatefulWidget {
  @override
  PreparaComidaWidgetState createState() => PreparaComidaWidgetState();
}

class PreparaComidaWidgetState extends State<PreparaComida> {
  @override
  void initState() {
    id_prepara_comida = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasADLQ
            .map((list) => list['code'] == "ADLQ27" ||
                    list['code'] == "ADLQ28" ||
                    list['code'] == "ADLQ29" ||
                    list['code'] == "ADLQ30" ||
                    list['code'] == "ADLQ31" ||
                    list['code'] == "ADLQ600"
                ? RadioListTile(
                    groupValue: id_prepara_comida,
                    title: Text(
                      list['respuesta'],
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily,
                      ),
                    ),
                    value: list['id'].toString(),
                    onChanged: (val) {
                      setState(() {
                        debugPrint('VAL = $val');
                        id_prepara_comida = val;
                      });
                    },
                  )
                : SizedBox())
            .toList(),
      ),
    );
  }
}

// Poner la Mesa *******************

var id_poner_mesa;

class PonerMesa extends StatefulWidget {
  @override
  PonerMesaWidgetState createState() => PonerMesaWidgetState();
}

class PonerMesaWidgetState extends State<PonerMesa> {
  @override
  void initState() {
    id_poner_mesa = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasADLQ
            .map((list) => list['code'] == "ADLQ1" ||
                    list['code'] == "ADLQ32" ||
                    list['code'] == "ADLQ33" ||
                    list['code'] == "ADLQ34" ||
                    list['code'] == "ADLQ599" ||
                    list['code'] == "ADLQ600"
                ? RadioListTile(
                    groupValue: id_poner_mesa,
                    title: Text(
                      list['respuesta'],
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily,
                      ),
                    ),
                    value: list['id'].toString(),
                    onChanged: (val) {
                      setState(() {
                        debugPrint('VAL = $val');
                        id_poner_mesa = val;
                      });
                    },
                  )
                : SizedBox())
            .toList(),
      ),
    );
  }
}

// Cuidados del Hogar *******************

var id_cuidado_hogar;

class CuidadoHogar extends StatefulWidget {
  @override
  CuidadoHogarWidgetState createState() => CuidadoHogarWidgetState();
}

class CuidadoHogarWidgetState extends State<CuidadoHogar> {
  @override
  void initState() {
    id_cuidado_hogar = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasADLQ
            .map((list) => list['code'] == "ADLQ35" ||
                    list['code'] == "ADLQ36" ||
                    list['code'] == "ADLQ37" ||
                    list['code'] == "ADLQ38" ||
                    list['code'] == "ADLQ599" ||
                    list['code'] == "ADLQ600"
                ? RadioListTile(
                    groupValue: id_cuidado_hogar,
                    title: Text(
                      list['respuesta'],
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily,
                      ),
                    ),
                    value: list['id'].toString(),
                    onChanged: (val) {
                      setState(() {
                        debugPrint('VAL = $val');
                        id_cuidado_hogar = val;
                      });
                    },
                  )
                : SizedBox())
            .toList(),
      ),
    );
  }
}

// Mantenimiento del Hogar *******************

var id_mantenimiento_hogar;

class MantenimientoHogar extends StatefulWidget {
  @override
  MantenimientoHogarWidgetState createState() =>
      MantenimientoHogarWidgetState();
}

class MantenimientoHogarWidgetState extends State<MantenimientoHogar> {
  @override
  void initState() {
    id_mantenimiento_hogar = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 310,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasADLQ
            .map((list) => list['code'] == "ADLQ39" ||
                    list['code'] == "ADLQ40" ||
                    list['code'] == "ADLQ41" ||
                    list['code'] == "ADLQ42" ||
                    list['code'] == "ADLQ599" ||
                    list['code'] == "ADLQ600"
                ? RadioListTile(
                    groupValue: id_mantenimiento_hogar,
                    title: Text(
                      list['respuesta'],
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily,
                      ),
                    ),
                    value: list['id'].toString(),
                    onChanged: (val) {
                      setState(() {
                        debugPrint('VAL = $val');
                        id_mantenimiento_hogar = val;
                      });
                    },
                  )
                : SizedBox())
            .toList(),
      ),
    );
  }
}

// Arreglos del Hogar *******************

var id_arreglos_hogar;

class ArreglosHogar extends StatefulWidget {
  @override
  ArreglosHogarWidgetState createState() => ArreglosHogarWidgetState();
}

class ArreglosHogarWidgetState extends State<ArreglosHogar> {
  @override
  void initState() {
    id_arreglos_hogar = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasADLQ
            .map((list) => list['code'] == "ADLQ43" ||
                    list['code'] == "ADLQ44" ||
                    list['code'] == "ADLQ45" ||
                    list['code'] == "ADLQ46" ||
                    list['code'] == "ADLQ599" ||
                    list['code'] == "ADLQ600"
                ? RadioListTile(
                    groupValue: id_arreglos_hogar,
                    title: Text(
                      list['respuesta'],
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily,
                      ),
                    ),
                    value: list['id'].toString(),
                    onChanged: (val) {
                      setState(() {
                        debugPrint('VAL = $val');
                        id_arreglos_hogar = val;
                      });
                    },
                  )
                : SizedBox())
            .toList(),
      ),
    );
  }
}

// Lavado de Ropa *******************

var id_lavado_ropa;

class LavadoRopa extends StatefulWidget {
  @override
  LavadoRopaWidgetState createState() => LavadoRopaWidgetState();
}

class LavadoRopaWidgetState extends State<LavadoRopa> {
  @override
  void initState() {
    id_lavado_ropa = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasADLQ
            .map((list) => list['code'] == "ADLQ48" ||
                    list['code'] == "ADLQ49" ||
                    list['code'] == "ADLQ50" ||
                    list['code'] == "ADLQ600"
                ? RadioListTile(
                    groupValue: id_lavado_ropa,
                    title: Text(
                      list['respuesta'],
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily,
                      ),
                    ),
                    value: list['id'].toString(),
                    onChanged: (val) {
                      setState(() {
                        debugPrint('VAL = $val');
                        id_lavado_ropa = val;
                      });
                    },
                  )
                : SizedBox())
            .toList(),
      ),
    );
  }
}

// Empleo *******************

var id_empleo;

class Empleo extends StatefulWidget {
  @override
  EmpleoWidgetState createState() => EmpleoWidgetState();
}

class EmpleoWidgetState extends State<Empleo> {
  @override
  void initState() {
    id_empleo = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 430,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasADLQ
            .map((list) => list['code'] == "ADLQ51" ||
                    list['code'] == "ADLQ52" ||
                    list['code'] == "ADLQ53" ||
                    list['code'] == "ADLQ54" ||
                    list['code'] == "ADLQ55" ||
                    list['code'] == "ADLQ56" ||
                    list['code'] == "ADLQ600"
                ? RadioListTile(
                    groupValue: id_empleo,
                    title: Text(
                      list['respuesta'],
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily,
                      ),
                    ),
                    value: list['id'].toString(),
                    onChanged: (val) {
                      setState(() {
                        debugPrint('VAL = $val');
                        id_empleo = val;
                      });
                    },
                  )
                : SizedBox())
            .toList(),
      ),
    );
  }
}

// Recreacion *******************

var id_recreacion;

class Recreacion extends StatefulWidget {
  @override
  RecreacionWidgetState createState() => RecreacionWidgetState();
}

class RecreacionWidgetState extends State<Recreacion> {
  @override
  void initState() {
    id_recreacion = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasADLQ
            .map((list) => list['code'] == "ADLQ57" ||
                    list['code'] == "ADLQ58" ||
                    list['code'] == "ADLQ59" ||
                    list['code'] == "ADLQ61" ||
                    list['code'] == "ADLQ62" ||
                    list['code'] == "ADLQ600"
                ? RadioListTile(
                    groupValue: id_recreacion,
                    title: Text(
                      list['respuesta'],
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily,
                      ),
                    ),
                    value: list['id'].toString(),
                    onChanged: (val) {
                      setState(() {
                        debugPrint('VAL = $val');
                        id_recreacion = val;
                      });
                    },
                  )
                : SizedBox())
            .toList(),
      ),
    );
  }
}

// Reuniones (eventos laborales) *******************

var id_reuniones;

class Reuniones extends StatefulWidget {
  @override
  ReunionesWidgetState createState() => ReunionesWidgetState();
}

class ReunionesWidgetState extends State<Reuniones> {
  @override
  void initState() {
    id_reuniones = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasADLQ
            .map((list) => list['code'] == "ADLQ63" ||
                    list['code'] == "ADLQ64" ||
                    list['code'] == "ADLQ65" ||
                    list['code'] == "ADLQ66" ||
                    list['code'] == "ADLQ67" ||
                    list['code'] == "ADLQ600"
                ? RadioListTile(
                    groupValue: id_reuniones,
                    title: Text(
                      list['respuesta'],
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily,
                      ),
                    ),
                    value: list['id'].toString(),
                    onChanged: (val) {
                      setState(() {
                        debugPrint('VAL = $val');
                        id_reuniones = val;
                      });
                    },
                  )
                : SizedBox())
            .toList(),
      ),
    );
  }
}

// Viajes *******************

var id_viajes;

class Viajes extends StatefulWidget {
  @override
  ViajesWidgetState createState() => ViajesWidgetState();
}

class ViajesWidgetState extends State<Viajes> {
  @override
  void initState() {
    id_viajes = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasADLQ
            .map((list) => list['code'] == "ADLQ57" ||
                    list['code'] == "ADLQ63" ||
                    list['code'] == "ADLQ68" ||
                    list['code'] == "ADLQ69" ||
                    list['code'] == "ADLQ70" ||
                    list['code'] == "ADLQ600"
                ? RadioListTile(
                    groupValue: id_viajes,
                    title: Text(
                      list['respuesta'],
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily,
                      ),
                    ),
                    value: list['id'].toString(),
                    onChanged: (val) {
                      setState(() {
                        debugPrint('VAL = $val');
                        id_viajes = val;
                      });
                    },
                  )
                : SizedBox())
            .toList(),
      ),
    );
  }
}

// Comprar Comida *******************

var id_comprar_comida;

class ComprarComida extends StatefulWidget {
  @override
  ComprarComidaWidgetState createState() => ComprarComidaWidgetState();
}

class ComprarComidaWidgetState extends State<ComprarComida> {
  @override
  void initState() {
    id_comprar_comida = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 370,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasADLQ
            .map((list) => list['code'] == "ADLQ1" ||
                    list['code'] == "ADLQ71" ||
                    list['code'] == "ADLQ72" ||
                    list['code'] == "ADLQ73" ||
                    list['code'] == "ADLQ74" ||
                    list['code'] == "ADLQ600"
                ? RadioListTile(
                    groupValue: id_comprar_comida,
                    title: Text(
                      list['respuesta'],
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily,
                      ),
                    ),
                    value: list['id'].toString(),
                    onChanged: (val) {
                      setState(() {
                        debugPrint('VAL = $val');
                        id_comprar_comida = val;
                      });
                    },
                  )
                : SizedBox())
            .toList(),
      ),
    );
  }
}

// Manejo de Efectivo *******************

var id_manejo_efectivo;

class ManejoEfectivo extends StatefulWidget {
  @override
  ManejoEfectivoWidgetState createState() => ManejoEfectivoWidgetState();
}

class ManejoEfectivoWidgetState extends State<ManejoEfectivo> {
  @override
  void initState() {
    id_manejo_efectivo = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasADLQ
            .map((list) => list['code'] == "ADLQ1" ||
                    list['code'] == "ADLQ75" ||
                    list['code'] == "ADLQ76" ||
                    list['code'] == "ADLQ77" ||
                    list['code'] == "ADLQ78" ||
                    list['code'] == "ADLQ600"
                ? RadioListTile(
                    groupValue: id_manejo_efectivo,
                    title: Text(
                      list['respuesta'],
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily,
                      ),
                    ),
                    value: list['id'].toString(),
                    onChanged: (val) {
                      setState(() {
                        debugPrint('VAL = $val');
                        id_manejo_efectivo = val;
                      });
                    },
                  )
                : SizedBox())
            .toList(),
      ),
    );
  }
}

// Manejo de Finanzas *******************

var id_manejo_finanzas;

class ManejoFinanzas extends StatefulWidget {
  @override
  ManejoFinanzasWidgetState createState() => ManejoFinanzasWidgetState();
}

class ManejoFinanzasWidgetState extends State<ManejoFinanzas> {
  @override
  void initState() {
    id_manejo_finanzas = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasADLQ
            .map((list) => list['code'] == "ADLQ1" ||
                    list['code'] == "ADLQ79" ||
                    list['code'] == "ADLQ80" ||
                    list['code'] == "ADLQ81" ||
                    list['code'] == "ADLQ83" ||
                    list['code'] == "ADLQ84" ||
                    list['code'] == "ADLQ600"
                ? RadioListTile(
                    groupValue: id_manejo_finanzas,
                    title: Text(
                      list['respuesta'],
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily,
                      ),
                    ),
                    value: list['id'].toString(),
                    onChanged: (val) {
                      setState(() {
                        debugPrint('VAL = $val');
                        id_manejo_finanzas = val;
                      });
                    },
                  )
                : SizedBox())
            .toList(),
      ),
    );
  }
}

// Transporte Publico *******************

var id_transporte_publico = null;

class TransportePublico extends StatefulWidget {
  @override
  TransportePublicoWidgetState createState() => TransportePublicoWidgetState();
}

class TransportePublicoWidgetState extends State<TransportePublico> {
  @override
  void initState() {
    id_transporte_publico = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasADLQ
            .map((list) => list['code'] == "ADLQ85" ||
                    list['code'] == "ADLQ86" ||
                    list['code'] == "ADLQ87" ||
                    list['code'] == "ADLQ88" ||
                    list['code'] == "ADLQ89" ||
                    list['code'] == "ADLQ600"
                ? RadioListTile(
                    groupValue: id_transporte_publico,
                    title: Text(
                      list['respuesta'],
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily,
                      ),
                    ),
                    value: list['id'].toString(),
                    onChanged: (val) {
                      setState(() {
                        debugPrint('VAL = $val');
                        id_transporte_publico = val;
                      });
                    },
                  )
                : SizedBox())
            .toList(),
      ),
    );
  }
}

// Conducir *******************

var id_conducir;

class Conducir extends StatefulWidget {
  @override
  ConducirWidgetState createState() => ConducirWidgetState();
}

class ConducirWidgetState extends State<Conducir> {
  @override
  void initState() {
    id_conducir = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasADLQ
            .map((list) => list['code'] == "ADLQ90" ||
                    list['code'] == "ADLQ91" ||
                    list['code'] == "ADLQ92" ||
                    list['code'] == "ADLQ93" ||
                    list['code'] == "ADLQ94" ||
                    list['code'] == "ADLQ600"
                ? RadioListTile(
                    groupValue: id_conducir,
                    title: Text(
                      list['respuesta'],
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily,
                      ),
                    ),
                    value: list['id'].toString(),
                    onChanged: (val) {
                      setState(() {
                        debugPrint('VAL = $val');
                        id_conducir = val;
                      });
                    },
                  )
                : SizedBox())
            .toList(),
      ),
    );
  }
}

// Movilidad en el Barrio *******************

var id_movilidad_barrio;

class MovilidadBarrio extends StatefulWidget {
  @override
  MovilidadBarrioWidgetState createState() => MovilidadBarrioWidgetState();
}

class MovilidadBarrioWidgetState extends State<MovilidadBarrio> {
  @override
  void initState() {
    id_movilidad_barrio = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasADLQ
            .map((list) => list['code'] == "ADLQ57" ||
                    list['code'] == "ADLQ95" ||
                    list['code'] == "ADLQ96" ||
                    list['code'] == "ADLQ97" ||
                    list['code'] == "ADLQ98" ||
                    list['code'] == "ADLQ600"
                ? RadioListTile(
                    groupValue: id_movilidad_barrio,
                    title: Text(
                      list['respuesta'],
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily,
                      ),
                    ),
                    value: list['id'].toString(),
                    onChanged: (val) {
                      setState(() {
                        debugPrint('VAL = $val');
                        id_movilidad_barrio = val;
                      });
                    },
                  )
                : SizedBox())
            .toList(),
      ),
    );
  }
}

// Viajar fuera del ambiente familiar (conocido) *******************

var id_viaje_fuera_ambiente;

class ViajarFueraAmbiente extends StatefulWidget {
  @override
  ViajarFueraAmbienteWidgetState createState() =>
      ViajarFueraAmbienteWidgetState();
}

class ViajarFueraAmbienteWidgetState extends State<ViajarFueraAmbiente> {
  @override
  void initState() {
    id_viaje_fuera_ambiente = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasADLQ
            .map((list) => list['code'] == "ADLQ57" ||
                    list['code'] == "ADLQ99" ||
                    list['code'] == "ADLQ100" ||
                    list['code'] == "ADLQ101" ||
                    list['code'] == "ADLQ599" ||
                    list['code'] == "ADLQ600"
                ? RadioListTile(
                    groupValue: id_viaje_fuera_ambiente,
                    title: Text(
                      list['respuesta'],
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily,
                      ),
                    ),
                    value: list['id'].toString(),
                    onChanged: (val) {
                      setState(() {
                        debugPrint('VAL = $val');
                        id_viaje_fuera_ambiente = val;
                      });
                    },
                  )
                : SizedBox())
            .toList(),
      ),
    );
  }
}

// Uso del telefono *******************

var id_uso_telefono;

class UsoTelefono extends StatefulWidget {
  @override
  UsoTelefonoWidgetState createState() => UsoTelefonoWidgetState();
}

class UsoTelefonoWidgetState extends State<UsoTelefono> {
  @override
  void initState() {
    id_uso_telefono = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasADLQ
            .map((list) => list['code'] == "ADLQ57" ||
                    list['code'] == "ADLQ102" ||
                    list['code'] == "ADLQ103" ||
                    list['code'] == "ADLQ104" ||
                    list['code'] == "ADLQ105" ||
                    list['code'] == "ADLQ600"
                ? RadioListTile(
                    groupValue: id_uso_telefono,
                    title: Text(
                      list['respuesta'],
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily,
                      ),
                    ),
                    value: list['id'].toString(),
                    onChanged: (val) {
                      setState(() {
                        debugPrint('VAL = $val');
                        id_uso_telefono = val;
                      });
                    },
                  )
                : SizedBox())
            .toList(),
      ),
    );
  }
}

// Conversacion *******************

var id_conversacion;

class Conversacion extends StatefulWidget {
  @override
  ConversacionWidgetState createState() => ConversacionWidgetState();
}

class ConversacionWidgetState extends State<Conversacion> {
  @override
  void initState() {
    id_conversacion = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasADLQ
            .map((list) => list['code'] == "ADLQ57" ||
                    list['code'] == "ADLQ106" ||
                    list['code'] == "ADLQ107" ||
                    list['code'] == "ADLQ108" ||
                    list['code'] == "ADLQ600"
                ? RadioListTile(
                    groupValue: id_conversacion,
                    title: Text(
                      list['respuesta'],
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily,
                      ),
                    ),
                    value: list['id'].toString(),
                    onChanged: (val) {
                      setState(() {
                        debugPrint('VAL = $val');
                        id_conversacion = val;
                      });
                    },
                  )
                : SizedBox())
            .toList(),
      ),
    );
  }
}

// Comprension *******************

var id_comprension;

class Comprension extends StatefulWidget {
  @override
  ComprensionWidgetState createState() => ComprensionWidgetState();
}

class ComprensionWidgetState extends State<Comprension> {
  @override
  void initState() {
    id_comprension = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasADLQ
            .map((list) => list['code'] == "ADLQ109" ||
                    list['code'] == "ADLQ110" ||
                    list['code'] == "ADLQ111" ||
                    list['code'] == "ADLQ112" ||
                    list['code'] == "ADLQ600"
                ? RadioListTile(
                    groupValue: id_comprension,
                    title: Text(
                      list['respuesta'],
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily,
                      ),
                    ),
                    value: list['id'].toString(),
                    onChanged: (val) {
                      setState(() {
                        debugPrint('VAL = $val');
                        id_comprension = val;
                      });
                    },
                  )
                : SizedBox())
            .toList(),
      ),
    );
  }
}

// Lectura *******************

var id_lectura;

class Lectura extends StatefulWidget {
  @override
  LecturaWidgetState createState() => LecturaWidgetState();
}

class LecturaWidgetState extends State<Lectura> {
  @override
  void initState() {
    id_lectura = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      // width: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasADLQ
            .map((list) => list['code'] == "ADLQ57" ||
                    list['code'] == "ADLQ113" ||
                    list['code'] == "ADLQ114" ||
                    list['code'] == "ADLQ115" ||
                    list['code'] == "ADLQ116" ||
                    list['code'] == "ADLQ600"
                ? RadioListTile(
                    groupValue: id_lectura,
                    title: Text(
                      list['respuesta'],
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily,
                      ),
                    ),
                    value: list['id'].toString(),
                    onChanged: (val) {
                      setState(() {
                        debugPrint('VAL = $val');
                        id_lectura = val;
                      });
                    },
                  )
                : SizedBox())
            .toList(),
      ),
    );
  }
}
// Escritura *******************

var id_escritura;

class Escritura extends StatefulWidget {
  @override
  EscrituraWidgetState createState() => EscrituraWidgetState();
}

class EscrituraWidgetState extends State<Escritura> {
  @override
  void initState() {
    id_escritura = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(8.0),
        children: itemsRespuestasADLQ
            .map((list) => list['code'] == "ADLQ57" ||
                    list['code'] == "ADLQ117" ||
                    list['code'] == "ADLQ118" ||
                    list['code'] == "ADLQ119" ||
                    list['code'] == "ADLQ120" ||
                    list['code'] == "ADLQ600"
                ? RadioListTile(
                    groupValue: id_escritura,
                    title: Text(
                      list['respuesta'],
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily,
                      ),
                    ),
                    value: list['id'].toString(),
                    onChanged: (val) {
                      setState(() {
                        debugPrint('VAL = $val');
                        id_escritura = val;
                      });
                    },
                  )
                : SizedBox())
            .toList(),
      ),
    );
  }
}



  //**************************/************************* */

