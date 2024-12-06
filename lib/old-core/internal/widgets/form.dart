import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

typedef CoreBaseFormBuilder = Widget? Function(
  GlobalKey<FormState>,
  BuildContext,
  CoreBaseFormState
)?;

class FormManager {
  static Map<String, Map<String, dynamic>> formsData = {};
  static Map<String, CoreBaseFormState> formStates = {};

  static void registerForm(String id) {
    if (formsData.containsKey(id)) return;
    formsData[id] = {};
  }

  static void unregisterForm(String id) {
    formsData.remove(id);
  }

  static void registerFormState(CoreBaseFormState formState) {
    formStates[formState.formId] = formState;
  }

  static void unregisterFormState(CoreBaseFormState formState) {
    formStates.remove(formState.formId);
  }

  static void setFormValue(String formId, String fieldId, dynamic value) {
    registerForm(formId);
    if (formsData.containsKey(formId)) {
      formsData[formId]?[fieldId] = value;
    }
  }

  static dynamic getFormValue(String formId, String fieldId, [dynamic defaultValue]) {
    registerForm(formId);
    if (formsData.containsKey(formId)) {
      return formsData[formId]?[fieldId];
    }
    return defaultValue;
  }
  
  static void unsetFormValues(String formId) {
    registerForm(formId);
    for (String fieldId in formsData[formId]?.keys ?? []) {
      formsData[formId]?[fieldId] = null;
    }
  }

  static void unsetFormFieldValue(String formId, String fieldId) {
    registerForm(formId);
    formsData[formId]?[fieldId] = null;
  }

  static void removeFormField(String formId, String fieldId) {
    registerForm(formId);
    formsData[formId]?.remove(fieldId);
  }
}

class CoreBaseForm extends StatefulWidget {
  final String? id;

  final Map<String, dynamic> initialValues;

  final void Function(CoreBaseFormState)? onSubmit;

  final CoreBaseFormBuilder? builder;

  const CoreBaseForm({
    super.key,
    this.id,
    this.builder,
    this.initialValues = const {},
    this.onSubmit
  });

  @override
  CoreBaseFormState createState() => CoreBaseFormState();
}

class CoreBaseFormState extends State<CoreBaseForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _formData = {};
  final Map<String, CoreBaseFieldState> _formFields = {};

  Map<String, dynamic> get formData => _formData;
  Map<String, CoreBaseFieldState> get formFields => _formFields;

  String get formId => widget.id ?? "unknown-$hashCode";

  @protected
  Widget? buildForm(
    GlobalKey<FormState> formKey,
    BuildContext context,
    CoreBaseFormState formState
  ) {
    return null;
  }

  void rebuild() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    FormManager.registerFormState(this);
  }

  @override
  void dispose() {
    FormManager.unregisterFormState(this);
    super.dispose();
  }

  T? getInitialValue<T>(String id) {
    return widget.initialValues[id] as T?;
  }

  void unsetFieldValues() {
    FormManager.unsetFormValues(formId);
    for (CoreBaseFieldState field in _formFields.values) {
      field.unsetValues();
    }
  }

  void unsetFieldValue(String id) {
    FormManager.unsetFormFieldValue(formId, id);
    _formFields[id]?.unsetValues();
  }

  void registerField(String id, CoreBaseFieldState fieldState) {
    FormManager.setFormValue(formId, id, fieldState.value);
    _formFields[id] = fieldState;
    _formData[id] = fieldState;
  }

  void unregisterField(String id) {
    FormManager.removeFormField(formId, id);
    _formFields.remove(id);
    _formData.remove(id);
  }

  void setFieldValue(String id, dynamic value) {
    FormManager.setFormValue(formId, id, value);
    _formData[id] = value;
  }

  void save() {
    _formKey.currentState?.save();
  }

  void submit() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      if (widget.onSubmit != null) {
        widget.onSubmit!(this);
      }
    }
  }

  Widget _getChild(BuildContext context) {
    if (widget.builder != null) {
      return widget.builder!(_formKey, context, this)!;
    }

    Widget? form = buildForm(_formKey, context, this);
    if (form != null) {
      return form;
    }

    return Text("No form builder provided for $formId");
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: _getChild(context),
    );
  }
}