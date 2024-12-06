import 'dart:collection';
import '../language/token.dart';

class Environment {
  final Map<String, dynamic> values = {};
  final Environment? enclosing;

  Environment([this.enclosing]);

  bool has(String name) => values.containsKey(name);

  dynamic get(Token name) {
    if (values.containsKey(name.lexeme)) {
      return values[name.lexeme];
    }

    if (enclosing != null) return enclosing!.get(name);

    throw Exception("Undefined variable '${name.lexeme}'.");
  }

  void define(String name, dynamic value) {
    values[name] = value;
  }

  void assign(String name, dynamic value) {
    if (has(name)) {
      values[name] = value;
      return;
    }

    if (enclosing != null) {
      enclosing!.assign(name, value);
      return;
    }

    throw Exception("Undefined variable '$name'.");
  }
}

class ScopedEnvironment {
  final Queue<Environment> _stack = Queue<Environment>();

  ScopedEnvironment(Environment environment) {
    _stack.addLast(environment);
  }

  Environment get current => _stack.first;

  void pushScope(Environment environment) {
    _stack.addFirst(environment);
  }

  void popScope() {
    if (_stack.length <= 1) {
      throw StateError("Cannot pop the last environment from the stack.");
    }
    _stack.removeFirst();
  }

  bool has(String name) => current.has(name);
  dynamic get(Token name) => current.get(name);
  void define(String name, dynamic value) => current.define(name, value);
  void assign(String name, dynamic value) => current.assign(name, value);

  Environment createScope() {
    final newEnv = Environment(current);
    pushScope(newEnv);
    return newEnv;
  }

  Future<T> withScope<T>(Future<T> Function(Environment) fn) async {
    final scope = createScope();
    try {
      return await fn(scope);
    } finally {
      popScope();
    }
  }
}