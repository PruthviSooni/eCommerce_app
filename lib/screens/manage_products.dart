import 'package:ecommerce_app/provider/products.dart';
import 'package:ecommerce_app/screens/add_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import '../widgets/manage_products_items.dart';

class ManageProductScreen extends StatelessWidget {
  static const String routeName = 'ManageProductsScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Product's"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
            ),
            onPressed: () =>
                Navigator.of(context).pushNamed(AddProductScreen.routeName),
          )
        ],
      ),
      body: Consumer<Products>(
        builder: (_, product, __) {
          return AnimationLimiter(
            child: ListView.builder(
              itemCount: product.items.length,
              itemBuilder: (context, index) =>
                  AnimationConfiguration.staggeredList(
                position: index,
                child: FadeInAnimation(
                  duration: Duration(milliseconds: 500),
                  child: ManageProductItems(
                    id: product.items[index].id,
                    title: product.items[index].title,
                    imgUrl: product.items[index].imageUrl,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
