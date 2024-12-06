import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:andromeda/old-core/core.dart';

extension TextStyleExtensions on TextStyle {
  TextStyle override({
    String? fontFamily,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    FontStyle? fontStyle,
    bool useGoogleFonts = true,
    TextDecoration? decoration,
    double? lineHeight,
  }) =>
      useGoogleFonts
          ? GoogleFonts.getFont(
        fontFamily ?? AppConfig.defaultFontFamily,
        color: color ?? this.color,
        fontSize: fontSize ?? this.fontSize,
        letterSpacing: letterSpacing ?? this.letterSpacing,
        fontWeight: fontWeight ?? this.fontWeight,
        fontStyle: fontStyle ?? this.fontStyle,
        decoration: decoration,
        height: lineHeight,
      )
          : copyWith(
        fontFamily: fontFamily,
        color: color,
        fontSize: fontSize,
        letterSpacing: letterSpacing,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        decoration: decoration,
        height: lineHeight,
      );
}
