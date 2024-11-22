import 'package:flutter/material.dart';

class SaldoProvider with ChangeNotifier {
  double _saldo = 0.0;

  double get saldo => _saldo;

  void updateSaldo(double newSaldo) {
    _saldo = newSaldo;
    notifyListeners(); // Notify all listeners that the saldo has changed
  }
}
