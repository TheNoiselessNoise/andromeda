import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

class EspoDateField extends CoreBaseField<DateTime, CoreBaseFieldState<DateTime>> {
  final String dateFormat;

  const EspoDateField({
    super.key,
    super.id,
    super.initialValue,
    super.validator,
    super.onChanged,
    super.options,
    super.onSaved,
    super.autofocus,
    super.focusNode,
    super.required,
    this.dateFormat = 'dd/MM/yyyy',
  });

  @override
  String renderValue(DateTime? value) {
    return value != null ? DateFormat(dateFormat).format(value) : '';
  }

  String? Function(DateTime?) get dateValidator {
    return validator ?? (value) {
      if (this.required && value == null) {
        return I18n.translate('core-fill-date');
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
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: state.value ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        state.setValue(pickedDate);
      },
      validator: (String? value) {
        return dateValidator(state.value);
      },
      onSaved: (value) {
        onSaved?.call(state.value!);
      },
      style: options?.textStyle,
    );
  }
}