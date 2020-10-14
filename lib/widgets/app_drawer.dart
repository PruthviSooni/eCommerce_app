import 'package:ecommerce_app/provider/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/add_product.dart';
import '../screens/manage_products.dart';
import '../screens/order_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final emailName = Provider.of<Auth>(context, listen: false).email;
    var i = emailName.indexOf("@");
    var name = emailName.substring(0, i).toUpperCase();
    var mediaQuery = MediaQuery.of(context).size;
    return Drawer(
      elevation: 200,
      child: Column(
        children: [
          Container(
            width: mediaQuery.width,
            height: mediaQuery.height / 4,
            color: Theme.of(context).accentColor.withOpacity(.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade800,
                  child: Icon(
                    Icons.person,
                    size: 50,
                  ),
                ),
                Divider(
                  color: Colors.transparent,
                ),
                Text(
                  "$name",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shopping_bag),
            title: Text("Shopping"),
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text("Orders"),
            onTap: () => Navigator.pushNamed(context, OrderScreen.routeName),
          ),
          ListTile(
            leading: Icon(Icons.add_box),
            title: Text("Add Product"),
            onTap: () =>
                Navigator.pushNamed(context, AddProductScreen.routeName),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Manage Products"),
            onTap: () =>
                Navigator.pushNamed(context, ManageProductScreen.routeName),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
