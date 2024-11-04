import 'package:flutter/material.dart';
import 'package:uas_flutter/Home/home_page.dart';
import 'package:uas_flutter/auth/login.dart';
import 'package:uas_flutter/auth/signup.dart';
import 'package:uas_flutter/Search/search_page.dart';
import 'package:uas_flutter/Wishlist/WishlistPage.dart';
import 'package:uas_flutter/settings/settings_page.dart';

final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName:(context) => const LoginScreen(),
  SignUpScreen.routeName:(context) => const SignUpScreen(),
  Myhomepage.routeName:(context) => const Myhomepage(),
  WishlistPage.routeName:(context) => const WishlistPage(),
  SettingsPage.routeName:(context) => const SettingsPage(),
};
