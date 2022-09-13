import 'package:app_salud/models/paciente_model.dart';

class UsuarioModel {
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

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
        emailUser: json['email'].toString(),
        tokenId: json['token'].toString(),
        password: json['token'].toString(),
        paciente: PacienteModel.fromJson(json['paciente']));
  }
}
