import 'package:uas_flutter/history/models/transaction_list.dart';

class Transactions {
  final String userId;
  final String date;
  final List<TransactionList> transactionList;
  final num amount;
  final int quantity;
  final num protectionFee;
  final num discountAmount;
  final String address;

  Transactions({
    required this.userId,
    required this.date,
    required this.transactionList,
    required this.amount,
    required this.quantity,
    required this.address,
    required this.protectionFee,
    required this.discountAmount,
  });

  factory Transactions.fromJson(Map<String, dynamic> json) {
    return Transactions(
      userId: json['userId'] as String,
      date: json['date'] as String,
      transactionList: (json['TransactionList'] as List)
          .map((item) => TransactionList.fromJson(item))
          .toList(),
      amount: json['amount'] as num,
      quantity: json['quantity'] as int,
      address: json['address'] as String,
      protectionFee: json['protectionFee'] ?? 0,
      discountAmount: json['discountAmount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'date': date,
      'TransactionList': transactionList.map((item) => item.toJson()).toList(),
      'amount': amount,
      'quantity': quantity,
      'address': address,
      'protectionFee': protectionFee,
      'discountAmount': discountAmount,
    };
  }

  Transactions copyWith({
    String? userId,
    String? date,
    List<TransactionList>? transactionList,
    num? amount,
    int? quantity,
    String? address,
    num? protectionFee,
    num? discountAmount,
  }) {
    return Transactions(
      userId: userId ?? this.userId,
      date: date ?? this.date,
      transactionList: transactionList ?? this.transactionList,
      amount: amount ?? this.amount,
      quantity: quantity ?? this.quantity,
      address: address ?? this.address,
      protectionFee: protectionFee ?? this.protectionFee,
      discountAmount: discountAmount ?? this.discountAmount,
    );
  }
}
