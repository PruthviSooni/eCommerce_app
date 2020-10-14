import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import '../utils/assests.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expire;
  String _uId;
  String error;
  http.Response res;
  String _email;

  bool get isAuth => _token != null;

  String get email {
    if (_email != null) {
      return _email;
    }
    return 'null';
  }

  String get token {
    if (_expire != null && _expire.isAfter(DateTime.now()) && _token != null) {
      return _token;
    }
    return null;
  }

  String get uId {
    return _uId;
  }

  Future<void> _authenticate(email, password, urlSegment) async {
    try {
      var url =
          'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=${Assets.key}';
      res = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      var data = jsonDecode(res.body);
      print(data);
      if (data['error'] != null) {
        throw HttpException(data['error']['message']);
      }
      _email = data['email'];
      _token = data['idToken'];
      _uId = data['localId'];
      _expire = DateTime.now().add(
        Duration(
          seconds: int.parse(data['expiresIn']),
        ),
      );
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> createAccount(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn(email, password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
