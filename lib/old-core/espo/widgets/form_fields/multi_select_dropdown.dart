import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:andromeda/old-core/core.dart';

class MultiSelectDropDownField<T> extends CoreBaseField<List<T>, CoreBaseFieldState<List<T>>>{
  final Map<String, T>? selectOptions;
  final List<T>? selectedOptions;
  final MultiSelectController<T>? msController;
  
  MultiSelectDropDownField({
    super.key,
    super.id,
    super.onChanged,
    super.options,
    super.validator,
    super.onSaved,
    super.autofocus,
    super.focusNode,
    super.required,
    this.selectOptions,
    this.selectedOptions,
    this.msController,
  }) : super(
    initialValue: selectedOptions ?? [],
  );

  String? Function(List<T>?) get msddValidator {
    return validator ?? (value) {
      if (this.required && (value?.isEmpty ?? true)) {
        return "This field is required";
      }
      return null;
    };
  }

  @override
  Widget buildField(BuildContext context, CoreBaseFieldState<List<T>> state) {
    return FormField<List<T>>(
      validator: (value) {
        return msddValidator(state.value);
      },
      builder: (fieldState) {
        List<ValueItem<T>> selectOptionsList = (selectOptions?.keys.map((e) {
          return ValueItem(value: e, label: selectOptions![e].toString());
        }).toList() ?? []) as List<ValueItem<T>>;

        List<ValueItem<T>> selectedOptionsList = state.value?.map((e) {
          return ValueItem(value: e, label: selectOptions![e].toString());
        }).toList() ?? [];

        return MultiSelectDropDown<T>(
          controller: msController,
          options: selectOptionsList,
          selectedOptions: selectedOptionsList,
          onOptionSelected: (List<ValueItem> selected) {
            List<T> selectedOptions = selected.map((e) => e.value as T).toList();
            state.setValue(selectedOptions);
          },
          onOptionRemoved: (int index, ValueItem removed) {
            if (state.value == null) return;
            List<T> selected = List.from(state.value!);
            selected.remove(removed.value);
            state.setValue(List.from(selected));
          },
          chipConfig: const ChipConfig(
            wrapType: WrapType.wrap,
          ),
          clearIcon: null,
        );
      },
    );
  }
}