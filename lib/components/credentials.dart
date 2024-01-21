import 'package:flutter/foundation.dart';

class Credentials with ChangeNotifier {
  Credentials({
    int id = 0,
    String email = '',
    String password = '',
  }) {
    _id = id;
    _email = email;
    _password = password;
  }

  int _id = 0;
  String _email = '';
  String _password = '';

  String get email => _email;
  String get password => _password;
  int get id => _id;

  set id(int id) {
    _id = id;
    notifyListeners();
  }

  set email(String email) {
    _email = email;
    notifyListeners();
  }

  set password(String password) {
    _password = password;
    notifyListeners();
  }

  void setCredentials(int id, String email, String password, {bool notify = false}) {
    _id = id;
    _email = email;
    _password = password;
    if (notify) notifyListeners();
  }

  void clearCredentials({bool notify = false}) {
    _id = 0;
    _email = '';
    _password = '';
    if (notify) notifyListeners();
  }
}
