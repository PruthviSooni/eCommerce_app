import 'package:ecommerce_app/provider/auth.dart';
import 'package:ecommerce_app/screens/shopping_cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart';
import '../provider/products.dart';
import '../utils/assests.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int tag;
  final String title;
  final String id;
  static final String routeName = "ProductDetailsScreen";

  const ProductDetailsScreen({
    Key key,
    this.title,
    this.tag,
    this.id,
  }) : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  var isFavorite;
  final price = new NumberFormat("#,##0.00", "en_US");
  var _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final loadedProduct = Provider.of<Products>(
      context,
    ).findById(widget.id);
    final auth = Provider.of<Auth>(context, listen: false);
    var addedToCart = Provider.of<Cart>(context);
    isFavorite = loadedProduct.isFavorite;
    return Hero(
      tag: loadedProduct.hashCode,
      child: Material(
        borderOnForeground: true,
        color: Colors.grey.shade800,
        child: Scaffold(
          key: _key,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(loadedProduct.title),
          ),
          floatingActionButton: Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            width: MediaQuery.of(context).size.width,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onPressed: () {
                addedToCart.addItem(
                  loadedProduct.id,
                  loadedProduct.title,
                  loadedProduct.price,
                );
                _key.currentState.showSnackBar(
                  SnackBar(
                    content: Text('${loadedProduct.title} Added To Cart'),
                    action: SnackBarAction(
                      label: 'Go To Cart',
                      onPressed: () {
                        Navigator.pushNamed(context, ShoppingCart.routeName);
                      },
                    ),
                  ),
                );
              },
              child: Text(
                "Add To Cart",
                style: TextStyle(fontSize: 18),
              ),
              color: Theme.of(context).accentColor,
            ),
          ),
          floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
          floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width / 2,
                  decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(18)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      loadedProduct.imageUrl,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${price.format(loadedProduct.price)}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              wordSpacing: 2),
                        ),
                      ),
                      IconButton(
                          icon: Icon(isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border),
                          onPressed: () {
                            loadedProduct.toggleFavorite(auth.uId);
                            setState(() {
                              isFavorite = loadedProduct.isFavorite;
                            });
                          }),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    Assets.ipsum,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16, wordSpacing: 2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
