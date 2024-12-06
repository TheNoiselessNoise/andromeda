// // ignore_for_file: overridden_fields
// // ignore_for_file: annotate_overrides

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:andromeda/config.dart';

// abstract class CoreTheme {
//   static CoreTheme of(BuildContext? context) {
//     Brightness brightness = context == null
//         ? AppConfig.defaultBrightness
//         : Theme.of(context).brightness;

//     return brightness == Brightness.dark
//         ? AppConfig.darkTheme
//         : AppConfig.lightTheme;
//   }

//   Color get primaryColor => primary;
//   Color get secondaryColor => secondary;
//   Color get tertiaryColor => tertiary;

//   late Color primary;
//   late Color secondary;
//   late Color tertiary;
//   late Color alternate;
//   late Color primaryText;
//   late Color secondaryText;
//   late Color primaryBackground;
//   late Color secondaryBackground;
//   late Color accent1;
//   late Color accent2;
//   late Color accent3;
//   late Color accent4;
//   late Color success;
//   late Color warning;
//   late Color error;
//   late Color info;

//   late Color primaryBtnText;
//   late Color lineColor;

//   String get title1Family => displaySmallFamily;
//   TextStyle get title1 => typography.displaySmall;
//   String get title2Family => typography.headlineMediumFamily;
//   TextStyle get title2 => typography.headlineMedium;
//   String get title3Family => typography.headlineSmallFamily;
//   TextStyle get title3 => typography.headlineSmall;
//   String get subtitle1Family => typography.titleMediumFamily;
//   TextStyle get subtitle1 => typography.titleMedium;
//   String get subtitle2Family => typography.titleSmallFamily;
//   TextStyle get subtitle2 => typography.titleSmall;
//   String get bodyText1Family => typography.bodyMediumFamily;
//   TextStyle get bodyText1 => typography.bodyMedium;
//   String get bodyText2Family => typography.bodySmallFamily;
//   TextStyle get bodyText2 => typography.bodySmall;

//   String get displayLargeFamily => typography.displayLargeFamily;
//   TextStyle get displayLarge => typography.displayLarge;
//   String get displayMediumFamily => typography.displayMediumFamily;
//   TextStyle get displayMedium => typography.displayMedium;
//   String get displaySmallFamily => typography.displaySmallFamily;
//   TextStyle get displaySmall => typography.displaySmall;
//   String get headlineLargeFamily => typography.headlineLargeFamily;
//   TextStyle get headlineLarge => typography.headlineLarge;
//   String get headlineMediumFamily => typography.headlineMediumFamily;
//   TextStyle get headlineMedium => typography.headlineMedium;
//   String get headlineSmallFamily => typography.headlineSmallFamily;
//   TextStyle get headlineSmall => typography.headlineSmall;
//   String get titleLargeFamily => typography.titleLargeFamily;
//   TextStyle get titleLarge => typography.titleLarge;
//   String get titleMediumFamily => typography.titleMediumFamily;
//   TextStyle get titleMedium => typography.titleMedium;
//   String get titleSmallFamily => typography.titleSmallFamily;
//   TextStyle get titleSmall => typography.titleSmall;
//   String get labelLargeFamily => typography.labelLargeFamily;
//   TextStyle get labelLarge => typography.labelLarge;
//   String get labelMediumFamily => typography.labelMediumFamily;
//   TextStyle get labelMedium => typography.labelMedium;
//   String get labelSmallFamily => typography.labelSmallFamily;
//   TextStyle get labelSmall => typography.labelSmall;
//   String get bodyLargeFamily => typography.bodyLargeFamily;
//   TextStyle get bodyLarge => typography.bodyLarge;
//   String get bodyMediumFamily => typography.bodyMediumFamily;
//   TextStyle get bodyMedium => typography.bodyMedium;
//   String get bodySmallFamily => typography.bodySmallFamily;
//   TextStyle get bodySmall => typography.bodySmall;

//   CoreTypography get typography => CoreThemeTypography(this);
// }

