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
//     super.onChanged,
//     super.options,
//     super.validator,
//     super.onSaved,
//     super.autofocus,
//     super.focusNode,
//     super.required,
//     super.initialValueMap,
//     this.countryCodeRequired = false
//   });

//   String? Function(String?) get countryCodeValidator {
//     return (coutryCode) {
//       if (countryCodeRequired && (coutryCode == null || coutryCode.isEmpty)) {
//         return 'Please enter a country code';
//       }

//       return null;
//     };
//   }

//   String? Function(String?) get phoneValidator {
//     return (phone) {
//       if (this.required && (phone == null || phone.isEmpty)) {
//         return 'Please enter a phone number';
//       }

//       return null;
//     };
//   }

//   @override
//   Widget buildField(BuildContext context, CoreBaseFieldState<String> state) {
//     CoreEditingController countryCodeController = state.getMapController('countryCode');
//     CoreEditingController numberController = state.getMapController('number');

//     return Row(
//       children: [
//         Expanded(
//           flex: 2,
//           child: TextFormField(
//             controller: countryCodeController,
//             onChanged: (value) {
//               state.setMapValue('countryCode', value);
//             },
//             validator: (value) {
//               return countryCodeValidator(value);
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
//             controller: numberController,
//             onChanged: (value) {
//               state.setMapValue('number', value);
//             },
//             validator: (value) {
//               return phoneValidator(value);
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
//       ],
//     );
//   }
// }