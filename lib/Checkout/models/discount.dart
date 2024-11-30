import 'package:cloud_firestore/cloud_firestore.dart';

class Discount {
  final String code;
  final int discountValue; // e.g., 30000
  final DateTime validTo;

  Discount({
    required this.code,
    required this.discountValue,
    required this.validTo,
  });

  // Factory to create a Discount from JSON (Firestore data)
  factory Discount.fromJson(Map<String, dynamic> json) {
    return Discount(
      code: json['code'] as String,
      discountValue: json['discountValue'] as int,
      validTo: (json['validTo'] as Timestamp).toDate(),
    );
  }

  // Convert Discount object to JSON (for Firestore)
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'discountValue': discountValue,
      'validTo': Timestamp.fromDate(validTo),
    };
  }

  // Copy function for updates
  Discount copyWith({
    String? code,
    int? discountValue,
    DateTime? validTo,
  }) {
    return Discount(
      code: code ?? this.code,
      discountValue: discountValue ?? this.discountValue,
      validTo: validTo ?? this.validTo,
    );
  }
}
