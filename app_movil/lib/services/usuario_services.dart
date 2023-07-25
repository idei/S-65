import 'dart:convert';
import 'package:app_salud/models/departamentos_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:app_salud/models/paciente_model.dart';
import 'package:app_salud/models/usuario_model.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'departamento_service.dart';

class UsuarioServices extends ChangeNotifier {
  UsuarioModel _usuarioModel;
  DepartamentoModel _departamentoModel;

  var _formDataPaciente;
  var _formDataDepartamentos;

  bool _isLoading = false;

  UsuarioModel get usuario => this._usuarioModel;
  bool get existeUsuarioModel => (this._usuarioModel != null) ? true : false;
  bool get isLoading => (this._isLoading != null) ? true : false;
  PacienteModel get formDataPaciente => _formDataPaciente;
  //DepartamentoModel get formDataDepartamento => this._formDataDepartamentos;

  set usuario(UsuarioModel user) {
    this._usuarioModel = user;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    //notifyListeners();
  }

  Future<void> loadData(BuildContext context) async {
    _formDataPaciente = PacienteModel();
    //_formDataUsuario = UsuarioModel();

    isLoading = true;
  }
}
