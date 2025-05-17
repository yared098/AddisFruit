import 'package:flutter/material.dart';
import '../Model/fruit_model.dart';

class FruitViewModel extends ChangeNotifier {
  List<Fruit> _allFruits = [
    Fruit(name: "Apple", image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQazpJCRL9hs8lklHmRkkxt5mh78zJQmwUN5A&s", icon: "apple"),
    Fruit(name: "Banana", image: "https://media.istockphoto.com/id/529664572/photo/fruit-background.jpg?s=612x612&w=0&k=20&c=K7V0rVCGj8tvluXDqxJgu0AdMKF8axP0A15P-8Ksh3I=", icon: "banana"),
    Fruit(name: "Mango", image: "https://via.placeholder.com/100?text=Mango", icon: "mango"),
    // Add more fruits here...
  ];

  Fruit? selectedFruit;
  bool showForm = false;
  String _searchText = '';
  String quantity = '';
  String amount = '';

  // 🔍 Filtered fruits based on search input
  List<Fruit> get filteredFruits {
    if (_searchText.isEmpty) return _allFruits;
    return _allFruits
        .where((fruit) =>
            fruit.name.toLowerCase().contains(_searchText.toLowerCase()))
        .toList();
  }

  // 🔎 Set search text
  void searchFruit(String text) {
    _searchText = text;
    notifyListeners();
  }

  // 🟩 SELECT Fruit for form
  void selectFruit(Fruit fruit) {
    selectedFruit = fruit;
    quantity = '';
    amount = '';
    showForm = true;
    notifyListeners();
  }

  // ❌ Close form
  void hideForm() {
    showForm = false;
    selectedFruit = null;
    quantity = '';
    amount = '';
    notifyListeners();
  }

  // 🧾 Update quantity and amount
  void setQuantity(String value) {
    quantity = value;
    notifyListeners();
  }

  void setAmount(String value) {
    amount = value;
    notifyListeners();
  }

  // ➕ ADD New Fruit (you can customize with backend call)
  void addFruit(Fruit fruit) {
    _allFruits.add(fruit);
    hideForm();
  }

  // ✏️ UPDATE existing fruit
  void updateFruit(Fruit updatedFruit) {
    final index = _allFruits.indexWhere((f) => f.name == updatedFruit.name);
    if (index != -1) {
      _allFruits[index] = updatedFruit;
    }
    hideForm();
  }

  // 🗑️ DELETE fruit
  void deleteFruit(Fruit fruit) {
    _allFruits.removeWhere((f) => f.name == fruit.name);
    hideForm();
  }

  // ✅ Save (calls add or update depending on if fruit exists)
  void saveFruit(String name, String image, String icon) {
    if (selectedFruit != null) {
      updateFruit(Fruit(name: name, image: image, icon: icon));
    } else {
      addFruit(Fruit(name: name, image: image, icon: icon));
    }
  }
}
