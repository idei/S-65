import 'package:app_salud/models/usuario_model.dart';
import 'package:flutter/foundation.dart';

class UsuarioServices extends ChangeNotifier {
  UsuarioModel _usuarioModel;

  UsuarioModel get usuario => this._usuarioModel;
  bool get existeUsuarioModel => (this._usuarioModel != null) ? true : false;

  set usuario(UsuarioModel user) {
    this._usuarioModel = user;
    notifyListeners();
  }
}
