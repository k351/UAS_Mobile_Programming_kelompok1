import 'package:flutter/material.dart';

class Searchpage extends StatelessWidget {
  const Searchpage ({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: const Center(
        child: Text("Welcome to Home Page"),
      ),
    );
  }
}