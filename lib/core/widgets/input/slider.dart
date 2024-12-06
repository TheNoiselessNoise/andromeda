import 'package:flutter/material.dart';
import 'base/field.dart';

class CoreSliderField extends CoreBaseFormField<double> {
  final double? min;
  final double? max;
  final int? divisions;
  final String? label;
  final String Function(double)? valueLabel;

  const CoreSliderField({
    super.key,
    required super.id,
    super.initialValue,
    this.min,
    this.max,
    this.divisions,
    this.label,
    this.valueLabel,
  });

  @override
  CoreSliderFieldState createState() => CoreSliderFieldState();
}

class CoreSliderFieldState extends CoreBaseFormFieldState<CoreSliderField> {
  late final CoreFormFieldController<double> _controller;

  double get min => widget.min ?? 0;
  double get max => widget.max ?? 100;

  @override
  void initState() {
    super.initState();
    _controller = CoreFormFieldController<double>(
      id: widget.id,
      initialValue: widget.initialValue ?? widget.min,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      formScope.controller.registerField(_controller);
    });
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
        Row(
          children: [
            Text(widget.min.toString()),
            Expanded(
              child: Slider(
                value: _controller.value ?? min,
                min: min,
                max: max,
                divisions: widget.divisions,
                label: widget.valueLabel?.call(_controller.value ?? min) ??
                    _controller.value?.toString(),
                onChanged: (value) {
                  setState(() {
                    _controller.setValue(value);
                    formScope.controller.updateValue(widget.id, value);
                  });
                },
              ),
            ),
            Text(widget.max.toString()),
          ],
        ),
        if (widget.valueLabel != null)
          Center(
            child: Text(
              widget.valueLabel!(_controller.value ?? min),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
      ],
    );
  }
}