import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final String description;
  bool isFavorite;
  final String token;

  Product({
    this.id,
    this.title,
    this.price,
    this.imageUrl,
    this.description,
    this.isFavorite = false,
    this.token,
  });

  void _setFavorite(status) {
    isFavorite = status;
    notifyListeners();
  }
  Future<void> toggleFavorite(String uId) async {
    var _url =
        "https://ecommerceapp-9e37c.firebaseio.com/userFavorites/$uId/$id.json?auth=$token";
    final oldState = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final res = await http.put(_url, body: json.encode(isFavorite));
      if (res.statusCode >= 400) {
        _setFavorite(oldState);
      }
      // var status = json.decode(res.body)['isFavorite'];
      // return status;
    } catch (_) {
      _setFavorite(oldState);
    }
  }
}
