import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

class EspoAddress {
  final String street;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  const EspoAddress({
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
  });

  factory EspoAddress.fromJson(Map<String, dynamic> json) {
    return EspoAddress(
      street: json['street'],
      city: json['city'],
      state: json['state'],
      postalCode: json['postalCode'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
    };
  }

  @override
  String toString() {
    return '$street, $city, $state, $postalCode, $country';
  }
}

class AddressDialog extends StatefulWidget {
  final EspoAddress initialValue;

  const AddressDialog({super.key, required this.initialValue});

  @override
  State<AddressDialog> createState() => _AddressDialogState();
}

class _AddressDialogState extends State<AddressDialog> {
  late TextEditingController _streetController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _postalCodeController;
  late TextEditingController _countryController;

  @override
  void initState() {
    super.initState();
    _streetController = TextEditingController(text: widget.initialValue.street);
    _cityController = TextEditingController(text: widget.initialValue.city);
    _stateController = TextEditingController(text: widget.initialValue.state);
    _postalCodeController = TextEditingController(text: widget.initialValue.postalCode);
    _countryController = TextEditingController(text: widget.initialValue.country);
  }

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Address'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _streetController,
              decoration: const InputDecoration(labelText: 'Street'),
            ),
            TextFormField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: 'City'),
            ),
            TextFormField(
              controller: _stateController,
              decoration: const InputDecoration(labelText: 'State'),
            ),
            TextFormField(
              controller: _postalCodeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Postal Code'),
            ),
            TextFormField(
              controller: _countryController,
              decoration: const InputDecoration(labelText: 'Country'),
            ),
          ],
        )
      ),
      actions: [
        TextButton(
          onPressed: () {
            CoreNavigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final EspoAddress address = EspoAddress(
              street: _streetController.text,
              city: _cityController.text,
              state: _stateController.text,
              postalCode: _postalCodeController.text,
              country: _countryController.text,
            );
            Navigator.of(context).pop(address);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class EspoAddressField extends CoreBaseField<EspoAddress, CoreBaseFieldState<EspoAddress>> {
  final bool streetRequired;
  final bool cityRequired;
  final bool stateRequired;
  final bool postalCodeRequired;
  final bool countryRequired;

  const EspoAddressField({
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
    this.streetRequired = false,
    this.cityRequired = false,
    this.stateRequired = false,
    this.postalCodeRequired = false,
    this.countryRequired = false,
  });

  String? Function(EspoAddress?) get addressValidator {
    return validator ?? (value) {
      if (value == null && (this.required || streetRequired || cityRequired || stateRequired || postalCodeRequired || countryRequired)) {
        return I18n.translate('core-fill-address');
      }
      if (value != null) {
        if (value.street.isEmpty && streetRequired) {
          return I18n.translate('core-fill-address-street');
        }
        if (value.city.isEmpty && cityRequired) {
          return I18n.translate('core-fill-address-city');
        }
        if (value.state.isEmpty && stateRequired) {
          return I18n.translate('core-fill-address-state');
        }
        if (value.postalCode.isEmpty && postalCodeRequired) {
          return I18n.translate('core-fill-address-postal-code');
        }
        if (value.country.isEmpty && countryRequired) {
          return I18n.translate('core-fill-address-country');
        }
      }
      return null;
    };
  }

  Future<void> _openAddressDialog(BuildContext context, CoreBaseFieldState<EspoAddress> state) async {
    final EspoAddress? result = await showDialog<EspoAddress>(
      context: context,
      builder: (BuildContext context) {
        return AddressDialog(initialValue: initialValue ?? const EspoAddress(street: '', city: '', state: '', postalCode: '', country: ''));
      },
    );
    if (result != null) {
      state.setValue(result);
    }
  }

  @override
  Widget buildField(BuildContext context, CoreBaseFieldState<EspoAddress> state) {
    return TextFormField(
      controller: state.controller,
      decoration: buildInputDecoration(),
      readOnly: true,
      onTap: () => _openAddressDialog(context, state),
      validator: (String? value) {
        return addressValidator(state.value);
      },
      onSaved: (value) {
        onSaved?.call(state.value!);
      },
      style: options?.textStyle,
    );
  }
}
