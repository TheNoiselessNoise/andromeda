import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

class EspoDateTimeField extends CoreBaseField<DateTime, CoreBaseFieldState<DateTime>> {
  final String? dateFormat;
  final String? timeFormat;

  const EspoDateTimeField({
    super.key,
    super.id,
    super.initialValue,
    super.onChanged,
    super.options,
    super.validator,
    super.onSaved,
    super.autofocus,
    super.focusNode,
    super.required,
    this.dateFormat = 'dd/MM/yyyy',
    this.timeFormat = 'HH:mm:ss',
  });

  @override
  String renderValue(DateTime? value) {
    return value != null ? DateFormat('$dateFormat $timeFormat').format(value) : '';
  }

  Future<void> _selectDate(BuildContext context, CoreBaseFieldState<DateTime> state) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: state.value ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (context.mounted){
      _selectTime(context, pickedDate, state);
    }
  }

  Future<void> _selectTime(BuildContext context, DateTime? pickedDate, CoreBaseFieldState<DateTime> state) async {
    if (pickedDate == null) {
      return;
    }

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(state.value ?? DateTime.now()),
    );

    if (pickedTime != null) {
      final DateTime result = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      state.setValue(result);
    }
  }

  String? Function(DateTime?) get dateTimeValidator {
    return validator ?? (value) {
      if (this.required && value == null) {
        return I18n.translate('core-fill-datetime');
      }
      return null;
    };
  }

  @override
  Widget buildField(BuildContext context, CoreBaseFieldState<DateTime> state) {
    return TextFormField(
      controller: state.controller,
      decoration: buildInputDecoration(),
      readOnly: true,
      onTap: () => _selectDate(context, state),
      validator: (String? value) {
        return dateTimeValidator(state.value);
      },
      onSaved: (value) {
        onSaved?.call(state.value!);
      },
      style: options?.textStyle,
    );
  }
}
