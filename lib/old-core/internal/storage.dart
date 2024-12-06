import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  Future<dynamic> getStorage() async {
    throw UnimplementedError();
  }

  Future<String> getString(String key, [String? defaultValue]) async {
    throw UnimplementedError();
  }

  Future<void> setString(String key, String? value) async {
    throw UnimplementedError();
  }

  Future<void> delete(String key) async {
    throw UnimplementedError();
  }
}

class SecuredStorageService extends StorageService {
  static SecuredStorageService? _instance;
  static FlutterSecureStorage? _storage;

  static SecuredStorageService get instance => _instance!;

  SecuredStorageService._();

  @override
  Future<FlutterSecureStorage> getStorage() async {
    // NOTE: autosetup options for other devices
    // READ: https://pub.dev/packages/flutter_secure_storage
    // IOSOptions, LinuxOptions, WindowsOptions, WebOptions, MacOsOptions

    return _storage ??= const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true
      )
    );
  }

  @override
  Future<String> getString(String key, [String? defaultValue]) async {
    return await _storage?.read(key: key) ?? defaultValue ?? '';
  }

  @override
  Future<void> setString(String key, String? value) async {
    await _storage?.write(key: key, value: value);
  }

  @override
  Future<void> delete(String key) async {
    await _storage?.delete(key: key);
  }

  static Future<void> init() async {
    _instance ??= SecuredStorageService._();
    _storage ??= await _instance?.getStorage();
  }
}

class SharedStorageService extends StorageService {
  static SharedStorageService? _instance;

  static SharedStorageService get instance => _instance!;

  static SharedPreferences? _storage;

  SharedStorageService._();

  @override
  Future<SharedPreferences> getStorage() async {
    return _storage ?? await SharedPreferences.getInstance();
  }

  @override
  Future<String> getString(String key, [String? defaultValue]) async {
    return _storage?.getString(key) ?? defaultValue ?? '';
  }

  @override
  Future<void> setString(String key, String? value) async {
    if (value != null) {
      _storage?.setString(key, value);
    } else {
      _storage?.remove(key);
    }
  }

  @override
  Future<void> delete(String key) async {
    _storage?.remove(key);
  }

  static Future<void> init() async {
    _instance ??= SharedStorageService._();
    _storage ??= await _instance?.getStorage();
  }
}