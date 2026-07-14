import 'package:flutter/material.dart';

class Customsnackbar {
  showCustomSnackbar(
    BuildContext context,
    String message, {
    Color bgColor = Colors.green,
  }) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: bgColor));
  }
}
