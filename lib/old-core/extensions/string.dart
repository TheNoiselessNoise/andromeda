import 'package:flutter/material.dart';

extension StringExtensions on String {
  String format(dynamic args) {
    if (args is List) {
      String result = this;
      for (int i = 0; i < args.length; i++) {
        result = result.replaceAll('{$i}', args[i].toString());
      }
      return result;
    }

    if (args is Map) {
      String result = this;
      args.forEach((key, value) {
        result = result.replaceAll('{$key}', value.toString());
      });
      return result;
    }

    return this;
  }

  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String toCamelCase() {
    return split(' ').map((String word) => word.capitalize()).join('');
  }

  String toSnakeCase() {
    return split(' ').map((String word) => word.toLowerCase()).join('_');
  }

  Image toImage() {
    return Image.asset(this);
  }

  String truncate({int? maxChars, String replacement = ''}) =>
    maxChars != null && length > maxChars
      ? replaceRange(maxChars, null, replacement)
      : this;

  Locale toLocale() {
    List<String> parts = split('_');
    return Locale(parts[0], parts.length > 1 ? parts[1] : '');
  }
}