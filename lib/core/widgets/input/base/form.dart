import 'package:flutter/material.dart';
import 'field.dart';

class CoreFormController extends ChangeNotifier {
  final String id;
  Map<String, dynamic> _values;
  final Map<String, CoreFormFieldController> _fields = {};
  final Map<String, CoreFormController> _nestedForms = {};
  CoreFormController? _parentForm;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  CoreFormController({
    required this.id,
    Map<String, dynamic> initialValues = const {},
  }) : _values = Map.from(initialValues);

  void registerField(CoreFormFieldController field) {
    _fields[field.id] = field;

    if (_values.containsKey(field.id) && field.value != _values[field.id]) {
      updateValue(field.id, field.value);
    } else if (_values.containsKey(field.id)) {
      field.setValue(_values[field.id]);
    }

    field.addListener(() {
      updateValue(field.id, field.value);
    });
  }

  void registerNestedForm(CoreFormController form) {
    _nestedForms[form.id] = form;
    form._parentForm = this;

    if (_values.containsKey(form.id) && _values[form.id] is Map<String, dynamic>) {
      form._values = Map.from(_values[form.id]);
    }
  }

  Map<String, dynamic> getValues() {
    final values = Map<String, dynamic>.from(_values);

    for (final field in _fields.entries) {
      values[field.key] = field.value.value;
    }

    for (final form in _nestedForms.entries) {
      values[form.key] = form.value.getValues();
    }

    return values;
  }

  void updateValue(String fieldId, dynamic value) {
    _values[fieldId] = value;
    notifyListeners();

    _parentForm?.updateNestedFormValue(id, getValues());
  }

  void updateNestedFormValue(String formId, Map<String, dynamic> values) {
    _values[formId] = values;
    notifyListeners();

    _parentForm?.updateNestedFormValue(id, getValues());
  }

  Future<Map<String, dynamic>> submit() async {
    if (_isSubmitting) return const {};

    try {
      _isSubmitting = true;
      notifyListeners();

      final values = getValues();

      await Future.wait(
        _nestedForms.values.map((form) => form.submit()),
      );

      return values;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}

class CoreBaseForm extends StatefulWidget {
  final String id;
  final Map<String, dynamic> initialValues;
  final Widget child;
  final Future<void> Function(Map<String, dynamic> values)? onSubmit;
  final Function(Object error)? onError;

  const CoreBaseForm({
    super.key,
    required this.id,
    this.initialValues = const {},
    required this.child,
    this.onSubmit,
    this.onError,
  });

  @override
  CoreBaseFormState createState() => CoreBaseFormState();
}

class CoreBaseFormState extends State<CoreBaseForm> {
  late final CoreFormController _controller;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = CoreFormController(
      id: widget.id,
      initialValues: widget.initialValues,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final parentFormScope = context.findAncestorWidgetOfExactType<CoreFormScope>();
      if (parentFormScope != null) {
        parentFormScope.controller.registerNestedForm(_controller);
      }
    });
  }

  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final values = await _controller.submit();
      if (widget.onSubmit != null) {
        await widget.onSubmit!(values);
      }
    } catch (error) {
      if (widget.onError != null) {
        widget.onError!(error);
      } else {
        rethrow;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CoreFormScope(
      controller: _controller,
      child: Form(
        key: _formKey,
        child: widget.child,
      ),
    );
  }
}

class CoreFormScope extends InheritedWidget {
  final CoreFormController controller;

  const CoreFormScope({
    super.key,
    required this.controller,
    required super.child,
  });

  static CoreFormScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CoreFormScope>();
    assert(scope != null, 'No CoreFormScope found in context');
    return scope!;
  }

  @override
  bool updateShouldNotify(CoreFormScope oldWidget) {
    return controller != oldWidget.controller;
  }
}