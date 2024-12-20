import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:andromeda/core/_.dart';

class Storage {
  static FlutterSecureStorage? _instance;

  static FlutterSecureStorage instance() {
    // TODO: some more settings
    _instance ??= const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      )
    );
    return _instance!;
  }

  static Future<void> save(String key, dynamic data) async {
    if (data is Storable) {
      await instance().write(key: key, value: jsonify(data.toJsonMap()));
      return;
    }

    await instance().write(key: key, value: jsonify(data));
  }

  static Future<void> saveDirect(String key, String value) async {
    await instance().write(key: key, value: value);
  }

  static Future<T?> load<T extends MapTraversable>(
    String key,
    T Function(Map data) constructor,
  ) async {
    final String? jsonString = await instance().read(key: key);
    if (jsonString == null) return null;
    
    final dynamic jsonData = unjsonify(jsonString);
    if (jsonData is! Map) return null;

    return constructor(Map<String, dynamic>.from(jsonData));
  }

  static Future<String?> loadDirect(String key) async {
    return await instance().read(key: key);
  }

  static Future<void> delete(String key) async {
    await instance().delete(key: key);
  }

  static Future<void> clear() async {
    await instance().deleteAll();
  }

  static Future<Set<String>> keys() async {
    final Map<String, String> allValues = await instance().readAll();
    return allValues.keys.toSet();
  }

  static Future<bool> exists(String key) async {
    final String? value = await instance().read(key: key);
    return value != null;
  }
}