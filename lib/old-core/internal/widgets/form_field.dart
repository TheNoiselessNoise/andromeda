import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

enum CoreFieldLabelSide {
  top,
  left,
  right,
  bottom
}

class CoreFieldOptions {
  final Color? fillColor;

  final OutlineInputBorder? border;
  final Color? borderColor;
  final double? borderWidth;
  final BorderSide? borderSide;
  final BorderRadius? borderRadius;

  final OutlineInputBorder? enabledBorder;
  final Color? enabledBorderColor;
  final double? enabledBorderWidth;
  final BorderSide? enabledBorderSide;
  final BorderRadius? enabledBorderRadius;

  final OutlineInputBorder? focusedBorder;
  final Color? focusedBorderColor;
  final double? focusedBorderWidth;
  final BorderSide? focusedBorderSide;
  final BorderRadius? focusedBorderRadius;

  final OutlineInputBorder? errorBorder;
  final Color? errorBorderColor;
  final double? errorBorderWidth;
  final BorderSide? errorBorderSide;
  final BorderRadius? errorBorderRadius;

  final OutlineInputBorder? focusedErrorBorder;
  final Color? focusedErrorBorderColor;
  final double? focusedErrorBorderWidth;
  final BorderSide? focusedErrorBorderSide;
  final BorderRadius? focusedErrorBorderRadius;

  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final EdgeInsetsGeometry? contentPadding;
  final String? hintText;

  final Widget? label;
  final String? labelText;
  final CoreFieldLabelSide? labelSide;
  final TextStyle? labelStyle;

  const CoreFieldOptions({
    this.fillColor,

    this.border,
    this.borderColor,
    this.borderWidth,
    this.borderSide,
    this.borderRadius,

    this.enabledBorder,
    this.enabledBorderColor,
    this.enabledBorderWidth,
    this.enabledBorderSide,
    this.enabledBorderRadius,

    this.focusedBorder,
    this.focusedBorderColor,
    this.focusedBorderWidth,
    this.focusedBorderSide,
    this.focusedBorderRadius,

    this.errorBorder,
    this.errorBorderColor,
    this.errorBorderWidth,
    this.errorBorderSide,
    this.errorBorderRadius,

    this.focusedErrorBorder,
    this.focusedErrorBorderColor,
    this.focusedErrorBorderWidth,
    this.focusedErrorBorderSide,
    this.focusedErrorBorderRadius,

    this.textStyle,
    this.hintStyle,
    this.contentPadding,
    this.hintText,

    this.label,
    this.labelText,
    this.labelSide,
    this.labelStyle,
  });
}

class CoreEditingController<T> extends TextEditingController {
  T? initialValue;
  final String Function(T?)? onValue;

  CoreEditingController({
    this.initialValue,
    this.onValue,
  });

  String get renderValue {
    if (onValue != null) {
      return onValue!(initialValue);
    }
    if (initialValue == null) {
      return '';
    }
    return initialValue.toString();
  }
}

typedef OnFieldChanged<T> = void Function(T? value, CoreBaseFieldState<T> state);

abstract class CoreBaseField<T, S extends CoreBaseFieldState<T>> extends StatefulWidget {
  final String? id;
  final GlobalKey? formKey;

  final CoreFieldOptions? options;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool required;
  final bool readOnly;

  final T? initialValue;
  final CoreEditingController<T>? controller;
  final String Function(T?)? onControllerValue;
  final OnFieldChanged? onChanged;
  final FormFieldSetter<T>? onSaved;
  final FormFieldValidator<T>? validator;

  const CoreBaseField({
    super.key,

    this.id,
    this.formKey,

    this.options,
    this.focusNode,
    this.autofocus = false,
    this.required = false,
    this.readOnly = false,

    this.initialValue,
    this.controller,
    this.onControllerValue,
    this.onChanged,
    this.onSaved,
    this.validator,
  });

  @override
  CoreBaseFieldState<T> createState() => CoreBaseFieldState<T>();

  @protected
  String renderValue(T? value) {
    return value != null ? value.toString() : '';
  }

  @protected
  Widget buildField(BuildContext context, S state) {
    return Text("Input '$id' not implemented");
  }

  @protected
  Widget? buildReadOnlyField(BuildContext context, S state) {
    return null;
  }

