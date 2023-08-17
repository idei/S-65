import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void login() {
    _isLoggedIn = true;
    print("Logueado");
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    print("logouteado");

    notifyListeners();
  }
}
