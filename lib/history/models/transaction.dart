import 'package:uas_flutter/history/models/transaction_list.dart';

/// Class [Transactions] merepresentasikan transaksi secara keseluruhan.
/// Berisi informasi tentang pengguna, tanggal, daftar transaksi, jumlah total,
/// kuantitas barang, biaya perlindungan, diskon, dan alamat pengiriman.
class Transactions {
  // ID pengguna yang melakukan transaksi
  final String userId;

  // Tanggal transaksi dilakukan
  final String date;

  // Daftar item transaksi yang dikelola melalui model [TransactionList]
  final List<TransactionList> transactionList;

  // Jumlah total pembayaran transaksi
  final num amount;

  // Total jumlah barang dalam transaksi
  final int quantity;

  // Biaya tambahan untuk perlindungan (opsional)
  final num protectionFee;

  // Jumlah diskon yang diberikan (opsional)
  final num discountAmount;

  // Alamat tujuan pengiriman barang
  final String address;

  /// Konstruktor utama untuk [Transactions].
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

  /// Factory constructor untuk membuat instance [Transactions] dari data JSON.
  /// Mengonversi setiap elemen [TransactionList] juga dari JSON.
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

  /// Mengonversi instance [Transactions] ke dalam bentuk JSON.
  /// Berguna untuk penyimpanan atau pengiriman data.
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

  /// Membuat salinan baru dari [Transactions] dengan properti yang dapat diubah.
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
