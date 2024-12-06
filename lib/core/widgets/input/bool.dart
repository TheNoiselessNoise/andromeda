import 'package:flutter/material.dart';
import 'base/field.dart';

class CoreBoolField extends CoreBaseFormField<bool> {
  final String? label;
  final bool triState;

  const CoreBoolField({
    super.key,
    required super.id,
    super.initialValue,
    this.label,
    this.triState = false,
  });

  @override
  CoreBoolFieldState createState() => CoreBoolFieldState();
}

class CoreBoolFieldState extends CoreBaseFormFieldState<CoreBoolField> {
  late final CoreFormFieldController<bool> _controller;

  @override
  void initState() {
    super.initState();
    _controller = CoreFormFieldController<bool>(
      id: widget.id,
      initialValue: widget.initialValue,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      formScope.controller.registerField(_controller);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      horizontalTitleGap: 0,
      child: CheckboxListTile(
        value: _controller.value,
        tristate: widget.triState,
        onChanged: (value) {
          setState(() {
            _controller.setValue(value);
            formScope.controller.updateValue(widget.id, value);
          });
        },
        title: widget.label != null ? Text(widget.label!) : null,
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}