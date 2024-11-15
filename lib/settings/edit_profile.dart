import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uas_flutter/size_config.dart';
import 'package:uas_flutter/constants.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);
  static String routeName = '/editprofile';

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          final data = userDoc.data()!;
          _usernameController.text = data['name'] ?? '';
          _emailController.text = data['email'] ?? '';
          _dobController.text = data['dob'] ?? '';
          _phoneController.text = data['phone'] ?? '';
        }
      }
    } catch (e) {
      // Tampilkan pesan error jika data tidak dapat dimuat
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user data: $e')),
      );
    }
  }

  Future<void> _updateUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'name': _usernameController.text,
          'email': _emailController.text,
          'dob': _dobController.text,
          'phone': _phoneController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    } catch (e) {
      // Tampilkan pesan error jika data gagal diperbarui
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstants.mainColor,
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(getProportionateScreenWidth(16)),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: getProportionateScreenWidth(40),
                    backgroundColor: AppConstants.greyColor4,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                      onPressed: () {
                        // Implement change profile picture logic
                      },
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(10)),
                  TextButton(
                    onPressed: () {
                      // Logic to update profile picture
                    },
                    child: const Text(
                      'Change Profile Picture',
                      style: TextStyle(color: AppConstants.mainColor),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            _buildTextField(
                _usernameController, 'Username', 'Enter your username'),
            _buildTextField(_emailController, 'Email', 'Enter your email',
                inputType: TextInputType.emailAddress),
            _buildTextField(
                _dobController, 'Date of Birth', 'Select your date of birth',
                readOnly: true, onTap: _selectDate),
            _buildTextField(
                _phoneController, 'Phone Number', 'Enter your phone number',
                inputType: TextInputType.phone),
            SizedBox(height: getProportionateScreenHeight(20)),
            ElevatedButton(
              onPressed: _updateUserData,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.mainColor,
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(40),
                  vertical: getProportionateScreenHeight(12),
                ),
              ),
              child: const Text('Save Changes', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint, {
    bool readOnly = false,
    TextInputType inputType = TextInputType.text,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: getProportionateScreenHeight(10)),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _dobController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }
}
