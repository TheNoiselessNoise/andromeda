import 'dart:math';
import 'package:flutter/material.dart';
import 'base/field.dart';

class CoreVarcharField extends CoreBaseFormField<String> {
  final int? maxLength;

  const CoreVarcharField({
    super.key,
    required super.id,
    super.initialValue,
    this.maxLength,
  });

  @override
  CoreVarcharFieldState createState() => CoreVarcharFieldState();
}

class CoreVarcharFieldState extends CoreBaseFormFieldState<CoreVarcharField> {
  late final CoreFormFieldController<String> _controller;
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _controller = CoreFormFieldController<String>(
      id: widget.id,
      initialValue: widget.initialValue,
    );
    _textController = TextEditingController(text: widget.initialValue);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      formScope.controller.registerField(_controller);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      maxLength: min(widget.maxLength ?? 255, 255),
      onChanged: (value) {
        _controller.setValue(value);
        formScope.controller.updateValue(widget.id, value);
      },
    );
  }
}