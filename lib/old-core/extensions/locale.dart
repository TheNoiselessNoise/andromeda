import 'package:flutter/material.dart';

extension LocaleExtensions on Locale {
  String toLocaleString() {
    if (countryCode == null){
      return languageCode;
    }
    return "${languageCode}_${countryCode!}";
  }
}