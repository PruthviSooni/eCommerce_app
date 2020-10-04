import '../provider/products.dart';
import '../provider/product.dart';
import '../utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = 'AddProductScreen';

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  final _imgUrlController = TextEditingController();
  final _priceFocusNode = FocusNode();
  String imgUrl = "";
  final _descriptionFocusNode = FocusNode();
  var _isInit = true;
  var _initValues = {
    'title': "",
    'description': "",
    'price': "",
    'imgUrl': "",
  };
  var _editingFields = Product(
    id: null,
    title: "",
    description: "",
    imageUrl: "",
    price: 0,
  );

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imgUrlController.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    if (_editingFields.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editingFields.id, _editingFields);
    } else {
      Provider.of<Products>(context, listen: false).addProduct(_editingFields);
    }
    Navigator.pop(context);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editingFields =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editingFields.title,
          'description': _editingFields.description,
          'price': _editingFields.price.toString(),
          'imgUrl': "",
        };
        _imgUrlController.text = _editingFields.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text("Add Product"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          children: [
            TextFormField(
              initialValue: _initValues['title'],
              decoration: kTextFieldDecoration.copyWith(labelText: "Title"),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_priceFocusNode),
              validator: (val) {
                if (val.isEmpty) {
                  return "Please enter title!";
                }
                return null;
              },
              onSaved: (newValue) => _editingFields = Product(
                id: _editingFields.id,
                title: newValue,
                description: _editingFields.description,
                imageUrl: _editingFields.imageUrl,
                price: _editingFields.price,
                isFavorite: _editingFields.isFavorite,
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              initialValue: _initValues['price'],
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              decoration: kTextFieldDecoration.copyWith(labelText: "Price"),
              focusNode: _priceFocusNode,
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(_descriptionFocusNode),
              onSaved: (newValue) => _editingFields = Product(
                id: _editingFields.id,
                title: _editingFields.title,
                description: _editingFields.description,
                imageUrl: _editingFields.imageUrl,
                price: double.parse(newValue),
                isFavorite: _editingFields.isFavorite,
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter price!';
                }
                if (double.tryParse(value) == null) {
                  return 'Please Enter valid number';
                }
                if (double.parse(value) < 100) {
                  return 'Price Should be greater than ₹100';
                }
                return null;
              },
            ),
            SizedBox(height: 8),
            TextFormField(
              initialValue: _initValues['description'],
              textInputAction: TextInputAction.next,
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              decoration:
                  kTextFieldDecoration.copyWith(labelText: "Description"),
              focusNode: _descriptionFocusNode,
              onSaved: (newValue) => _editingFields = Product(
                  id: _editingFields.id,
                  title: _editingFields.title,
                  description: newValue,
                  imageUrl: _editingFields.imageUrl,
                  price: _editingFields.price,
                  isFavorite: _editingFields.isFavorite),
              // ignore: missing_return
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter description!';
                }
                if (value.length < 10) {
                  return 'Description should be at least 10 characters';
                }
              },
            ),
            Container(
              width: 100,
              margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: imgUrl.isEmpty
                                ? Colors.red.shade500
                                : Colors.grey.shade500,
                            width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: imgUrl.isEmpty && _editingFields.imageUrl.isEmpty
                          ? Icon(
                              Icons.add_a_photo,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                _imgUrlController.text,
                                fit: BoxFit.cover,
                              ),
                            )),
                  Container(
                    width: 230,
                    margin: EdgeInsets.only(bottom: 5),
                    child: TextFormField(
                        controller: _imgUrlController,
                        maxLines: _imgUrlController.text.length > 20 ? 4 : 1,
                        textInputAction: TextInputAction.done,
                        decoration: kTextFieldDecoration.copyWith(
                            labelText: "Image Path"),
                        validator: (value) {
                          bool url = isURL(value);
                          if (url == false) {
                            return "Please enter valid url";
                          } else {
                            setState(() {
                              imgUrl = value;
                            });
                          }
                        },
                        onEditingComplete: _saveForm,
                        onSaved: (newValue) {
                          print(newValue);
                          _editingFields = Product(
                            imageUrl: newValue,
                            title: _editingFields.title,
                            description: _editingFields.description,
                            price: _editingFields.price,
                            id: _editingFields.id,
                            isFavorite: _editingFields.isFavorite,
                          );
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
