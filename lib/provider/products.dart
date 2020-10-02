import 'package:flutter/material.dart';

import '../utils/assests.dart';
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: "1",
      title: "DSLR",
      price: 39800,
      imageUrl: Assets.image1,
      description: Assets.ipsum,
    ),
    Product(
      id: "2",
      title: "Amazon Alexa",
      price: 2890,
      imageUrl: Assets.image2,
      description: Assets.ipsum,
    ),
    Product(
      id: "3",
      title: "Face Wash",
      price: 100,
      imageUrl: Assets.image3,
      description: Assets.ipsum,
    ),
    Product(
      id: "4",
      title: "Casual Shoes",
      price: 2579,
      imageUrl: Assets.image4,
      description: Assets.ipsum,
    ),
    Product(
      id: "5",
      title: "Desk",
      price: 15499,
      imageUrl: Assets.image5,
      description: Assets.ipsum,
    ),
    Product(
      id: "6",
      title: "Table",
      price: 21450,
      imageUrl: Assets.image6,
      description: Assets.ipsum,
    ),
    Product(
      id: "7",
      title: "Air Pods 2",
      price: 24999,
      imageUrl: Assets.image7,
      description: Assets.ipsum,
    ),
    Product(
      id: "8",
      title: "Nike Shoes",
      price: 2499,
      imageUrl: Assets.image8,
      description: Assets.ipsum,
    ),
    Product(
      id: "9",
      title: "Product Red ",
      price: 49999,
      imageUrl: Assets.image9,
      description: Assets.ipsum,
    ),
    Product(
      id: "10",
      title: "Power Bank",
      price: 2000,
      imageUrl: Assets.image10,
      description: Assets.ipsum,
    ),
    Product(
      id: "11",
      title: "Snickers Shoes",
      price: 3500,
      imageUrl: Assets.image11,
      description: Assets.ipsum,
    ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  void addProduct(Product product) {
    var newProduct = Product(
      id: DateTime.now().toString(),
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
    );
    _items.add(newProduct);
    notifyListeners();
  }

  void updateProduct(String id, Product product) {
    // var _items.indexWhere((element) => element.id == id);
  }
}
