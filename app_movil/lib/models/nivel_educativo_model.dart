import 'package:flutter/material.dart';

class NivelEducativoModel extends InheritedWidget {
  String idNivelEducativo;
  String nombreNivelEducativo;

  NivelEducativoModel({
    this.idNivelEducativo,
    this.nombreNivelEducativo,
  });

  Map<String, dynamic> get map {
    return {
      "id": idNivelEducativo,
      "nombre_nivel": nombreNivelEducativo,
    };
  }

  factory NivelEducativoModel.fromJson(Map<String, dynamic> json) {
    return NivelEducativoModel(
      idNivelEducativo: json['id'].toString(),
      nombreNivelEducativo: json['nombre_nivel'].toString(),
    );
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    throw UnimplementedError();
  }
}
