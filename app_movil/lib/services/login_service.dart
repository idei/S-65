import 'dart:convert';

import 'package:app_salud/models/usuario_model.dart';
import 'package:app_salud/services/secure_storage.dart';
import 'package:app_salud/models/error_response.dart';
import 'package:app_salud/services/usuario_services.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'auth_interceptor.dart';
import 'device_utils.dart';
import '../pages/env.dart';

class LoginService {
  static final _authClient = AuthInterceptor();

  static Future<ErrorResponse> login(String email, String password) async {
    final deviceName = await DeviceUtils.getDeviceName();
    var estado_users;

    String URL_base = Env.URL_API;

    final response = await http.post(Uri.parse(URL_base + "/login"),
        body: json.encode(
          {'email': email, 'password': password, 'device_name': deviceName},
        ));
    //var responseDecode = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final userData = Map<String, String>.from(json.decode(response.body));

      Map userMap = userData;
      var usuarioModel = UsuarioModel.fromJsonLogin(userMap);

      final usuarioService = Provider.of<UsuarioServices>(null, listen: false);
      usuarioService.usuario = usuarioModel;

      estado_users = userMap['data']['paciente']['estado_users'];

      return null;
    }

    final loginErrorResponse = ErrorResponse.fromJson(response.body);
    if (loginErrorResponse != null) {
      return loginErrorResponse;
    }

    return ErrorResponse(
        "Ocurrio un problema al iniciar sesion", <String, List<String>>{});
  }

  static Future<bool> logout() async {
    String URL_base = Env.URL_API;

    final response = await _authClient.delete(Uri.parse(URL_base + '/logout'));

    return response.statusCode == 200;
  }
}
