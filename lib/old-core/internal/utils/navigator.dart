import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

class CoreNavigator {
  static void pop<T>(BuildContext context, [T? returnValue]) {
    Navigator.of(context).pop(returnValue);
  }

  static void popLast<T>(BuildContext context, [T? returnValue, bool rootNavigator = true]) {
    Navigator.of(context, rootNavigator: rootNavigator).pop(returnValue);
  }

  static Future<T?> pushAndReturn<T>(BuildContext context, Widget widget) async {
    return await Navigator.push<T>(context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );
  }

  static void until(BuildContext context, Widget widget, {
    PageTransitionType type = PageTransitionType.rightToLeft,
    int duration = 200,
    int reverseDuration = 200
  }) {
    Navigator.pushAndRemoveUntil(context,
      PageTransition(
        type: type,
        duration: Duration(milliseconds: duration),
        reverseDuration: Duration(milliseconds: reverseDuration),
        child: widget,
      ), (route) => false
    );
  }

  static void to(BuildContext context, Widget widget, {
    PageTransitionType type = PageTransitionType.rightToLeft,
    int duration = 200,
    int reverseDuration = 200,
    bool replace = false
  }) {
    if (replace) {
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: type,
          duration: Duration(milliseconds: duration),
          reverseDuration: Duration(milliseconds: reverseDuration),
          child: widget,
        ),
      );
    } else {
      Navigator.push(
        context,
        PageTransition(
          type: type,
          duration: Duration(milliseconds: duration),
          reverseDuration: Duration(milliseconds: reverseDuration),
          child: widget,
        ),
      );
    }
  }
}