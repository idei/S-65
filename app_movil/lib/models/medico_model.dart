import 'package:flutter/material.dart';

class MedicoModel extends InheritedWidget {
  final String nombre_medico;
  final String apellido_medico;
  final String especialidad;
  var rela_medico;
  final String matricula;
  var estado_habilitacion;

  MedicoModel(
      {this.nombre_medico,
      this.apellido_medico,
      this.rela_medico,
      this.especialidad,
      this.matricula,
      this.estado_habilitacion});

  Map<String, dynamic> get map {
    return {
      "nombre_medico": nombre_medico,
      "apellido_medico": apellido_medico,
      "especialidad": especialidad,
      "rela_medico": rela_medico,
      "matricula": matricula,
      "estado_habilitacion": estado_habilitacion
    };
  }

  factory MedicoModel.fromJson(Map<String, dynamic> json) {
    return MedicoModel(
      nombre_medico: json['nombre'],
      apellido_medico: json['apellido'],
      rela_medico: json['id'],
      especialidad: json['especialidad'],
      matricula: json['matricula'],
      estado_habilitacion: json['estado_habilitacion'],
    );
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    throw UnimplementedError();
  }
}
