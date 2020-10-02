import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/order.dart';

class OrderScreen extends StatelessWidget {
  static final String routeName = 'OrderScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Processing Order"),
      ),
      body: Consumer<Order>(
        builder: (ctx, orderData, _) {
          return orderData.order.isEmpty
              ? Center(
                  child: Text("No Order Found"),
                )
              : ListView.builder(
                  itemCount: orderData.order.length,
                  itemBuilder: (ctx, i) {
                    var data = orderData.order[i];
                    return ExpansionTile(
                      title: Text("₹${data.total}"),
                      subtitle: Text(
                        formatDate(data.time, [
                          'Ordered At ',
                          hh,
                          ":",
                          mm,
                          " ",
                          am,
                          " ",
                          dd,
                          "/",
                          mm,
                          "/",
                          yy
                        ]),
                      ),
                      children: [
                        ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.all(10),
                          children: data.products
                              .map((product) => Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            product.title,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "${product.quantity}x ₹${product.price}",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey.shade400),
                                          )
                                        ],
                                      ),
                                    ],
                                  ))
                              .toList(),
                        ),
                        Container(
                          margin:
                              EdgeInsets.only(right: 10, bottom: 10, left: 10),
                          alignment: Alignment.bottomRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total: ",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "₹${data.total}",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  });
        },
      ),
    );
  }
}
