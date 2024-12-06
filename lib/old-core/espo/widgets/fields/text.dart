import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

class EspoTextField extends CoreBaseField<String, CoreBaseFieldState<String>> {
  final int? maxLines;
  final int? minLines;

  const EspoTextField({
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
    this.maxLines,
    this.minLines,
  });

  String? Function(String?) get textValidator {
    return validator ?? (value) {
      if (readOnly) {
        return null;
      }
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
        state.setValue(value);
      },
      validator: (value) {
        return textValidator(state.value);
      },
      onSaved: onSaved,
      autofocus: autofocus,
      focusNode: focusNode,
      decoration: buildInputDecoration(),
      style: options?.textStyle,
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: TextInputType.multiline,
      readOnly: readOnly,
    );
  }
}