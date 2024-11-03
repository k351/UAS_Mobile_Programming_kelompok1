import 'package:flutter/material.dart';
import 'package:uas_flutter/Home/home_page.dart';
import 'package:uas_flutter/login/login.dart';
import 'package:uas_flutter/login/signup.dart';

final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName:(context) => const LoginScreen(),
  SignUpScreen.routeName:(context) => const SignUpScreen(),
  Myhomepage.routeName:(context) => const Myhomepage(),
};