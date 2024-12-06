import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

class EspoMultiEnumField<E> extends CoreBaseField<List<E>, CoreBaseFieldState<List<E>>> {
  final List<E> items;
  final Widget Function(E)? itemLabelBuilder;

  final String Function(E)? dialogItemLabelBuilder;
  final Widget? dropdownTitleWidget;
  final Widget? dropdownWidget;
  final Widget? dropdownCancelActionWidget;
  final Widget? dropdownConfirmActionWidget;
  final List<Widget>? dropdownOtherActionsWidgets;
  final bool showCheckboxes;

  const EspoMultiEnumField({
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
    required this.items,
    this.itemLabelBuilder,
    this.dialogItemLabelBuilder,
    this.dropdownTitleWidget,
    this.dropdownWidget,
    this.dropdownCancelActionWidget,
    this.dropdownConfirmActionWidget,
    this.dropdownOtherActionsWidgets,
    this.showCheckboxes = false,
  });

  void _onItemCheckedChange(CoreBaseFieldState<List<E>> state, E itemValue, bool checked) {
    final List<E> currentValues = state.value ?? <E>[];
    final List<E> updatedValues = List<E>.from(currentValues);

    if (checked) {
      updatedValues.add(itemValue);
    } else {
      updatedValues.remove(itemValue);
    }

    state.setValue(updatedValues);
  }

  void _showMultiSelectDialog(BuildContext context, CoreBaseFieldState<List<E>> state) async {
    List<E>? selectedValues = await showDialog<List<E>>(
        context: context,
        builder: (BuildContext context) {
          return MultiSelectDialog(
            items: items,
            initialSelectedValues: state.value ?? <E>[],
            titleWidget: dropdownTitleWidget,
            itemLabelBuilder: dialogItemLabelBuilder,
            cancelActionWidget: dropdownCancelActionWidget,
            confirmActionWidget: dropdownConfirmActionWidget,
            otherActionsWidgets: dropdownOtherActionsWidgets,
          );
        }
    );

    if (selectedValues != null) {
      state.setValue(selectedValues);
    }
  }

  String? Function(List<E>?) get multiEnumValidator {
    return validator ?? (value) {
      if (this.required && (value == null || value.isEmpty)) {
        return I18n.translate('core-choose-option-s');
      }
      return null;
    };
  }

  @override
  Widget buildField(BuildContext context, CoreBaseFieldState<List<E>> state) {
    if (dropdownWidget != null) {
      return GestureDetector(
        onTap: () => _showMultiSelectDialog(context, state),
        child: dropdownWidget,
      );
    }

    return FormField<List<E>>(
      initialValue: state.value ?? [],
      onSaved: onSaved,
      validator: (value) {
        return multiEnumValidator(state.value);
      },
      builder: (FormFieldState<List<E>> field) {
        return Column(
          children: items.map((E item) {
            if (showCheckboxes) {
              return CheckboxListTile(
                value: state.value?.contains(item) ?? false,
                onChanged: (bool? checked) {
                  if (readOnly) {
                    return;
                  }
                  _onItemCheckedChange(state, item, checked ?? false);
                },
                title: itemLabelBuilder != null
                    ? itemLabelBuilder!(item)
                    : Text(item.toString()),
                activeColor: options?.borderColor,
                checkColor: options?.fillColor,
              );
            }

            return SwitchListTile(
              value: state.value?.contains(item) ?? false,
              onChanged: (bool value) {
                if (readOnly) {
                  return;
                }
                _onItemCheckedChange(state, item, value);
              },
              title: itemLabelBuilder != null
                  ? itemLabelBuilder!(item)
                  : Text(item.toString()),
              activeColor: options?.fillColor,
              activeTrackColor: options?.borderColor,
            );
          }).toList(),
        );
      },
    );
  }
}