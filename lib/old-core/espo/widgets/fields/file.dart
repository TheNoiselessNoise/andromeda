import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:andromeda/old-core/core.dart';

class EspoFileField extends CoreBaseField<List<File>, EspoFileFieldState> {
  final FileType? fileType;
  final List<String>? allowedExtensions;
  final bool multiple;

  const EspoFileField({
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
    this.fileType,
    this.allowedExtensions,
    this.multiple = false,
  });

  @override
  EspoFileFieldState createState() => EspoFileFieldState();

  String? Function(List<File>?) get fileValidator {
    return validator ?? (value) {
      if (this.required && (value == null || value.isEmpty)) {
        return I18n.translate('core-choose-file');
      }
      return null;
    };
  }

  @override
  Widget buildField(BuildContext context, EspoFileFieldState state) {
    return InkWell(
      onTap: () async {
        await state.pickFile();
      },
      child: Container(
        height: 50, // Set a fixed height for the file field
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: options?.borderColor ?? Colors.grey,
            width: options?.borderWidth ?? 1.0,
          ),
          borderRadius: options?.borderRadius ?? BorderRadius.circular(4.0),
        ),
        alignment: Alignment.center,
        child: state.value != null
            ? Text(state.value!.first.path.split('/').last) // Display the file name
            : const Text('Tap to select a file'),
      ),
    );
  }
}

class EspoFileFieldState extends CoreBaseFieldState<List<File>> {
  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: (widget as EspoFileField).fileType ?? FileType.any,
      allowedExtensions: (widget as EspoFileField).allowedExtensions,
      allowMultiple: (widget as EspoFileField).multiple,
    );

    if (result != null) {
      setValue(result.paths.map((path) => File(path!)).toList());
    }
  }
}
