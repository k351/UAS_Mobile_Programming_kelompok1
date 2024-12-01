import 'package:flutter/material.dart';
import 'package:uas_flutter/constants.dart';

class SnackbarUtils {
  static void showSnackbar(BuildContext context, String message,
      {Color backgroundColor = AppConstants.clrBlue,
      Duration duration = const Duration(seconds: 2)}) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        backgroundColor: backgroundColor,
      ),
    );
  }
}