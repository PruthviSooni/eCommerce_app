import 'package:flutter/material.dart';

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
  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
