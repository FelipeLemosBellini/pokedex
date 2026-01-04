import 'package:flutter/material.dart';

abstract class CustomSnackBar {
  static void openSnackBar({
    required BuildContext context,
    String? message,
  }) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? 'Houve um erro'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
