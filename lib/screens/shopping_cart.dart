import 'package:ecommerce_app/screens/order_screen.dart';
import 'package:ecommerce_app/utils/assests.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import "../provider/cart.dart";
import '../provider/order.dart';
import '../widgets/shopping_cart_item.dart';

class ShoppingCart extends StatelessWidget {
  static final String routeName = 'ShoppingCart';

  void showSnackBar(
    GlobalKey<ScaffoldState> key,
    BuildContext ctx,
    String msg,
    bool isEmpty,
  ) {
    key.currentState?.showSnackBar(SnackBar(
      duration: Duration(seconds: 3),
      content: Text(msg),
      action: isEmpty == false
          ? SnackBarAction(
              label: "Show Order",
              onPressed: () {
                Navigator.of(ctx).pushNamed(OrderScreen.routeName);
              })
          : SnackBarAction(
              onPressed: () {
                Navigator.pop(ctx);
              },
              label: "Add Product",
            ),
    ));
  }

  final _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context);
    return Scaffold(
      key: _key,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: cart.itemCount == 0
          ? Container()
          : Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  if (cart.itemCount != 0) {
                    Provider.of<Order>(context, listen: false).addOrder(
                        cart.items.values.toList(),
                        cart.totalAmount.toString());
                    cart.clearCart();
                    showSnackBar(_key, context, "Order Completed", false);
                  } else {
                    showSnackBar(
                        _key, context, "Please Add Product In Cart!", true);
                  }
                },
                child: Text(
                  "Order Now",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: cart.itemCount == 0
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.remove_shopping_cart_outlined,
                    size: 80,
                    color: Theme.of(context).accentColor,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FlatButton(
                      onPressed: () => Navigator.pop(context),
                      color: Colors.grey.shade800,
                      child: Text(
                        "Goto To Home",
                        style: TextStyle(fontSize: 18),
                      ))
                ],
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 30),
                  height: MediaQuery.of(context).size.height * .35,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: cart.itemCount,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, i) {
                        var data = cart.items.values.toList()[i];
                        return ShoppingCartItems(
                          productId: cart.items.keys.toList()[i],
                          id: data.id,
                          title: data.title,
                          price: data.price,
                          quantity: data.quantity,
                        );
                      }),
                ),
                Card(
                  elevation: 3,
                  margin: EdgeInsets.only(left: 10, right: 10, bottom: 100),
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: cart.itemCount,
                                    itemBuilder: (ctx, i) {
                                      var cartItems =
                                          cart.items.values.toList()[i];
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            cartItems.title,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "${cartItems.quantity}x ₹${Assets.price.format(cartItems.price)}",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey.shade400),
                                          )
                                        ],
                                      );
                                    }),
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 2,
                            indent: 0,
                            endIndent: 0,
                            color:
                                Theme.of(context).accentColor.withOpacity(.5),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            alignment: Alignment.bottomRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total: ",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "₹${cart.totalAmount}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
