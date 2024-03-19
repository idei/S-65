import 'dart:async';
import 'package:http/http.dart' as http;
import 'secure_storage.dart';

class AuthInterceptor extends http.BaseClient {
  final http.Client _client = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // final token = await SecureStorage.getToken();

    // if (token != null) {
    //   request.headers['Authorization'] = 'Bearer $token';
    // }

    request.headers['Content-Type'] = 'application/json';
    request.headers['Accept'] = 'application/json';

    return _client.send(request);
  }
}
