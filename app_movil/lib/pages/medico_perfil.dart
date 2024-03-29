import 'package:flutter/material.dart';

var id_paciente;
String nombre_medico;
String apellido_medico;
var especialidad;
var matricula;
var rela_medico;

class MedicoPerfil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map parametros = ModalRoute.of(context).settings.arguments;

    id_paciente = parametros['id_paciente'];
    rela_medico = parametros['rela_medico'];
    nombre_medico = parametros['nombre_medico'];
    apellido_medico = parametros['apellido_medico'];
    especialidad = parametros['especialidad'];
    matricula = parametros['matricula'];

    return Scaffold(
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
              Navigator.pushNamed(context, '/list_medicos');
            },
          ),
          title: Text(
            'Perfil del Dr/a ',
            style: TextStyle(
              fontFamily: Theme.of(context).textTheme.headline1.fontFamily,
            ),
          ),
        ),
        body: FutureBuilder(
          future: read_medico(context, rela_medico),
          builder: (context, snapshot) {
            return Form(
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView(children: <Widget>[
                      CardPerfilMedico(),
                      SizedBox(
                        height: 30,
                      ),
                    ])));
          },
        ));
  }
}

class CardPerfilMedico extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.person),
                title: Text("$nombre_medico $apellido_medico",
                    style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily)),
                subtitle: Text(
                    'Matricula: $matricula \nEspecialidad: $especialidad',
                    style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.headline1.fontFamily)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

read_medico(BuildContext context, var rela_medico) async {
  // String URL_base = Env.URL_PREFIX;
  // var url = URL_base + "/read_medico.php";
  // var response = await http.post(url, body: {
  //   "rela_paciente": id_paciente.toString(),
  // });

  // print(response.body);
  // var data = json.decode(response.body);

  // if (response.statusCode == 200) {
  //   nombre_medico = data["nombre"];
  //   apellido_medico = data["apellido"];
  //   especialidad = data["especialidad"];
  //   matricula = data["matricula"];
  // }
}
