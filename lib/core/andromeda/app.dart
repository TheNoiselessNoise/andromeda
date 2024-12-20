import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:andromeda/core/_.dart';

class AndromedaApp extends StatelessWidget {
  final Widget initialPage;

  const AndromedaApp({
    super.key,
    required this.initialPage,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<TranslationManager, ThemeManager>(
      builder: (context, translations, theme, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Andromeda',
          locale: translations.currentLocale,
          themeMode: theme.currentTheme,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.light,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.dark,
            useMaterial3: true,
          ),
          home: initialPage,
        );
      },
    );
  }
}