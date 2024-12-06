import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:andromeda/old-core/core.dart';

class RequestType {
  static const String get = 'GET';
  static const String post = 'POST';
  static const String put = 'PUT';
  static const String head = 'HEAD';
  static const String delete = 'DELETE';
  static const String patch = 'PATCH';
}

class EspoApiPoints {
  static const String metadata = 'UniversalAppManager/metadata';
  static const String metadataLength = 'UniversalAppManager/metadataLength';
}

class EspoHttpClient {
  static Future<http.Response?> head(Uri url, {
    Map<String, String>? headers,
    int timeout = 5000
  }) async {
    return await http.head(url,
      headers: headers,
    ).timeout(Duration(milliseconds: timeout));
  }

  static Future<http.Response?> patch(Uri url, {
    String? data,
    Map<String, String>? headers,
    int timeout = 5000,
    Encoding? encoding
  }) async {
    return await http.patch(url,
      headers: headers,
      body: data,
      encoding: encoding ?? Encoding.getByName('UTF-8')
    ).timeout(Duration(milliseconds: timeout));
  }

  static Future<http.Response?> delete(Uri url, {
    String? data,
    Map<String, String>? headers,
    int timeout = 5000,
    Encoding? encoding
  }) async {
    return await http.delete(url,
      headers: headers,
      body: data,
      encoding: encoding ?? Encoding.getByName('UTF-8')
    ).timeout(Duration(milliseconds: timeout));
  }

  static Future<http.Response?> post(Uri url, {
    String? data,
    Map<String, String>? headers,
    int timeout = 5000
  }) async {
    return await http.post(url,
      headers: headers,
      body: data,
    ).timeout(Duration(milliseconds: timeout));
  }

  static Future<http.Response> get(Uri url, {
    Map<String, String>? headers,
    int timeout = 5000
  }) async {
    return await http.get(url,
      headers: headers,
    ).timeout(Duration(milliseconds: timeout));
  }

  static Future<http.Response?> put(Uri url, {
    String? data,
    Map<String, String>? headers,
    int timeout = 5000
  }) async {
    return await http.put(url,
      headers: headers,
      body: data,
    ).timeout(Duration(milliseconds: timeout));
  }

  static Future<http.StreamedResponse?> custom(String method, {
    required Uri url,
    String? data,
    Map<String, String>? headers,
    int timeout = 5000
  }) async {
    var request = http.Request(method, url);
    request.headers.addAll(headers ?? {});
    request.body = data ?? '';
    try {
      return await request.send().timeout(Duration(milliseconds: timeout));
    } on TimeoutException catch (e) {
      log(e);
      // throw Exception('Request to $url timed out: ${e.message}');
    } catch (e) {
      // throw Exception('Request to $url failed: ${e.toString()}');
    }
    return null;
  }

  static Future<void> stream({
    required Uri url,
    String method = RequestType.get,
    bool cancelOnError = true,
    Map<String, String>? headers,
    required Function(double received) onUpdateProgress,
    required Function(Uint8List data) onDone,
    required Function(dynamic error) onError,
    Function(int? statusCode)? onStatusCode,
  }) async {
    var response = await EspoHttpClient.custom(method,
      url: url,
      headers: headers
    );

    if (response?.statusCode == 200) {
      int received = 0;
      BytesBuilder builder = BytesBuilder(copy: false);

      // ignore: unused_local_variable
      StreamSubscription<List<int>>? subscription;

      subscription = response!.stream.listen(
        (List<int> chunk) async {
          // uncomment these to simulate slow network
          // subscription?.pause();
          received += chunk.length;
          builder.add(chunk);
          onUpdateProgress(received.toDouble());
          // await Future.delayed(const Duration(milliseconds: 1));
          // subscription?.resume();
        },
        onDone: () {
          onDone(builder.takeBytes());
        },
        onError: onError,
        cancelOnError: cancelOnError,
      );
    } else {
      if (onStatusCode != null) onStatusCode(response?.statusCode);
    }
  }
}

class EspoApi {
  static int timeout = 30000;
  static bool useApiUser = AppConfig.useApiUser;

  static Uri baseUri([String? path]) {
    return Uri.parse(AppConfig.siteUrl + (path ?? ''));
  }

  static String baseUrl([String? path]) {
    Uri uri = Uri.parse(AppConfig.siteUrl);
    String basePath = uri.path.startsWith('/') ? uri.path : '/${uri.path}';
    return '${uri.scheme}://${uri.host}:${uri.port}$basePath$path';
  }

  static Uri baseApiUri([String? path]) {
    return Uri.parse(AppConfig.apiUrl + (path ?? ''));
  }

  static String baseApiUrl([String? path]) {
    Uri uri = Uri.parse(AppConfig.apiUrl);
    String basePath = uri.path.startsWith('/') ? uri.path : '/${uri.path}';
    return '${uri.scheme}://${uri.host}:${uri.port}$basePath$path';
  }

