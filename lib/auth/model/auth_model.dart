import 'dart:convert';

class AuthModel {
  final String id;
  final String name;
  final String email;
  final String dob;
  final String phone;
  AuthModel({
    required this.id,
    required this.name,
    required this.email,
    required this.dob,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
    };
  }

  factory AuthModel.fromMap(Map<String, dynamic> map) {
    return AuthModel(
      id: map['id'] ?? "",
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
