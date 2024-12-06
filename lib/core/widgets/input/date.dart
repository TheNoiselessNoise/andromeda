import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'base/field.dart';

class CoreDateField extends CoreBaseFormField<DateTime> {
  final String? placeholder;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const CoreDateField({
    super.key,
    required super.id,
    super.initialValue,
    this.placeholder,
    this.firstDate,
    this.lastDate,
  });

  @override
  CoreDateFieldState createState() => CoreDateFieldState();
}

class CoreDateFieldState extends CoreBaseFormFieldState<CoreDateField> {
  late final CoreFormFieldController<DateTime> _controller;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = CoreFormFieldController<DateTime>(
      id: widget.id,
      initialValue: widget.initialValue,
    );
    _updateTextController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      formScope.controller.registerField(_controller);
    });
  }

  void _updateTextController() {
    _textController.text = _controller.value != null
        ? DateFormat('yyyy-MM-dd').format(_controller.value!)
        : '';
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _controller.value ?? DateTime.now(),
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime(2100),
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
      onTap: _selectDate,
      decoration: InputDecoration(
        hintText: widget.placeholder ?? 'Select date',
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
            const Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }
}
