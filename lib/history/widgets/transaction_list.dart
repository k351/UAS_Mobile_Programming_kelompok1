import 'package:flutter/material.dart';
import 'package:uas_flutter/history/history_detail_page.dart';
import '../models/transaction.dart';
import 'transaction_card.dart';

class TransactionListWidget extends StatelessWidget {
  final List<Transactions> transactions;

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
        final transaction = transactions[index]; // Corrected variable name
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    HistoryDetailPage(transaction: transaction),
              ),
            );
          },
          child:
              TransactionCard(transaction: transaction), // Corrected this line
        );
      },
    );
  }
}
