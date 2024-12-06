import 'dart:async';
import '../language/token.dart';
import '../language/ast.dart';
import '../renderer/_.dart';

class ClassInstance {
  final FClass classDef;
  final Environment environment;
  ClassInstance? parent;

  ClassInstance(this.classDef, this.environment);

  String getName() => classDef.name.lexeme;

  Future<dynamic> getProperty(String name) async {
    try {
      return environment.get(Token.variable(name));
    } catch (e) {
      if (parent != null) return parent!.getProperty(name);
      rethrow;
    }
  }

  Future<void> setProperty(String name, dynamic value) async => environment.assign(Token.variable(name), value);

  ClassMethod? getMethod(String name) {
    var method = classDef.getMethod(name);
    if (method == null && parent != null) {
      return parent!.getMethod(name);
    }
    return method;
  }

  @override
  String toString() {
    if (parent != null) return "Instance<${getName()}(${parent!.getName()})>";
    return "Instance<${classDef.name}>";
  }
}

class WidgetStateSignal {
  final String name;
  final dynamic value;
  final dynamic oldValue;

  WidgetStateSignal(this.name, this.value, this.oldValue);
}

class WidgetInstance {
  FWidget widgetDef;
  Environment environment;
  Map<String, dynamic> initialState;
  AndromedaWidgetState? flutterWidgetState;
  WidgetInstance? _parentWidget;

  final _stateController = StreamController<WidgetStateSignal>.broadcast();
  Stream<WidgetStateSignal> get stateStream => _stateController.stream;

  WidgetInstance(this.widgetDef, this.environment, [this.initialState = const {}]);

  AndromedaWidgetState? get state => flutterWidgetState;
  WidgetInstance? get parentWidget => _parentWidget;

  void setFlutterWidgetState(AndromedaWidgetState? state) => flutterWidgetState = state;
  void setParentWidget(WidgetInstance parent) => _parentWidget = parent;
  void setInitialState(Map<String, dynamic> values) => initialState = values;

  void signalStateChange(String name, dynamic value, dynamic oldValue) {
    _stateController.add(WidgetStateSignal(name, value, oldValue));
  }

  List<WidgetInstance> getAncestors() {
    List<WidgetInstance> ancestors = [];
    WidgetInstance? current = parentWidget;

    while (current != null) {
      ancestors.add(current);
      current = current.parentWidget;
    }

    return ancestors;
  }

  bool hasInitialVar(String name) {
    if (initialState.containsKey(name)) return true;
    return _parentWidget?.hasInitialVar(name) ?? false;
  }

  dynamic getInitialVar(String name) {
    if (initialState.containsKey(name)) return initialState[name];
    return _parentWidget?.getInitialVar(name);
  }

  WidgetInstance getRootInstance() {
    WidgetInstance current = this;
    while (current.parentWidget != null) {
      current = current.parentWidget!;
    }
    return current;
  }

  AndromedaWidgetState? getStateHolder() {
    if (state != null) return state;
    return parentWidget?.getStateHolder();
  }

  AndromedaWidgetState? findStateForVariable(String varName) {
    if (state?.hasStateVar(varName) ?? false) {
      return state;
    }

    if (initialState.containsKey(varName)) {
      return state;
    }

    if (_parentWidget != null) {
      return _parentWidget!.findStateForVariable(varName);
    }

    return null;
  }

  void dispose() {
    flutterWidgetState = null;
    _stateController.close();
  }
}