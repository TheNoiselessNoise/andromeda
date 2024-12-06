import 'package:flutter/material.dart';
import 'base/field.dart';

class CorePasswordField extends CoreBaseFormField<String> {
  final String? placeholder;
  final String? label;
  final bool? showStrengthIndicator;

  const CorePasswordField({
    super.key,
    required super.id,
    super.initialValue,
    this.placeholder,
    this.label,
    this.showStrengthIndicator,
  });

  @override
  CorePasswordFieldState createState() => CorePasswordFieldState();
}

class CorePasswordFieldState extends CoreBaseFormFieldState<CorePasswordField> {
  late final CoreFormFieldController<String> _controller;
  final TextEditingController _textController = TextEditingController();
  bool _obscureText = true;
  double _strength = 0;

  bool get showStrengthIndicator => widget.showStrengthIndicator ?? false;

  @override
  void initState() {
    super.initState();
    _controller = CoreFormFieldController<String>(
      id: widget.id,
      initialValue: widget.initialValue,
    );
    _textController.text = widget.initialValue ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      formScope.controller.registerField(_controller);
    });
  }

  void _updateStrength(String value) {
    if (value.isEmpty) {
      _strength = 0;
      return;
    }

    _strength = 0;
    if (value.length > 6) _strength += 0.2;
    if (value.length > 8) _strength += 0.2;
    if (value.contains(RegExp(r'[A-Z]'))) _strength += 0.2;
    if (value.contains(RegExp(r'[0-9]'))) _strength += 0.2;
    if (value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) _strength += 0.2;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _textController,
          obscureText: _obscureText,
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.placeholder ?? 'Enter password',
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
          ),
          onChanged: (value) {
            if (showStrengthIndicator) {
              setState(() {
                _updateStrength(value);
              });
            }
            _controller.setValue(value);
            formScope.controller.updateValue(widget.id, value);
          },
        ),
        if (showStrengthIndicator && _textController.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  value: _strength,
                  backgroundColor: Colors.grey[300],
                  color: _strength < 0.3
                      ? Colors.red
                      : _strength < 0.7
                          ? Colors.orange
                          : Colors.green,
                ),
                const SizedBox(height: 4),
                Text(
                  _strength < 0.3
                      ? 'Weak'
                      : _strength < 0.7
                          ? 'Medium'
                          : 'Strong',
                  style: TextStyle(
                    color: _strength < 0.3
                        ? Colors.red
                        : _strength < 0.7
                            ? Colors.orange
                            : Colors.green,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}