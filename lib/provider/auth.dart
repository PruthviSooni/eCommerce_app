import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../utils/assests.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expire;
  String _uId;
  String error;
  var res;

  Future<void> createAccount(String email, String password) async {
    var url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${Assets.key}';
    res = await http.post(url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }));
    var data = jsonDecode(res.body);
    if (res.statusCode == 400) {
      // print(data['error']['message']);
      var err = data['error']['message'];
      err = error;
    } else {
      print('Account Added');
    }
  }
}
