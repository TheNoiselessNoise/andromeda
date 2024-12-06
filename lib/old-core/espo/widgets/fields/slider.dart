import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

class EspoSliderField extends CoreBaseField<double, CoreBaseFieldState<double>> {
  final double min;
  final double max;
  final int? divisions;

  const EspoSliderField({
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
    this.min = 0,
    this.max = 100,
    this.divisions,
  });

  String? Function(double?) get sliderValidator {
    return validator ?? (value) {
      if (this.required && value == null) {
        return I18n.translate('core-field-required');
      }

      if (value != null) {
        if (value < min || value > max) {
          return I18n.translate('core-value-between').format([min, max]);
        }
      }

      return null;
    };
  }

  @override
  Widget buildField(BuildContext context, CoreBaseFieldState<double> state) {
    return FormField(
      validator: sliderValidator,
      initialValue: state.value ?? initialValue ?? min,
      onSaved: onSaved,
      builder: (FormFieldState<double> field) {
        return Slider(
          value: field.value ?? min,
          min: min,
          max: max,
          divisions: divisions,
          label: options?.labelText ?? field.value?.toStringAsFixed(1),
          onChanged: (double newValue) {
            if (readOnly) {
              return;
            }
            field.didChange(newValue);
            state.setValue(newValue);
          },
        );
      },
    );
  }
}