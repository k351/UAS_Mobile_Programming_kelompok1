import 'package:flutter/material.dart';

class Cartprovider extends ChangeNotifier {
  num _total = 0;
  List<Map<String, dynamic>> _cartItems = [];
  num get total => _total;
  List<Map<String, dynamic>> get cartItems => _cartItems;

  void setCartItems(List<Map<String, dynamic>> items) {
    _cartItems = items;
    notifyListeners();
  }

  List<Map<String, dynamic>> get checkedItems {
    return _cartItems.where((item) => item['check'] == true).toList();
  }

  void inititateData(num price) {
    _total = price;
  }

  void increase(String id, num price) {
    final item = _cartItems.firstWhere((item) => item['id'] == id);
    if (item != null) {
      item['cartQuantity'] += 1;
      print(item);
      calculateTotal();
      notifyListeners();
    }
  }

  void decrease(String id, num price) {
    final item = _cartItems.firstWhere((item) => item['id'] == id);
    if (item != null) {
      if (item['cartQuantity'] > 1) {
        item['cartQuantity'] -= 1;
        print(item);
        calculateTotal();
        notifyListeners();
      }
    }
  }

  void check(String id, int quantity, num price, bool newcheck) {
    final index = _cartItems.indexWhere((item) => item['id'] == id);
    if (index != -1) {
      _cartItems[index]['check'] = newcheck;
      calculateTotal();
      notifyListeners();
    }
  }

  void calculateTotal() {
    _total = _cartItems
        .where((item) => item['check'] == true)
        .fold(0, (sum, item) => sum + (item['price'] * item['cartQuantity']));
    notifyListeners();
  }

  void removeItem(String id) {
    final index = _cartItems.indexWhere((item) => item['id'] == id);
    if (index != -1) {
      _cartItems.removeAt(index);
      calculateTotal();
      notifyListeners();
    }
  }

  void updateScreen() {
    notifyListeners();
  }
}
