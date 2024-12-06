import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'base/field.dart';

// TODO: add support for multiple List<File>
//       or make it a separate field - CoreMultiFileField

class CoreFileFieldFileType {
  static const FileType image = FileType.image;
  static const FileType video = FileType.video;
  static const FileType audio = FileType.audio;
  static const FileType media = FileType.media;
  static const FileType custom = FileType.custom;
  static const FileType any = FileType.any;
}

class CoreFileField extends CoreBaseFormField<File> {
  final String? label;
  final FileType? acceptedType;
  final bool? allowMultiple;
  final Widget? placeholder;
  final double? maxSizeInMB;

  const CoreFileField({
    super.key,
    required super.id,
    this.label,
    this.acceptedType,
    this.allowMultiple,
    this.placeholder,
    this.maxSizeInMB,
  }) : super(initialValue: null);

  @override
  CoreFileFieldState createState() => CoreFileFieldState();
}

class CoreFileFieldState extends CoreBaseFormFieldState<CoreFileField> {
  late final CoreFormFieldController<File> _controller;
  bool _isDragging = false;

  FileType get acceptedType => widget.acceptedType ?? FileType.any;
  bool get allowMultiple => widget.allowMultiple ?? false;

  @override
  void initState() {
    super.initState();
    _controller = CoreFormFieldController<File>(
      id: widget.id,
      initialValue: widget.initialValue,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      formScope.controller.registerField(_controller);
    });
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: acceptedType,
      allowMultiple: allowMultiple,
    );

    if (result != null) {
      final file = File(result.files.single.path!);
      if (widget.maxSizeInMB != null) {
        final sizeInMB = file.lengthSync() / (1024 * 1024);
        if (sizeInMB > widget.maxSizeInMB!) {
          // Show error
          return;
        }
      }

      setState(() {
        _controller.setValue(file);
        formScope.controller.updateValue(widget.id, file);
      });
    }
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
        DragTarget<File>(
          onAcceptWithDetails: (details) {
            setState(() {
              _controller.setValue(details.data);
              formScope.controller.updateValue(widget.id, details.data);
              _isDragging = false;
            });
          },
          onLeave: (_) => setState(() => _isDragging = false),
          onWillAcceptWithDetails: (_) {
            setState(() => _isDragging = true);
            return true;
          },
          builder: (context, candidateData, rejectedData) {
            return GestureDetector(
              onTap: _pickFile,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  // border: Border.all(
                  //   color: _isDragging ? Theme.of(context).primaryColor : Colors.grey,
                  //   width: 2,
                  //   style: _isDragging ? BorderStyle.solid : BorderStyle.dashed,
                  // ),
                  border: Border.all(
                    color: _isDragging ? Theme.of(context).primaryColor : Colors.grey,
                    width: 2,
                    style: _isDragging ? BorderStyle.solid : BorderStyle.none,
                  ),
                ),
                child: _controller.value != null
                    ? Stack(
                        children: [
                          Center(
                            child: Text(_controller.value!.path.split('/').last),
                          ),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                setState(() {
                                  _controller.setValue(null);
                                  formScope.controller.updateValue(widget.id, null);
                                });
                              },
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.upload_file, size: 48),
                          const SizedBox(height: 8),
                          Text(
                            'Drop files here or click to upload',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          if (widget.maxSizeInMB != null)
                            Text(
                              'Max size: ${widget.maxSizeInMB}MB',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                        ],
                      ),
              ),
            );
          },
        ),
      ],
    );
  }
}