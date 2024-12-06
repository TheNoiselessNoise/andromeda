import 'dart:convert';
import 'package:http/http.dart' as http;

extension HttpResponseExtensions on http.Response {
  String? toJsonString() {
    try {
      jsonDecode(body);
      return body;
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic>? toJsonMap() {
    try {
      return jsonDecode(body);
    } catch (e) {
      return null;
    }
  }

  List<dynamic>? toJsonList() {
    try {
      return jsonDecode(body);
    } catch (e) {
      return null;
    }
  }
}