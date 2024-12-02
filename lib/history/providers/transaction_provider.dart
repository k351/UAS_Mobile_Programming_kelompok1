import 'package:flutter/material.dart';
import 'package:uas_flutter/history/models/transaction.dart';
import 'package:uas_flutter/history/services/transaction_service.dart';

/// [TransactionProvider] adalah penyedia state management berbasis [ChangeNotifier].
/// Mengelola transaksi pengguna, termasuk fetching, menambah, dan status loading.
class TransactionProvider with ChangeNotifier {
  // Instance dari [TransactionService] untuk berinteraksi dengan service.
  final TransactionService _transactionService = TransactionService();

  // List untuk menyimpan semua transaksi.
  List<Transactions> _transactions = [];

  // Status loading untuk operasi asinkron.
  bool _isLoading = false;

  /// Getter untuk mengambil daftar transaksi.
  List<Transactions> get transactions => _transactions;

  /// Getter untuk mengambil status loading.
  bool get isLoading => _isLoading;

  /// Mengambil transaksi dari service untuk pengguna tertentu berdasarkan [userId].
  Future<void> fetchTransactions(userId) async {
    _isLoading = true; // Menandai bahwa proses fetch sedang berlangsung.
    notifyListeners(); // Memberitahu widget untuk melakukan update UI.

    try {
      // Meminta data transaksi dari service dan memperbarui daftar transaksi.
      _transactions = await _transactionService.fetchTransactions(userId);
    } catch (e) {
      // Menangani error saat fetching transaksi.
      debugPrint('Error fetching transactions: $e');
    } finally {
      // Menandai bahwa proses fetch selesai.
      _isLoading = false;
      notifyListeners(); // Memperbarui status loading di UI.
    }
  }

  /// Menambahkan transaksi baru ke daftar dan mengirimkan ke service.
  Future<void> addTransaction(Transactions transaction) async {
    try {
      // Menambahkan transaksi ke service.
      await _transactionService.addTransaction(transaction);

      // Menambahkan transaksi ke daftar lokal jika berhasil.
      _transactions.add(transaction); // Memperbarui UI untuk menyertakan transaksi baru.
    } catch (e) {
      // Menangani error saat menambahkan transaksi.
      debugPrint('Error adding transaction: $e');
    }
  }
}
