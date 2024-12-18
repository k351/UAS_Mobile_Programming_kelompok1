import 'package:flutter/material.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/utils/size_config.dart';
import 'package:uas_flutter/utils/date_formatter.dart';
import '../models/transaction.dart';
import 'package:uas_flutter/utils/currency_formatter.dart';

/// [TransactionCard] adalah widget stateless yang menampilkan
/// informasi singkat tentang sebuah transaksi dalam bentuk kartu.
class TransactionCard extends StatelessWidget {
  // Objek transaksi yang akan ditampilkan dalam kartu.
  final Transactions transaction;

  /// Konstruktor yang menerima [Transactions] sebagai parameter.
  const TransactionCard({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    // Ambil item pertama dari daftar transaksi untuk ditampilkan.
    final firstItem = transaction.transactionList.isNotEmpty
        ? transaction.transactionList[0]
        : null;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppConstants.clrBackground,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormatter.formatDate(DateTime.parse(transaction.date)),
                    style: TextStyle(
                      color: AppConstants.clrBlue,
                      fontSize: getProportionateScreenWidth(14),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Divider(height: 24, thickness: 1),
              // Baris kedua untuk menampilkan detail transaksi.
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (firstItem != null)
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: AssetImage(firstItem.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  const SizedBox(width: 16),
                  // Menampilkan detail item dan jumlah transaksi.
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction.transactionList.first.title,
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // Jika lebih dari satu item, tampilkan jumlah tambahan.
                        if (transaction.quantity > 1) ...[
                          const SizedBox(height: 4),
                          Text(
                            '+${transaction.quantity - 1} more',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                        const SizedBox(height: 8),
                         // Menampilkan jumlah transaksi dengan format mata uang.
                        Text(
                          formatCurrency(transaction.amount),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppConstants.clrBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
