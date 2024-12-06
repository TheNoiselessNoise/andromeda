import 'package:andromeda/old-core/core.dart';

class MapTraversable {
  final Map<String, dynamic> data;

  const MapTraversable([this.data = const {}]);

  bool get hasData => data.isNotEmpty;

  Map<String, dynamic> get dataCopy => Map<String, dynamic>.from(data);

  bool has(String path) => mapListWalker(data, path) != null;

  Map<String, dynamic> changesOf(Map<String, dynamic> newData, [
    bool includeNonExistingKeys = false
  ]) {
    if (newData.isEmpty) return {};

    bool isDataEmpty(dynamic test) {
      if (test is String) return test.isEmpty;
      if (test is List) return test.isEmpty;
      if (test is Map) return test.isEmpty;
      if (test == null) return true;
      return false;
    }

    Map<String, dynamic> changes = {};
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

  double getDouble(String path, [double defaultValue = 0.0]){
    dynamic value = get(path, defaultValue);

    if (value is int) {
      return value.toDouble();
    }

    return value;
  }

  bool getBool(String path, [bool defaultValue = false]){
    return get(path, defaultValue);
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
    Map<String, dynamic> oldData = Map<String, dynamic>.from(data);
    myMergeMaps(oldData, other?.data ?? {});
    return EspoEntityChange(oldData);
  }
}
