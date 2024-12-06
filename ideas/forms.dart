// import 'package:flutter/material.dart';

// // Form Context Provider
// class FormProvider extends InheritedWidget {
//   final FormController controller;
  
//   const FormProvider({
//     super.key,
//     required this.controller,
//     required super.child,
//   });
  
//   static FormController of(BuildContext context) {
//     final provider = context.dependOnInheritedWidgetOfExactType<FormProvider>();
//     if (provider == null) {
//       throw FlutterError('No FormProvider found in context');
//     }
//     return provider.controller;
//   }
  
//   @override
//   bool updateShouldNotify(FormProvider oldWidget) {
//     return controller != oldWidget.controller;
//   }
// }

// // Form Controller - Handles form state and field management
// class FormController extends ChangeNotifier {
//   final String formId;
//   final Map<String, FieldController> _fields = {};
//   bool _isValid = false;
//   bool _isDirty = false;
  
//   FormController({required this.formId});
  
//   bool get isValid => _isValid;
//   bool get isDirty => _isDirty;
//   Map<String, FieldController> get fields => Map.unmodifiable(_fields);
  
//   void registerField(FieldController field) {
//     if (_fields.containsKey(field.fieldId)) {
//       throw StateError('Field ${field.fieldId} already registered');
//     }
//     _fields[field.fieldId] = field;
//     field.addListener(_onFieldChanged);
//     _validateForm();
//     notifyListeners();
//   }
  
//   void unregisterField(String fieldId) {
//     final field = _fields.remove(fieldId);
//     field?.removeListener(_onFieldChanged);
//     _validateForm();
//     notifyListeners();
//   }
  
//   void _onFieldChanged() {
//     _isDirty = true;
//     _validateForm();
//     notifyListeners();
//   }
  
//   void _validateForm() {
//     _isValid = _fields.values.every((field) => field.isValid);
//   }
  
//   Map<String, dynamic> getFormData() {
//     return {
//       for (var field in _fields.entries)
//         field.key: field.value.value
//     };
//   }
  
//   void reset() {
//     for (var field in _fields.values) {
//       field.reset();
//     }
//     _isDirty = false;
//     notifyListeners();
//   }
  
//   @override
//   void dispose() {
//     for (var field in _fields.values) {
//       field.dispose();
//     }
//     _fields.clear();
//     super.dispose();
//   }
// }

// // Field Controller - Manages individual field state
// class FieldController<T> extends ValueNotifier<T?> {
//   final String fieldId;
//   final T? initialValue;
//   final FormFieldValidator<T>? validator;
  
//   String? _error;
//   bool _isDirty = false;
//   bool _isTouched = false;
  
//   FieldController({
//     required this.fieldId,
//     this.initialValue,
//     this.validator,
//   }) : super(initialValue);
  
//   bool get isValid => _error == null;
//   bool get isDirty => _isDirty;
//   bool get isTouched => _isTouched;
//   String? get error => _error;
  
//   void setValue(T? newValue) {
//     if (value != newValue) {
//       value = newValue;
//       _isDirty = true;
//       _validate();
//     }
//   }
  
//   void touch() {
//     if (!_isTouched) {
//       _isTouched = true;
//       _validate();
//     }
//   }
  
//   void _validate() {
//     if (validator != null) {
//       _error = validator!(value);
//       notifyListeners();
//     }
//   }
  
//   void reset() {
//     value = initialValue;
//     _error = null;
//     _isDirty = false;
//     _isTouched = false;
//     notifyListeners();
//   }
// }

// // Base Form Widget
// class CoreForm extends StatefulWidget {
//   final String id;
//   final Widget child;
//   final void Function(Map<String, dynamic> data)? onSubmit;
  
//   const CoreForm({
//     super.key,
//     required this.id,
//     required this.child,
//     this.onSubmit,
//   });
  
//   @override
//   State<CoreForm> createState() => _CoreFormState();
// }

// class _CoreFormState extends State<CoreForm> {
//   late final FormController _controller;
  
//   @override
//   void initState() {
//     super.initState();
//     _controller = FormController(formId: widget.id);
//   }
  
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
  
//   void _handleSubmit() {
//     if (_controller.isValid && widget.onSubmit != null) {
//       widget.onSubmit!(_controller.getFormData());
//     }
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return FormProvider(
//       controller: _controller,
//       child: widget.child,
//     );
//   }
// }

// // Base Field Widget
// class CoreField<T> extends StatefulWidget {
//   final String id;
//   final T? initialValue;
//   final FormFieldValidator<T>? validator;
//   final Widget Function(FieldController<T> controller) builder;
  
//   const CoreField({
//     super.key,
//     required this.id,
//     required this.builder,
//     this.initialValue,
//     this.validator,
//   });
  
//   @override
//   State<CoreField<T>> createState() => _CoreFieldState<T>();
// }

// class _CoreFieldState<T> extends State<CoreField<T>> {
//   late final FieldController<T> _controller;
//   late final FormController _formController;
  
//   @override
//   void initState() {
//     super.initState();
//     _controller = FieldController<T>(
//       fieldId: widget.id,
//       initialValue: widget.initialValue,
//       validator: widget.validator,
//     );
//   }
  
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _formController = FormProvider.of(context);
//     _formController.registerField(_controller);
//   }
  
//   @override
//   void dispose() {
//     _formController.unregisterField(widget.id);
//     _controller.dispose();
//     super.dispose();
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return widget.builder(_controller);
//   }
// }

// // Example Usage
// class ExampleForm extends StatelessWidget {
//   const ExampleForm({super.key});
  
//   @override
//   Widget build(BuildContext context) {
//     return CoreForm(
//       id: 'example-form',
//       onSubmit: (data) {
//         print('Form submitted with data: $data');
//       },
//       child: Column(
//         children: [
//           CoreField<String>(
//             id: 'name',
//             validator: (value) {
//               if (value?.isEmpty ?? true) return 'Name is required';
//               return null;
//             },
//             builder: (controller) => TextField(
//               onChanged: controller.setValue,
//               decoration: InputDecoration(
//                 labelText: 'Name',
//                 errorText: controller.error,
//               ),
//             ),
//           ),
//           CoreField<int>(
//             id: 'age',
//             validator: (value) {
//               if (value == null) return 'Age is required';
//               if (value < 0) return 'Age must be positive';
//               return null;
//             },
//             builder: (controller) => TextField(
//               onChanged: (value) => controller.setValue(int.tryParse(value)),
//               decoration: InputDecoration(
//                 labelText: 'Age',
//                 errorText: controller.error,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }