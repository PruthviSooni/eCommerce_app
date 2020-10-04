import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart';
import '../provider/product.dart';
import '../screens/product_details.dart';

class ProductItemList extends StatelessWidget {
  final bool showFavorites;

  const ProductItemList({Key key, this.showFavorites}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var product = Provider.of<Product>(context);
    var cart = Provider.of<Cart>(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Hero(
              tag: product.hashCode,
              child: Image.network(
                product.imageUrl,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.image_not_supported,
                  color: Colors.red,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          //title
          title: Text(
            "${product.title}",
          ),
          subtitle: Text(
            "₹${product.price}",
          ),
          trailing: Container(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    cart.addItem(product.id, product.title, product.price);
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Added To Card'),
                      duration: Duration(seconds: 3),
                    ));
                  },
                ),
                IconButton(
                  icon: Icon(product.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border),
                  onPressed: () {
                    product.toggleFavorite();
                  },
                ),
              ],
            ),
          ),

          onTap: () {
            Navigator.pushNamed(
              context,
              ProductDetailsScreen.routeName,
              arguments: product.id,
            );
          },
        ),
      ),
    );
  }
}
