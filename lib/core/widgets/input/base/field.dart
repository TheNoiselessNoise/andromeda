import 'package:flutter/material.dart';
import 'form.dart';

class CoreFormFieldController<T> extends ChangeNotifier {
  final String id;
  T? _value;

  CoreFormFieldController({
    required this.id,
    T? initialValue,
  }) : _value = initialValue;

  T? get value => _value;

  void setValue(T? newValue) {
    if (_value != newValue) {
      _value = newValue;
      notifyListeners();
    }
  }
}

abstract class CoreBaseFormField<T> extends StatefulWidget {
  final String id;
  final T? initialValue;

  const CoreBaseFormField({
    super.key,
    required this.id,
    this.initialValue,
  });
}

abstract class CoreBaseFormFieldState<T extends CoreBaseFormField> extends State<T> {
  CoreFormScope get formScope => CoreFormScope.of(context);
}