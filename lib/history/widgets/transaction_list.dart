import 'package:flutter/material.dart';
import 'package:uas_flutter/history/history_detail_page.dart';
import '../models/transaction.dart';
import 'transaction_card.dart';

/// [TransactionListWidget] adalah widget stateless yang menampilkan daftar transaksi
/// dalam bentuk list, di mana setiap transaksi ditampilkan menggunakan [TransactionCard].
class TransactionListWidget extends StatelessWidget {
  // Daftar transaksi yang akan ditampilkan.
  final List<Transactions> transactions;

  /// Konstruktor untuk menerima daftar transaksi.
  const TransactionListWidget({
    super.key,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return GestureDetector(
          // Ketika transaksi diklik, navigasi ke halaman detail transaksi.
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    HistoryDetailPage(transaction: transaction),
              ),
            );
          },
          // Menampilkan kartu transaksi menggunakan [TransactionCard].
          child:
              TransactionCard(transaction: transaction),
        );
      },
    );
  }
}
