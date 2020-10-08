import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final String description;
  bool isFavorite;

  Product({
    this.id,
    this.title,
    this.price,
    this.imageUrl,
    this.description,
    this.isFavorite = false,
  });
  void _setFavorite(status) {
    isFavorite = status;
    notifyListeners();
  }

  Future<void> toggleFavorite() async {
    var _url = "https://ecommerceapp-9e37c.firebaseio.com/products/$id.json";
    final oldState = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final res =
          await http.patch(_url, body: json.encode({'isFavorite': isFavorite}));
      if (res.statusCode >= 400) {
        _setFavorite(oldState);
      }
      var status = json.decode(res.body)['isFavorite'];
      return status;
    } catch (_) {
      _setFavorite(oldState);
    }
  }
}
