import 'package:flutter/material.dart';
import 'base/field.dart';

class CoreTextField extends CoreBaseFormField<String> {
  const CoreTextField({
    super.key,
    required super.id,
    super.initialValue,
  });

  @override
  CoreTextFieldState createState() => CoreTextFieldState();
}

class CoreTextFieldState extends CoreBaseFormFieldState<CoreTextField> {
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
      onChanged: (value) {
        _controller.setValue(value);
        formScope.controller.updateValue(widget.id, value);
      },
    );
  }
}