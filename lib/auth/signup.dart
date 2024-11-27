import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_flutter/Home/home_page.dart';
import 'package:uas_flutter/auth/providers/user_provider.dart';
import 'package:uas_flutter/auth/widget/phonenumberfield.dart';
import 'package:uas_flutter/auth/widget/textfield.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/auth/login.dart';
import 'package:uas_flutter/utils/size_config.dart';

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

  void homeNavigator() => Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (_) => const Myhomepage()));

  Future<void> signUp() async {
    final signProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      await signProvider.signUp(
        usernameController.text,
        emailController.text,
        dobController.text,
        phoneNumberController.text,
        passwordController.text,
      );
      // Show a success dialog or a message before navigating to the login page
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account created successfully!')),
      );
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, Myhomepage.routeName);
      });
    } catch (e) {
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
                  GestureDetector(
                    onTap: () async {
                      await _selectDate();
                    },
                    child: AbsorbPointer(
                      child: TextFieldWidget(
                        controller: dobController,
                        keyboardType: TextInputType.datetime,
                        title: AppConstants.dateOfBirth,
                        hintText: 'ex. MM/DD/YYYY',
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
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(10)),
                  // Phone Number
                  PhoneNumberFieldWidget(
                    title: AppConstants.phoneNumber,
                    controller: phoneNumberController,
                    validator: (value) {
                      if (value == null || value.number.isEmpty) {
                        return 'Phone number cannot be empty';
                      }
                      if (!RegExp(r'^\+?[0-9]{10,13}$')
                          .hasMatch(value.number)) {
                        return 'Enter a valid phone number with 10-13 digits';
                      }
                      return null;
                    },
                  ),
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
                      List<String> errorMessages = [];
                      if (value == null || value.isEmpty) {
                        errorMessages.add('Password cannot be empty');
                      } else {
                        if (value.length < 8 || value.length > 20) {
                          errorMessages
                              .add('Password must be between 8-20 characters');
                        }
                        if (!RegExp(r'[A-Z]').hasMatch(value)) {
                          errorMessages.add(
                              'Password must contain at least one uppercase letter');
                        }
                        if (!RegExp(r'[a-z]').hasMatch(value)) {
                          errorMessages.add(
                              'Password must contain at least one lowercase letter');
                        }
                        if (!RegExp(r'\d').hasMatch(value)) {
                          errorMessages
                              .add('Password must contain at least one number');
                        }
                        if (!RegExp(r'[@$!%?&]').hasMatch(value)) {
                          errorMessages.add(
                              'Password must contain at least one special character (@, !, %, ?, &)');
                        }
                      }
                      if (errorMessages.isNotEmpty) {
                        return errorMessages.join('\n');
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
                          if (_formKey.currentState!.validate()) {
                            signUp();
                          }
                        },
                        child: Text(
                          AppConstants.signUp,
                          style: TextStyle(
                            fontFamily: AppConstants.fontInterRegular,
                            fontSize: getProportionateScreenWidth(15),
                            fontWeight: FontWeight.bold,
                            color: AppConstants.clrBackground,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppConstants.alreadyHaveAccount,
                        style: TextStyle(
                          color: AppConstants.greyColor,
                          fontFamily: AppConstants.fontInterRegular,
                          fontSize: getProportionateScreenWidth(13),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const Text.rich(
                        TextSpan(
                          text: " ",
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, LoginScreen.routeName);
                        },
                        child: Text(
                          AppConstants.login,
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(14),
                            fontWeight: FontWeight.bold,
                            color: AppConstants.mainColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Function for selecting Date of Birth
  _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        dobController.text =
            "${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }
}
