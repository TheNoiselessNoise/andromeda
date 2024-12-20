import 'dart:convert';
import 'package:uuid/v4.dart';
import 'package:flutter/foundation.dart';
import 'package:andromeda/core/_.dart';

String uuidv4() => const UuidV4().generate();

void myMergeMaps(Map original, Map updates) {
  updates.forEach((key, value) {
    if (value is Map && original[key] is Map) {
      myMergeMaps(original[key], value);
    } else {
      original[key] = value;
    }
  });
}

dynamic mapListSetter(dynamic json, String path, dynamic value) {
  if (json == null) return null;
  if (path.isEmpty) return value;
  String pathPart = path.contains('.') ? path.split('.').first : path;

  if (json is Map) {
    if (json.containsKey(pathPart)) {
      if (path.contains('.')) {
        json[pathPart] = mapListSetter(json[pathPart], path.split('.').sublist(1).join('.'), value);
      } else {
        json[pathPart] = value;
      }
    }
  }

  if (json is List) {
    int pathIndex = int.tryParse(pathPart) ?? -1;
    if (pathIndex < 0) return null;
    if (pathIndex >= json.length) return null;
    if (path.contains('.')) {
      json[pathIndex] = mapListSetter(json[pathIndex], path.split('.').sublist(1).join('.'), value);
    } else {
      json[pathIndex] = value;
    }
  }

  return json;
}

dynamic mapListWalker(dynamic json, String path) {
  if (json == null) return null;
  if (path.isEmpty) return json;
  String pathPart = path.contains('.') ? path.split('.').first : path;

  if (json is Map) {
    if (json.containsKey(pathPart)) {
      if (path.contains('.')) {
        return mapListWalker(json[pathPart], path.split('.').sublist(1).join('.'));
      } else {
        return json[pathPart];
      }
    }
  }

  if (json is List) {
    int pathIndex = int.tryParse(pathPart) ?? -1;
    if (pathIndex < 0) return null;
    if (pathIndex >= json.length) return null;
    if (path.contains('.')) {
      return mapListWalker(json[pathIndex], path.split('.').sublist(1).join('.'));
    } else {
      return json[pathIndex];
    }
  }

  return null;
}

bool isBasicType(Object object) {
  return [
    String,
    int,
    double,
    bool,
    DateTime,
    List,
    Map,
    Set,
  ].contains(object.runtimeType);
}

final Map<String, Function> defaultJsonifyRules = {
  'String': (dynamic value) => value,
  'int': (dynamic value) => value,
  'double': (dynamic value) => value,
  'bool': (dynamic value) => value,
  'DateTime': (DateTime value) => value.toIso8601String(),
  'List': (List value) => value,
  'Map': (dynamic value) => value,
  'Set': (dynamic value) => value,
  'Storable': (Storable value) => value.toJsonMap(),
  'MapTraversable': (MapTraversable value) => value.data,
};

// final Map<String, Function> defaultJsonifyStorageRules = {
//   'String': (dynamic value) => "__string__$value",
//   'int': (dynamic value) => "__int__$value",
//   'double': (dynamic value) => "__double__$value",
//   'bool': (dynamic value) => "__bool__$value",
//   'DateTime': (DateTime value) => "__datetime__${value.toIso8601String()}",
//   'List': (List value) => value,
//   'Map': (dynamic value) => value,
//   'Set': (dynamic value) => value,
// };

final Map<String, Function> defaultUnjsonifyRules = {
  '__string__': (dynamic value) => value,
  '__int__': (dynamic value) => value is int ? value : int.tryParse(value) ?? 0,
  '__double__': (dynamic value) => value is double ? value : double.tryParse(value) ?? 0.0,
  '__bool__': (dynamic value) => value is bool ? value : value == 'true',
  '__datetime__': (String value) => DateTime.tryParse(value) ?? DateTime.now(),
};

String jsonify(dynamic data, [Map<String, Function> additionalRules = const {}]) {
  return jsonEncodeWithRules(data, {...defaultJsonifyRules, ...additionalRules});
}

dynamic unjsonify(String jsonString) => jsonDecode(jsonString);

dynamic jsonDecodeWithRules([dynamic object, Map<String, Function> rules = const {}]) {
  Map<String, Function> defaultRules = {
    '__string__': (dynamic value) => value,
    '__int__': (dynamic value) => value is int ? value : int.tryParse(value) ?? 0,
    '__double__': (dynamic value) => value is double ? value : double.tryParse(value) ?? 0.0,
    '__bool__': (dynamic value) => value is bool ? value : value == 'true',
    '__datetime__': (String value) => DateTime.tryParse(value) ?? DateTime.now(),
  };

  final Map<String, Function> finalRules = {...defaultRules, ...rules};

  if (object is Map) {
    return object.map((key, value) {
      if (key is String && value is String) {
        for (String ruleKey in finalRules.keys) {
          if (value.startsWith(ruleKey)) {
            return MapEntry(key, finalRules[ruleKey]!(value.substring(ruleKey.length)));
          }
        }
      }

      return MapEntry(key, jsonDecodeWithRules(value, rules));
    });
  }

  if (object is List) {
    return object.map((value) {
      return jsonDecodeWithRules(value, rules);
    }).toList();
  }

  if (object is Set) {
    return object.map((value) {
      return jsonDecodeWithRules(value, rules);
    }).toSet();
  }

  return object;
}

String jsonEncodeWithRules(dynamic object, [Map<String, Function> rules = const {}]) {
  Map<String, Function> defaultRules = {
    'String': (dynamic value) => value,
    'int': (dynamic value) => value,
    'double': (dynamic value) => value,
    'bool': (dynamic value) => value,
    'DateTime': (DateTime value) => value.toIso8601String(),
    'List': (List value) => value,
    'Map': (dynamic value) => value,
    'Set': (dynamic value) => value,
  };

  final Map<String, Function> finalRules = {...defaultRules, ...rules};

  return JsonEncoder((dynamic object) {
    if (object == null) return null;

    String runtimeType = object.runtimeType.toString();

    if (!isBasicType(object) && !finalRules.containsKey(runtimeType)) {
      if (kDebugMode) {
        print("[jsonEncodeWithRules] Detected unhandled non-basic type, returning as stringified.");
        print("[jsonEncodeWithRules] Type: $runtimeType");
        print("[jsonEncodeWithRules] Stringified: $object");
      }

      return object.toString();
    }

    if (finalRules.containsKey(runtimeType)) {
      return finalRules[runtimeType]!(object);
    }

    if (object is Map) {
      return object.map((key, value) {
        return MapEntry(key, jsonEncodeWithRules(value, rules));
      });
    }

    if (object is List) {
      return object.map((value) {
        return jsonEncodeWithRules(value, rules);
      }).toList();
    }

    if (object is Set) {
      return object.map((value) {
        return jsonEncodeWithRules(value, rules);
      }).toSet();
    }

    return object;
  }).convert(object);
}