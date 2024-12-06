import 'package:flutter/material.dart';

class AndromedaBaseWrapper {
  final dynamic _original;
  final Map<String, dynamic> _storage;

  const AndromedaBaseWrapper(this._original, [this._storage = const {}]);

  dynamic get original => _original;
  Map<String, dynamic> get storage => _storage;

  dynamic wrap(dynamic value) => AndromedaWrapper.wrap(value);

  Future<dynamic> getProperty(String name) async {
    switch (name) {
      case '\$type': return runtimeType;
      default: throw Exception("Property '$name' not found in $runtimeType");
    }
  }

  Future<dynamic> setProperty(String name, dynamic value) async {
    throw Exception("Property '$name' is read-only in $runtimeType");
  }

  // NOTE: Override in AndromedaWidget's state classes
  Future<dynamic> callMethod(String name, List<dynamic> args) async {
    switch (name) {
      case 'toString':
        return runtimeType;
      default: throw Exception("Method '$name' not found in $runtimeType");
    }
  }
}

class AndromedaStatefulElementWrapper extends AndromedaBaseWrapper {
  const AndromedaStatefulElementWrapper(BuildContext super._original);

  static Set<String> get supportedTypes => {'StatefulElement'};
  static Map<String, Function> get wrappers => Map.fromEntries(supportedTypes.map((type) => MapEntry(type, (value) => AndromedaStatefulElementWrapper(value))));

  @override
  BuildContext get original => _original;

  @override
  Future<dynamic> getProperty(String name) async {
    switch (name) {
      case '\$widget': return original.widget;
      default: return super.getProperty(name);
    }
  }

  @override
  Future<dynamic> callMethod(String name, List<dynamic> args) async {
    switch (name) {
      case 'toString':
        return original.toString();
      default: return super.callMethod(name, args);
    }
  }
}

class AndromedaAsyncSnapshotWrapper extends AndromedaBaseWrapper {
  const AndromedaAsyncSnapshotWrapper(AsyncSnapshot super._original);

  static Set<String> get supportedTypes => {'AsyncSnapshot', 'AsyncSnapshot<dynamic>'};
  static Map<String, Function> get wrappers => Map.fromEntries(supportedTypes.map((type) => MapEntry(type, (value) => AndromedaAsyncSnapshotWrapper(value))));

  @override
  AsyncSnapshot get original => _original;

  @override
  Future<dynamic> getProperty(String name) async {
    switch (name) {
      case '\$data': return wrap(original.data);
      case '\$error': return wrap(original.error);
      case '\$hasData': return wrap(original.hasData);
      case '\$hasError': return wrap(original.hasError);
      case '\$connectionState': return wrap(original.connectionState.name);
      case '\$type': return runtimeType;
      default: return super.getProperty(name);
    }
  }
}

class AndromedaAnimationControllerWrapper extends AndromedaBaseWrapper {
  const AndromedaAnimationControllerWrapper(AnimationController super._original);

  static Set<String> get supportedTypes => {'AnimationController'};
  static Map<String, Function> get wrappers => Map.fromEntries(supportedTypes.map((type) => MapEntry(type, (value) => AndromedaAnimationControllerWrapper(value))));

  @override
  AnimationController get original => _original;

  @override
  Future<dynamic> callMethod(String name, List<dynamic> args) async {
    switch (name) {
      case 'forward':
        original.reset();
        return original.forward();
      default: return super.callMethod(name, args);
    }
  }
}


class AndromedaWrapper {
  static final Set<String> _primitiveTypes = {
    'String',
    'int',
    'double',
    'bool',
  };

  static final _wrappers = {
    ...Map.fromEntries(_primitiveTypes.map((type) => MapEntry(type, (value) => value))),
    ...AndromedaStatefulElementWrapper.wrappers,
    ...AndromedaAsyncSnapshotWrapper.wrappers,
    ...AndromedaAnimationControllerWrapper.wrappers,
  };

  static bool isSupported(dynamic value) {
    return _wrappers.containsKey(value.runtimeType.toString());
  }

  static dynamic wrap(dynamic value) {
    if (!isSupported(value)) {
      print("!!!!!!!! Unsupported value type for wrapping: ${value.runtimeType}");
      return value;
      // throw Exception('Unsupported value type for wrapping: ${value.runtimeType}');
    }

    return _wrappers[value.runtimeType.toString()]!(value);
  }
}