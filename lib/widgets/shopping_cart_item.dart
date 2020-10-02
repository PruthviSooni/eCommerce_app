import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart';

class ShoppingCartItems extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  const ShoppingCartItems({
    Key key,
    this.id,
    this.productId,
    this.title,
    this.price,
    this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8, right: 8, top: 3, bottom: 3),
      width: MediaQuery.of(context).size.width * .40,
      child: Card(
        child: Dismissible(
            confirmDismiss: (direction) {
              return showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text("Are you Sure?"),
                  content:
                      Text("Do you want to remove the item from the cart!"),
                  actions: [
                    FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                      child: Text("Cancel"),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                      child: Text("Delete"),
                    )
                  ],
                ),
              );
            },
            dragStartBehavior: DragStartBehavior.start,
            key: ValueKey(id),
            direction: DismissDirection.up,
            background: Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(bottom: 10),
              color: Theme.of(context).errorColor,
              child: Icon(
                Icons.delete_forever_rounded,
                color: Colors.white,
              ),
            ),
            onDismissed: (dir) {
              Provider.of<Cart>(context, listen: false).removeItem(productId);
            },
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Theme.of(context).accentColor,
                    child: Text(
                      '₹${(price).round()}',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    title,
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Total: ₹${price * quantity}",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey.shade700,
                        child: IconButton(
                          icon: Icon(
                            Icons.add,
                            color: Colors.lightBlue,
                          ),
                          onPressed: () {
                            Provider.of<Cart>(context, listen: false)
                                .addQuantity(productId);
                          },
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text("$quantity x"),
                      SizedBox(
                        width: 8,
                      ),
                      quantity == 1
                          ? Container(
                              width: 40,
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.grey.shade700,
                              child: IconButton(
                                icon: Icon(
                                  Icons.remove,
                                  color: Colors.lightBlue,
                                ),
                                onPressed: () {
                                  Provider.of<Cart>(context, listen: false)
                                      .removeQuantity(productId);
                                },
                              ),
                            ),
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}
