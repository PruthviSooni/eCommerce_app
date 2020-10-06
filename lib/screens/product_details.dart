import 'package:ecommerce_app/provider/products.dart';
import 'package:ecommerce_app/utils/assests.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final loadedProduct = Provider.of<Products>(
      context,
      listen: true,
    ).findById(id);
    return Hero(
      tag: loadedProduct.hashCode,
      child: Material(
        borderOnForeground: true,
        color: Colors.grey.shade800,
        child: Scaffold(
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
                borderRadius: BorderRadius.circular(16),
              ),
              onPressed: () {},
              child: Text(
                "Order Now",
                style: TextStyle(fontSize: 18),

              ),
              color: Theme.of(context).primaryColor,
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
                          "₹${loadedProduct.price}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              wordSpacing: 2),
                        ),
                      ),
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
