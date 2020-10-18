import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:ecommerce_app/provider/auth.dart';
import 'package:ecommerce_app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/add_product.dart';
import '../screens/manage_products.dart';
import '../screens/order_screen.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  var brightness = false;

  @override
  Widget build(BuildContext context) {
    final emailName = Provider.of<Auth>(context, listen: false).email;
    var i = emailName.indexOf("@");
    var name = emailName.substring(0, i);
    var mediaQuery = MediaQuery.of(context).size;
    return Drawer(
      elevation: 200,
      child: Column(
        children: [
          Container(
            width: mediaQuery.width,
            height: mediaQuery.height / 4,
            color: Theme.of(context).accentColor.withOpacity(.9),
            child: Stack(children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade800,
                  child: Icon(
                    Icons.person,
                    size: 50,
                  ),
                ),
              ),
              Divider(
                color: Colors.transparent,
              ),
              Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(bottom: 20),
                child: Text(
                  "Hello ${name[0].toUpperCase()}${name.substring(1)}",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: ThemeSwitcher(
                    clipper: ThemeSwitcherBoxClipper(),
                    builder: (context) {
                      return IconButton(
                        icon: Icon(Icons.wb_incandescent_rounded),
                        onPressed: () {
                          ThemeSwitcher.of(context).changeTheme(
                            theme: ThemeProvider.of(context).brightness ==
                                    Brightness.light
                                ? darkTheme
                                : lightTheme,
                          );
                        },
                      );
                    },
                  )),
            ]),
          ),
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
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Log Out"),
            onTap: () => Provider.of<Auth>(context, listen: false).logout(),
          ),
        ],
      ),
    );
  }
}
