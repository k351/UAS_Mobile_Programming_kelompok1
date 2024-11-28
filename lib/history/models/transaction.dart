import 'package:uas_flutter/history/models/transaction_list.dart';

class Transactions {
  final String userId;
  final String date;
  final List<TransactionList> transactionList;
  final num amount;
  final int quantity;

  Transactions({
    required this.userId,
    required this.date,
    required this.transactionList,
    required this.amount,
    required this.quantity
  });

  factory Transactions.fromJson(Map<String, dynamic> json) {
    return Transactions(
      userId: json['userId'] as String,
      date: json['date'] as String,
      transactionList: (json['TransactionList'] as List)
          .map((item) => TransactionList.fromJson(item))
          .toList(),
      amount: json['amount'] as num,
      quantity: json['quantity'] as int
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'date': date,
      'TransactionList': transactionList.map((item) => item.toJson()).toList(),
      'amount': amount,
      'quantity': quantity,
    };
  }

  Transactions copyWith({
    String? userId,
    String? date,
    List<TransactionList>? transactionList,
    num? amount,
    int? quantity,
  }) {
    return Transactions(
      userId: userId ?? this.userId,
      date: date ?? this.date,
      transactionList: transactionList ?? this.transactionList,
      amount: amount ?? this.amount,
      quantity: quantity ?? this.quantity,
    );
  }
}
