import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

class EspoFloatField extends CoreBaseField<double, CoreBaseFieldState<double>> {
  const EspoFloatField({
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
    super.readOnly,
  });

  String? Function(double?) get floatValidator {
    return validator ?? (value) {
      if (this.required && value == null) {
        return I18n.translate('core-field-required');
      }
      return null;
    };
  }

  @override
  Widget buildField(BuildContext context, CoreBaseFieldState<double> state) {
    return TextFormField(
      controller: state.controller,
      readOnly: readOnly,
      onChanged: (value) {
        state.setValue(double.tryParse(value));
      },
      validator: (value) {
        return floatValidator(state.value);
      },
      onSaved: (value) {
        if (onSaved != null) {
          onSaved!(double.tryParse(value ?? ''));
        }
      },
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      autofocus: autofocus,
      focusNode: focusNode,
      decoration: buildInputDecoration(),
      style: options?.textStyle,
    );
  }
}