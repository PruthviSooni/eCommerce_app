import 'package:ecommerce_app/utils/assests.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/shopping_cart.dart';
import '../provider/cart.dart';
import '../provider/product.dart';
import '../screens/product_details.dart';

class ProductItemGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var product = Provider.of<Product>(context);
    var cart = Provider.of<Cart>(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
              reverseTransitionDuration: Duration(milliseconds: 500),
              transitionDuration: Duration(milliseconds: 500),
              maintainState: true,
              pageBuilder: (_, __, ___) => ProductDetailsScreen(
                    id: product.id,
                    tag: product.hashCode,
                    title: product.title,
                  )),
        );
      },
      child: Hero(
        tag: product.hashCode,
        child: Material(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: GridTile(
                header: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.black38,
                  ),
                  child: Text(
                    "${product.title}",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                footer: GridTileBar(
                  backgroundColor: Colors.black54,
                  leading: Text("₹${Assets.price.format(product.price)}",
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(color: Colors.white)),
                  trailing: IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {
                      cart.addItem(product.id, product.title, product.price);
                      Scaffold.of(context).showSnackBar(SnackBar(
                        action: SnackBarAction(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(ShoppingCart.routeName);
                          },
                          label: "Cart",
                        ),
                        content: Text('Added To Card'),
                        duration: Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ));
                    },
                  ),
                  title: IconButton(
                    icon: Icon(product.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border),
                    onPressed: () {
                      product.toggleFavorite().then((value) => print('toggle'));
                    },
                  ),
                ),
                child: FadeInImage(
                  image: NetworkImage(product.imageUrl),
                  placeholder: AssetImage('images/placeholder.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
