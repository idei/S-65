import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_salud/models/departamentos_model.dart';
import 'package:flutter/foundation.dart';

import '../pages/env.dart';

class DepartamentoServices extends ChangeNotifier {
  DepartamentoModel _departamentoModel;
  var _formDataDepartamentos;
  List<DepartamentoModel> _formDataList = [];
  bool _isLoading = false;

  List<DepartamentoModel> get formDataList => _formDataList;

  bool get existeDeptoModel => (this._departamentoModel != null) ? true : false;
  bool get isLoadingDeptos => (this._isLoading != null) ? true : false;
  DepartamentoModel get formDataDepartamento => this._formDataDepartamentos;

  set departamento(DepartamentoModel depto) {
    this._formDataDepartamentos = depto;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> loadDepartamentos() async {
    String URL_base = Env.URL_API;
    var url = URL_base + "/deptos_generos_patologias";

    var response = await http.post(url, body: {"tipo": "1"});

    var responseBody = json.decode(response.body);

    final List jsonData = responseBody['data'];
    _formDataList =
        jsonData.map((json) => DepartamentoModel.fromJson(json)).toList();

    _formDataDepartamentos = DepartamentoModel();

    isLoading = true;
  }
}
