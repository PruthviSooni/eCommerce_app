import 'package:flutter/material.dart';

import 'cart_items.dart';

class OrderItems {
  final String id;
  final String total;
  final List<CartItems> products;
  final DateTime time;

  OrderItems({this.id, this.total, this.products, this.time});
}

class Order with ChangeNotifier {
  List<OrderItems> _orders = [];

  List<OrderItems> get order => [..._orders];

  void addOrder(List<CartItems> cartItems, String total) {
    _orders.insert(
      0,
      OrderItems(
        id: DateTime.now().toString(),
        products: cartItems,
        time: DateTime.now(),
        total: total,
      ),
    );
  }

  void clearOrder() {
    _orders.clear();
    notifyListeners();
  }
}
