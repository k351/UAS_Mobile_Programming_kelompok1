import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_flutter/bottom_navigator.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/history/providers/transaction_provider.dart';
import 'widgets/transaction_list.dart';
import 'widgets/empty_transactions.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});
  static String routeName = 'history';

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    String userId = FirebaseAuth.instance.currentUser!.uid;
    Future.microtask(() {
      Provider.of<TransactionProvider>(context, listen: false)
          .fetchTransactions(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.clrBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Purchase History',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: AppConstants.fontInterMedium,
            color: AppConstants.clrBlackFont,
          ),
        ),
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, transactionProvider, child) {
          return transactionProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : transactionProvider.transactions.isEmpty
                  ? const EmptyTransactions()
                  : TransactionListWidget(
                      transactions: transactionProvider.transactions,
                    );
        },
      ),
      bottomNavigationBar: NavigasiBar(
        selectedIndex: 1,
        onTap: (index) {
          NavigationUtils.navigateToPage(context, index);
        },
      ),
    );
  }
}