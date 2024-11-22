import 'dart:convert';

class AddressModel {
  final String id;
  final String userId;
  final String recipientName;
  final String fullAddress;
  final String postalCode;
  final String addressLabel;

  AddressModel({
    required this.id,
    required this.userId,
    required this.recipientName,
    required this.fullAddress,
    required this.postalCode,
    required this.addressLabel,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'recipientName': recipientName,
      'fullAddress': fullAddress,
      'postalCode': postalCode,
      'addressLabel': addressLabel,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map, String documentId) {
    return AddressModel(
      id: documentId,
      userId: map['userId'] ?? "",
      recipientName: map['recipientName'] ?? "",
      fullAddress: map['fullAddress'] ?? "",
      postalCode: map['postalCode'] ?? "",
      addressLabel: map['addressLabel'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressModel.fromJson(String source, String documentId) =>
      AddressModel.fromMap(json.decode(source), documentId);
}
