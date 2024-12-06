import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'exception.dart';
import '../context/script.dart';

class FScriptApiService {
  final String baseUrl;
  final String apiKey;
  final http.Client _client;

  FScriptApiService({
    required this.baseUrl,
    required this.apiKey,
  }) : _client = http.Client();

  Future<int?> getScriptVersion() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/version'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return int.tryParse(response.body);
      } else {
        throw ApiException(
          'Failed to fetch version: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ScriptContent> fetchScript(String scriptPath) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/$scriptPath'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // TODO: this
        // final data = json.decode(response.body);
        // return ScriptContent.fromJson(data);
        return ScriptContent(source: response.body);
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Invalid API key');
      } else if (response.statusCode == 404) {
        throw NotFoundException('Script not found: $scriptPath');
      } else {
        throw ApiException(
          'Failed to fetch script: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on SocketException {
      throw NetworkException('No internet connection');
    } on TimeoutException {
      throw NetworkException('Request timed out');
    } on FormatException {
      // Invalid JSON
      throw ApiException('Invalid response format', 500);
    } catch (e) {
      throw ApiException('Unknown error: $e', 500);
    }
  }

  void dispose() {
    _client.close();
  }
}
