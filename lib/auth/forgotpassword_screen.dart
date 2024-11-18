import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uas_flutter/auth/widget/textfield.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/size_config.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  static String routeName = "/forgotPasswordScreen";

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    try {
      await _auth.sendPasswordResetEmail(email: emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset email sent! Check your inbox.')),
      );
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: AppConstants.clrBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: getProportionateScreenHeight(20)),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppConstants.greyColor4.withOpacity(0.3),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: AppConstants.mainColor,
                      size: getProportionateScreenWidth(20),
                    ),
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(40)),
                Text(
                  AppConstants.forgotPassword,
                  style: TextStyle(
                    color: AppConstants.mainColor,
                    fontSize: getProportionateScreenWidth(34),
                    fontFamily: AppConstants.fontInterBold,
                    letterSpacing: -1,
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(12)),
                Text(
                  "Don't worry! It happens. Please enter the email address associated with your account.",
                  style: TextStyle(
                    color: AppConstants.greyColor4,
                    fontSize: getProportionateScreenWidth(14),
                    fontFamily: AppConstants.fontInterRegular,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(40)),
                TextFieldWidget(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  title: "Email Address",
                  hintText: "Enter your email address",
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(height: getProportionateScreenHeight(40)),
                GestureDetector(
                  onTap: () {
                    if (emailController.text.isNotEmpty) {
                      resetPassword();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Please enter your email address')),
                      );
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      color: AppConstants.mainColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppConstants.mainColor.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "Reset Password",
                        style: TextStyle(
                          color: AppConstants.clrBackground,
                          fontSize: getProportionateScreenWidth(16),
                          fontFamily: AppConstants.fontInterMedium,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
