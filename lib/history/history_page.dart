import 'package:flutter/material.dart';
import 'widgets/transaction_list.dart';
import 'widgets/empty_transactions.dart';
import 'models/transaction.dart';
import 'utils/currency_formatter.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});
  static String routeName = '/history';

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final List<Transaction> transactions = [
    Transaction(
      id: "123456",
      title: "Sepatu Running Nike Air Max",
      date: "17 Nov 2024",
      amount: 250000,
      quantity: 1,
    ),
    Transaction(
      id: "123457",
      title: "Tas Ransel Adidas Classic",
      date: "15 Nov 2024",
      amount: 500000,
      quantity: 2,
    ),
    Transaction(
      id: "123458",
      title: "Kaos Olahraga Puma",
      date: "10 Nov 2024",
      amount: 100000,
      quantity: 1,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Purchase History',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: transactions.isEmpty
          ? const EmptyTransactions()
          : TransactionList(transactions: transactions),
    );
  }
}
