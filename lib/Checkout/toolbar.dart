import 'package:flutter/material.dart';
import 'package:uas_flutter/constants.dart';

class Toolbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  const Toolbar({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppConstants.clrBackground,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey, // Color of the divider
            width: 0.5, // Thickness of the divider
          ),
        ),
      ),
      child: AppBar(
        backgroundColor:
            Colors.transparent, // Make AppBar background transparent
        elevation: 0, // Remove elevation
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
