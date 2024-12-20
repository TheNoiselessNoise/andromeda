import 'package:flutter/material.dart';
import 'utils.dart';

class ContextableMapTraversable extends MapTraversable {
  final BuildContext context;

  const ContextableMapTraversable(this.context, super.data);
}

abstract class Storable {
  const Storable();

  Map<String, dynamic> toJsonMap();
}

class MapTraversable extends Storable {
  const MapTraversable([this.data = const {}]);

  final Map data;
  bool get hasData => data.isNotEmpty;
  Map get dataCopy => Map.from(data);

  bool has(String path) => mapListWalker(data, path) != null;

  @override
  Map<String, dynamic> toJsonMap() => Map<String, dynamic>.from(data);

  bool __isDataEmpty(dynamic test) {
    if (test is String) return test.isEmpty;
    if (test is List) return test.isEmpty;
    if (test is Map) return test.isEmpty;
    if (test == null) return true;
    return false;
  }

  Map changesOf(Map newData, [
    bool includeNonExistingKeys = false,
    bool Function(dynamic)? testFunc,
  ]) {
    if (newData.isEmpty) return {};

    bool Function(dynamic) isDataEmpty = testFunc ?? __isDataEmpty;

    Map changes = {};
    for (String key in newData.keys) {
      if (!includeNonExistingKeys && !data.containsKey(key)) continue;

      dynamic oldValue = data[key];
      dynamic newValue = newData[key];

      if (isDataEmpty(oldValue) && isDataEmpty(newValue)) continue;

      if (data[key] != newData[key]) {
        changes[key] = newData[key];
      }
    }

    return changes;
  }

  bool hasKey(String path, [String? key]) {
    if (key == null) return data.containsKey(path);
    dynamic value = mapListWalker(data, path);
    return value is Map && value.containsKey(key);
  }

  void set(String path, dynamic value) {
    mapListSetter(data, path, value);
  }

  dynamic get(String? path, [dynamic defaultValue]) {
    if (path == null) return defaultValue;
    return mapListWalker(data, path) ?? defaultValue;
  }

  String getString(String path, [String defaultValue = '']){
    return get(path, defaultValue);
  }

  int getInt(String path, [int defaultValue = 0]){
    dynamic value = get(path, defaultValue);

    if (value is double) {
      return value.toInt();
    }

    return value;
  }

  int? getIntOrNull(String path){
    dynamic value = get(path);

    if (value is double) {
      return value.toInt();
    }

    return value;
  }

  double getDouble(String path, [double defaultValue = 0.0]){
    dynamic value = get(path, defaultValue);

    if (value is int) {
      return value.toDouble();
    }

    return value;
  }

  double? getDoubleOrNull(String path){
    dynamic value = get(path);

    if (value is int) {
      return value.toDouble();
    }

    return value;
  }

  int? toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  double? toDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  bool getBool(String path, [bool defaultValue = false]){
    dynamic value = get(path, defaultValue);
    return value is bool ? value : defaultValue;
  }

  Map<String, T> getMap<T>(String path, [Map<String, T> defaultValue = const {}]){
    dynamic value = get(path, defaultValue);

    if (value == null) return defaultValue;

    if (value is MapTraversable) {
      return Map<String, T>.from(value.data);
    }

    if (value is! Map) return defaultValue;

    return Map<String, T>.from(value);
  }

  List<T> getList<T>(String path, [List<T> defaultValue = const []]){
    return List<T>.from(get(path, defaultValue));
  }

  DateTime? getDateTime(String path, [DateTime? defaultValue]){
    dynamic value = get(path, defaultValue);

    if (value is String) {
      return DateTime.tryParse(value) ?? defaultValue!;
    }

    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }

    return value;
  }

  MapTraversable merge([MapTraversable? other]) {
    Map oldData = Map.from(data);
    myMergeMaps(oldData, other?.data ?? {});
    return MapTraversable(oldData);
  }
}
