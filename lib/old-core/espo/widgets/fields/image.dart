import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:andromeda/old-core/core.dart';

class EspoImageField extends CoreBaseField<List<File>, EspoImageFieldState> {
  final String? assetPath;
  final double maxImageHeight;
  final bool multiple;

  const EspoImageField({
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
    super.readOnly,
    this.assetPath,
    this.maxImageHeight = 200,
    this.multiple = false,
  });

  @override
  EspoImageFieldState createState() => EspoImageFieldState();

  String? Function(List<File>?) get imageValidator {
    return validator ?? (value) {
      if (this.required && (value == null || value.isEmpty)) {
        for (File? file in value!) {
          if (file == null) {
            return I18n.translate('core-field-required');
          }
          if (!file.existsSync()) {
            return I18n.translate('core-field-required');
          }
        }
      }
      return null;
    };
  }

  @override
  Widget? buildReadOnlyField(BuildContext context, EspoImageFieldState state) {
    return buildField(context, state);
  }

  @override
  Widget buildField(BuildContext context, EspoImageFieldState state) {
    Widget? innerChild = const Icon(Icons.image, size: 50, color: Colors.grey);

    if (state.imageProviders.isNotEmpty) {
      innerChild = Container(color: options?.fillColor ?? Colors.transparent);
    }

    return GestureDetector(
      onTap: () async {
        if (readOnly) return;
        await state.pickImage();
      },
      onLongPress: () {
        state.zoomImage();
      },
      child: Container(
          height: maxImageHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: options?.borderColor ?? Colors.grey,
              width: options?.borderWidth ?? 1.0,
            ),
            borderRadius: options?.borderRadius ?? BorderRadius.circular(4.0),
          ),
          child: state.imageProviders.isNotEmpty
              ? PageView.builder(
                  controller: state.pageController,
                  itemCount: state.imageProviders.length,
                  onPageChanged: (index) {
                    state.onItemPageChanged(index);
                  },
                  itemBuilder: (context, index) {
                    return Image(
                      image: state.imageProviders[index],
                      fit: BoxFit.contain,
                    );
                  },
                )
              : innerChild
      ),
    );
  }
}

class EspoImageFieldState extends CoreBaseFieldState<List<File>> {
  final ImagePicker _picker = ImagePicker();
  List<ImageProvider> _imageProviders = [];

  PageController pageController = PageController();

  ImagePicker get picker => _picker;
  List<ImageProvider> get imageProviders => _imageProviders;

  int currentIndex = -1;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void onItemPageChanged(int index) {
    currentIndex = index;
  }

  @override
  void initState() {
    super.initState();

    String? assetPath = (widget as EspoImageField).assetPath;

    if (value != null) {
      for (File? file in value!) {
        try {
          if (file != null && file.lengthSync() > 0) {
            _imageProviders.add(FileImage(file)); 
          }
        } catch(e) {
          continue;
        }
      }
    } else if (assetPath != null) {
      _imageProviders = [AssetImage(assetPath)];
    }

    if (_imageProviders.isNotEmpty) {
      currentIndex = 0;
    }
  }

  Future<void> pickImage() async {
    List<XFile>? pickedFiles;

    if ((widget as EspoImageField).multiple) {
      pickedFiles = await picker.pickMultiImage();
    } else {
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        pickedFiles = [pickedFile];
      }
    }

    if (pickedFiles != null) {
      List<File> imageFiles = pickedFiles.map((pickedFile) =>
          File(pickedFile.path)).toList();

      _imageProviders = imageFiles.map((file) => FileImage(file)).toList();

      setValue(imageFiles);
    }
  }

  void zoomImage() {
    if (_imageProviders.isEmpty) return;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: PhotoViewGallery(
          enableRotation: true,
          pageController: PageController(initialPage: currentIndex),
          pageOptions: _imageProviders.map((imageProvider) => PhotoViewGalleryPageOptions(
            imageProvider: imageProvider,
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          )).toList(),
          backgroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Colors.white
          ),
        )
      ),
    );
  }
}