  InputDecoration buildInputDecoration() {
    return InputDecoration(
      label: options?.label,
      labelText: options?.labelText,
      labelStyle: options?.labelStyle,
      fillColor: options?.fillColor,
      border: options?.border ?? OutlineInputBorder(
        borderSide: options?.borderSide ?? BorderSide(
          color: options?.borderColor ?? Colors.grey,
          width: options?.borderWidth ?? 1.0,
        ),
        borderRadius: options?.borderRadius ?? BorderRadius.circular(4.0),
      ),
      enabledBorder: options?.enabledBorder ?? OutlineInputBorder(
        borderSide: options?.enabledBorderSide ?? BorderSide(
          color: options?.enabledBorderColor ?? Colors.grey,
          width: options?.enabledBorderWidth ?? 1.0,
        ),
        borderRadius: options?.enabledBorderRadius ?? BorderRadius.circular(4.0),
      ),
      focusedBorder: options?.focusedBorder ?? OutlineInputBorder(
        borderSide: options?.focusedBorderSide ?? BorderSide(
          color: options?.focusedBorderColor ?? Colors.blue,
          width: options?.focusedBorderWidth ?? 1.0,
        ),
        borderRadius: options?.focusedBorderRadius ?? BorderRadius.circular(4.0),
      ),
      errorBorder: options?.errorBorder ?? OutlineInputBorder(
        borderSide: options?.errorBorderSide ?? BorderSide(
          color: options?.errorBorderColor ?? Colors.red,
          width: options?.errorBorderWidth ?? 1.0,
        ),
        borderRadius: options?.errorBorderRadius ?? BorderRadius.circular(4.0),
      ),
      focusedErrorBorder: options?.focusedErrorBorder ?? OutlineInputBorder(
        borderSide: options?.focusedErrorBorderSide ?? BorderSide(
          color: options?.focusedErrorBorderColor ?? Colors.red,
          width: options?.focusedErrorBorderWidth ?? 1.0,
        ),
        borderRadius: options?.focusedErrorBorderRadius ?? BorderRadius.circular(4.0),
      ),
      contentPadding: options?.contentPadding ?? const EdgeInsets.all(8.0),
      hintText: options?.hintText,
      hintStyle: options?.hintStyle,
    );
  }
}

class CoreBaseFieldState<T> extends State<CoreBaseField<T, CoreBaseFieldState<T>>> {
  T? _oldValue;
  T? _value;
  CoreEditingController<T>? _controller;

  T? get value => _value;
  CoreEditingController<T>? get controller => _controller;

  @override
  void didUpdateWidget(CoreBaseField<T, CoreBaseFieldState<T>> oldWidget) {
    super.didUpdateWidget(oldWidget);
   
    if (widget.initialValue != oldWidget.initialValue) {
      _value = widget.initialValue;
      _controller?.initialValue = _value;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_controller?.text.isEmpty ?? false) {
          _controller?.text = _controller?.renderValue ?? '';
        }
        updateFormIfAny();
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _oldValue = _value;
    _value = _value ?? widget.initialValue;

    _controller ??= widget.controller ?? CoreEditingController<T>(
      initialValue: _value,
      onValue: widget.onControllerValue ?? widget.renderValue
    );

    if (_controller?.text.isEmpty ?? false) {
      _controller?.text = _controller?.renderValue ?? '';
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      mountToFormIfAny();
      updateFormIfAny();

      if (widget.initialValue != _oldValue) {
        setState(() {}); 
      }
    });
  }

  void unsetValues() {
    if (_value != null) {
      setValue(null);
    }
  }

  void mountToFormIfAny() {
    if (widget.id != null) {
      final formState = context.findAncestorStateOfType<CoreBaseFormState>();
      if (formState is CoreBaseFormState) {
        if (!formState.formFields.containsKey(widget.id!)) {
          formState.registerField(widget.id!, this);
        }
      }
    }
  }

  void updateFormIfAny() {
    final formState = context.findAncestorStateOfType<CoreBaseFormState>();

    if (formState is CoreBaseFormState) {
      if (widget.id == null){
        Type formType = formState.widget.runtimeType;
        throw Exception('Form $formType does not support form fields without id (${widget.runtimeType})');
      }

      if (formState.mounted) {
        if (formState.formFields.containsKey(widget.id!)) {
          formState.formFields[widget.id!] = this;
        }

        formState.setFieldValue(widget.id!, _value);
      }
    } else {
      setState(() {});
    }
  }

  void unmountFromFormIfAny() {
    if (widget.id != null) {
      final formState = context.findAncestorStateOfType<CoreBaseFormState>();
      if (formState is CoreBaseFormState) {
        if (formState.mounted) {
          if (formState.formFields.containsKey(widget.id!)) {
            formState.formFields.remove(widget.id!);
          }
        }
      }
    }
  }

  @override
  void deactivate() {
    unmountFromFormIfAny();
    super.deactivate();
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller?.dispose();
    super.dispose();
  }

  void setValue(T? newValue) {
    if (newValue == _value) return;

    _value = newValue;
    _controller?.initialValue = newValue;

    if (_controller?.text.isEmpty ?? false) {
      if (widget.onControllerValue != null) {
      _controller?.text = widget.onControllerValue!(newValue);
      } else {
        _controller?.text = controller!.renderValue;
      }
    }

    updateFormIfAny();

    if (widget.onChanged != null) {
      widget.onChanged!(newValue, this);
    }
  }

  void setValueFunc(T? Function(T? oldValue) func) {
    setValue(func(_value));
  }

  Future<void> setValueFuncAsync(Future<T?> Function(T? oldValue) func) async {
    setValue(await func(_value));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.readOnly) {
      Widget? readOnlyField = widget.buildReadOnlyField(context, this);
      return readOnlyField ?? Text(_controller!.renderValue);
    }
    return widget.buildField(context, this);
  }
}

