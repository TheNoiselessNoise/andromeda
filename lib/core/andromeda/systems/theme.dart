import 'package:flutter/material.dart';
import 'package:andromeda/core/_.dart';

class ThemeManager extends ChangeNotifier {
  static final ThemeManager _instance = ThemeManager._internal();
  factory ThemeManager() => _instance;
  ThemeManager._internal();

  static const String _themeKey = 'selected_theme';
  ThemeMode _currentTheme = ThemeMode.system;

  ThemeMode get currentTheme => _currentTheme;

  Future<void> init() async {
    final savedTheme = await Storage.loadDirect(_themeKey);
    if (savedTheme != null) {
      _currentTheme = ThemeMode.values.firstWhere(
        (e) => e.toString() == savedTheme,
        orElse: () => ThemeMode.system,
      );
      notifyListeners();
    }
  }

  Future<void> setTheme(ThemeMode theme) async {
    await Storage.saveDirect(_themeKey, theme.toString());
    _currentTheme = theme;
    notifyListeners();
  }
}