import 'package:flutter/material.dart';

class Cartprovider extends ChangeNotifier {
  num _total = 0;
  int _cartQuantity = 0;
  int get cartQuantity => _cartQuantity;
  List<Map<String, dynamic>> _cartItems = [];
  num get total => _total;
  List<Map<String, dynamic>> get cartItems => _cartItems;

  void setCartItems(List<Map<String, dynamic>> items) {
    _cartItems = items;
    _cartQuantity =
        items.fold(0, (sum, item) => sum + item['cartQuantity'] as int);
    notifyListeners();
  }

  void increaseCartQuantity(int quantityAdded) {
    _cartQuantity += quantityAdded;
    notifyListeners();
  }

  void decreaseCartQuantity(int quantityAdded) {
    _cartQuantity -= quantityAdded;
    notifyListeners();
  }

  List<Map<String, dynamic>> get checkedItems {
    return _cartItems.where((item) => item['check'] == true).toList();
  }

  void inititateData(num price) {
    _total = price;
  }

  bool getCheckStatusById(String id) {
    final cartItem = _cartItems.firstWhere(
      (item) => item['id'] == id,
    );
    return cartItem['check'];
  }

  Map<String, int> getQuantityById(String id) {
    final cartItem = _cartItems.firstWhere((item) => item['id'] == id);
    return {
      'quantity': cartItem['quantity'],
      'cartQuantity': cartItem['cartQuantity']
    };
  }

  void increase(String id) {
    final item = _cartItems.firstWhere((item) => item['id'] == id);
    item['cartQuantity'] += 1;
    calculateTotal();
    notifyListeners();
  }

  void decrease(String id) {
    final item = _cartItems.firstWhere((item) => item['id'] == id);
    if (item['cartQuantity'] > 1) {
      item['cartQuantity'] -= 1;
      calculateTotal();
      notifyListeners();
    }
  }

  void check(String id, bool newcheck) {
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
      // Kurangi _cartQuantity berdasarkan quantity dari item
      final quantityToRemove = (_cartItems[index]['cartQuantity'] ?? 0) as int;
      _cartQuantity -= quantityToRemove;

      // Hapus item dari _cartItems
      _cartItems.removeAt(index);

      // Hitung ulang total
      calculateTotal();
      notifyListeners();
    }
  }

  void updateScreen() {
    notifyListeners();
  }
}
