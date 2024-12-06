import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

abstract class CoreBaseCameraState<T extends CoreComponentableStatefulWidget> extends CoreComponentableState<T> {
  JsonCameraInfo get cameraInfo => widget.component.info.cameraInfo;

  CameraController? controller;
  XFile? photoFile;
  bool isReady = false;
  bool isTakingPicture = false;

  @override
  bool isComponent() => true;

  @override
  void initState() {
    super.initState();
    initCamera();
    coreBloc.setCameraState(this);
  }

  Future<void> initCamera();
  Future<void> onPhotoTaken();

  void unsetTakenPicture() {
    setState(() {
      photoFile = null;
    });
  }

  Future<void> takePicture() async {
    if (isTakingPicture) {
      return;
    }
    isTakingPicture = true;
    if (controller != null && controller!.value.isInitialized) {
      photoFile = await controller!.takePicture();
      setState(() {
        onPhotoTaken();
        isTakingPicture = false;
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Widget buildCamera(BuildContext context) {
    return Text("$runtimeType buildCamera not implemented");
  }  

  @override
  Widget buildContent(BuildContext context) {
    return Column(
      children: [
        if (cameraInfo.hasHeaderComponent) ...[
          buildHeaderComponent(cameraInfo.headerComponent)
        ],
        buildCamera(context),
        if (cameraInfo.hasFooterComponent) ...[
          buildFooterComponent(cameraInfo.footerComponent)
        ],
      ],
    );
  }
}
