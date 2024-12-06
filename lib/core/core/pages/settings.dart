import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:country_flags/country_flags.dart';

class AndromedaSettingsPage extends StatefulWidget {
  const AndromedaSettingsPage({super.key});

  @override
  State<AndromedaSettingsPage> createState() => _AndromedaSettingsPageState();
}

class _AndromedaSettingsPageState extends State<AndromedaSettingsPage> {
  TranslationManager get translations => TranslationManager();

  Map<String, String> get langs => TranslationManager.supportedLanguages;
  ThemeMode get themeMode => context.watch<ThemeManager>().currentTheme;
  String get themeName => themeMode == ThemeMode.system
      ? tr('sys-system-theme')
      : themeMode == ThemeMode.light
          ? tr('sys-light-theme')
          : tr('sys-dark-theme');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('main-settings')),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(tr('sys-language')),
            subtitle: Text(
              langs[translations.getCurrentLanguage()] ??
              langs[TranslationManager.defaultLanguage] ?? 'Unknown',
            ),
            leading: const Icon(Icons.language),
            onTap: () => _showLanguageSelection(),
          ),
          ListTile(
            title: Text(tr('sys-theme')),
            subtitle: Text(themeName),
            leading: const Icon(Icons.brightness_4),
            onTap: () => _showThemeSelection(),
          ),
        ],
      ),
    );
  }

  void _showLanguageSelection() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(tr('sys-language')),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: langs.length,
              itemBuilder: (BuildContext context, int index) {
                final code = langs.keys.toList()[index];
                return ListTile(
                  title: Text(langs[code]!),
                  leading: CountryFlag.fromLanguageCode(code),
                  onTap: () async {
                    await translations.setLanguage(code);
                    if (mounted) setState(() {});
                    if (context.mounted) Navigator.pop(context);
                  },
                  trailing: code == translations.getCurrentLanguage()
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showThemeSelection() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(tr('sys-theme')),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(tr('sys-system-theme')),
                  leading: const Icon(Icons.brightness_auto),
                  onTap: () {
                    ThemeManager().setTheme(ThemeMode.system);
                    Navigator.pop(context);
                  },
                  trailing: context.watch<ThemeManager>().currentTheme == ThemeMode.system
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                ),
                ListTile(
                  title: Text(tr('sys-light-theme')),
                  leading: const Icon(Icons.light_mode),
                  onTap: () {
                    ThemeManager().setTheme(ThemeMode.light);
                    Navigator.pop(context);
                  },
                  trailing: context.watch<ThemeManager>().currentTheme == ThemeMode.light
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                ),
                ListTile(
                  title: Text(tr('sys-dark-theme')),
                  leading: const Icon(Icons.dark_mode),
                  onTap: () {
                    ThemeManager().setTheme(ThemeMode.dark);
                    Navigator.pop(context);
                  },
                  trailing: context.watch<ThemeManager>().currentTheme == ThemeMode.dark
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}