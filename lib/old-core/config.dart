import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:andromeda/old-core/core.dart';

class AppConfig {
  static bool useApiUser = false;
  static bool apiDebugMode = true;
  static bool devMode = true;

  // --- EspoCRM API key
  static String espoApiKey = '824db2f6e24a5d326b6558a35daeb7b8';
  static String testingEspoApiKey = '92694e96a4e76be5a06bd97d2a5ae7b3';
  static String get apiKey => devMode ? testingEspoApiKey : espoApiKey;

  // --- EspoCRM Site Port
  static String get sitePort => devMode ? ':4004' : ':443';
  static String get wsPort => devMode ? ':9999' : '';

  // --- EspoCRM Site Domain
  static String espoSiteDomain = 'artspect.deverp.cz';
  static String testingSiteDomain = '192.168.178.36';
  static String get siteDomain => devMode ? testingSiteDomain : espoSiteDomain;

  // --- EspoCRM Site URL
  static String espoSiteUrl = 'https://$espoSiteDomain$sitePort/';
  static String testingSiteUrl = 'http://$testingSiteDomain$sitePort/';
  static String get siteUrl => devMode ? testingSiteUrl : espoSiteUrl;

  // --- EspoCRM API URL
  static String espoApiUrl = 'https://$espoSiteDomain$sitePort/api/v1/';
  static String testingApiUrl = 'http://$testingSiteDomain$sitePort/api/v1/';
  static String get apiUrl => devMode ? testingApiUrl : espoApiUrl;

  // --- EspoCRM WebSocket URL
  static String espoWSUrl = 'wss://$espoSiteDomain$wsPort/wss';
  static String testingWSUrl = 'ws://$testingSiteDomain$wsPort/';
  static String get wsUrl => devMode ? testingWSUrl : espoWSUrl;

  // --- EspoCRM Login
  static String espoTestUsername = 'app';
  static String espoTestPassword = 'PvT99mUj7XAdmVBiw19fsoFqy72r04QiJdj4fJ52';

  // --- Main
  static String appTitle = 'Andromda';
  static String appName = 'artspect';
  static String appId = 'SomeIdHereeee';

  // --- Storage
  static String defaultApiUserStorageKey = 'apiUser';
  static String defaultAppUserStorageKey = 'espoUser';
  static String defaultEspoMetadataStorageKey = 'EspoMetadata';
  static StorageService defaultLoginStorage = SecuredStorageService.instance;
  static StorageService defaultDataStorage = SecuredStorageService.instance;

  // --- Common
  static String defaultLanguage = 'cs_CZ';
  static List<String> defaultSupportedLanguages = ['cs_CZ', 'uk_UA'];
  static const splashScreenDuration = 3000;
  static Brightness defaultBrightness = Brightness.dark;

  static String currentLanguage = defaultLanguage;
  static String defaultFontFamily = 'Roboto';

  static List<Permission> requiredPermissions = [
    Permission.storage,
    Permission.camera,
    Permission.microphone,
    Permission.locationWhenInUse,
  ];

  // --- Themes
  // static CoreTheme lightTheme = CoreLightTheme().override(
  //   // You can override light theme here
  // );

  // static CoreTheme darkTheme = CoreDarkTheme().override(
  //   // You can override dark theme here
  // );

  // --- Database
  static bool useDatabase = false;
  static Directory? defaultDatabaseDirectory;
  static String defaultDatabaseFile = 'app.db';
  static String? defaultDatabasePath;

  // --- Init
  static Future<void> init() async {
    defaultDatabaseDirectory = await getApplicationDocumentsDirectory();
    defaultDatabasePath = join(defaultDatabaseDirectory!.path, defaultDatabaseFile);
  }

  // Default translations
  // Language data
  static Map<String, Map<String, String>> defaultTranslations = {
    'cs_CZ': {
      'login-label-username': 'Uživatelské jméno',
      'login-label-password': 'Heslo',
      'login-button-login': 'Přihlásit se',
      'core-field-required': 'Povinné pole',
      'core-field-invalid': 'Neplatná hodnota',
      'core-fill-password': 'Vyplňte heslo',
    },
    'en_US': {
      'login-label-username': 'Username',
      'login-label-password': 'Password',
      'login-button-login': 'Login',
      'core-field-required': 'Required field',
      'core-field-invalid': 'Invalid value',
      'core-fill-password': 'Fill in password',
    },
  };
}