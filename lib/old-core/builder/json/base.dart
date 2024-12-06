import 'package:andromeda/old-core/core.dart';

class JsonOrder extends MapTraversable {
  const JsonOrder(super.data);

  String? get by => get('by');
  String? get direction => get('direction');
}

class JsonFilter extends MapTraversable {
  const JsonFilter(super.data);

  String? get type => get('type');
  String get attribute => getString('attribute');
  dynamic get value => get('value');

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'attribute': attribute,
      'value': value,
    };
  }

  dynamic get firstValue {
    if (value is List && (value as List).isNotEmpty) {
      return value[0];
    }

    return value;
  }
}

class JsonSerializable extends MapTraversable {
  static const int _maxDepth = 100;
  static final Map<Object, dynamic> _cache = {};

  const JsonSerializable(super.data);

  Map<String, dynamic> toMap() {
    _cache.clear(); // Clear the cache before starting
    return Map<String, dynamic>.from(data).map(
      (key, value) => MapEntry(key, _convertToSerializable(value, 0))
    );
  }

  dynamic _convertToSerializable(dynamic value, int depth) {
    if (depth > _maxDepth) {
      return null; // or some other sentinel value to indicate max depth reached
    }

    if (value is JsonSerializable) {
      if (_cache.containsKey(value)) {
        return '[Circular Reference]'; // or some other indicator
      }
      _cache[value] = true;
      var result = value.data.map((key, val) => 
          MapEntry(key, _convertToSerializable(val, depth + 1)));
      _cache.remove(value);
      return result.cast<String, dynamic>();
    } else if (value is List) {
      return value.map((item) => _convertToSerializable(item, depth + 1)).toList();
    } else if (value is Map) {
      return value.map((key, val) => 
          MapEntry(key, _convertToSerializable(val, depth + 1))).cast<String, dynamic>();
    } else {
      return value;
    }
  }

  String toJSON() {
    return jsonEncode(toMap());
  }
}