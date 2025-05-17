import 'dart:convert';

import 'package:addisfruit/Model/CartItem.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CartViewModel extends ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;


 CartViewModel() {
    _loadFromPrefs();
  }  
  
  void addItem(String name, String image) {
    final index = _items.indexWhere((item) => item.name == name);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(name: name, image: image,kilo: 1));
    }
    _saveToPrefs();
    notifyListeners();
  }

  void increaseQuantity(String name) {
    final item = _items.firstWhere((item) => item.name == name);
    item.quantity++;
    notifyListeners();
  }

  void decreaseQuantity(String name) {
    final item = _items.firstWhere((item) => item.name == name);
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(item);
    }
    notifyListeners();
  }

  void removeItem(String name) {
    _items.removeWhere((item) => item.name == name);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void _saveToPrefs() async {
    // final prefs = await SharedPreferences.getInstance();
    // final encodedData = jsonEncode(_items.map((e) => e.toJson()).toList());
    // await prefs.setString('orders', encodedData);
  }
  // added new
   void _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('orders');
    if (jsonString != null) {
      final List<dynamic> decoded = jsonDecode(jsonString);
      _items = decoded.map((e) => CartItem.fromJson(e)).toList();
      notifyListeners();
    }
  }
}
