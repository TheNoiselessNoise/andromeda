import 'package:flutter/material.dart';
import 'base/field.dart';

class CoreRangeField extends CoreBaseFormField<RangeValues> {
  final double? min;
  final double? max;
  final int? divisions;
  final String? label;
  final String Function(double)? valueLabel;
  final bool? showLabels;

  const CoreRangeField({
    super.key,
    required super.id,
    this.min,
    this.max,
    super.initialValue,
    this.divisions,
    this.label,
    this.valueLabel,
    this.showLabels = true,
  });

  @override
  CoreRangeFieldState createState() => CoreRangeFieldState();
}

class CoreRangeFieldState extends CoreBaseFormFieldState<CoreRangeField> {
  late final CoreFormFieldController<RangeValues> _controller;

  double get min => widget.min ?? 0;
  double get max => widget.max ?? 100;
  bool get showLabels => widget.showLabels ?? true;

  @override
  void initState() {
    super.initState();
    _controller = CoreFormFieldController<RangeValues>(
      id: widget.id,
      initialValue: widget.initialValue ?? RangeValues(min, max),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      formScope.controller.registerField(_controller);
    });
  }

  String _formatValue(double value) {
    if (widget.valueLabel != null) {
      return widget.valueLabel!(value);
    }
    return value.toStringAsFixed(widget.divisions == null ? 1 : 0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(widget.label!),
          ),
        if (showLabels)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatValue(_controller.value?.start ?? min)),
              Text(_formatValue(_controller.value?.end ?? max)),
            ],
          ),
        RangeSlider(
          values: _controller.value ?? RangeValues(min, max),
          min: min,
          max: max,
          divisions: widget.divisions,
          labels: RangeLabels(
            _formatValue(_controller.value?.start ?? min),
            _formatValue(_controller.value?.end ?? max),
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _controller.setValue(values);
              formScope.controller.updateValue(widget.id, values);
            });
          },
        ),
      ],
    );
  }
}