  static Future<Map<String, String>> getApiHeaders() async {
    if (useApiUser) {
      return EspoLoginApi.getApiHeaders();
    } else {
      return await EspoLoginUser.getApiHeaders();
    }
  }

  static Future<http.Response?> metadata(
    Map<String, String>? headers
  ) async {
    return await getApi(
      EspoApiPoints.metadata,
      headers: headers
    );
  }

  static Future<int?> metadataLength({
    Map<String, String>? headers
  }) async {
    http.Response? response = await getApi(
      EspoApiPoints.metadataLength,
      headers: headers
    );

    if (response == null) return null;
    if (response.statusCode != 200) return null;
    final jsonObject = response.toJsonMap();
    if (jsonObject == null) return null;
    return jsonObject['length'];
  }

  static Future<http.Response?> createEntity({
    required String entityType,
    required Map<String, dynamic> data,
    Map<String, String>? headers
  }) async {
    return await postApi(
      entityType,
      data: data,
      headers: headers
    );
  }

  static Future<http.Response?> updateEntity({
    required String entityType,
    required String entityId,
    required Map<String, dynamic> data,
    Map<String, String>? headers
  }) async {
    return await putApi(
      '$entityType/$entityId',
      data: data,
      headers: headers
    );
  }

  static Future<http.Response?> deleteEntity({
    required String entityType,
    required String entityId,
    Map<String, String>? headers
  }) async {
    return await deleteApi(
      '$entityType/$entityId',
      headers: headers
    );
  }

  static Future<http.Response?> uploadAttachmentImage({
    required String parentType,
    required String field,
    required String filePath,
    String? imageName,
  }) async {
    File file = File(filePath);
    if (!(await file.exists())) return null;

    String mimeType = lookupMimeType(filePath) ?? 'image/png';

    return await postApi(
      'Attachment',
      data: {
        "role": "Attachment",
        "parentType": parentType,
        "field": field,
        "name": imageName ?? DateTime.now().millisecondsSinceEpoch.toString(),
        "type": mimeType,
        "size": await file.length(),
        "file": "data:$mimeType;base64,${getBase64Image(filePath)}"
      }
    );
  }

  static Future<http.Response?> head(String url, {
    Map<String, dynamic>? data,
    Map<String, String>? headers,
  }) async {
    if (AppConfig.apiDebugMode) log('HEAD: ${baseUrl(url)}');
    return await EspoHttpClient.head(
      baseUri(url),
      headers: (await getApiHeaders())..addAll(headers ?? {}),
      timeout: timeout
    );
  }

  static Future<http.Response?> headApi(String url, {
    Map<String, dynamic>? data,
    Map<String, String>? headers,
  }) async {
    if (AppConfig.apiDebugMode) log('HEAD API: ${baseApiUrl(url)}');
    return await EspoHttpClient.head(
      baseApiUri(url),
      headers: (await getApiHeaders())..addAll(headers ?? {}),
      timeout: timeout
    );
  }

  static Future<http.Response?> patch(String url, {
    Map<String, dynamic>? data,
    Map<String, String>? headers,
    Encoding? encoding
  }) async {
    if (AppConfig.apiDebugMode) log('PATCH: ${baseUrl(url)}');
    return await EspoHttpClient.patch(
      baseUri(url),
      data: jsonEncode(data),
      headers: (await getApiHeaders())..addAll(headers ?? {}),
      encoding: encoding ?? Encoding.getByName('UTF-8'),
      timeout: timeout
    );
  }

  static Future<http.Response?> patchApi(String url, {
    Map<String, dynamic>? data,
    Map<String, String>? headers,
    Encoding? encoding
  }) async {
    if (AppConfig.apiDebugMode) log('PATCH API: ${baseApiUrl(url)}');
    return await EspoHttpClient.patch(
      baseApiUri(url),
      data: jsonEncode(data),
      headers: (await getApiHeaders())..addAll(headers ?? {}),
      encoding: encoding ?? Encoding.getByName('UTF-8'),
      timeout: timeout
    );
  }

  static Future<http.Response?> delete(String url, {
    Map<String, dynamic>? data,
    Map<String, String>? headers,
    Encoding? encoding
  }) async {
    if (AppConfig.apiDebugMode) log('DELETE: ${baseUrl(url)}');
    return await EspoHttpClient.delete(
      baseUri(url),
      data: jsonEncode(data),
      headers: (await getApiHeaders())..addAll(headers ?? {}),
      encoding: encoding ?? Encoding.getByName('UTF-8'),
      timeout: timeout
    );
  }

  static Future<http.Response?> deleteApi(String url, {
    Map<String, dynamic>? data,
    Map<String, String>? headers,
    Encoding? encoding
  }) async {
    if (AppConfig.apiDebugMode) log('DELETE API: ${baseApiUrl(url)}');
    return await EspoHttpClient.delete(
      baseApiUri(url),
      data: jsonEncode(data),
      headers: (await getApiHeaders())..addAll(headers ?? {}),
      encoding: encoding ?? Encoding.getByName('UTF-8'),
      timeout: timeout
    );
  }

