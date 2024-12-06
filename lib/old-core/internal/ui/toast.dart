import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:andromeda/old-core/core.dart';

class CoreToast {
  static void show(String message, {
    Toast toastLength = Toast.LENGTH_SHORT,
    int timeInSecForIosWeb = 1,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Color backgroundColor = Colors.black,
    Color textColor = Colors.white,
    double fontSize = 16.0,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      timeInSecForIosWeb: timeInSecForIosWeb,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
    );
  }

  static void translated(String key, {
    Toast toastLength = Toast.LENGTH_SHORT,
    int timeInSecForIosWeb = 1,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Color backgroundColor = Colors.black,
    Color textColor = Colors.white,
    double fontSize = 16.0,
  }) {
    show(I18n.translate(key),
      toastLength: toastLength,
      timeInSecForIosWeb: timeInSecForIosWeb,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
    );
  }

  static void cancel() {
    Fluttertoast.cancel();
  }
}