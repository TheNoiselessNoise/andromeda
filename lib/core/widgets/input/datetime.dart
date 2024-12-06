import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'base/field.dart';

class CoreDateTimeField extends CoreBaseFormField<DateTime> {
  final String? placeholder;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const CoreDateTimeField({
    super.key,
    required super.id,
    super.initialValue,
    this.placeholder,
    this.firstDate,
    this.lastDate,
  });

  @override
  CoreDateTimeFieldState createState() => CoreDateTimeFieldState();
}

class CoreDateTimeFieldState extends CoreBaseFormFieldState<CoreDateTimeField> {
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
        ? DateFormat('yyyy-MM-dd HH:mm').format(_controller.value!)
        : '';
  }

  Future<void> _selectDateTime() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _controller.value ?? DateTime.now(),
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime(2100),
    );

    if (date == null) return;

    if (!mounted) return;

    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_controller.value ?? DateTime.now()),
    );

    if (time == null) return;

    final DateTime dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    setState(() {
      _controller.setValue(dateTime);
      formScope.controller.updateValue(widget.id, dateTime);
      _updateTextController();
    });
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
      onTap: _selectDateTime,
      decoration: InputDecoration(
        hintText: widget.placeholder ?? 'Select date and time',
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
            const Icon(Icons.event),
          ],
        ),
      ),
    );
  }
}