import 'package:flutter/material.dart';

class MedicoModel extends InheritedWidget {
  String nombre_medico;
  String apellido_medico;
  String especialidad;
  var rela_medico;
  String matricula;

  MedicoModel({
    this.nombre_medico,
    this.apellido_medico,
    this.rela_medico,
    this.especialidad,
    this.matricula,
  });

  Map<String, dynamic> get map {
    return {
      "nombre_medico": nombre_medico,
      "apellido_medico": apellido_medico,
      "especialidad": especialidad,
      "rela_medico": rela_medico,
      "matricula": matricula,
    };
  }

  factory MedicoModel.fromJson(Map<String, dynamic> json) {
    return MedicoModel(
      nombre_medico: json['nombre'],
      apellido_medico: json['apellido'],
      rela_medico: json['id'],
      especialidad: json['especialidad'],
      matricula: json['matricula'],
    );
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    throw UnimplementedError();
  }
}
