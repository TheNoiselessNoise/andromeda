import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

class EspoEmailField extends CoreBaseField<String, CoreBaseFieldState<String>> {
  const EspoEmailField({
    super.key,
    super.id,
    super.initialValue,
    super.onChanged,
    super.options,
    super.validator,
    super.onSaved,
    super.autofocus,
    super.focusNode,
    super.required
  });

  String? Function(String?) get emailValidator {
    return validator ?? (value) {
      if (this.required && (value == null || value.isEmpty)) {
        return I18n.translate('core-fill-email');
      }

      if (value != null && value.isNotEmpty) {
        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
        if (!emailRegex.hasMatch(value)) {
          return I18n.translate('core-fill-email-valid');
        }
      }

      return null;
    };
  }

  @override
  Widget buildField(BuildContext context, CoreBaseFieldState<String> state) {
    return TextFormField(
      controller: state.controller,
      onChanged: (value) {
        state.setValue(value);
      },
      validator: (value) {
        return emailValidator(state.value);
      },
      onSaved: onSaved,
      autofocus: autofocus,
      focusNode: focusNode,
      decoration: buildInputDecoration(),
      style: options?.textStyle,
      keyboardType: TextInputType.emailAddress,
    );
  }
}