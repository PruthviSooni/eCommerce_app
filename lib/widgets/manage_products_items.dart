import 'package:ecommerce_app/screens/add_product.dart';
import 'package:flutter/material.dart';

class ManageProductItems extends StatelessWidget {
  final String id;
  final String title;
  final String imgUrl;

  ManageProductItems({
    this.id,
    this.title,
    this.imgUrl,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: AssetImage(imgUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
                icon: Icon(
                  Icons.edit,
                ),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(AddProductScreen.routeName, arguments: id);
                }),
            IconButton(
                icon: Icon(
                  Icons.delete_forever,
                  color: Theme.of(context).errorColor,
                ),
                onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
