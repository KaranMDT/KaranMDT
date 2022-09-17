import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/Provider/cart.dart';
import 'package:http/http.dart' as http;

class orderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime date;

  orderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.date});
}

class Order with ChangeNotifier {
  List<orderItem> _orders = [];
  final String authToken;
  final String userId;

  Order(this.authToken, this.userId, this._orders);

  List<orderItem> get orders {
    return _orders;
  }

  Future<void> fatchorders() async {
    final url =
        "https://shopapp-72eab-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken";
    final response = await http.get(Uri.parse(url));
    final extractorder = json.decode(response.body) as Map<String, dynamic>;
    List<orderItem> loadingorder = [];

    if (extractorder == null) {
      return;
    }
    extractorder.forEach((key, value) {
      loadingorder.add(
        orderItem(
          id: key,
          amount: value['amount'],
          date: DateTime.parse(value['date']),
          products: (value['product'] as List<dynamic>)
              .map(
                (e) => CartItem(
                  id: e['id'],
                  title: e['title'],
                  quantity: e['quantity'],
                  price: e['price'],
                ),
              )
              .toList(),
        ),
      );
      _orders = loadingorder.reversed.toList();
      notifyListeners();
    });
  }

  Future<void> addOrders(List<CartItem> cartproducts, double total) async {
    final url =
        "https://shopapp-72eab-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken";
    final response = await http.post(
      Uri.parse(url),
      body: json.encode(
        {
          'amount': total,
          'date': DateTime.now().toIso8601String(),
          'product': cartproducts
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'quantity': e.quantity,
                    'price': e.price,
                  })
              .toList()
        },
      ),
    );
    _orders.insert(
      0,
      orderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartproducts,
        date: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
