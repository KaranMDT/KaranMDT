import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:shop_app/model/http_exeption.dart';

import '../Provider/Product.dart';

import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _itemslist = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://media.gq-magazine.co.uk/photos/603cf4855caa5669c2c5d281/master/w_1920,h_1280,c_limit/Trousers_0005_Brunello%20Cucinelli.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl: 'https://i.ytimg.com/vi/T7GK78FaHoY/maxresdefault.jpg',
    // ),
    // Product(
    //   id: 'p5',
    //   title: 'A shoes',
    //   description: 'It is a man Shoes',
    //   price: 99.99,
    //   imageUrl:
    //       'https://rukminim1.flixcart.com/image/332/398/kq6yefk0/shoe/p/s/r/10-fashion-star-black-165-beige-10-hotstyle-beige-black-original-imag4992vm7yfvfq.jpeg?q=50',
    // ),
    // Product(
    //   id: 'p6',
    //   title: 'A wallet',
    //   description: 'It is a woman wallet',
    //   price: 199.99,
    //   imageUrl:
    //       'https://cdn11.bigcommerce.com/s-pkla4xn3/images/stencil/1280x1280/products/22606/202813/Wallet-Women-Small-Purse-Card-Slot-Zipper-Coin-Pocket-Wallet-Female-Purse-High-Quality-Leather-Wallet__81827.1546846788.jpg?c=2',
    // ),
  ];

  final String authToken;
  final String userID;
  Products(this.authToken, this.userID, this._itemslist);

  List<Product> get items {
    return [..._itemslist];
  }

  List<Product> get favouriteitem {
    return _itemslist.where((element) => element.isfavourite).toList();
  }

  Product findbyid(String id) {
    return _itemslist.firstWhere((element) => element.id == id);
  }

  Future<void> fatchdata([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userID"' : '';
    var url =
        'https://shopapp-72eab-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(Uri.parse(url));

      final extractdata = json.decode(response.body) as Map<String, dynamic>;
      print(extractdata);
      if (extractdata == null) {
        return;
      }
      final furl =
          "https://shopapp-72eab-default-rtdb.firebaseio.com/userfavorite/$userID.json?auth=$authToken";
      final favoriteResponse = await http.get(Uri.parse(furl));
      final favoriteData = json.decode(favoriteResponse.body);

      final List<Product> loadData = [];

      extractdata.forEach((prodkey, prodValue) {
        loadData.add(
          Product(
            id: prodkey,
            title: prodValue['title'],
            price: prodValue['price'],
            description: prodValue['descreption'],
            isfavourite:
                favoriteData == null ? false : favoriteData[prodkey] ?? false,
            imageUrl: prodValue['imageurl'],
          ),
        );
      });

      _itemslist = loadData;

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addproduct(Product products) async {
    final url =
        "https://shopapp-72eab-default-rtdb.firebaseio.com/products.json?auth=$authToken";
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            "title": products.title,
            "descreption": products.description,
            "price": products.price,
            "imageurl": products.imageUrl,
            "creatorId": userID,
          },
        ),
      );
      final newproduct = Product(
        id: json.decode(response.body)['name'],
        title: products.title,
        description: products.description,
        imageUrl: products.imageUrl,
        price: products.price,
      );

      _itemslist.add(newproduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newproduct) async {
    final prodindex = _itemslist.indexWhere((element) => element.id == id);
    if (prodindex >= 0) {
      final url =
          "https://shopapp-72eab-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken";
      await http.patch(Uri.parse(url),
          body: json.encode({
            'title': newproduct.title,
            'descreption': newproduct.description,
            'price': newproduct.price,
            'imageurl': newproduct.imageUrl,
          }));
      _itemslist[prodindex] = newproduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        "https://shopapp-72eab-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken";
    final existingproductIndex =
        _itemslist.indexWhere((element) => element.id == id);
    var existingproduct = _itemslist[existingproductIndex];
    _itemslist.removeAt(existingproductIndex);
    notifyListeners();

    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _itemslist.insert(existingproductIndex, existingproduct);
      notifyListeners();
      throw HttpException("Could not delete product");
    }
  }
}
