import 'package:flutter/material.dart';

extension WidgetExtensions on Widget {
  Widget padAll(double value) {
    return Padding(
      padding: EdgeInsets.all(value),
      child: this,
    );
  }

  Widget pad([
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0
  ]) {
    return Padding(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: this,
    );
  }
}