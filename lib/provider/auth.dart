import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';
import '../utils/assests.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expire;
  String _uId;
  String error;
  http.Response res;
  String _email;
  Timer authTimer;
  String get email {
    if (_email != null) {
      return _email;
    }
    return 'null';
  }
  bool get isAuth {
    return token != null;
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
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': uId,
        'expireTime': _expire.toIso8601String(),
        'email': _email,
      });
      prefs.setString('userData', userData);
    } catch (e) {
      throw e;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expireTime']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    } else {
      _token = extractedUserData['token'];
      _uId = extractedUserData['userId'];
      _expire = expiryDate;
      _email = extractedUserData['email'];
      notifyListeners();
      _autoLogout();
      return true;
    }
  }

  Future<void> createAccount(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn(email, password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logout() async {
    _token = null;
    _uId = null;
    _expire = null;
    _email = null;
    if (authTimer != null) {
      authTimer.cancel();
      authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (authTimer != null) {
      authTimer.cancel();
    }
    var timeToLogout = _expire.difference(DateTime.now()).inSeconds;
    authTimer = Timer(Duration(seconds: timeToLogout), logout);

  }
}
