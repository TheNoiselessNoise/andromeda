import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

class CoreSnackbar {
  static void advanced(BuildContext context, String message, {
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 3),
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    Color backgroundColor = Colors.black,
    Color textColor = Colors.white,
    double fontSize = 16.0
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: textColor, fontSize: fontSize)),
        action: action,
        duration: duration,
        behavior: behavior,
        backgroundColor: backgroundColor
      ),
    );
  }

  static void basic(BuildContext context, String message, [int duration = 2]){
    if(context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: Duration(seconds: duration),
          showCloseIcon: false
        ),
      );
    }
  }

  static void translated(BuildContext context, String key) {
    basic(context, I18n.translate(key));
  }
}

