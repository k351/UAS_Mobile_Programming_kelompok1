import 'package:flutter/material.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/login/login.dart';
import 'package:uas_flutter/size_config.dart';
import 'package:uas_flutter/usage/textfield.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static String routeName = "/signUpScreen";

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPassword = true;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: AppConstants.clrBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(15)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: getProportionateScreenHeight(20)),
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  Text(
                    AppConstants.signUp,
                    style: TextStyle(
                      color: AppConstants.clrBlack,
                      fontSize: getProportionateScreenWidth(30),
                      fontFamily: AppConstants.fontInterBold,
                      letterSpacing: -1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(10)),
                  Text(
                    AppConstants.createAccountText,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: getProportionateScreenWidth(13),
                      fontFamily: AppConstants.fontInterRegular,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(10)),

                  // Username
                  TextFieldWidget(
                    controller: usernameController,
                    keyboardType: TextInputType.text,
                    title: AppConstants.username,
                    hintText: 'Enter your username',
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username cannot be empty';
                      }
                      if (!RegExp(r'^[a-zA-Z0-9_]{3,16}$').hasMatch(value)) {
                        return 'Username must be 3-16 characters, and only contain letters, numbers, or underscores';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: getProportionateScreenHeight(10)),

                  // Email
                  TextFieldWidget(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    title: AppConstants.email,
                    hintText: 'Enter your email',
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email cannot be empty';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: getProportionateScreenHeight(10)),

                  // Date of Birth
                  TextFieldWidget(
                    controller: dobController,
                    keyboardType: TextInputType.datetime,
                    title: AppConstants.dateOfBirth,
                    hintText: 'ex. 06/09/2005',
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Date of Birth cannot be empty';
                      }
                      if (!RegExp(
                              r'^(0[1-9]|1[0-2])/(0[1-9]|[12][0-9]|3[01])/[0-9]{4}$')
                          .hasMatch(value)) {
                        return 'Enter a valid date in MM/DD/YYYY format';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: getProportionateScreenHeight(10)),

                  // Phone Number
                  TextFieldWidget(
                    controller: phoneNumberController,
                    keyboardType: TextInputType.phone,
                    title: AppConstants.phoneNumber,
                    hintText: 'ex. +6289623244972',
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone number cannot be empty';
                      }
                      if (!RegExp(r'^\+?[0-9]{10,13}$').hasMatch(value)) {
                        return 'Enter a valid phone number with 10-13 digits';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: getProportionateScreenHeight(10)),

                  // Password
                  TextFieldWidget(
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    title: AppConstants.password,
                    hintText: 'Enter your password here',
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          isPassword = !isPassword;
                        });
                      },
                      child: Icon(
                        isPassword ? Icons.visibility_off : Icons.visibility,
                        color: AppConstants.clrBlack,
                      ),
                    ),
                    obscure: isPassword ? true : false,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password cannot be empty';
                      }
                      if (!RegExp(
                              r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,20}$')
                          .hasMatch(value)) {
                        return 'Password must be 8-20 characters with uppercase, lowercase, number, and special character';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),

                  // Sign Up Button
                  Container(
                    width: getProportionateScreenWidth(340),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    decoration: const BoxDecoration(
                      color: AppConstants.mainColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {}
                        },
                        child: Text(
                          AppConstants.signUp,
                          style: TextStyle(
                            fontFamily: AppConstants.fontInterMedium,
                            color: AppConstants.clrBackground,
                            fontSize: getProportionateScreenWidth(16),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),

                  // Login Prompt
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, LoginScreen.routeName),
                    child: Center(
                      child: RichText(
                        text: const TextSpan(
                          text: AppConstants.alreadyHaveAccount,
                          style: TextStyle(color: AppConstants.clrBlack),
                          children: [
                            TextSpan(text: " "),
                            TextSpan(
                              text: AppConstants.login,
                              style: TextStyle(color: AppConstants.textBlue),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
