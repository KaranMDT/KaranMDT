import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/Product.dart';
import '../Provider/products.dart';

class EditProductscreen extends StatefulWidget {
  final String? productId;
  const EditProductscreen({
    Key? key,
    this.productId,
  }) : super(key: key);

  @override
  State<EditProductscreen> createState() => _EditProductscreenState();
}

class _EditProductscreenState extends State<EditProductscreen> {
  final _pricefocusnode = FocusNode();
  final _descreptonfocusnode = FocusNode();
  final _imageurlfocusnode = FocusNode();
  final _imageController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: "",
    title: "",
    description: "",
    imageUrl: "",
    price: 0,
    isfavourite: false,
  );
  var _initvalues = {
    "title": "",
    "descreption": "",
    "price": "",
    "imageurl": "",
  };

  var _isInit = true;
  var _isLoading = false;

  void initState() {
    _imageurlfocusnode.addListener(updateimageurl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (widget.productId != null) {
        _editedProduct = Provider.of<Products>(context, listen: false)
            .findbyid(widget.productId.toString());
        _initvalues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': ''
        };
        _imageController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageurlfocusnode.removeListener(updateimageurl);
    _pricefocusnode.dispose();
    _descreptonfocusnode.dispose();
    _imageController.dispose();
    _imageurlfocusnode.dispose();
    super.dispose();
  }

  void updateimageurl() {
    if (!_imageurlfocusnode.hasFocus) {
      if ((!_imageController.text.startsWith('http') &&
              !_imageController.text.startsWith('https')) ||
          (!_imageController.text.endsWith('.png') &&
              !_imageController.text.endsWith('.jpg') &&
              !_imageController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveform() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      if (widget.productId != null) {
        await Provider.of<Products>(
          context,
          listen: false,
        ).updateProduct(widget.productId.toString(), _editedProduct);
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      } else {
        try {
          await Provider.of<Products>(
            context,
            listen: false,
          ).addproduct(_editedProduct);
        } catch (error) {
          await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("An Error occured!"),
                  content: const Text("Something Went Wrong!"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Okay"),
                    ),
                  ],
                );
              });
        }

        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Edit Products"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveform,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColorDark,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formkey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initvalues["title"],
                      decoration: const InputDecoration(
                        labelText: "Title",
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_pricefocusnode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter a title.";
                        }
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: value,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          price: _editedProduct.price,
                          isfavourite: _editedProduct.isfavourite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initvalues["price"],
                      decoration: const InputDecoration(
                        labelText: "Price",
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _pricefocusnode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descreptonfocusnode);
                      },
                      validator: (value) {
                        if (value!.isEmpty && double.tryParse(value) == null) {
                          return "Please enter a price.";
                        } else if (double.parse(value) <= 0) {
                          return "Please enter price grater than zero.";
                        }
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          price: double.parse(value),
                          isfavourite: _editedProduct.isfavourite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initvalues["description"],
                      decoration: const InputDecoration(
                        labelText: "Descreption",
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      focusNode: _descreptonfocusnode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_imageurlfocusnode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter a descreption.";
                        } else if (value.length <= 10) {
                          return "Should be at least 10 characters long.";
                        }
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: value,
                          imageUrl: _editedProduct.imageUrl,
                          price: _editedProduct.price,
                          isfavourite: _editedProduct.isfavourite,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _imageController.text.isNotEmpty
                              ? FittedBox(
                                  child: Image.network(
                                    _imageController.text,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Text("Enter URL"),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Enter Image Url",
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            focusNode: _imageurlfocusnode,
                            controller: _imageController,
                            onFieldSubmitted: (_) {
                              _saveform();
                            },
                            validator: (value) {
                              if (value!.isEmpty ||
                                  (!value.startsWith("http") &&
                                      !value.startsWith("https")) ||
                                  (!value.endsWith('.png') &&
                                      !value.endsWith('.jpg') &&
                                      !value.endsWith('.jpeg'))) {
                                return "Please enter a valid image URl";
                              }
                              _editedProduct = Product(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                imageUrl: value,
                                price: _editedProduct.price,
                                isfavourite: _editedProduct.isfavourite,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
