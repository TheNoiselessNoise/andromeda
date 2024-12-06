import 'package:flutter/material.dart';

extension MoreTextValidationExtensions on String? Function(BuildContext, String?)? {
  String? Function(String?)? useValidator(BuildContext context) {
    if (this == null) {
      return null;
    }
    return (value) {
      return this!(context, value);
    };
  }
}

extension TextExtensions on Text {
  Text bold([FontWeight? weight]) {
    return Text(
      data ?? '',
      style: TextStyle(
        fontWeight: weight ?? FontWeight.bold,
      ),
    );
  }
}