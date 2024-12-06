import 'package:http/http.dart' as http;
import 'package:andromeda/old-core/core.dart';

enum LoginResult {
  success,
  failed
}

class EspoLoginData {
  String? username;
  String? password;
  String? authToken;
  String? secretToken;
  http.Response? response;

  static StorageService defaultStorage = AppConfig.defaultLoginStorage;
  static String storageKey = AppConfig.defaultAppUserStorageKey;

  EspoLoginData({
    this.username,
    this.password,
    this.authToken,
    this.secretToken,
    this.response
  });

  bool get isValid {
    return !isStringEmpty(username) && !isStringEmpty(password) &&
        !isStringEmpty(authToken) && !isStringEmpty(secretToken);
  }

  Future<void> toStorage([StorageService? storage]) async {
    await (storage ?? defaultStorage).setString(storageKey, toJson());
  }

  Future<void> clearFromStorage([StorageService? storage]) async {
    await (storage ?? defaultStorage).delete(storageKey);
  }

  static Future<void> deleteFromStorage([StorageService? storage]) async {
    (await EspoLoginData.fromStorage(storage)).clearFromStorage();
  }

  static Future<EspoLoginData> fromStorage([StorageService? storage]) async {
    final String data = await (storage ?? defaultStorage).getString(storageKey);
    
    if (data.isEmpty) {
      return EspoLoginData();
    }

    Map<String, dynamic> jsonData = jsonDecode(data);

    return EspoLoginData(
      username: mapListWalker(jsonData, 'username'),
      password: mapListWalker(jsonData, 'password'),
      authToken: mapListWalker(jsonData, 'authToken'),
      secretToken: mapListWalker(jsonData, 'secretToken')
    );
  }

  static Future<EspoLoginData> fromResponse(http.Response response) async {
    if (response.statusCode != 200) {
      return EspoLoginData();
    }

    String? authToken = loadJsonAndGet(response.body, 'token');
    String? secretToken;

    if (response.headers.containsKey('set-cookie')) {
      List<String> cookies = response.headers['set-cookie']!.split(';');
      for (String cookie in cookies) {
        if (cookie.contains('auth-token-secret')) {
          secretToken = cookie.split('=')[1];
          break;
        }
      }
    }

    return EspoLoginData(
      authToken: authToken,
      secretToken: secretToken,
      response: response
    );
  }

  EspoLoginData withData(EspoLoginData data) {
    return EspoLoginData(
      username: data.username ?? username,
      password: data.password ?? password,
      authToken: data.authToken ?? authToken,
      secretToken: data.secretToken ?? secretToken,
      response: data.response ?? response
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'authToken': authToken,
      'secretToken': secretToken
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}

class EspoLoginApi {
  static Map<String, String> getApiHeaders() {
    return {
      'Content-Type': 'application/json',
      'X-Universal-App': AppConfig.appName,
      'X-Universal-App-Version': AppInfo.version ?? '0.0.0',
      'X-Universal-App-Id': AppConfig.appId,
      'X-Api-Key': AppConfig.apiKey
    };
  }

  static Future<bool> checkApiConnection() async {
    return (await tryApiLogin()) == LoginResult.success;
  }

  static Future<LoginResult> tryApiLogin() async {
    final response = await requestLoginApiResponse();
    return response.statusCode == 200 ? LoginResult.success : LoginResult.failed;
  }

  static Future<LoginResult> requestApiLogin() async {
    final response = await requestLoginApiResponse();

    if (response.statusCode != 200){
      return LoginResult.failed;
    }

    try {
      await AppConfig.defaultLoginStorage.setString(AppConfig.defaultAppUserStorageKey, response.body);
      return LoginResult.success;
    } catch (e) {
      return LoginResult.failed;
    }
  }

  static Future<http.Response> requestLoginApiResponse() async {
    return await http.get(
      Uri.parse('${AppConfig.apiUrl}App/user'),
      headers: getApiHeaders(),
    );
  }
}

class EspoLoginUser {
  static Future<Map<String, String>> getApiHeaders([EspoLoginData? data]) async {
    data ??= await EspoLoginData.fromStorage();
    if (!data.isValid) return {};
    String username = data.username ?? '';
    String authString = base64Encode(utf8.encode('$username:${data.authToken}'));
    Map<String, String> headers = {
      'Authorization': 'Basic $authString',
      'Espo-Authorization': authString,
      'Espo-Authorization-By-Token': 'true',
      'Cookie': 'auth-token-secret=${data.secretToken}; auth-token=${data.authToken}'
    };
    return headers;
  }

  static Future<Map<String, String>> getLoginHeaders([EspoLoginData? data]) async {
    data ??= await EspoLoginData.fromStorage();
    if (data.username == null || data.password == null) return {};
    String username = data.username ?? '';
    String password = data.password ?? '';
    String authString = base64Encode(utf8.encode('$username:$password'));
    return {
      'Authorization': 'Basic $authString',
      'Espo-Authorization': authString,
      'Espo-Authorization-By-Token': 'false',
      'Espo-Authorization-Create-Token-Secret': 'true'
    };
  }

  static Future<Map<String, String>> getHeaders([EspoLoginData? data]) async {
    data ??= await EspoLoginData.fromStorage();

    if (data.authToken != null && data.secretToken != null) {
      return getApiHeaders(data);
    }

    return getLoginHeaders(data);
  }

  static Future<bool> checkLoggedIn() async {
    return (await tryLogin()) == LoginResult.success;
  }

  static Future<LoginResult> tryLogin() async {
    try {
      EspoLoginData data = await EspoLoginData.fromStorage();
      var response = await requestLoginResponse(data);
      return response.statusCode == 200 ? LoginResult.success : LoginResult.failed;
    } catch (e) {
      return LoginResult.failed;
    }
  }

  static Future<LoginResult> requestLogin([EspoLoginData? data]) async {
    data ??= await EspoLoginData.fromStorage();

    try {
      var responseWithToken = await requestLoginResponse(data);
    
      if (responseWithToken.statusCode != 200){
        return LoginResult.failed;
      }

      EspoLoginData newLoginData = await EspoLoginData.fromResponse(responseWithToken);

      data.withData(newLoginData).toStorage();

      return LoginResult.success;
    } catch (e) {
      return LoginResult.failed;
    }
  }

  static Future<http.Response> requestLoginResponse([EspoLoginData? data]) async {
    data ??= await EspoLoginData.fromStorage();

    return await http.get(
      Uri.parse('${AppConfig.apiUrl}App/user'),
      headers: await getHeaders(data),
    );
  }
}