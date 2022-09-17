import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shop_app/Screens/auth_screen.dart';

import '../model/http_exeption.dart';

class Auth with ChangeNotifier {
  String? _userId;
  String? _token;
  DateTime? _expirydate;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expirydate != null &&
        _expirydate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userid {
    return _userId.toString();
  }

  Future<void> authanticate(
    String email,
    String password,
    String urlSegment,
    BuildContext context,
  ) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDmOjNUttmTTl7-q3vp5In7759OaSQ_KeQ";
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'email': email.trim(),
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final responcedata = json.decode(response.body);
      print(responcedata);

      if (responcedata['error'] != null) {
        throw HttpException(responcedata['error']['message']);
      }

      _token = responcedata['idToken'];
      _userId = responcedata['localId'];
      _expirydate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responcedata['expiresIn'],
          ),
        ),
      );
      autoLogout(context);
      notifyListeners();

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final userdata = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expirydate!.toIso8601String()
      });
      await prefs.setString('userdata', userdata);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signup(
    String email,
    String password,
    context,
  ) async {
    return authanticate(
      email,
      password,
      "signUp",
      context,
    );
  }

  Future<void> login(
    String email,
    String password,
    context,
  ) async {
    return authanticate(
      email,
      password,
      "signInWithPassword",
      context,
    );
  }

  Future<bool> tryAutoLogin(
    BuildContext context,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userdata')) {
      return false;
    }

    final extractUserData = json.decode(prefs.getString('userdata').toString())
        as Map<String, dynamic>;

    final expiryDate = DateTime.parse(extractUserData['expiryDate'].toString());

    if (expiryDate.isBefore(DateTime.now())) {
      return true;
      // token is not valid
    }
    _token = extractUserData['token'].toString();
    _userId = extractUserData['userId'].toString();
    _expirydate = expiryDate;

    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expirydate = null;

    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void autoLogout(BuildContext context) {
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    final timetoExpiry = _expirydate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(
      Duration(seconds: timetoExpiry),
      () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AuthScreen(),
          ),
        );
      },
    );
  }
}
