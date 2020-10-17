import 'dart:convert';
import 'dart:io';

import 'package:ecommerce_app/models/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'product.dart';

class Products with ChangeNotifier {
  final String token;
  final String uId;
  List<Product> _items = [];
  var _isDisposed = false;

  List<Product> get items {
    return [..._items];
  }

  Products(this.token, this.uId, this._items);

  List<Product> get favItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchProducts() async {
    var _url =
        "https://ecommerceapp-9e37c.firebaseio.com/products.json?auth=$token";
    final _url_2 =
        "https://ecommerceapp-9e37c.firebaseio.com/userFavorites/$uId.json?auth=$token";
    final res = await http.get(_url);
    final data = json.decode(res.body) as Map<String, dynamic>;
    final favRes = await http.get(_url_2);
    final favData = json.decode(favRes.body);
    if (data == null) {
      throw HttpException(data['error']);
    }
    List<Product> loadedData = [];
    data.forEach((productId, productData) => loadedData.add(Product(
          id: productId,
          token: token,
          title: productData['title'],
          description: productData['description'],
          price: productData['price'],
          isFavorite: favData == null ? false : favData[productId] ?? false,
          imageUrl: productData['imgUrl'],
        )));
    _items = loadedData;
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> addProduct(Product product) async {
    final _url =
        "https://ecommerceapp-9e37c.firebaseio.com/products.json?auth=$token";
    try {
      final res = await http.post(
        _url,
        body: json.encode({
          "title": product.title,
          "description": product.description,
          "price": product.price,
          "imgUrl": product.imageUrl,
        }),
      );
      print('Data added');
      var newProduct = Product(
        id: json.decode(res.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        // isFavorite: product.isFavorite,
      );
      _items.add(newProduct);
      notifyListeners();
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    var index = _items.indexWhere((element) => element.id == id);
    if (index >= 0) {
      var _url =
          "https://ecommerceapp-9e37c.firebaseio.com/products/$id.json?auth=$token";
      await http.patch(_url,
          body: jsonEncode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imgUrl': newProduct.imageUrl,
            'isFavorite': newProduct.isFavorite,
          }));
      _items[index] = newProduct;

      notifyListeners();
    } else {
      print('product is different');
    }
  }

  Future<void> removeProduct(String id) async {
    var _url =
        "https://ecommerceapp-9e37c.firebaseio.com/products/$id.json?auth=$token";
    final existingProductIndex =
        _items.indexWhere((product) => product.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final res = await http.delete(_url);
    if (res.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Failed to Delete product");
    }
    existingProduct = null;
  }
}
