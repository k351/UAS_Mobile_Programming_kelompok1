import 'dart:convert';

class AuthModel {
  final String name;
  final String email;
  final String dob;
  final String phone;
  AuthModel({
    required this.name,
    required this.email,
    required this.dob,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
    };
  }

  factory AuthModel.fromMap(Map<String, dynamic> map) {
    return AuthModel(
      name: map['name'] ?? "",
      email: map['email'] ?? "",
      dob: map['dob'] ?? "",
      phone: map['phone'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthModel.fromJson(String source) =>
      AuthModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
