import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];
  var _url = "https://ecommerceapp-9e37c.firebaseio.com/products.json";

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchProducts() async {
    try {
      final res = await http.get(_url);
      final data = json.decode(res.body) as Map<String, dynamic>;
      final List<Product> loadedData = [];
      data.forEach((productId, productData) {
        loadedData.add(Product(
          id: productId,
          title: productData['title'] as String,
          description: productData['description'],
          price: productData['price'],
          isFavorite: productData['isFavorite'],
          imageUrl: productData['imgUrl'],
        ));
        _items = loadedData;
        notifyListeners();
      });
    } on HttpException catch (e) {
      print(e.message);
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final res = await http.post(
        _url,
        body: json.encode({
          "title": product.title,
          "description": product.description,
          "price": product.price,
          "imgUrl": product.imageUrl,
          "isFavorite": product.isFavorite,
        }),
      );
      print('Data added');
      var newProduct = Product(
        id: json.decode(res.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    var index = _items.indexWhere((element) => element.id == id);
    if (index >= 0) {
      var _url = "https://ecommerceapp-9e37c.firebaseio.com/products/$id.json";
      await http.patch(_url,
          body: jsonEncode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imgUrl': newProduct.imageUrl,
          }));
      _items[index] = newProduct;
      notifyListeners();
    } else {
      print('product is different');
    }
  }

  void removeProduct(String id) {
    _items.removeWhere((product) => product.id == id);
    notifyListeners();
  }
}
