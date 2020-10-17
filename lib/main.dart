import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:ecommerce_app/screens/splash_screen.dart';
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
import './utils/constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isPlatformDark =
        WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
    final initTheme = isPlatformDark ? darkTheme : lightTheme;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        // ignore: missing_required_param
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousProducts) => Products(
            auth.token,
            auth.uId,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        // ignore: missing_required_param
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (_, auth, oldOrders) => Orders(
            auth.token,
            auth.uId,
            oldOrders == null ? [] : oldOrders.order,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (__, auth, _) => ThemeProvider(
          initTheme: initTheme,
          duration: Duration(milliseconds: 800),
          child: Builder(
            builder: (context) => MaterialApp(
              home: auth.isAuth
                  ? ProductScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (context, snapshot) {
                        return snapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen();
                      }),
              theme: ThemeProvider.of(context),
              routes: {
                ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
                ShoppingCart.routeName: (ctx) => ShoppingCart(),
                OrderScreen.routeName: (ctx) => OrderScreen(),
                AddProductScreen.routeName: (ctx) => AddProductScreen(),
                ManageProductScreen.routeName: (ctx) => ManageProductScreen(),
                AuthScreen.routeName: (ctx) => AuthScreen(),
              },
            ),
          ),
        ),
      ),
    );
  }
}
