import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'base/field.dart';

class CoreColorField extends CoreBaseFormField<Color> {
  final String? label;
  final bool? showAlpha;
  final List<Color>? presetColors;

  const CoreColorField({
    super.key,
    required super.id,
    super.initialValue,
    this.label,
    this.showAlpha,
    this.presetColors,
  });

  @override
  CoreColorFieldState createState() => CoreColorFieldState();
}

class CoreColorFieldState extends CoreBaseFormFieldState<CoreColorField> {
  late final CoreFormFieldController<Color> _controller;

  @override
  void initState() {
    super.initState();
    _controller = CoreFormFieldController<Color>(
      id: widget.id,
      initialValue: widget.initialValue ?? Colors.blue,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      formScope.controller.registerField(_controller);
    });
  }

  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Pick a color'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ColorPicker(
                pickerColor: _controller.value ?? Colors.blue,
                onColorChanged: (color) {
                  setState(() {
                    _controller.setValue(color);
                    formScope.controller.updateValue(widget.id, color);
                  });
                },
                hexInputBar: true,
                enableAlpha: widget.showAlpha ?? true,
                displayThumbColor: true,
                pickerAreaHeightPercent: 0.8,
                portraitOnly: true,
              ),
              if (widget.presetColors != null) ...[
                const Divider(),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.presetColors!.map((color) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _controller.setValue(color);
                          formScope.controller.updateValue(widget.id, color);
                        });
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: color,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
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
        GestureDetector(
          onTap: () => _showColorPicker(context),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _controller.value ?? Colors.blue,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      bottomLeft: Radius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '#${(_controller.value ?? Colors.blue).value.toRadixString(16).toUpperCase().padLeft(8, '0')}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Spacer(),
                const Icon(Icons.colorize),
                const SizedBox(width: 12),
              ],
            ),
          ),
        ),
      ],
    );
  }
}