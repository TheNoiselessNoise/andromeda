import 'package:andromeda/old-core/core.dart';

class JsonA extends JsonSerializable {
  const JsonA(super.data);

  String get on => getString('on', 'immediate');
  String get type => getString('type', 'navigation');
  String? get to => get('to');

  String? get name => getString('name');
  Map<String, dynamic> get args => getMap('args');

  static JsonA from(dynamic data) {
    if (data is Map<String, dynamic>) return JsonA(data);
    if (data is JsonA) return data;
    return const JsonA({});
  }
}
