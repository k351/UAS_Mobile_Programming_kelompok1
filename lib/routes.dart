import 'package:flutter/material.dart';
import 'package:uas_flutter/Checkout/checkout_page.dart';
import 'package:uas_flutter/Checkout/payment_page.dart';
import 'package:uas_flutter/Home/home_page.dart';
import 'package:uas_flutter/auth/forgotpassword_screen.dart';
import 'package:uas_flutter/auth/login.dart';
import 'package:uas_flutter/auth/signup.dart';
import 'package:uas_flutter/Wishlist/WishlistPage.dart';
import 'package:uas_flutter/history/history_page.dart';
import 'package:uas_flutter/products/models/product.dart';
import 'package:uas_flutter/products/product_detail_screen.dart';
import 'package:uas_flutter/settings/edit_profile.dart';
import 'package:uas_flutter/settings/my_address_page.dart';
import 'package:uas_flutter/settings/notification/email_notif.dart';
import 'package:uas_flutter/settings/notification/notification_page.dart';
import 'package:uas_flutter/settings/notification/push_notif.dart';
import 'package:uas_flutter/settings/settings_page.dart';
import 'package:uas_flutter/Cart/cartpage.dart';

final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName: (context) => const LoginScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  Myhomepage.routeName: (context) => const Myhomepage(),
  WishlistPage.routeName: (context) => const WishlistPage(),
  SettingsPage.routeName: (context) => const SettingsPage(),
  ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
  DetailScreen.routeName: (context) {
    final args = ModalRoute.of(context)!.settings.arguments as Product;
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    return DetailScreen(
      product: args,
      productId: productId,
    );
  },
  Cartpage.routeName: (context) => Cartpage(),
  HistoryPage.routeName: (context) => const HistoryPage(),
  CheckoutPage.routeName: (context) => const CheckoutPage(),
  PaymentPage.routeName: (context) => const PaymentPage(),
  EditProfilePage.routeName: (context) => const EditProfilePage(),
  MyAddressesPage.routeName: (context) => const MyAddressesPage(),
  NotificationPage.routeName: (context) => NotificationPage(),
  PushNotificationPage.routeName: (context) => const PushNotificationPage(),
  EmailNotificationPage.routeName: (context) => const EmailNotificationPage(),
};
