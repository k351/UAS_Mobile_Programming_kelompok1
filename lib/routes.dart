import 'package:flutter/material.dart';
import 'package:uas_flutter/login/login.dart';
import 'package:uas_flutter/login/signup.dart';

final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName:(context) => LoginScreen(),
  SignUpScreen.routeName:(context) => SignUpScreen(),
};