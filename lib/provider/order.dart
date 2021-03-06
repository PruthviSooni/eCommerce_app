import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'cart_items.dart';

class OrderItems {
  final String id;
  final String total;
  final List<CartItems> products;
  final DateTime time;

  OrderItems({this.id, this.total, this.products, this.time});
}

class Orders with ChangeNotifier {
  List<OrderItems> _orders = [];
  final String token;
  final String userId;

  List<OrderItems> get order => [..._orders];

  Orders(this.token, this.userId, this._orders);

  Future<void> getOrders() async {
    var _url =
        "https://ecommerceapp-9e37c.firebaseio.com/orders/$userId.json?auth=$token";
    // print('order token ==> $token');
    final res = await http.get(_url);
    List<OrderItems> loadedData = [];
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (data == null) {
      return;
    }
    data.forEach((orderId, orderData) {
      loadedData.add(OrderItems(
        id: orderId,
        time: DateTime.parse(orderData['time']),
        total: orderData['total'],
        products: (orderData['products'] as List<dynamic>)
            .map((cartItem) => CartItems(
                  id: cartItem['id'],
                  price: cartItem['price'],
                  quantity: cartItem['quantity'],
                  title: cartItem['title'],
                ))
            .toList(),
      ));
    });
    _orders = loadedData.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItems> cartItems, String total) async {
    var _url =
        "https://ecommerceapp-9e37c.firebaseio.com/orders/$userId.json?auth=$token";

    try {
      var timeStamp = DateTime.now();
      final res = await http.post(
        _url,
        body: json.encode({
          'products': cartItems
              .map((ci) =>
          {
            'id': ci.id,
            'title': ci.title,
                    'price': ci.price,
                    'quantity': ci.quantity,
                  })
              .toList(),
          'total': total,
          'time': timeStamp.toIso8601String(),
        }),
      );
      _orders.insert(
        0,
        OrderItems(
          id: json.decode(res.body)['name'],
          products: cartItems,
          time: timeStamp,
          total: total,
        ),
      );
    } on Exception catch (e) {
      print(e);
    }
  }

  void clearOrder() {
    _orders.clear();
    notifyListeners();
  }
}
