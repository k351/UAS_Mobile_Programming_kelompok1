import 'package:flutter/material.dart';

/// [EmptyTransactions] adalah widget stateless yang menampilkan UI
/// untuk kondisi di mana tidak ada transaksi ditemukan.
class EmptyTransactions extends StatelessWidget {
  const EmptyTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      // Menempatkan konten di tengah layar.
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // Mengatur layout kolom untuk menampilkan ikon dan teks secara vertikal.
        children: [
          // Ikon untuk merepresentasikan keadaan "tidak ada transaksi".
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No transactions found',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
