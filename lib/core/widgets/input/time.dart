import 'package:flutter/material.dart';
import 'base/field.dart';

class CoreTimeField extends CoreBaseFormField<TimeOfDay> {
  final String? placeholder;

  const CoreTimeField({
    super.key,
    required super.id,
    super.initialValue,
    this.placeholder,
  });

  @override
  CoreTimeFieldState createState() => CoreTimeFieldState();
}

class CoreTimeFieldState extends CoreBaseFormFieldState<CoreTimeField> {
  late final CoreFormFieldController<TimeOfDay> _controller;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = CoreFormFieldController<TimeOfDay>(
      id: widget.id,
      initialValue: widget.initialValue,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateTextController();
      formScope.controller.registerField(_controller);
    });
  }

  void _updateTextController() {
    _textController.text = _controller.value?.format(context) ?? '';
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _controller.value ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _controller.setValue(picked);
        formScope.controller.updateValue(widget.id, picked);
        _updateTextController();
      });
    }
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
      readOnly: true,
      onTap: _selectTime,
      decoration: InputDecoration(
        hintText: widget.placeholder ?? 'Select time',
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_controller.value != null)
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    _controller.setValue(null);
                    formScope.controller.updateValue(widget.id, null);
                    _updateTextController();
                  });
                },
              ),
            const Icon(Icons.access_time),
          ],
        ),
      ),
    );
  }
}