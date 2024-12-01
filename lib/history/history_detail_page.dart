import 'package:flutter/material.dart';
import 'package:uas_flutter/history/models/transaction.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/utils/currency_formatter.dart';
import 'package:uas_flutter/utils/date_formatter.dart'; // Add the import for DateFormatter

class HistoryDetailPage extends StatelessWidget {
  final Transactions transaction;

  const HistoryDetailPage({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Transaction Details',
          style: TextStyle(
            color: AppConstants.clrBlack,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: AppConstants.clrBlack),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Transaction Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppConstants.clrBlue.withOpacity(0.1),
                  AppConstants.clrBlue.withOpacity(0.2),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transaction Date',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppConstants.clrBlack.withOpacity(0.7),
                      ),
                    ),
                    Text(
                      DateFormatter.formatDate(
                          DateTime.parse(transaction.date)),
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppConstants.clrBlack,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Full Address',
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color.fromARGB(255, 22, 15, 15)
                            .withOpacity(0.7),
                      ),
                    ),
                    Text(
                      transaction.address,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppConstants.clrBlack,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Items List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: transaction.transactionList.length,
              itemBuilder: (context, index) {
                final item = transaction.transactionList[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: Hero(
                      tag: 'item_image_$index',
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: AssetImage(item.image),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppConstants.clrBlack,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formatCurrency(item.price),
                              style: const TextStyle(
                                color: AppConstants.clrBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppConstants.clrBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.shopping_basket,
                                    size: 16,
                                    color: AppConstants.clrBlue,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Qty: ${item.quantity}',
                                    style: const TextStyle(
                                      color: AppConstants.clrBlue,
                                      fontWeight: FontWeight.w600,
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
                );
              },
            ),
          ),

          // Total Summary
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: AppConstants.clrBlue.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Protection Fee Row
                if (transaction.protectionFee != null &&
                    transaction.protectionFee > 0)
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Protection Fee',
                            style: TextStyle(
                              color: AppConstants.clrBlue,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            formatCurrency(transaction.protectionFee ?? 0),
                            style: const TextStyle(
                              color: AppConstants.clrBlue,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10), // SizedBox inside if
                    ],
                  ),

                // Discount Value Row
                if (transaction.discountAmount != null &&
                    transaction.discountAmount > 0)
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Discount Value',
                            style: TextStyle(
                              color: AppConstants.clrBlue,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            formatCurrency(transaction.discountAmount ?? 0),
                            style: const TextStyle(
                              color: AppConstants.clrBlue,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10), // SizedBox inside if
                    ],
                  ),

                // Total Amount Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount',
                      style: TextStyle(
                        color: AppConstants.clrBlue,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      formatCurrency(transaction.amount),
                      style: const TextStyle(
                        color: AppConstants.clrBlue,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
