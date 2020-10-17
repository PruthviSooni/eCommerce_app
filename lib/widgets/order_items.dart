import 'package:date_format/date_format.dart';
import 'package:ecommerce_app/utils/assests.dart';
import 'package:flutter/material.dart';

import '../provider/order.dart' as orders;

class OrderItems extends StatelessWidget {
  const OrderItems({
    Key key,
    @required this.data,
  }) : super(key: key);

  final orders.OrderItems data;

  dynamic formatPrice(dynamic price) {
    if (price is String) {
      return Assets.price.format(double.parse(price));
    } else {
      return Assets.price.format(price);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text("₹${formatPrice(data.total)}"),
      subtitle: Text(
        formatDate(data.time,
            ['Ordered At ', hh, ":", mm, " ", am, " ", dd, "/", mm, "/", yy]),
      ),
      children: [
        ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(10),
          children: data.products
              .map((product) => Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product.title ?? "",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${product.quantity}x ₹${formatPrice(
                                product.price)}",
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey.shade400),
                          )
                        ],
                      ),
                    ],
                  ))
              .toList(),
        ),
        Container(
          margin: EdgeInsets.only(right: 10, bottom: 10, left: 10),
          alignment: Alignment.bottomRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total: ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "₹${formatPrice(data.total)}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        )
      ],
    );
  }
}
