import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:andromeda/old-core/core.dart';

// NOTE: for now, I18n class only works with AppConfig.defaultTranslations
class I18n {
  I18n(this.locale);
  final Locale locale;

  // Map<LanguageCode, Map<Key, Value>>
  static final Map<String, Map<String, String>> _localizedValues = AppConfig.defaultTranslations;

  static List<String> languages() => _localizedValues.keys.toList();

  static String translate(String key) {
    return _localizedValues[AppConfig.currentLanguage]?[key] ?? '![$key]';
  }

  static Text text(String key, {TextStyle? style}) {
    return Text(
      translate(key),
      style: style,
    );
  }

  // NOTE: not for now
  // Future<void> loadJson() async {
  //   String jsonString = await rootBundle.loadString('locale/${locale.languageCode}.json');
  //   Map<String, dynamic> jsonMap = json.decode(jsonString);
  //   _localizedValues[locale.languageCode].addAll(Map<String, String>.from(jsonMap));
  // }

  static Future<void> init() async {
    // NOTE: nothing?
  }

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('cs'),
    Locale('cs', 'CZ'),
  ];

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    I18nDelegate(),
  ];

  static Locale? localeResolutionCallback(
      Locale? locale, Iterable<Locale> supportedLocales) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale?.languageCode &&
          supportedLocale.countryCode == locale?.countryCode) {
        return supportedLocale;
      }
    }
    return supportedLocales.first;
  }
}

class I18nDelegate extends LocalizationsDelegate<I18n> {
  const I18nDelegate();

  @override
  bool isSupported(Locale locale) =>
      I18n.languages().contains(locale.languageCode) ||
      (locale.languageCode == 'cs' && locale.countryCode == 'CZ');

  @override
  Future<I18n> load(Locale locale) {
    return SynchronousFuture<I18n>(I18n(locale));
  }

  @override
  bool shouldReload(I18nDelegate old) => false;
}
