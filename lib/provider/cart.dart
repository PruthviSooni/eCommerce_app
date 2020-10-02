import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../provider/cart_items.dart';

class Cart with ChangeNotifier {
  Map<String, CartItems> _items = {};

  Map<String, CartItems> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var _total = 0.0;
    _items.forEach((key, value) {
      _total += value.price * value.quantity;
    });
    return _total;
  }

  void addItem(String id, String title, double price) {
    if (_items.containsKey(id)) {
      _items.update(
        id,
        (updateCart) => CartItems(
          id: updateCart.id,
          title: updateCart.title,
          price: updateCart.price,
          quantity: updateCart.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        id,
        () => CartItems(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
      notifyListeners();
    }
  }

  void addQuantity(String id) {
    _items.update(id, (cartItem) {
      return CartItems(
        id: cartItem.id,
        title: cartItem.title,
        price: cartItem.price,
        quantity: cartItem.quantity + 1,
      );
    });
    notifyListeners();
  }

  void removeQuantity(String id) {
    _items.update(id, (cartItem) {
      return CartItems(
        id: cartItem.id,
        title: cartItem.title,
        price: cartItem.price,
        quantity: cartItem.quantity - 1,
      );
    });
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
