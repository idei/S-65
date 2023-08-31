import 'package:flutter/material.dart';
import 'package:app_salud/models/paciente_model.dart';
import 'package:app_salud/models/usuario_model.dart';

class UsuarioServices extends ChangeNotifier {
  UsuarioModel _usuarioModel;

  var _formDataPaciente;

  bool _isLoading = false;

  UsuarioModel get usuario => this._usuarioModel;
  bool get existeUsuarioModel => (this._usuarioModel != null) ? true : false;
  bool get isLoading => (this._isLoading != null) ? true : false;
  PacienteModel get formDataPaciente => _formDataPaciente;

  set usuario(UsuarioModel user) {
    this._usuarioModel = user;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
  }

  Future<void> loadData(BuildContext context) async {
    _formDataPaciente = PacienteModel();
    //_formDataUsuario = UsuarioModel();

    isLoading = true;
  }
}
