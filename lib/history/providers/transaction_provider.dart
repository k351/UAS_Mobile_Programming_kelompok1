import 'package:flutter/material.dart';
import 'package:uas_flutter/history/models/transaction.dart';
import 'package:uas_flutter/history/services/transaction_service.dart';

class TransactionProvider with ChangeNotifier {
  final TransactionService _transactionService = TransactionService();
  List<Transactions> _transactions = [];
  bool _isLoading = false;

  List<Transactions> get transactions => _transactions;
  bool get isLoading => _isLoading;

  Future<void> fetchTransactions() async {
    if (_transactions.isEmpty) {
      _isLoading = true;
      notifyListeners();

      try {
        _transactions = await _transactionService.fetchTransactions();
      } catch (e) {
        debugPrint('Error fetching transactions: $e');
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> addTransaction(Transactions transaction) async {
    try {
      await _transactionService.addTransaction(transaction);
      _transactions.add(transaction);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding transaction: $e');
    }
  }
}