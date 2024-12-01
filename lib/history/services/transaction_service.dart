import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uas_flutter/history/models/transaction.dart';
import 'package:uas_flutter/history/models/transaction_list.dart';

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addTransaction(Transactions transaction) async {
    try {
      await _firestore.collection('transactions').add({
        'userId': transaction.userId,
        'date': transaction.date,
        'amount': transaction.amount,
        'quantity': transaction.quantity,
        'address': transaction.address,
        'discountAmount': transaction.discountAmount,
        'protectionFee': transaction.protectionFee,
        'transactionList': transaction.transactionList
            .map((item) => {
                  'productId': item.productId,
                  'title': item.title,
                  'image': item.image,
                  'price': item.price,
                  'quantity': item.quantity,
                })
            .toList(),
      });
    } catch (e) {
      throw Exception('Failed to add transaction: $e');
    }
  }

  Future<List<Transactions>> fetchTransactions(userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('transactions')
          .where('userId', isEqualTo: userId) // Filter by userId
          .get();

      // Debug: Print jumlah dokumen
      print('Jumlah dokumen: ${querySnapshot.docs.length}');

      return querySnapshot.docs.map((doc) {
        // Debug: Print data mentah setiap dokumen
        final data = doc.data();
        print('Data dokumen: $data');

        return Transactions(
          userId: (data['userId'] as String?) ?? '',
          date: (data['date']),
          amount: (data['amount'] as num),
          quantity: (data['quantity'] as int),
          address: (data['address'] as String),
          discountAmount: (data['discountAmount'] as num),
          protectionFee: (data['protectionFee'] as num),
          transactionList: data['transactionList'] != null
              ? (data['transactionList'] as List<dynamic>).map((item) {
                  return TransactionList(
                    title: (item['title'] as String?) ?? '',
                    productId: (item['productId'] as String?) ?? '',
                    image: (item['image'] as String?) ?? '',
                    price: (item['price'] is num)
                        ? (item['price'] as num).toDouble()
                        : 0.0,
                    quantity: (item['quantity'] is num)
                        ? (item['quantity'] as num).toInt()
                        : 0,
                  );
                }).toList()
              : [], // Kembalikan list kosong jika null
        );
      }).toList();
    } catch (e) {
      // Cetak error detail untuk debugging
      print('Detail error fetching transactions: $e');

      // Kembalikan list kosong daripada throw exception
      return [];
    }
  }
}
