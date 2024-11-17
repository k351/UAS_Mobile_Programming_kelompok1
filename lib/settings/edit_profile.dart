import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_flutter/size_config.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/settings/provider/edit_profile_provider.dart';
import 'package:uas_flutter/settings/models/edit_profile_model.dart';

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

  @override
  void initState() {
    super.initState();
  
    Future.microtask(() {
      final provider = Provider.of<EditProfileProvider>(context, listen: false);
      provider.loadUserProfile().then((_) {
        final profile = provider.profile;
        if (profile != null) {
          _usernameController.text = profile.username;
          _emailController.text = profile.email;
          _dobController.text = profile.dob;
          _phoneController.text = profile.phone;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EditProfileProvider>(context);

    SizeConfig.init(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstants.mainColor,
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(getProportionateScreenWidth(16)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: getProportionateScreenWidth(40),
                            backgroundColor: AppConstants.greyColor4,
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt,
                                  color: Colors.white),
                              onPressed: () {
                                // logic ganti profile(kemungkinan gabisa)
                              },
                            ),
                          ),
                          SizedBox(height: getProportionateScreenHeight(10)),
                          TextButton(
                            onPressed: () {
                              // Logic updateny
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
                    _buildTextField(
                        _emailController, 'Email', 'Enter your email',
                        inputType: TextInputType.emailAddress),
                    _buildTextField(_dobController, 'Date of Birth',
                        'Select your date of birth',
                        readOnly: true, onTap: _selectDate),
                    _buildTextField(_phoneController, 'Phone Number',
                        'Enter your phone number',
                        inputType: TextInputType.phone),
                    SizedBox(height: getProportionateScreenHeight(20)),
                    ElevatedButton(
                      onPressed: () {
                        final updatedProfile = EditProfileModel(
                          username: _usernameController.text,
                          email: _emailController.text,
                          dob: _dobController.text,
                          phone: _phoneController.text,
                        );
                        provider.updateUserProfile(updatedProfile).then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Profile updated successfully')),
                          );
                        }).catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Error updating profile: $error')),
                          );
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.mainColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(40),
                          vertical: getProportionateScreenHeight(12),
                        ),
                      ),
                      child: const Text('Save Changes'),
                    ),
                  ],
                ),
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
