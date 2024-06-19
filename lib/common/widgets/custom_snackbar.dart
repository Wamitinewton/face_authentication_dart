import 'package:face_auth/common/utils/theme.dart';
import 'package:flutter/material.dart';

class CustomSnackbar {
  static late BuildContext context;

  static errorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Theme.of(context).colorScheme.error,
      behavior: SnackBarBehavior.floating,
    ));
  }

  static successSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: kSeaGreen,
      behavior: SnackBarBehavior.floating,
    ));
  }
}
