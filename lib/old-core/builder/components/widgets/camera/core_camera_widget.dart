import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:andromeda/old-core/core.dart';

class CameraButtonComponent extends CoreBaseStatelessWidget {
  final Color? backgroundColor;
  final IconData? icon;
  final Color? iconColor;
  final String? text;
  final Color? textColor;
  final Function()? onPressed;

  const CameraButtonComponent({
    super.key,
    this.backgroundColor,
    this.icon,
    this.iconColor,
    this.text,
    this.textColor,
    this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FaIcon(
                icon,
                color: iconColor,
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  text ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textColor),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CoreCameraWidget extends CoreComponentableStatefulWidget {
  final void Function(CoreCameraWidgetState)? onPhotoTaken;

  const CoreCameraWidget({super.key,
    required super.component,
    required super.parentContext,
    this.onPhotoTaken,
  });

  @override
  CoreCameraWidgetState createState() => CoreCameraWidgetState();
}

class CoreCameraWidgetState extends CoreBaseCameraState<CoreCameraWidget> {
  List<CameraDescription>? _cameras;

  @override
  bool isComponent() => true;

  @override
  Future<void> initCamera() async {
    _cameras = await availableCameras();

    if (_cameras?.isNotEmpty ?? false) {
      CameraLensDirection lensDirection = getCameraLensDirectionFromString(cameraInfo.defaultCamera) ?? CameraLensDirection.back;

      List<CameraDescription> camDescs = _cameras!
        .where((camera) => camera.lensDirection == lensDirection).toList();

      CameraDescription description = camDescs.isEmpty ? camDescs.first : _cameras!.first;

      controller = CameraController(description, ResolutionPreset.max);

      FlashMode flashMode = getFlashModeFromString(cameraInfo.flashMode) ?? FlashMode.off;
      controller?.setFlashMode(flashMode);

      controller!.initialize().then((_) {
        if (!mounted) return;
        setState(() => isReady = true);
      });
    }
  }

  @override
  Future<void> onPhotoTaken() async {
    if (widget.onPhotoTaken != null) {
      widget.onPhotoTaken!(this);
    }

    assignOutputs();
  }

  void assignOutputs() {
    Map<String, dynamic> possibleOutputs = {
      "photoFile": photoFile,
    };

    for (String key in possibleOutputs.keys) {
      if (cameraInfo.defaultOutputs.containsKey(key)) {
        context.coreBloc.setToTemporaryStorage(key, possibleOutputs[key]);
      }
    }
  }

  Widget buildPhoto() {
    return Positioned.fill(
      child: Image.file(
        File(photoFile!.path),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildTopWidget() {
    if (cameraInfo.hasTopComponent) {
      return Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: CWBuilder.build(context, cameraInfo.topComponent, parentContext),
        ),
      );
    }

    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.5),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: const Text("Take a photo please",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }

  Widget buildTopWhenPhotoTakenWidget() {
    if (cameraInfo.hasTopWhenPhotoTakenComponent) {
      return Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: CWBuilder.build(context, cameraInfo.topWhenPhotoTakenComponent, parentContext),
        ),
      );
    }

    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.5),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: const Text("Is this a good photo?",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }

  Widget buildButtons() {
    return Positioned(
      bottom: 20.0,
      left: 0,
      right: 0,
      child: cameraInfo.hasButtonsComponent ?
        CWBuilder.build(context, cameraInfo.buttonsComponent, parentContext) :
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CameraButtonComponent(
              backgroundColor: Colors.red,
              icon: FontAwesomeIcons.xmark,
              iconColor: Colors.white,
              text: "NO",
              textColor: Colors.white,
              onPressed: () {
                unsetTakenPicture();
              },
            ),
            CameraButtonComponent(
              backgroundColor: Colors.green,
              icon: FontAwesomeIcons.check,
              iconColor: Colors.white,
              text: "OK",
              textColor: Colors.white,
              onPressed: () {
                onPhotoTaken();
              },
            ),
          ],
        ),
    );
  }

  Widget buildTakePhotoButton() {
    if (cameraInfo.hasTakePhotoComponent) {
      return Positioned(
        bottom: 20.0,
        left: 0,
        right: 0,
        child: Align(
          alignment: Alignment.center,
          child: CWBuilder.build(context, cameraInfo.takePhotoComponent, parentContext)
        ),
      );
    }

    return Positioned(
      bottom: 20.0,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.center,
        child: FloatingActionButton(
          heroTag: null,
          onPressed: takePicture,
          child: const Icon(Icons.camera),
        ),
      ),
    );
  }

  @override
  Widget buildCamera(BuildContext context) {
    if(!isReady) {
      if (cameraInfo.hasLoadingComponent) {
        return CWBuilder.build(context, cameraInfo.loadingComponent, parentContext);
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    }

    if (controller == null) {
      if (cameraInfo.hasNoCameraComponent) {
        return CWBuilder.build(context, cameraInfo.noCameraComponent, parentContext);
      } else {
        return const Center(child: Text("No camera found"));
      }
    }

    return SafeArea(
      child: Stack(
        children: <Widget>[
          CameraPreview(controller!),
          if (photoFile != null) ...[
            buildPhoto(),
            buildTopWhenPhotoTakenWidget(),
            buildButtons(),
          ] else ...[
            buildTopWidget(),
            buildTakePhotoButton()
          ],
        ],
      ),
    );
  }
}
