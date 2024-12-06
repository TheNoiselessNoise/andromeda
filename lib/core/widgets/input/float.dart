import 'package:flutter/material.dart';
import 'base/field.dart';

class CoreFloatField extends CoreBaseFormField<double> {
  const CoreFloatField({
    super.key,
    required super.id,
    super.initialValue,
  });

  @override
  CoreFloatFieldState createState() => CoreFloatFieldState();
}

class CoreFloatFieldState extends CoreBaseFormFieldState<CoreFloatField> {
  late final CoreFormFieldController<double> _controller;
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _controller = CoreFormFieldController<double>(
      id: widget.id,
      initialValue: widget.initialValue,
    );
    _textController = TextEditingController(text: widget.initialValue?.toString() ?? '');

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
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (value) {
        final doubleValue = double.tryParse(value);
        if (doubleValue != null) {
          _controller.setValue(doubleValue);
          formScope.controller.updateValue(widget.id, doubleValue);
        }
      },
    );
  }
}