import 'package:ecommerce_app/utils/assests.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import './provider/cart.dart';
import './provider/order.dart';
import './provider/products.dart';
import './screens/product_details.dart';
import './screens/products_screen.dart';
import './screens/shopping_cart.dart';
import './screens/add_product.dart';
import './screens/order_screen.dart';
import './screens/manage_products.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var isLoading = false;
  Future getImage() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(Assets.image1);
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      return response;
    }
  }

  @override
  void didChangeDependencies() {
    setState(() {
      getImage();
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Order(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.deepOrange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
          ShoppingCart.routeName: (ctx) => ShoppingCart(),
          OrderScreen.routeName: (ctx) => OrderScreen(),
          AddProductScreen.routeName: (ctx) => AddProductScreen(),
          ManageProductScreen.routeName: (ctx) => ManageProductScreen(),
        },
        home: ProductScreen(),
      ),
    );
  }
}
