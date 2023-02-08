import 'package:flutter/material.dart';

extension NPSSnackBar on BuildContext {
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(
        message,
        //style: headlineMedium?.copyWith(color: Colors.white),
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.red,
    ));
  }
}
