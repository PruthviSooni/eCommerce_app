import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './provider/auth.dart';
import './provider/cart.dart';
import './provider/order.dart';
import './provider/products.dart';
import './screens/add_product.dart';
import './screens/auth_screen.dart';
import './screens/manage_products.dart';
import './screens/order_screen.dart';
import './screens/product_details.dart';
import './screens/products_screen.dart';
import './screens/shopping_cart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(
          create: (_) => Auth(),
        ),
        // ignore: missing_required_param
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousProducts) => Products(
            auth.token,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        // ignore: missing_required_param
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (_, auth, oldOrders) => Orders(
            auth.token,
            oldOrders == null ? [] : oldOrders.order,
          ),
        ),
      ],
      child: Consumer<Auth>(
          builder: (__, auth, _) => MaterialApp(
                home: auth.isAuth ? ProductScreen() : AuthScreen(),
                theme: ThemeData(
                  brightness: Brightness.dark,
                  scaffoldBackgroundColor: Colors.grey.shade900,
                  primarySwatch: Colors.deepOrange,
                  accentColor: Colors.deepOrange,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
                // initialRoute: AuthScreen.routeName,
                routes: {
                  ProductDetailsScreen.routeName: (ctx) =>
                      ProductDetailsScreen(),
                  ShoppingCart.routeName: (ctx) => ShoppingCart(),
                  OrderScreen.routeName: (ctx) => OrderScreen(),
                  AddProductScreen.routeName: (ctx) => AddProductScreen(),
                  ManageProductScreen.routeName: (ctx) => ManageProductScreen(),
                  AuthScreen.routeName: (ctx) => AuthScreen(),
                },
              )),
    );
  }
}
