import 'dart:convert';
import 'package:app_salud/models/grupo_conviviente_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../pages/env.dart';

class GrupoConvivienteServices extends ChangeNotifier {
  GrupoConvivienteModel _grupoModel;
  var _formDataGrupo;
  List<GrupoConvivienteModel> _formDataList = [];
  bool _isLoading = false;

  List<GrupoConvivienteModel> get formDataList => _formDataList;

  bool get existeGrupoModel => (this._grupoModel != null) ? true : false;
  bool get isLoadingGrupos => (this._isLoading != null) ? true : false;
  GrupoConvivienteModel get formDataDepartamento => this._formDataGrupo;

  set grupos(GrupoConvivienteModel grupoConvivienteModel) {
    this._formDataGrupo = grupoConvivienteModel;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> loadGrupoConviviente() async {
    String URL_base = Env.URL_API;
    var url = URL_base + "/deptos_generos_patologias";

    var response = await http.post(url, body: {"tipo": "4"});

    var responseBody = json.decode(response.body);

    final List jsonData = responseBody['data'];
    _formDataList =
        jsonData.map((json) => GrupoConvivienteModel.fromJson(json)).toList();

    _formDataGrupo = GrupoConvivienteModel();

    isLoading = true;
  }
}
