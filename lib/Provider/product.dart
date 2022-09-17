import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isfavourite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isfavourite = false,
  });

  void _setvalue(bool newvalue) {
    isfavourite = newvalue;
    notifyListeners();
  }

  Future<void> toggleFavouriteStatus(String authToken, String userID) async {
    final oldstatus = isfavourite;
    isfavourite = !isfavourite;
    notifyListeners();

    final url =
        "https://shopapp-72eab-default-rtdb.firebaseio.com/userfavorite/$userID/$id.json?auth=$authToken";
    try {
      final response = await http.put(
        Uri.parse(url),
        body: json.encode(
          isfavourite,
        ),
      );
      if (response.statusCode >= 400) {
        _setvalue(oldstatus);
      }
    } catch (error) {
      _setvalue(oldstatus);
    }
  }
}
