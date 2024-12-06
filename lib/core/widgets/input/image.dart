import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'base/field.dart';

// TODO: add support for multiple List<File>
//       or make it a separate field - CoreMultiImageField

class CoreImageField extends CoreBaseFormField<File> {
  final String? label;
  final double? maxSizeInMB;
  final bool? allowMultiple;
  final double? previewHeight;
  final double? previewWidth;
  final BoxFit? previewFit;

  const CoreImageField({
    super.key,
    required super.id,
    super.initialValue,
    this.label,
    this.maxSizeInMB,
    this.allowMultiple,
    this.previewHeight,
    this.previewWidth,
    this.previewFit,
  });

  @override
  CoreImageFieldState createState() => CoreImageFieldState();
}

class CoreImageFieldState extends CoreBaseFormFieldState<CoreImageField> {
  late final CoreFormFieldController<File> _controller;
  bool _isDragging = false;
  String? _error;

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

  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: allowMultiple,
      );

      if (result != null) {
        final file = File(result.files.single.path!);
        
        // Validate file size if maxSize is specified
        if (widget.maxSizeInMB != null) {
          final sizeInMB = file.lengthSync() / (1024 * 1024);
          if (sizeInMB > widget.maxSizeInMB!) {
            setState(() {
              _error = 'Image size exceeds ${widget.maxSizeInMB}MB limit';
            });
            return;
          }
        }

        // Validate that it's actually an image
        try {
          await decodeImageFromList(file.readAsBytesSync());
        } catch (e) {
          setState(() {
            _error = 'Selected file is not a valid image';
          });
          return;
        }

        setState(() {
          _error = null;
          _controller.setValue(file);
          formScope.controller.updateValue(widget.id, file);
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error picking image: $e';
      });
    }
  }

  Widget _buildImagePreview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.file(
        _controller.value!,
        height: widget.previewHeight,
        width: widget.previewWidth,
        fit: widget.previewFit,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: widget.previewHeight,
            width: widget.previewWidth,
            color: Colors.grey[200],
            child: const Center(
              child: Icon(Icons.error_outline, size: 32, color: Colors.red),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: widget.previewHeight,
      width: widget.previewWidth,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.image, size: 48, color: Colors.grey),
          const SizedBox(height: 8),
          Text(
            'Drop image here or click to upload',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          if (widget.maxSizeInMB != null) ...[
            const SizedBox(height: 4),
            Text(
              'Max size: ${widget.maxSizeInMB}MB',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
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
        DragTarget<File>(
          onAcceptWithDetails: (details) async {
            try {
              // Validate that it's an image
              await decodeImageFromList(details.data.readAsBytesSync());
              
              setState(() {
                _error = null;
                _controller.setValue(details.data);
                formScope.controller.updateValue(widget.id, details.data);
                _isDragging = false;
              });
            } catch (e) {
              setState(() {
                _error = 'Dropped file is not a valid image';
                _isDragging = false;
              });
            }
          },
          onLeave: (_) => setState(() => _isDragging = false),
          onWillAcceptWithDetails: (_) {
            setState(() => _isDragging = true);
            return true;
          },
          builder: (context, candidateData, rejectedData) {
            return GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  _controller.value != null
                      ? _buildImagePreview()
                      : _buildPlaceholder(),
                  if (_controller.value != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Material(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              _controller.setValue(null);
                              formScope.controller.updateValue(widget.id, null);
                            });
                          },
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _error!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}