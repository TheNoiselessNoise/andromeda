import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

class EspoEnumField<T> extends CoreBaseField<T, CoreBaseFieldState<T>> {
  final Map<String, dynamic>? mapItems;
  final List<T>? items;
  final Widget Function(T)? itemLabelBuilder;

  const EspoEnumField({
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
    this.mapItems,
    this.items,
    this.itemLabelBuilder,
  });

  String? Function(T?) get enumValidator {
    return validator ?? (value) {
      if (this.required && value == null) {
        return I18n.translate('core-choose-option');
      }
      return null;
    };
  }

  @override
  Widget buildField(BuildContext context, CoreBaseFieldState<T> state) {
    List<DropdownMenuItem<T>> finalItems = [];

    if (mapItems != null) {
      finalItems = mapItems!.entries.map<DropdownMenuItem<T>>((entry) {
        return DropdownMenuItem<T>(
          value: entry.key as T,
          child: itemLabelBuilder != null ? itemLabelBuilder!(entry.key as T) : Text(entry.value.toString()),
        );
      }).toList();
    }

    if (this.items != null) {
      finalItems = items!.map<DropdownMenuItem<T>>((T value) {
        return DropdownMenuItem<T>(
          value: value,
          child: itemLabelBuilder != null ? itemLabelBuilder!(value) : Text(value.toString()),
        );
      }).toList();
    }

    return DropdownButtonFormField<T>(
      value: state.value,
      onChanged: (T? newValue) {
        state.setValue(newValue);
      },
      validator: (value) {
        return enumValidator(state.value);
      },
      onSaved: onSaved,
      items: finalItems,
      decoration: buildInputDecoration(),
      style: options?.textStyle,
    );
  }
}