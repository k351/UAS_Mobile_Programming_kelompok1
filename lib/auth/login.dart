import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/auth/forgotpassword_screen.dart';
import 'package:uas_flutter/auth/signup.dart';
import 'package:uas_flutter/size_config.dart';
import 'package:uas_flutter/usage/loginsocialfield.dart';
import 'package:uas_flutter/usage/textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String routeName = "/loginScreen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                TextFieldWidget(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  title: AppConstants.email,
                  hintText: 'Enter your email here',
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                TextFieldWidget(
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  title: AppConstants.password,
                  obscure: true,
                  hintText: 'Enter your password here',
                  textInputAction: TextInputAction.done,
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
                          fontSize: getProportionateScreenWidth(14),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                Container(
                  width: getProportionateScreenWidth(350),
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    color: AppConstants.mainColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, '/myhomepage'); // Ubah route ke 'MyHomePage'
                    },
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
                const SocialLoginButton(
                    image: AppConstants.imgGoogle,
                    text: AppConstants.googleLogin),
                SizedBox(height: getProportionateScreenHeight(20)),
                const SocialLoginButton(
                    image: AppConstants.imgFacebook,
                    text: AppConstants.facebookLogin),
                SizedBox(height: getProportionateScreenHeight(20)),
                GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, SignUpScreen.routeName),
                  child: Center(
                    child: RichText(
                      text: const TextSpan(
                        text: AppConstants.dontHaveAccount,
                        style: TextStyle(color: AppConstants.clrBlack),
                        children: [
                          TextSpan(text: " "),
                          TextSpan(
                            text: AppConstants.signUp,
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
    );
  }
}