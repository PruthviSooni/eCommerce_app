import 'dart:io';

import 'package:ecommerce_app/provider/product.dart';
import 'package:ecommerce_app/provider/products.dart';
import 'package:ecommerce_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = 'AddProductScreen';

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  File _image;
  String imgPath;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  final _imgUrlController = TextEditingController();
  var _isInit = true;
  var _initValues = {
    'title': "",
    'description': "",
    'price': "",
    'imgUrl': "",
  };
  PickedFile pickedFile;
  var _editingFields = Product(
    id: null,
    title: "",
    description: "",
    imageUrl: "",
    price: 0,
  );
  Future getImage() async {
    pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print(_image.path);
        _imgUrlController.text = _image.path;
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    Provider.of<Products>(context, listen: false).addProduct(_editingFields);
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
        _imgUrlController.text = _initValues['imgUrl'];
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  final _priceFocusNode = FocusNode();

  final _descriptionFocusNode = FocusNode();

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
              if (_image == null) {
                _key.currentState.showSnackBar(
                  SnackBar(
                    content: Text("Please provide image!"),
                  ),
                );
              } else {
                _saveForm();
              }
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
              ),
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
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: getImage,
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: _image == null
                                ? Colors.red.shade500
                                : Colors.grey.shade500,
                            width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: _image == null
                          ? Icon(
                              Icons.add_a_photo,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                _image,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                  Container(
                    width: 230,
                    margin: EdgeInsets.only(bottom: 5),
                    child: TextFormField(
                      controller: _imgUrlController,
                      enabled: false,
                      maxLines: _imgUrlController.text.length > 20 ? 4 : 1,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      decoration: kTextFieldDecoration.copyWith(
                          labelText: "Image Path"),
                      onSaved: (newValue) => _editingFields = Product(
                        imageUrl: newValue,
                        title: _editingFields.title,
                        description: _editingFields.description,
                        price: _editingFields.price,
                      ),
                    ),
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
