import 'package:flutter/material.dart';
import 'base/field.dart';

class CoreEmailField extends CoreBaseFormField<String> {
  final String? placeholder;
  final String? label;
  final bool? allowMultiple;
  final bool? validate;

  const CoreEmailField({
    super.key,
    required super.id,
    super.initialValue,
    this.placeholder,
    this.label,
    this.allowMultiple,
    this.validate,
  });

  @override
  CoreEmailFieldState createState() => CoreEmailFieldState();
}

class CoreEmailFieldState extends CoreBaseFormFieldState<CoreEmailField> {
  late final CoreFormFieldController<String> _controller;
  final TextEditingController _textController = TextEditingController();

  bool get allowMultiple => widget.allowMultiple ?? false;
  bool get validate => widget.validate ?? true;

  @override
  void initState() {
    super.initState();
    _controller = CoreFormFieldController<String>(
      id: widget.id,
      initialValue: widget.initialValue,
    );
    _textController.text = widget.initialValue ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      formScope.controller.registerField(_controller);
    });
  }

  String? _validateEmail(String? value) {
    if (!validate) return null;
    if (value == null || value.isEmpty) return null;

    if (allowMultiple) {
      final emails = value.split(',').map((e) => e.trim());
      for (final email in emails) {
        if (!RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(email)) {
          return 'Invalid email format: $email';
        }
      }
      return null;
    }

    if (!RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(value)) {
      return 'Invalid email format';
    }
    return null;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _textController,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      validator: _validateEmail,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.placeholder ?? 'Enter email${allowMultiple ? 's (comma-separated)' : ''}',
        prefixIcon: const Icon(Icons.email),
      ),
      onChanged: (value) {
        _controller.setValue(value);
        formScope.controller.updateValue(widget.id, value);
      },
    );
  }
}