  static Future<http.Response?> post(String url, {
    Map<String, dynamic>? data,
    Map<String, String>? headers,
  }) async {
    if (AppConfig.apiDebugMode) log('POST: ${baseUrl(url)}');
    return await EspoHttpClient.post(
      baseUri(url),
      data: jsonEncode(data),
      headers: (await getApiHeaders())..addAll(headers ?? {}),
      timeout: timeout
    );
  }

  static Future<http.Response?> postApi(String url, {
    Map<String, dynamic>? data,
    Map<String, String>? headers,
  }) async {
    if (AppConfig.apiDebugMode) log('POST API: ${baseApiUrl(url)}');
    if (AppConfig.apiDebugMode) log('POST API DATA: $data');
    return await EspoHttpClient.post(
      baseApiUri(url),
      data: jsonEncode(data),
      headers: (await getApiHeaders())..addAll(headers ?? {}),
      timeout: timeout
    );
  }

  static Future<http.Response?> get(String url, {
    Map<String, String>? headers,
  }) async {
    if (AppConfig.apiDebugMode) log('GET: ${baseUrl(url)}');
    return await EspoHttpClient.get(
      baseUri(url),
      headers: (await getApiHeaders())..addAll(headers ?? {}),
      timeout: timeout
    );
  }

  static Future<http.Response?> getApi(String url, {
    Map<String, String>? headers,
  }) async {
    if (AppConfig.apiDebugMode) log('GET API: ${baseApiUrl(url)}');
    return await EspoHttpClient.get(
      baseApiUri(url),
      headers: (await getApiHeaders())..addAll(headers ?? {}),
      timeout: timeout
    );
  }

  static Future<http.Response?> put(String url, {
    Map<String, dynamic>? data,
    Map<String, String>? headers,
  }) async {
    if (AppConfig.apiDebugMode) log('PUT: ${baseUrl(url)}');
    return await EspoHttpClient.put(
      baseUri(url),
      data: jsonEncode(data),
      headers: (await getApiHeaders())..addAll(headers ?? {}),
      timeout: timeout
    );
  }

  static Future<http.Response?> putApi(String url, {
    Map<String, dynamic>? data,
    Map<String, String>? headers,
  }) async {
    if (AppConfig.apiDebugMode) log('PUT API: ${baseApiUrl(url)}');
    if (AppConfig.apiDebugMode) log('PUT API DATA: $data');
    return await EspoHttpClient.put(
      baseApiUri(url),
      data: jsonEncode(data),
      headers: (await getApiHeaders())..addAll(headers ?? {}),
      timeout: timeout
    );
  }

  static Future<void> stream({
    required String url,
    String method = RequestType.get,
    bool cancelOnError = true,
    required Function(double received) onUpdateProgress,
    required Function(Uint8List data) onDone,
    required Function(dynamic error) onError,
    Function(int? statusCode)? onStatusCode,
  }) async {
    await EspoHttpClient.stream(
      url: baseUri(url),
      method: method,
      cancelOnError: cancelOnError,
      headers: await getApiHeaders(),
      onStatusCode: onStatusCode,
      onUpdateProgress: onUpdateProgress,
      onDone: onDone,
      onError: onError
    );
  }

  static Future<void> streamApi({
    required String url,
    String method = RequestType.get,
    bool cancelOnError = true,
    required Function(double received) onUpdateProgress,
    required Function(Uint8List data) onDone,
    required Function(dynamic error) onError,
    Function(int? statusCode)? onStatusCode,
  }) async {
    await EspoHttpClient.stream(
      url: baseApiUri(url),
      method: method,
      cancelOnError: cancelOnError,
      headers: await getApiHeaders(),
      onStatusCode: onStatusCode,
      onUpdateProgress: onUpdateProgress,
      onDone: onDone,
      onError: onError
    );
  }

  static Future<http.Response?> change(EspoEntityChange change, {
    Map<String, String>? headers
  }) async {
    EspoEntity entity = change.entity;

    if (change.isCreate) {
      return await createEntity(
        entityType: entity.entityType,
        data: change.changeData,
        headers: headers
      );
    }
    
    if (change.isUpdate) {
      return await updateEntity(
        entityType: entity.entityType,
        entityId: entity.id,
        data: change.changeData,
        headers: headers
      );
    }
    
    if (change.isDelete) {
      return await deleteEntity(
        entityType: entity.entityType,
        entityId: entity.id,
        headers: headers
      );
    }

    return null;
  }

  static Future<Uint8List> bytes(String url, {
    Map<String, String>? headers
  }) async {
    http.Response? response = await get(url,
      headers: (await getApiHeaders())..addAll(headers ?? {})
    );
    if (response == null) return Uint8List(0);
    return response.bodyBytes;
  }
}