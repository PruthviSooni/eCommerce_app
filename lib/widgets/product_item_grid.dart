import 'dart:io';

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
    return Container(
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
            leading: Text("₹${product.price}",
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
                      Navigator.of(context).pushNamed(ShoppingCart.routeName);
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
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                product.toggleFavorite();
              },
            ),
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                ProductDetailsScreen.routeName,
                arguments: product.id,
              );
            },
            child: Hero(
              tag: product.hashCode,
              child: product.imageUrl.startsWith('/storage/emulated')
                  ? Image.file(
                      File(product.imageUrl),
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      product.imageUrl,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
