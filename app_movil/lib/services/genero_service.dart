import 'dart:convert';
import 'package:app_salud/models/genero_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../pages/env.dart';

class GeneroServices extends ChangeNotifier {
  GeneroModel _generoModel;
  var _formDataGenero;
  List<GeneroModel> _formDataList = [];
  bool _isLoading = false;

  List<GeneroModel> get formDataList => _formDataList;

  bool get existeDeptoModel => (this._generoModel != null) ? true : false;
  bool get isLoadingGenero => (this._isLoading != null) ? true : false;
  GeneroModel get formDataDepartamento => this._formDataGenero;

  set departamento(GeneroModel depto) {
    this._formDataGenero = depto;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> loadGeneros() async {
    String URL_base = Env.URL_API;
    var url = URL_base + "/deptos_generos_patologias";

    var response = await http.post(url, body: {"tipo": "2"});

    var responseBody = json.decode(response.body);

    final List jsonData = responseBody['data'];
    _formDataList = jsonData.map((json) => GeneroModel.fromJson(json)).toList();

    _formDataGenero = GeneroModel();

    isLoading = true;
  }
}
