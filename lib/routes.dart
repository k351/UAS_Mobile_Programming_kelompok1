import 'package:flutter/material.dart';
import 'package:uas_flutter/login/login.dart';
import 'package:uas_flutter/login/signup.dart';
import 'package:uas_flutter/Home/HomePage.dart';
import 'package:uas_flutter/Search/SearchPage.dart';
import 'package:uas_flutter/settings/SettingsPage.dart';

final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName: (context) => LoginScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  Myhomepage.routeName: (context) => Myhomepage(),
  Searchpage.routeName: (context) => Searchpage(),
  SettingsPage.routeName: (context) => SettingsPage(),
};