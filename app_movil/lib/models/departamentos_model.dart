import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DepartamentoModel extends InheritedWidget {
  String idDepartamento;
  String nombreDepartamento;

  DepartamentoModel({
    this.idDepartamento,
    this.nombreDepartamento,
  });

  Map<String, dynamic> get map {
    return {
      "id": idDepartamento,
      "nombre_departamento": nombreDepartamento,
    };
  }

  factory DepartamentoModel.fromJson(Map<String, dynamic> json) {
    return DepartamentoModel(
      idDepartamento: json['id'].toString(),
      nombreDepartamento: json['nombre_departamento'].toString(),
    );
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    throw UnimplementedError();
  }
}
