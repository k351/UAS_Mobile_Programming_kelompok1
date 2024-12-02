import 'package:flutter/material.dart';

// Provider untuk mengelola data dan state keranjang belanja
class Cartprovider extends ChangeNotifier {
  // Total harga dari semua item di keranjang yang dicentang
  num _total = 0;
  // Total jumlah semua item di keranjang
  int _cartQuantity = 0;
  // Daftar item dalam keranjang, setiap item adalah Map dengan informasi detail
  List<Map<String, dynamic>> _cartItems = [];
  // Getter untuk total jumlah item di keranjang
  int get cartQuantity => _cartQuantity;
  // Getter untuk total harga
  num get total => _total;
  // Getter untuk daftar item di keranjang
  List<Map<String, dynamic>> get cartItems => _cartItems;

  // Mengatur ulang daftar item di keranjang
  void setCartItems(List<Map<String, dynamic>> items) {
    _cartItems = items;

    // Menghitung total jumlah item berdasarkan field 'cartQuantity'
    _cartQuantity =
        items.fold(0, (sum, item) => sum + item['cartQuantity'] as int);
    notifyListeners();
  }

// Menambahkan jumlah item secara global
  void increaseCartQuantity(int quantityAdded) {
    _cartQuantity += quantityAdded;
    notifyListeners();
  }

// Mengurangi jumlah item secara global
  void decreaseCartQuantity(int quantityAdded) {
    _cartQuantity -= quantityAdded;
    notifyListeners();
  }

  // Mendapatkan semua item yang telah dicentang untuk checkout
  List<Map<String, dynamic>> get checkedItems {
    return _cartItems.where((item) => item['check'] == true).toList();
  }

  // Menginisialisasi total harga
  void inititateData(num price) {
    _total = price;
  }

  // Mendapatkan status centang (check) dari item berdasarkan ID
  bool getCheckStatusById(String id) {
    final cartItem = _cartItems.firstWhere(
      (item) => item['id'] == id,
    );
    return cartItem['check'];
  }

  // Mendapatkan quantity dan cartQuantity dari item berdasarkan ID
  Map<String, int> getQuantityById(String id) {
    final cartItem = _cartItems.firstWhere((item) => item['id'] == id);
    return {
      'quantity': cartItem['quantity'],
      'cartQuantity': cartItem['cartQuantity']
    };
  }

  // Menambah jumlah item di keranjang berdasarkan ID
  void increase(String id) {
    final item = _cartItems.firstWhere((item) => item['id'] == id);
    item['cartQuantity'] += 1;
    calculateTotal();
    notifyListeners();
  }

  // Mengurangi jumlah item di keranjang berdasarkan ID
  void decrease(String id) {
    final item = _cartItems.firstWhere((item) => item['id'] == id);
    if (item['cartQuantity'] > 1) {
      item['cartQuantity'] -= 1;
      calculateTotal();
      notifyListeners();
    }
  }

  // Memperbarui status centang (check) dari item di keranjang
  void check(String id, bool newcheck) {
    final index = _cartItems.indexWhere((item) => item['id'] == id);
    if (index != -1) {
      _cartItems[index]['check'] = newcheck;
      calculateTotal();
      notifyListeners();
    }
  }

  // Menghitung total harga berdasarkan item yang dicentang
  void calculateTotal() {
    _total = _cartItems
        .where((item) => item['check'] == true)
        .fold(0, (sum, item) => sum + (item['price'] * item['cartQuantity']));
    notifyListeners();
  }

  // Menghapus item dari keranjang berdasarkan ID
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

  // Menghapus beberapa item dari keranjang berdasarkan daftar ID
  void removeItems(List<String> ids) {
    _cartItems.removeWhere((item) {
      if (ids.contains(item['id'])) {
        // Kurangi jumlah total item dengan kuantitas item yang dihapus
        _cartQuantity -= item['cartQuantity'] as int;
        return true;
      }
      return false;
    });
    calculateTotal();
    notifyListeners();
  }

  // Memperbarui UI secara manual (jika diperlukan)
  void updateScreen() {
    notifyListeners();
  }
}