class MultiSelectDialog<E> extends StatefulWidget {
  final List<E> items;
  final List<E> initialSelectedValues;
  final Widget? titleWidget;
  final String Function(E)? itemLabelBuilder;
  final Widget? cancelActionWidget;
  final Widget? confirmActionWidget;
  final List<Widget>? otherActionsWidgets;
  final CoreFieldOptions? options;
  final bool readOnly;
  final bool showCheckboxes;

  const MultiSelectDialog({
    super.key,
    required this.items,
    required this.initialSelectedValues,
    this.titleWidget,
    this.itemLabelBuilder,
    this.cancelActionWidget,
    this.confirmActionWidget,
    this.otherActionsWidgets,
    this.options,
    this.readOnly = false,
    this.showCheckboxes = false
  });

  @override
  State<MultiSelectDialog<E>> createState() => _MultiSelectDialogState<E>();
}

class _MultiSelectDialogState<E> extends State<MultiSelectDialog<E>> {
  List<E> _selectedValues = [];

  @override
  void initState() {
    super.initState();
    _selectedValues = List<E>.from(widget.initialSelectedValues);
  }

  void _onItemCheckedChange(E itemValue, bool checked) {
    setState(() {
      if (checked) {
        _selectedValues.add(itemValue);
      } else {
        _selectedValues.remove(itemValue);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget cancelActionWidget = TextButton(
      child: const Text('Cancel'),
      onPressed: () {
        CoreNavigator.pop(context);
      },
    );

    if (widget.cancelActionWidget != null) {
      cancelActionWidget = GestureDetector(
        onTap: () {
          CoreNavigator.pop(context);
        },
        child: widget.cancelActionWidget,
      );
    }

    Widget confirmActionWidget = TextButton(
      child: const Text('OK'),
      onPressed: () {
        Navigator.of(context).pop(_selectedValues);
      },
    );

    if (widget.confirmActionWidget != null) {
      confirmActionWidget = GestureDetector(
        onTap: () {
          Navigator.of(context).pop(_selectedValues);
        },
        child: widget.confirmActionWidget,
      );
    }

    return AlertDialog(
      title: widget.titleWidget ?? const Text('Select Options'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items.map((E item) {
            if (widget.showCheckboxes) {
              return CheckboxListTile(
                value: _selectedValues.contains(item),
                onChanged: (bool? checked) {
                  if (widget.readOnly) {
                    return;
                  }
                  _onItemCheckedChange(item, checked ?? false);
                },
                title: Text(
                    widget.itemLabelBuilder != null ? widget.itemLabelBuilder!(
                        item) : item.toString()),
              );
            }

            return SwitchListTile(
              value: _selectedValues.contains(item),
              onChanged: (bool value) {
                if (widget.readOnly) {
                  return;
                }
                _onItemCheckedChange(item, value);
              },
              title: Text(
                  widget.itemLabelBuilder != null ? widget.itemLabelBuilder!(
                      item) : item.toString()),
              activeColor: widget.options?.fillColor,
              activeTrackColor: widget.options?.borderColor,
            );
          }).toList(),
        ),
      ),
      actions: <Widget>[
        cancelActionWidget,
        confirmActionWidget,
        if (widget.otherActionsWidgets != null) ...widget.otherActionsWidgets!,
      ],
    );
  }
}