import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

class EspoIntField extends CoreBaseField<int, CoreBaseFieldState<int>> {
  const EspoIntField({
    super.key,
    super.id,
    super.initialValue,
    super.onChanged,
    super.options,
    super.validator,
    super.onSaved,
    super.autofocus,
    super.focusNode,
    super.readOnly,
    super.required
  });

  String? Function(int?) get intValidator {
    return validator ?? (value) {
      if (this.required && value == null) {
        return I18n.translate('core-field-required');
      }
      return null;
    };
  }

  @override
  Widget buildField(BuildContext context, CoreBaseFieldState<int> state) {
    return TextFormField(
      controller: state.controller,
      onChanged: (value) {
        state.setValue(int.tryParse(value));
      },
      validator: (value) {
        return intValidator(state.value);
      },
      onSaved: (value) {
        if (onSaved != null) {
          onSaved!(int.tryParse(value ?? ''));
        }
      },
      readOnly: readOnly,
      keyboardType: TextInputType.number,
      autofocus: autofocus,
      focusNode: focusNode,
      decoration: buildInputDecoration(),
      style: options?.textStyle,
    );
  }
}