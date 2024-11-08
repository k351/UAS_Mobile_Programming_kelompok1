import 'package:flutter/material.dart';
import 'package:uas_flutter/Home/home_page.dart';
import 'package:uas_flutter/auth/forgotpassword_screen.dart';
import 'package:uas_flutter/auth/login.dart';
import 'package:uas_flutter/auth/signup.dart';
import 'package:uas_flutter/Wishlist/WishlistPage.dart';
import 'package:uas_flutter/products/models/product.dart';
import 'package:uas_flutter/products/product_detail_screen.dart';
import 'package:uas_flutter/settings/settings_page.dart';
import 'package:uas_flutter/Cart/CartPage.dart';

final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName: (context) => const LoginScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  Myhomepage.routeName: (context) => const Myhomepage(),
  WishlistPage.routeName: (context) => const WishlistPage(),
  SettingsPage.routeName: (context) => const SettingsPage(),
  ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
  DetailScreen.routeName: (context) => DetailScreen(product: product[0]),
  Cartpage.routeName: (context) => Cartpage(),
};
