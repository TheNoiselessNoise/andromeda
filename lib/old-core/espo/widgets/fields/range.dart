import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

class EspoRangeField extends CoreBaseField<RangeValues, CoreBaseFieldState<RangeValues>> {
  final double min;
  final double max;
  final int? divisions;

  const EspoRangeField({
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

  String? Function(RangeValues?) get intValidator {
    return validator ?? (value) {
      if (this.required && value == null) {
        return I18n.translate('core-field-required');
      }

      if (value != null) {
        if (value.start < min || value.end > max) {
          return I18n.translate('core-value-between').format([min, max]);
        }
      }

      return null;
    };
  }

  @override
  Widget buildField(BuildContext context, CoreBaseFieldState<RangeValues> state) {
    return FormField(
      validator: intValidator,
      initialValue: state.value ?? initialValue ?? RangeValues(min, max),
      onSaved: onSaved,
      builder: (FormFieldState<RangeValues> field) {
        return RangeSlider(
          values: field.value ?? RangeValues(min, max),
          min: min,
          max: max,
          divisions: divisions,
          labels: RangeLabels(
            field.value?.start.toStringAsFixed(1) ?? min.toStringAsFixed(1),
            field.value?.end.toStringAsFixed(1) ?? max.toStringAsFixed(1),
          ),
          onChanged: (RangeValues newValues) {
            if (readOnly) {
              return;
            }
            field.didChange(newValues);
            state.setValue(newValues);
          },
        );
      },
    );
  }
}