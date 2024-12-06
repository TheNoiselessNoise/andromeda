import 'package:flutter/material.dart';
import 'package:flutter_datawedge/flutter_datawedge.dart';
import 'package:andromeda/old-core/core.dart';

extension ActionResultLog on ActionResult {
  String get logContent {
    return switch (DatawedgeApiTargets.fromString(command)) {
      DatawedgeApiTargets.softScanTrigger => result,
      DatawedgeApiTargets.scannerPlugin =>
        result == "SUCCESS" ? result : '${resultInfo!['RESULT_CODE']}',
      DatawedgeApiTargets.getProfiles => '${resultInfo!['profiles']}',
      DatawedgeApiTargets.getActiveProfile => '${resultInfo!['activeProfile']}',
    };
  }
}

class CoreZebraScannerWidget extends CoreComponentableStatefulWidget {
  final void Function(CoreZebraScannerWidgetState)? onScan;

  const CoreZebraScannerWidget({super.key,
    required super.component,
    required super.parentContext,
    this.onScan,
  });

  @override
  CoreZebraScannerWidgetState createState() => CoreZebraScannerWidgetState();
}

class CoreZebraScannerWidgetState extends CoreBaseZebraScannerState<CoreZebraScannerWidget> {
  @override
  bool isComponent() => true;

  void startScan() {
    setState(() { sendCommand("SOFT_SCAN_TRIGGER", "START_SCANNING"); });
  }

  void stopScan() {
    setState(() { sendCommand("SOFT_SCAN_TRIGGER", "STOP_SCANNING"); });
  }

  @override
  void onEvent(dynamic event) {
    super.onEvent(event);

    if (widget.onScan != null) {
      widget.onScan!(this);
    }

    assignOutputs();
  }

  void assignOutputs() {
    Map<String, dynamic> possibleOutputs = {
      "barcodeString": barcodeString,
      "barcodeSymbology": barcodeSymbology,
      "scanTime": scanTime,
    };

    for (String key in possibleOutputs.keys) {
      if (zebraScannerInfo.defaultOutputs.containsKey(key)) {
        context.coreBloc.setToTemporaryStorage(key, possibleOutputs[key]);
      }
    }
  }

  @override
  Widget buildZebraScanner(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              barcodeString,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              barcodeSymbology,
                              style: TextStyle(
                                color: Colors.grey[500],
                              ),
                            ),
                          ),
                          Text(
                            scanTime,
                            style: const TextStyle(
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTapDown: (TapDownDetails tdd) {
                  startScan();
                },
                onTapUp: (TapUpDetails tud) {
                  stopScan();
                },
                // The custom button
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(22.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Center(
                    child: Text(
                      "SCAN",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
