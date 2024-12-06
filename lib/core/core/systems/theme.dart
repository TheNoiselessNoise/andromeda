import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ThemeManager extends ChangeNotifier {
  static final ThemeManager _instance = ThemeManager._internal();
  factory ThemeManager() => _instance;
  ThemeManager._internal();

  final storage = const FlutterSecureStorage();
  static const String _themeKey = 'selected_theme';
  ThemeMode _currentTheme = ThemeMode.system;

  ThemeMode get currentTheme => _currentTheme;

  Future<void> init() async {
    final savedTheme = await storage.read(key: _themeKey);
    if (savedTheme != null) {
      _currentTheme = ThemeMode.values.firstWhere(
        (e) => e.toString() == savedTheme,
        orElse: () => ThemeMode.system,
      );
      notifyListeners();
    }
  }

  Future<void> setTheme(ThemeMode theme) async {
    await storage.write(key: _themeKey, value: theme.toString());
    _currentTheme = theme;
    notifyListeners();
  }
}