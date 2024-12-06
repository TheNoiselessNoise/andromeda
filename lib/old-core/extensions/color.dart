import 'package:flutter/material.dart';

extension ColorExtensions on Color {
  Color withAlpha(int alpha) {
    return Color.fromARGB(alpha, red, green, blue);
  }
}