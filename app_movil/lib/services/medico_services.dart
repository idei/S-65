import 'package:app_salud/models/medico_model.dart';
import 'package:flutter/foundation.dart';

class MedicoServices extends ChangeNotifier {
  MedicoModel _medicoModel;

  MedicoModel get medico => this._medicoModel;
  bool get existeUsuarioModel => (this._medicoModel != null) ? true : false;

  set medico(MedicoModel user) {
    this._medicoModel = user;
    notifyListeners();
  }
}
