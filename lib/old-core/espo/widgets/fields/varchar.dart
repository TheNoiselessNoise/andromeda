import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

class EspoVarcharField extends CoreBaseField<String, CoreBaseFieldState<String>> {
  const EspoVarcharField({
    super.key,
    super.id,
    super.controller,
    super.initialValue,
    super.onChanged,
    super.options,
    super.validator,
    super.onSaved,
    super.autofocus,
    super.focusNode,
    super.required,
    super.readOnly,
    super.onControllerValue
  });

  String? Function(String?) get varcharValidator {
    return validator ?? (value) {
      if (this.required && (value == null || value.isEmpty)) {
        return I18n.translate('core-field-required');
      }
      return null;
    };
  }

  @override
  Widget buildField(BuildContext context, CoreBaseFieldState<String> state) {
    return TextFormField(
      controller: state.controller,
      onChanged: (value) {
        if (onChanged != null) onChanged!(value, state);
        state.setValue(value);
      },
      validator: (value) {
        return varcharValidator(state.value);
      },
      onSaved: onSaved,
      autofocus: autofocus,
      focusNode: focusNode,
      decoration: buildInputDecoration(),
      style: options?.textStyle,
      readOnly: readOnly,
    );
  }
}