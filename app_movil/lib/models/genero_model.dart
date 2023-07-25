import 'package:flutter/material.dart';

class GeneroModel extends InheritedWidget {
  String idGenero;
  String nombreGenero;

  GeneroModel({
    this.idGenero,
    this.nombreGenero,
  });

  Map<String, dynamic> get map {
    return {
      "id": idGenero,
      "nombre": nombreGenero,
    };
  }

  factory GeneroModel.fromJson(Map<String, dynamic> json) {
    return GeneroModel(
      idGenero: json['id'].toString(),
      nombreGenero: json['nombre'].toString(),
    );
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    throw UnimplementedError();
  }
}
