class EditProfileModel {
  String username;
  String email;
  String dob; 
  String phone;

  EditProfileModel({
    required this.username,
    required this.email,
    required this.dob,
    required this.phone,
  });

  //model to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'dob': dob,
      'phone': phone,
    };
  }

  // Create model from Firestore data
  factory EditProfileModel.fromMap(Map<String, dynamic> map) {
    return EditProfileModel(
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      dob: map['dob'] ?? '',
      phone: map['phone'] ?? '',
    );
  }
}
