import 'dart:convert';

// Kelas model untuk menangani data autentikasi pengguna.
class AuthModel {
  final String name;
  final String email;
  final String dob;
  final String phone;
  // Konstruktor dengan parameter wajib untuk inisialisasi properti.
  AuthModel({
    required this.name,
    required this.email,
    required this.dob,
    required this.phone,
  });

  // Mengonversi objek `AuthModel` menjadi Map (key-value pair).
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
    };
  }

  // Factory constructor untuk membuat instance `AuthModel` dari Map.
  factory AuthModel.fromMap(Map<String, dynamic> map) {
    return AuthModel(
      name: map['name'] ?? "",
      email: map['email'] ?? "",
      dob: map['dob'] ?? "",
      phone: map['phone'] ?? "",
    );
  }

  // Mengonversi objek `AuthModel` ke JSON string.
  String toJson() => json.encode(toMap());

  // Factory constructor untuk membuat instance `AuthModel` dari JSON string.
  factory AuthModel.fromJson(String source) =>
      AuthModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
