import 'package:ecommerce_app/utils/assests.dart';
import 'package:ecommerce_app/widgets/order_items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/order.dart' as orders;

dynamic price(dynamic price) {
  return Assets.price.format(double.parse(price));
}

class OrderScreen extends StatelessWidget {
  static final String routeName = 'OrderScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Processing Order"),
      ),
      body: FutureBuilder(
          future: Provider.of<orders.Order>(context, listen: false).getOrders(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                break;
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
                break;
              case ConnectionState.active:
                break;
              case ConnectionState.done:
                return Consumer<orders.Order>(
                  builder: (ctx, orderData, _) {
                    return ListView.builder(
                        itemCount: orderData.order.length,
                        itemBuilder: (ctx, i) {
                          final data = orderData.order[i];
                          return OrderItems(
                              data: orders.OrderItems(
                            id: data.id,
                            products: data.products,
                            time: data.time,
                            total: data.total,
                          ));
                        });
                  },
                );
                break;
            }
            return Container();
          }),
    );
  }
}
