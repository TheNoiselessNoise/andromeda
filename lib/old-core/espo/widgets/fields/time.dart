import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

class EspoTimeField extends CoreBaseField<DateTime, CoreBaseFieldState<DateTime>> {
  final String timeFormat;

  const EspoTimeField({
    super.key,
    super.id,
    super.initialValue,
    super.onChanged,
    super.options,
    super.onSaved,
    super.autofocus,
    super.focusNode,
    super.required,
    super.onControllerValue,
    this.timeFormat = 'HH:mm:ss',
  });

  @override
  String renderValue(DateTime? value) {
    return value != null ? DateFormat(timeFormat).format(value) : '';
  }

  String? Function(DateTime?) get timeValidator {
    return validator ?? (value) {
      if (this.required && value == null) {
        return I18n.translate('core-fill-time');
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
      onTap: () async {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(state.value ?? DateTime.now()),
        );

        if (time != null) {
          DateTime now = DateTime.now();
          state.setValue(DateTime(
            now.year,
            now.month,
            now.day,
            time.hour,
            time.minute,
          ));
        }
      },
      validator: (value) {
        return timeValidator(state.value);
      },
      onSaved: (value) {
        onSaved?.call(state.value!);
      },
      style: options?.textStyle,
    );
  }
}