import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
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
    with TickerProviderStateMixin {
  AnimationController _controller, _controller_2;
  Animation<double> _animation;
  var result;
  bool showFavoritesOnly = false;
  bool isGridView = false;
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
      reverseDuration: Duration(milliseconds: 400),
    );
    _controller_2 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
      reverseDuration: Duration(milliseconds: 400),
    );
    _animation = CurvedAnimation(curve: Curves.easeIn, parent: _controller_2);
    _controller_2.forward();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchProducts().then(
            (value) => _isLoading = false,
          );
      setState(() {
        _isLoading = true;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Products>(context);
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
          child: Builder(
            builder: (BuildContext context) {
              return _isLoading
                  ? LinearProgressIndicator()
                  : isGridView
                      ? FadeTransition(
                          opacity: _animation,
                          child: AnimationLimiter(
                            child: ListView.builder(
                              itemCount: productsData.length,
                              itemBuilder: (ctx, i) =>
                                  AnimationConfiguration.staggeredList(
                                position: i,
                                child: SlideAnimation(
                                  duration: Duration(milliseconds: 700),
                                  child: FadeInAnimation(
                                    child: ChangeNotifierProvider.value(
                                      value: productsData[i],
                                      child: ProductItemList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : AnimationLimiter(
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemBuilder: (ctx, i) {
                              return AnimationConfiguration.staggeredGrid(
                                columnCount: 2,
                                position: i,
                                child: ScaleAnimation(
                                  duration: Duration(milliseconds: 400),
                                  child: ChangeNotifierProvider.value(
                                    value: productsData[i],
                                    child: ProductItemGrid(),
                                  ),
                                ),
                              );
                            },
                            itemCount: productsData.length,
                          ),
                        );
            },
          ),
        ));
  }

  void showSnackBar(String mag) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(mag),
      ),
    );
  }
}
