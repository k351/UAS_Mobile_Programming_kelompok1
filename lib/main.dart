import 'package:flutter/material.dart';
import 'package:uas_flutter/Home/home_page.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/login/login.dart';
import 'package:uas_flutter/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Audio Reading',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppConstants.clrBackground,
        fontFamily: "Inter",
        textTheme: const TextTheme(
          bodySmall: TextStyle(color: AppConstants.clrBlack),
          bodyLarge: TextStyle(color: AppConstants.clrBlack),
          bodyMedium: TextStyle(color: AppConstants.clrBlack),
        ),
        primarySwatch: Colors.blue,
      ),
      initialRoute: Myhomepage.routeName,
      routes: routes,
    );
  }
}
