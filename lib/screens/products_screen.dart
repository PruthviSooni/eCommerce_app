import 'package:ecommerce_app/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart';
import '../provider/products.dart';
import '../screens/shopping_cart.dart';
import '../widgets/badge.dart';
import '../widgets/product_item_grid.dart';
import '../widgets/product_item_list.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  bool showFavoritesOnly = false;
  bool isGridView = false;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
      reverseDuration: Duration(milliseconds: 500),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Products>(context);
    // final cart = Provider.of<Cart>(context);
    final productsData =
        showFavoritesOnly == true ? product.favItems : product.items;
    return Scaffold(
      appBar: AppBar(
        title: Text("E Commerce Store"),
        actions: [
          Container(
            child: IconButton(
              icon: AnimatedIcon(
                icon: AnimatedIcons.list_view,
                progress: _controller,
              ),
              onPressed: () {
                setState(() {
                  isGridView ? _controller.reverse() : _controller.forward();
                  isGridView = !isGridView;
                });
              },
            ),
          ),
          Consumer<Cart>(
            builder: (_, cart, child) => Badge(
              child: child,
              value: cart.itemCount.toString(),
              color: Colors.black54,
            ),
            child: IconButton(
              highlightColor: Colors.white54,
              icon: Icon(Icons.shopping_cart_outlined),
              onPressed: () =>
                  Navigator.pushNamed(context, ShoppingCart.routeName),
            ),
          ),
          PopupMenuButton(
            child: Icon(Icons.more_vert),
            onSelected: (FilterOptions selected) {
              setState(() {
                if (selected == FilterOptions.Favorites) {
                  if (product.favItems.isEmpty) {
                    showSnackBar("No Favorites available");
                  }
                  showFavoritesOnly = true;
                } else {
                  showFavoritesOnly = false;
                }
              });
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                child: Text("Show Favorites"),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text("Show All"),
                value: FilterOptions.All,
              ),
            ],
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Container(
        padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
        child: isGridView
            ? ListView.builder(
                itemCount: productsData.length,
                itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                  value: productsData[i],
                  child: ProductItemList(),
                ),
              )
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                  value: productsData[i],
                  child: ProductItemGrid(),
                ),
                itemCount: productsData.length,
              ),
      ),
    );
  }

  void showSnackBar(String mag) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(mag),
      ),
    );
  }
}
