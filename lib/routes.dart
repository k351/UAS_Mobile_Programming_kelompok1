import 'package:flutter/material.dart';
import 'package:uas_flutter/Home/home_page.dart';
import 'package:uas_flutter/auth/login.dart';
import 'package:uas_flutter/auth/signup.dart';
import 'package:uas_flutter/Search/search_page.dart';
import 'package:uas_flutter/settings/settings_page.dart';

final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName: (context) => LoginScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  Myhomepage.routeName: (context) => Myhomepage(),
  Searchpage.routeName: (context) => Searchpage(),
  SettingsPage.routeName: (context) => SettingsPage(),
};