// class CoreLightTheme extends CoreTheme {
//   late Color primary = const Color(0xFF4B39EF);
//   late Color secondary = const Color(0xFF39D2C0);
//   late Color tertiary = const Color(0xFFEE8B60);
//   late Color alternate = const Color(0xFFE0E3E7);
//   late Color primaryText = const Color(0xFF14181B);
//   late Color secondaryText = const Color(0xFF57636C);
//   late Color primaryBackground = const Color(0xFFFFFFFF);
//   late Color secondaryBackground = const Color(0xFFD0D0D0);
//   late Color accent1 = const Color(0x4C4B39EF);
//   late Color accent2 = const Color(0x4D39D2C0);
//   late Color accent3 = const Color(0x4DEE8B60);
//   late Color accent4 = const Color(0xCCFFFFFF);
//   late Color success = const Color(0xFF249689);
//   late Color warning = const Color(0xFFF9CF58);
//   late Color error = const Color(0xFFFF5963);
//   late Color info = const Color(0xFFFFFFFF);

//   late Color primaryBtnText = const Color(0xFFFFFFFF);
//   late Color lineColor = const Color(0xFFE0E3E7);
// }

// class CoreDarkTheme extends CoreTheme {
//   @override
//   Color get primaryColor => primary;
//   @override
//   Color get secondaryColor => secondary;
//   @override
//   Color get tertiaryColor => tertiary;

//   late Color primary = const Color(0xFF4B39EF);
//   late Color secondary = const Color(0xFF39D2C0);
//   late Color tertiary = const Color(0xFFEE8B60);
//   late Color alternate = const Color(0xFF262D34);
//   late Color primaryText = const Color(0xFFFFFFFF);
//   late Color secondaryText = const Color(0xFF95A1AC);
//   late Color primaryBackground = const Color(0xFF1D2428);
//   late Color secondaryBackground = const Color(0xFF14181B);
//   late Color accent1 = const Color(0x4C4B39EF);
//   late Color accent2 = const Color(0x4D39D2C0);
//   late Color accent3 = const Color(0x4DEE8B60);
//   late Color accent4 = const Color(0xB2262D34);
//   late Color success = const Color(0xFF249689);
//   late Color warning = const Color(0xFFF9CF58);
//   late Color error = const Color(0xFFFF5963);
//   late Color info = const Color(0xFFFFFFFF);

//   late Color primaryBtnText = const Color(0xFFFFFFFF);
//   late Color lineColor = const Color(0xFF22282F);
// }

// abstract class CoreTypography {
//   String get displayLargeFamily;
//   TextStyle get displayLarge;
//   String get displayMediumFamily;
//   TextStyle get displayMedium;
//   String get displaySmallFamily;
//   TextStyle get displaySmall;
//   String get headlineLargeFamily;
//   TextStyle get headlineLarge;
//   String get headlineMediumFamily;
//   TextStyle get headlineMedium;
//   String get headlineSmallFamily;
//   TextStyle get headlineSmall;
//   String get titleLargeFamily;
//   TextStyle get titleLarge;
//   String get titleMediumFamily;
//   TextStyle get titleMedium;
//   String get titleSmallFamily;
//   TextStyle get titleSmall;
//   String get labelLargeFamily;
//   TextStyle get labelLarge;
//   String get labelMediumFamily;
//   TextStyle get labelMedium;
//   String get labelSmallFamily;
//   TextStyle get labelSmall;
//   String get bodyLargeFamily;
//   TextStyle get bodyLarge;
//   String get bodyMediumFamily;
//   TextStyle get bodyMedium;
//   String get bodySmallFamily;
//   TextStyle get bodySmall;
// }

// class CoreThemeTypography extends CoreTypography {
//   CoreThemeTypography(this.theme);

//   final CoreTheme theme;

