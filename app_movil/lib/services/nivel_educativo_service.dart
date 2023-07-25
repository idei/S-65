import 'dart:convert';
import 'package:app_salud/models/nivel_educativo_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../pages/env.dart';

class NivelEducativoService extends ChangeNotifier {
  NivelEducativoModel _educativoModel;
  var _formDataNivelEducativo;
  List<NivelEducativoModel> _formDataList = [];
  bool _isLoading = false;

  List<NivelEducativoModel> get formDataList => _formDataList;

  bool get existeEducativoModel =>
      (this._educativoModel != null) ? true : false;
  bool get isLoadingNivelEducativo => (this._isLoading != null) ? true : false;
  NivelEducativoModel get formDataNivelEducativo =>
      this._formDataNivelEducativo;

  set nivelEducativo(NivelEducativoModel nivel) {
    this._formDataNivelEducativo = nivel;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> loadNivelEducativo() async {
    String URL_base = Env.URL_API;
    var url = URL_base + "/deptos_generos_patologias";

    var response = await http.post(url, body: {"tipo": "3"});

    var responseBody = json.decode(response.body);

    final List jsonData = responseBody['data'];
    _formDataList =
        jsonData.map((json) => NivelEducativoModel.fromJson(json)).toList();

    _formDataNivelEducativo = NivelEducativoModel();

    isLoading = true;
  }
}
