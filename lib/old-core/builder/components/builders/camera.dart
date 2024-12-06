import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

class CameraWidgetBuilder {
  static Widget buildCoreCameraWidget(BuildContext context, JsonC component, ParentContext parentContext) {
    List<JsonA> onPhotoTakenActions = component.info.cameraInfo.onPhotoTaken;

    return CoreCameraWidget(
      component: component,
      onPhotoTaken: ActionBuilder.directFunctionWithArg(context, onPhotoTakenActions, parentContext),
      parentContext: parentContext,
    );
  }
}