//   String get displayLargeFamily => AppConfig.defaultFontFamily;
//   TextStyle get displayLarge => GoogleFonts.getFont(
//     AppConfig.defaultFontFamily,
//     color: theme.primaryText,
//     fontWeight: FontWeight.normal,
//     fontSize: 64.0,
//   );
//   String get displayMediumFamily => AppConfig.defaultFontFamily;
//   TextStyle get displayMedium => GoogleFonts.getFont(
//     AppConfig.defaultFontFamily,
//     color: theme.primaryText,
//     fontWeight: FontWeight.normal,
//     fontSize: 44.0,
//   );
//   String get displaySmallFamily => AppConfig.defaultFontFamily;
//   TextStyle get displaySmall => GoogleFonts.getFont(
//     AppConfig.defaultFontFamily,
//     color: theme.primaryText,
//     fontWeight: FontWeight.w600,
//     fontSize: 36.0,
//   );
//   String get headlineLargeFamily => AppConfig.defaultFontFamily;
//   TextStyle get headlineLarge => GoogleFonts.getFont(
//     AppConfig.defaultFontFamily,
//     color: theme.primaryText,
//     fontWeight: FontWeight.w600,
//     fontSize: 32.0,
//   );
//   String get headlineMediumFamily => AppConfig.defaultFontFamily;
//   TextStyle get headlineMedium => GoogleFonts.getFont(
//     AppConfig.defaultFontFamily,
//     color: theme.primaryText,
//     fontWeight: FontWeight.normal,
//     fontSize: 24.0,
//   );
//   String get headlineSmallFamily => AppConfig.defaultFontFamily;
//   TextStyle get headlineSmall => GoogleFonts.getFont(
//     AppConfig.defaultFontFamily,
//     color: theme.primaryText,
//     fontWeight: FontWeight.w500,
//     fontSize: 24.0,
//   );
//   String get titleLargeFamily => AppConfig.defaultFontFamily;
//   TextStyle get titleLarge => GoogleFonts.getFont(
//     AppConfig.defaultFontFamily,
//     color: theme.primaryText,
//     fontWeight: FontWeight.w500,
//     fontSize: 22.0,
//   );
//   // NOTE: Outfit -> Roboto


//   String get titleMediumFamily => AppConfig.defaultFontFamily;
//   TextStyle get titleMedium => GoogleFonts.getFont(
//     AppConfig.defaultFontFamily,
//     color: theme.info,
//     fontWeight: FontWeight.normal,
//     fontSize: 18.0,
//   );
//   String get titleSmallFamily => AppConfig.defaultFontFamily;
//   TextStyle get titleSmall => GoogleFonts.getFont(
//     AppConfig.defaultFontFamily,
//     color: theme.info,
//     fontWeight: FontWeight.w500,
//     fontSize: 16.0,
//   );
//   String get labelLargeFamily => AppConfig.defaultFontFamily;
//   TextStyle get labelLarge => GoogleFonts.getFont(
//     AppConfig.defaultFontFamily,
//     color: theme.secondaryText,
//     fontWeight: FontWeight.normal,
//     fontSize: 16.0,
//   );
//   String get labelMediumFamily => AppConfig.defaultFontFamily;
//   TextStyle get labelMedium => GoogleFonts.getFont(
//     AppConfig.defaultFontFamily,
//     color: theme.secondaryText,
//     fontWeight: FontWeight.normal,
//     fontSize: 14.0,
//   );
//   String get labelSmallFamily => AppConfig.defaultFontFamily;
//   TextStyle get labelSmall => GoogleFonts.getFont(
//     AppConfig.defaultFontFamily,
//     color: theme.secondaryText,
//     fontWeight: FontWeight.normal,
//     fontSize: 12.0,
//   );
//   String get bodyLargeFamily => AppConfig.defaultFontFamily;
//   TextStyle get bodyLarge => GoogleFonts.getFont(
//     AppConfig.defaultFontFamily,
//     color: theme.primaryText,
//     fontWeight: FontWeight.normal,
//     fontSize: 16.0,
//   );
//   String get bodyMediumFamily => AppConfig.defaultFontFamily;
//   TextStyle get bodyMedium => GoogleFonts.getFont(
//     AppConfig.defaultFontFamily,
//     color: theme.primaryText,
//     fontWeight: FontWeight.normal,
//     fontSize: 14.0,
//   );
//   String get bodySmallFamily => AppConfig.defaultFontFamily;
//   TextStyle get bodySmall => GoogleFonts.getFont(
//     AppConfig.defaultFontFamily,
//     color: theme.primaryText,
//     fontWeight: FontWeight.normal,
//     fontSize: 12.0,
//   );
// }