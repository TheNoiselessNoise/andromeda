import 'package:andromeda/old-core/core.dart';

class ComponentBuilder extends MapTraversable {
  const ComponentBuilder(super.data);

  ComponentBuilder type(String type) {
    Map<String, dynamic> newData = dataCopy;
    newData['type'] = type;
    return ComponentBuilder(newData);
  }

  ComponentBuilder add(String key, dynamic value) {
    Map<String, dynamic> newData = dataCopy;
    newData[key] = value;
    return ComponentBuilder(newData);
  }

  ComponentBuilder addInfo(String key, dynamic value) {
    Map<String, dynamic> newData = dataCopy;
    String type = newData['type'] ?? 'label';
    newData['info'] = Map<String, dynamic>.from(newData['info'] ?? {});
    newData['info'][type] = Map<String, dynamic>.from(newData['info'][type] ?? {});
    newData['info'][type][key] = value;
    return ComponentBuilder(newData);
  }

  ComponentBuilder addInfoMap(Map<String, dynamic> map) {
    Map<String, dynamic> newData = dataCopy;
    String type = newData['type'] ?? 'label';
    newData['info'] = Map<String, dynamic>.from(newData['info'] ?? {});
    newData['info'][type] = Map<String, dynamic>.from(newData['info'][type] ?? {});
    newData['info'][type].addAll(map);
    return ComponentBuilder(newData);
  }

  Map<String, dynamic> build() {
    return data;
  }
}