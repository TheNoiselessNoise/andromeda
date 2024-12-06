import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:andromeda/old-core/core.dart';

abstract class CoreBaseZebraScannerState<T extends CoreComponentableStatefulWidget> extends CoreComponentableState<T> {
  JsonZebraScannerInfo get zebraScannerInfo => widget.component.info.zebraScannerInfo;

  MethodChannel methodChannel = MethodChannel('${AppInfo.getPackageName()}/command');
  EventChannel scanChannel = EventChannel('${AppInfo.getPackageName()}/scan');

  String barcodeString = "Barcode will be shown here";
  String barcodeSymbology = "Symbology will be shown here";
  String scanTime = "Scan Time will be shown here";

  @override
  bool isComponent() => true;

  @override
  void initState() {
    super.initState();
    scanChannel.receiveBroadcastStream().listen(onEvent, onError: onError);
    createProfile(getProfileId);
    coreBloc.setZebraScannerState(this);
  }

  String get getProfileId => "${AppInfo.getPackageName()}-$hashCode";

  Future<void> createProfile(String profileName) async {
    try {
      await methodChannel.invokeMethod('createDataWedgeProfile', profileName);
    } on PlatformException {
      //  Error invoking Android method
    }
  }

  Future<void> sendCommand(String command, String parameter) async {
    try {
      String argumentAsJson = jsonEncode({
        "command": "com.symbol.datawedge.api.$command",
        "parameter": parameter
      });
      await methodChannel.invokeMethod('sendDataWedgeCommandStringParameter', argumentAsJson);
    } on PlatformException {
      //  Error invoking Android method
    }
  }

  void onEvent(dynamic event) {
    setState(() {
      Map barcodeScan = jsonDecode(event);
      barcodeString = barcodeScan['scanData'];
      barcodeSymbology = barcodeScan['symbology'];
      scanTime = barcodeScan['dateTime'];
    });
  }

  void onError(Object error) {
    setState(() {
      barcodeString = "ERROR";
      barcodeSymbology = "ERROR";
      scanTime = "ERROR";
    });
  }

  Widget buildZebraScanner(BuildContext context) {
    return Text("$runtimeType buildContent not implemented");
  }

  @override
  Widget buildContent(BuildContext context) {
    return Column(
      children: [
        if (zebraScannerInfo.hasHeaderComponent) ...[
          buildHeaderComponent(zebraScannerInfo.headerComponent)
        ],
        buildZebraScanner(context),
        if (zebraScannerInfo.hasFooterComponent) ...[
          buildFooterComponent(zebraScannerInfo.footerComponent)
        ],
      ],
    );
  }
}
