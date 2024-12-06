import 'package:andromeda/old-core/core.dart';

class JsonPSettings extends MapTraversable {
  const JsonPSettings(super.data);

  List<JsonA> get onLoggedInUser => getList('onLoggedInUser')
    .map((e) => JsonA.from(e)).toList();
  bool get ignoreHistory => getBool('ignoreHistory');
  JsonC get appBar => JsonC.from(getMap('appBar'));
  dynamic get drawer {
    dynamic d = get('drawer');
    return d is Map ? JsonC.from(d) : d;
  }

  bool get hasAppBar => appBar.data.isNotEmpty;
}

class JsonPArguments extends MapTraversable {
  const JsonPArguments(super.data);

  ParentContext? get parentContext => get('parentContext');
}

class JsonP extends MapTraversable {
  final String id;
  
  JsonP(this.id, super.data);

  JsonPArguments get args => JsonPArguments(getMap('arguments'));

  String? get entityType => get('entityType');
  JsonPSettings get settings => JsonPSettings(getMap('settings'));

  JsonC get component => JsonC(getMap('component'));

  void addComponent(JsonC component) {
    data['component'] = component.data;
  }

  JsonP withArguments(Map<String, dynamic> newArgs) {
    return JsonP(id, {
      ...data,
      'arguments': {
        ...data['arguments'] ?? {},
        ...newArgs
      }
    });
  }
}