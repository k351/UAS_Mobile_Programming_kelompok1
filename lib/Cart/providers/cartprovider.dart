import 'package:flutter/material.dart';

class Cartprovider extends ChangeNotifier {
  num _total = 0;
  List<Map<String, dynamic>> _cartItem = [];
  num get total => _total;
  List<Map<String, dynamic>> get cartItem => _cartItem;

  void setCartItems(List<Map<String, dynamic>> items) {
    _cartItem = items;
    notifyListeners();
  }

  List<Map<String, dynamic>> get checkedItems {
    return _cartItem.where((item) => item['check'] == true).toList();
  }

  void inititateData(num price) {
    _total = price;
  }

  void increase(String id, num price) {
    final item = _cartItem.firstWhere((item) => item['id'] == id);
    if (item != null) {
      item['quantity'] += 1;
      print(item);
      calculateTotal();
      notifyListeners();
    }
  }

  void decrease(String id, num price) {
    final item = _cartItem.firstWhere((item) => item['id'] == id);
    if (item != null) {
      if (item['quantity'] > 1) {
        item['quantity'] -= 1;
        print(item);
        calculateTotal();
        notifyListeners();
      }
    }
  }

  void check(String id, int quantity, num price, bool newcheck) {
    final index = _cartItem.indexWhere((item) => item['id'] == id);
    if (index != -1) {
      _cartItem[index]['check'] = newcheck;
      calculateTotal();
      notifyListeners();
    }
  }

  void calculateTotal() {
    _total = _cartItem
        .where((item) => item['check'] == true)
        .fold(0, (sum, item) => sum + (item['price'] * item['quantity']));
    notifyListeners();
  }

  void updateScreen() {
    notifyListeners();
  }
}
