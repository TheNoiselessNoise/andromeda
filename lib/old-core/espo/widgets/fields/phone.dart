import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

class EspoPhone {
  final String? countryCode;
  final String? number;

  EspoPhone({
    this.countryCode,
    this.number,
  });

  factory EspoPhone.fromJson(Map<String, dynamic> json) {
    return EspoPhone(
      countryCode: json['countryCode'],
      number: json['number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'countryCode': countryCode,
      'number': number,
    };
  }

  @override
  String toString() {
    String countryCode = this.countryCode != null ? '+${this.countryCode} ' : '';
    return '$countryCode$number';
  }
}

class EspoPhoneField extends CoreBaseField<EspoPhone, CoreBaseFieldState<EspoPhone>> {
  final bool countryCodeRequired;

  const EspoPhoneField({
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
    this.countryCodeRequired = false
  });

  String? Function(EspoPhone?) get phoneValidator {
    return validator ?? (value) {
      if (this.required && (value == null || value.number == null || value.number!.isEmpty)) {
        return I18n.translate('core-fill-phone-number');
      }

      if (countryCodeRequired && (value == null || value.countryCode == null || value.countryCode!.isEmpty)) {
        return I18n.translate('core-fill-phone-country');
      }

      return null;
    };
  }

  @override
  Widget buildField(BuildContext context, CoreBaseFieldState<EspoPhone> state) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextFormField(
            initialValue: state.value?.countryCode,
            onChanged: (value) {
              state.setValue(EspoPhone(
                countryCode: value,
                number: state.value?.number,
              ));
            },
            validator: (value) {
              return phoneValidator(state.value);
            },
            onSaved: (value) {
              onSaved?.call(EspoPhone(
                countryCode: state.value?.countryCode,
                number: value,
              ));
            },
            keyboardType: TextInputType.number,
            autofocus: autofocus,
            focusNode: focusNode,
            decoration: buildInputDecoration(),
            style: options?.textStyle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: TextFormField(
            initialValue: state.value?.number,
            onChanged: (value) {
              state.setValue(EspoPhone(
                countryCode: state.value?.countryCode,
                number: value,
              ));
            },
            validator: (value) {
              return phoneValidator(state.value);
            },
            onSaved: (value) {
              onSaved?.call(EspoPhone(
                countryCode: state.value?.countryCode,
                number: value,
              ));
            },
            keyboardType: TextInputType.number,
            autofocus: autofocus,
            focusNode: focusNode,
            decoration: buildInputDecoration(),
            style: options?.textStyle,
          ),
        ),
      ],
    );
  }
}