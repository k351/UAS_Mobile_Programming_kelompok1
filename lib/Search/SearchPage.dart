import 'package:flutter/material.dart';

class Searchpage extends StatelessWidget {
  static const String routeName = '/search';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: Center(
        child: Text("Welcome to Home Page"),
      ),
    );
  }
}
