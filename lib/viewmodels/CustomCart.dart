import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Model/CustomCart.dart';

class CustomCartProvider extends ChangeNotifier {
  List<CustomCart> _list = [];

  List<CustomCart> get list => _list;

  CustomCartProvider() {
    loadFromPrefs();
  }

  Future<void> addCustomCart(CustomCart cart) async {
    _list.add(cart);
    await saveToPrefs();
    notifyListeners();
  }

  Future<void> deleteCustomCart(int id) async {
    _list.removeWhere((cart) => cart.id == id);
    await saveToPrefs();
    notifyListeners();
  }

  Future<void> clearCart() async {
    _list.clear();
    await saveToPrefs();
    notifyListeners();
  }
  void removeCustomCart(int id) {
  list.removeWhere((item) => item.id == id);
  notifyListeners();
}
  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> cartJsonList =
        _list.map((cart) => json.encode(cart.toJson())).toList();
    await prefs.setStringList('customCartList', cartJsonList);
  }

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? cartJsonList = prefs.getStringList('customCartList');
    if (cartJsonList != null) {
      _list = cartJsonList
          .map((jsonStr) => CustomCart.fromJson(json.decode(jsonStr)))
          .toList();
      notifyListeners();
    }
  }
}
