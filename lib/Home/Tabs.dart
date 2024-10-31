import 'package:flutter/material.dart';

class AppTabs extends StatelessWidget {
  final String text;

  const AppTabs({ 
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 50,
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w700),
      ),
    );
  }
}
