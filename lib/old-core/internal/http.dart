import 'package:http/http.dart' as http;

class Request {
  String? _baseUrl;
  final Map<String, String> _headers = {};

  Request({String? baseUrl, Map<String, String>? headers}){
    _baseUrl = baseUrl;
    if(headers != null){
      _headers.addAll(headers);
    }
  }

  void setBaseUrl(String baseUrl){
    _baseUrl = baseUrl;
  }

  void addHeader(String key, String value){
    _headers[key] = value;
  }

  Future<http.Response> get(String url) async {
    return await http.get(Uri.parse(_baseUrl! + url), headers: _headers);
  }

  static Future<http.Response> getRequest(String url) async {
    return await http.get(Uri.parse(url));
  }

  static Future<http.Response> postRequest(String url, {Map<String, String>? body}) async {
    return await http.post(Uri.parse(url), body: body);
  }
}