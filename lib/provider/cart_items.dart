import 'package:flutter/foundation.dart';

class CartItems {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItems({
    @required this.id,
    this.title,
    this.price,
    this.quantity,
  });
}
