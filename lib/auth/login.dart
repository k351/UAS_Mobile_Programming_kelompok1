import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uas_flutter/auth/services/auth_services.dart';
import 'package:uas_flutter/auth/widget/loginsocialfield.dart';
import 'package:uas_flutter/auth/widget/textfield.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/auth/forgotpassword_screen.dart';
import 'package:uas_flutter/auth/signup.dart';
import 'package:uas_flutter/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String routeName = "/loginScreen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isPasswordVisible = false; // State variable to track password visibility

  // Handle login process
  Future<void> _login() async {
    try {
      // Get email and password from the controllers
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      // Sign in with Firebase Authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // If login is successful, navigate to home page
      if (userCredential.user != null) {
        // Replace with your desired route for successful login
        Navigator.pushReplacementNamed(context, '/myhomepage');
      }
    } catch (e) {
      // Handle errors (e.g., incorrect credentials)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed. Please check your credentials.")),
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
          child: Container(
            margin: EdgeInsets.only(
              left: getProportionateScreenWidth(15),
              right: getProportionateScreenWidth(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: getProportionateScreenHeight(20)),
                SvgPicture.asset(
                  AppConstants.imgAppLogo,
                  width: getProportionateScreenWidth(100),
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
                Text(
                  AppConstants.signInTop,
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
                  AppConstants.enterEmailPassText,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: getProportionateScreenWidth(11),
                    fontFamily: AppConstants.fontInterRegular,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(30)),
                // Email Field
                TextFieldWidget(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  title: AppConstants.email,
                  hintText: 'Enter your email here',
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
                SizedBox(height: getProportionateScreenHeight(20)),
                // Password Field with Visibility Toggle
                TextFieldWidget(
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  title: AppConstants.password,
                  obscure: !isPasswordVisible, // Toggle obscure based on state
                  hintText: 'Enter your password here',
                  textInputAction: TextInputAction.done,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                    child: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppConstants.clrBlack,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password cannot be empty';
                    }
                    // Add more validation if needed
                    return null;
                  },
                ),
                SizedBox(height: getProportionateScreenHeight(10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                          context, ForgotPasswordScreen.routeName),
                      child: Text(
                        AppConstants.forgotPassword,
                        style: TextStyle(
                          color: AppConstants.textBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: getProportionateScreenWidth(14),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                GestureDetector(
                  onTap: _login, // Call the login function
                  child: Container(
                    width: getProportionateScreenWidth(350),
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                      color: AppConstants.mainColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Center(
                      child: Text(
                        AppConstants.login,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 150,
                      height: 0.5,
                      color: Colors.grey[400],
                      margin: const EdgeInsets.only(right: 10),
                    ),
                    Text(
                      AppConstants.or,
                      style: TextStyle(
                        fontFamily: AppConstants.fontInterMedium,
                        color: AppConstants.greyColor4,
                        fontSize: getProportionateScreenWidth(13),
                      ),
                    ),
                    Container(
                      width: 150,
                      height: 0.5,
                      color: Colors.grey[400],
                      margin: const EdgeInsets.only(left: 10),
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                // SocialLoginButton(
                //   onTap: () async {
                //     try {
                //       // Sign in with Google
                //       UserCredential userCredential =
                //           await AuthService().signInWithGoogle(context);

                //       // Check if userCredential is not null and has a valid user
                //       if (userCredential.user != null) {
                //         Navigator.pushReplacementNamed(context, '/myhomepage');
                //       } else {
                //         // If userCredential is null, show an error message
                //         ScaffoldMessenger.of(context).showSnackBar(
                //           SnackBar(
                //             content: Text(
                //                 'Google sign-in failed. Please try again.'),
                //           ),
                //         );
                //       }
                //     } catch (e) {
                //       // Catch the exception and show a notification
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         SnackBar(
                //           content:
                //               Text('Google sign-in failed: ${e.toString()}'),
                //         ),
                //       );
                //     }
                //   },
                //   image: AppConstants.imgGoogle,
                //   text: AppConstants.googleLogin,
                // ),
                SizedBox(height: getProportionateScreenHeight(20)),
                SocialLoginButton(
                    onTap: () {},
                    image: AppConstants.imgFacebook,
                    text: AppConstants.facebookLogin),
                SizedBox(height: getProportionateScreenHeight(20)),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: AppConstants.dontHaveAccount,
                      style: const TextStyle(color: AppConstants.clrBlack),
                      children: [
                        const TextSpan(text: " "),
                        TextSpan(
                          text: AppConstants.signUp,
                          style: const TextStyle(
                            color: AppConstants.textBlue,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(
                                  context, SignUpScreen.routeName);
                            },
                        ),
                      ],
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
