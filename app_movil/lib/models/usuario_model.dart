import 'package:app_salud/models/paciente_model.dart';
import 'package:flutter/cupertino.dart';

class UsuarioModel extends InheritedWidget {
  String tokenId;
  String emailUser;
  String password;
  PacienteModel paciente;

  UsuarioModel({
    this.tokenId,
    this.emailUser,
    this.paciente,
    this.password,
  });

  Map<String, dynamic> get map {
    return {
      "token": tokenId,
      "email": emailUser,
      "paciente": paciente,
    };
  }

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
        emailUser: json['email'].toString(),
        tokenId: json['token'].toString(),
        password: json['token'].toString(),
        paciente: PacienteModel.fromJsonFromRegisterInitial(json['paciente']));
  }

  factory UsuarioModel.fromJsonLogin(Map<String, dynamic> json) {
    return UsuarioModel(
        emailUser: json['data']['email'].toString(),
        tokenId: json['data']['token'].toString(),
        password: json['data']['token'].toString(),
        paciente: PacienteModel.fromJson(json['data']['paciente']));
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    throw UnimplementedError();
  }
}
