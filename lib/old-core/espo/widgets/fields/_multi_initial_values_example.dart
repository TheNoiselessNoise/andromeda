// import 'package:flutter/material.dart';
// import 'package:andromeda/old-core/core.dart';

// class EspoPhone {
//   final String? countryCode;
//   final String? number;

//   EspoPhone({
//     this.countryCode,
//     this.number,
//   });

//   factory EspoPhone.fromJson(Map<String, dynamic> json) {
//     return EspoPhone(
//       countryCode: json['countryCode'],
//       number: json['number'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'countryCode': countryCode,
//       'number': number,
//     };
//   }

//   @override
//   String toString() {
//     String countryCode = this.countryCode != null ? '+${this.countryCode} ' : '';
//     return '$countryCode$number';
//   }
// }

// class EspoPhoneField extends CoreBaseField<String, CoreBaseFieldState<String>> {
//   final bool countryCodeRequired;

//   const EspoPhoneField({
//     super.key,
//     super.id,
//     super.initialValue,
//     super.initialValue2,
//     super.onChanged,
//     super.onChanged2,
//     super.options,
//     super.validator,
//     super.validator2,
//     super.onSaved,
//     super.onSaved2,
//     super.autofocus,
//     super.focusNode,
//     super.required,
//     this.countryCodeRequired = false
//   });

//   String? Function(String?) get countryCodeValidator {
//     return validator ?? (value) {
//       if (countryCodeRequired && (value == null || value.isEmpty)) {
//         return 'Please enter a country code';
//       }

//       return null;
//     };
//   }

//   String? Function(String?) get numberValidator {
//     return validator2 ?? (value) {
//       if (this.required && (value == null || value.isEmpty)) {
//         return 'Please enter a phone number';
//       }

//       return null;
//     };
//   }

//   @override
//   Widget buildField(BuildContext context, CoreBaseFieldState<String> state) {
//     return Row(
//       children: [
//         Expanded(
//           flex: 2,
//           child: TextFormField(
//             controller: state.controller,
//             onChanged: (value) {
//               state.setValue(value);
//             },
//             validator: (value) {
//               return countryCodeValidator(state.value);
//             },
//             onSaved: (value) {
//               onSaved?.call(value);
//             },
//             keyboardType: TextInputType.number,
//             autofocus: autofocus,
//             focusNode: focusNode,
//             decoration: buildInputDecoration(),
//             style: options?.textStyle,
//           ),
//         ),
//         const SizedBox(width: 8),
//         Expanded(
//           flex: 3,
//           child: TextFormField(
//             controller: state.controller2,
//             onChanged: (value) {
//               state.setValue2(value);
//             },
//             validator: (value) {
//               return numberValidator(value);
//             },
//             onSaved: (value) {
//               onSaved2?.call(value);
//             },
//             keyboardType: TextInputType.number,
//             autofocus: autofocus,
//             focusNode: focusNode,
//             decoration: buildInputDecoration(),
//             style: options?.textStyle,
//           ),
//         ),
//       ],
//     );
//   }
// }