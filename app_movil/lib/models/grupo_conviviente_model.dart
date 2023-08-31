import 'package:flutter/material.dart';

class GrupoConvivienteModel extends InheritedWidget {
  final String idGrupo;
  final String nombreGrupo;

  GrupoConvivienteModel({
    this.idGrupo,
    this.nombreGrupo,
  });

  Map<String, dynamic> get map {
    return {
      "id": idGrupo,
      "nombre": nombreGrupo,
    };
  }

  factory GrupoConvivienteModel.fromJson(Map<String, dynamic> json) {
    return GrupoConvivienteModel(
      idGrupo: json['id'].toString(),
      nombreGrupo: json['nombre'].toString(),
    );
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    throw UnimplementedError();
  }
}
