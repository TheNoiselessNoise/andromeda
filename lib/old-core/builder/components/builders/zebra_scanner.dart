import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

class ZebraScannerWidgetBuilder {
  static Widget buildCoreZebraScannerWidget(BuildContext context, JsonC component, ParentContext parentContext) {
    List<JsonA> onScanActions = component.info.zebraScannerInfo.onScan;

    return CoreZebraScannerWidget(
      component: component,
      onScan: ActionBuilder.directFunctionWithArg(context, onScanActions, parentContext),
      parentContext: parentContext,
    );
  }
}