import 'package:flutter/material.dart';

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
      "nombre": nombreDepartamento,
    };
  }

  factory DepartamentoModel.fromJson(Map<String, dynamic> json) {
    return DepartamentoModel(
      idDepartamento: json['id'].toString(),
      nombreDepartamento: json['nombre'].toString(),
    );
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    throw UnimplementedError();
  }
}
