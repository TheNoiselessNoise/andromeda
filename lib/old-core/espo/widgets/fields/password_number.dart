import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

class EspoPasswordNumberField extends CoreBaseField<String, EspoPasswordNumberFieldState> {
  const EspoPasswordNumberField({
    super.key,
    super.id,
    super.initialValue,
    super.onChanged,
    super.options,
    super.validator,
    super.onSaved,
    super.autofocus,
    super.focusNode,
    super.required = true
  });

  @override
  EspoPasswordNumberFieldState createState() => EspoPasswordNumberFieldState();

  String? Function(String?) get passwordValidator {
    return validator ?? (value) {
      if (this.required && (value == null || value.isEmpty)) {
        return I18n.translate('core-fill-password');
      }
      return null;
    };
  }

  @override
  Widget buildField(BuildContext context, EspoPasswordNumberFieldState state) {
    Widget suffixIcon = InkWell(
      onTap: () => state.toggleObscureText(),
      focusNode: FocusNode(skipTraversal: true),
      child: Icon(
      state.obscureText
      ? Icons
          .visibility_outlined
          : Icons
          .visibility_off_outlined,
      size: 22,
      ),
    );

    return TextFormField(
      controller: state.controller,
      onChanged: (value) {
        state.setValue(value);
      },
      validator: (value) {
        return passwordValidator(state.value);
      },
      onSaved: onSaved,
      autofocus: autofocus,
      focusNode: focusNode,
      decoration: buildInputDecoration().copyWith(
        suffixIcon: suffixIcon,
      ),
      style: options?.textStyle,
      keyboardType: TextInputType.number,
      obscureText: state.obscureText,
    );
  }
}

class EspoPasswordNumberFieldState extends CoreBaseFieldState<String> {
  bool _obscureText = true;

  bool get obscureText => _obscureText;

  void toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}