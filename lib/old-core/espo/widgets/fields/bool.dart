import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

class EspoBoolField extends CoreBaseField<bool, CoreBaseFieldState<bool>> {
  final bool showAsCheckbox;

  const EspoBoolField({
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
    this.showAsCheckbox = false,
  });

  String? Function(bool?) get boolValidator {
    return validator ?? (value) {
      if (this.required && value == null) {
        return I18n.translate('core-field-required');
      }
      return null;
    };
  }

  @override
  Widget buildField(BuildContext context, CoreBaseFieldState<bool> state) {
    return FormField<bool>(
      initialValue: state.value ?? false,
      onSaved: onSaved,
      validator: boolValidator,
      builder: (FormFieldState<bool> field) {
        if (showAsCheckbox) {
          return CheckboxListTile(
            enabled: !readOnly,
            value: field.value ?? false,
            onChanged: (bool? value) {
              field.didChange(value);
              state.setValue(value);
            },
            title: field.hasError
                ? Text(
              field.errorText!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            )
                : options?.label ?? const Text(''),
            activeColor: options?.fillColor,
          );
        }

        return SwitchListTile(
          value: field.value ?? false,
          onChanged: (bool value) {
            if (readOnly) {
              return;
            }
            field.didChange(value);
            state.setValue(value);
          },
          title: field.hasError
              ? Text(
            field.errorText!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          )
              : options?.label ?? const Text(''),
          activeColor: options?.fillColor,
          activeTrackColor: options?.borderColor,
        );
      },
    );
  }
}