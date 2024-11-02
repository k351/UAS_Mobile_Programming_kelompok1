import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/size_config.dart';
import 'package:uas_flutter/textField.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static String routeName = "/signUpScreen";

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isPassword = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: AppConstants.clrBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          // Fix overflow with SingleChildScrollView
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(15)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
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
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                Text(
                  AppConstants.createAccountText,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: getProportionateScreenWidth(13),
                    fontFamily: AppConstants.fontInterRegular,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                TextFieldWidget(
                  controller: fullNameController,
                  keyboardType: TextInputType.text,
                  title: AppConstants.fullName,
                  hintText: 'Enter full name',
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                TextFieldWidget(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  title: AppConstants.email,
                  hintText: 'Enter your email',
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                TextFieldWidget(
                  controller: dobController,
                  keyboardType: TextInputType.datetime,
                  title: AppConstants.dateOfBirth,
                  hintText: 'ex. 06/09/2005',
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
                TextFieldWidget(
                  controller: phoneNumberController,
                  keyboardType: TextInputType.phone,
                  title: AppConstants.phoneNumber,
                  hintText: 'ex. 089623244972',
                  textInputAction: TextInputAction.next,
                ),
                SizedBox(
                  height: getProportionateScreenHeight(10),
                ),
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
                      isPassword ? Icons.visibility : Icons.visibility_off,
                      color: AppConstants.clrBlack,
                    ),
                  ),
                  obscure: isPassword ? true : false,
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                Container(
                  width: getProportionateScreenWidth(340),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: BoxDecoration(
                    color: AppConstants.mainColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Center(
                    child: Text(
                      AppConstants.signUp,
                      style: TextStyle(
                          fontFamily: AppConstants.fontInterMedium,
                          color: AppConstants.clrBackground,
                          fontSize: getProportionateScreenWidth(16)),
                    ),
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),
                GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, '/login'), // Adjust route
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                          text: AppConstants.alreadyHaveAccount,
                          style: TextStyle(color: AppConstants.clrBlack),
                          children: [
                            TextSpan(
                              text: " ",
                            ),
                            TextSpan(
                              text: AppConstants.login,
                              style: TextStyle(color: AppConstants.textBlue),
                            )
                          ]),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
