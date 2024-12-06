import 'dart:async';
import 'package:flutter/material.dart';

class AppStateSignal {
  final String name;
  final dynamic value;
  final dynamic oldValue;

  AppStateSignal(this.name, this.value, this.oldValue);
}

class AppStateHolder {
  static AppState? _instance;

  static AppState getInstance() {
    _instance ??= AppState._();
    return _instance!;
  }

  static void reset() {
    _instance?.dispose();
    _instance = null;
  }
}

class AppState extends ChangeNotifier {
  final Map<String, dynamic> _state = {};
  final _stateController = StreamController<AppStateSignal>.broadcast();

  AppState._();

  Stream<AppStateSignal> get stateStream => _stateController.stream;

  bool hasVar(String name) => _state.containsKey(name);

  dynamic getVar(String name) => _state[name];

  void setVar(String name, dynamic value) {
    final oldValue = _state[name];
    if (oldValue != value) {
      _state[name] = value;
      _stateController.add(AppStateSignal(name, value, oldValue));
      notifyListeners();
    }
  }

  void setInitialState(Map<String, dynamic> state) {
    if (_state.isEmpty) {
      _state.addAll(state);
    }
  }

  @override
  void dispose() {
    _stateController.close();
    super.dispose();
  }
}