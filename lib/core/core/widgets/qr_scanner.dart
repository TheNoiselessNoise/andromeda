import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_dart_scan/qr_code_dart_scan.dart';
import 'package:andromeda/core/_.dart';

class BorderShadowPainter extends CustomPainter {
  final Color borderColor;
  final Color shadowColor;
  final double borderWidth;
  final double borderRadius;
  final double shadowBlur;
  final Offset shadowOffset;

  BorderShadowPainter({
    required this.borderColor,
    required this.shadowColor,
    required this.borderWidth,
    required this.borderRadius,
    required this.shadowBlur,
    required this.shadowOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(borderRadius),
      ),
    );

    Paint shadowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowBlur)
      ..color = shadowColor;
    
    canvas.drawPath(
      path.shift(shadowOffset),
      shadowPaint,
    );

    Paint borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..color = borderColor;
    
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class QRScanner extends StatefulWidget {
  const QRScanner({super.key});

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  QRCodeDartScanController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool _hasScanned = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('qr-scan-qr')),
      ),
      body: Center(
        child: QRCodeDartScanView(
          key: qrKey,
          onCapture: _onQRViewCreated,
          intervalScan: const Duration(seconds: 3),
          controller: controller,
          lockCaptureOrientation: DeviceOrientation.portraitUp,
          typeCamera: TypeCamera.back,
          typeScan: TypeScan.live,
          child: Center(
            child: CustomPaint(
              size: const Size(300, 300),
              painter: BorderShadowPainter(
                borderColor: Theme.of(context).primaryColor,
                shadowColor: Colors.white.withOpacity(0.5),
                borderWidth: 10,
                borderRadius: 10,
                shadowBlur: 7,
                shadowOffset: const Offset(0, 0),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onQRViewCreated(Result result) {
    if (!_hasScanned && result.text.isNotEmpty) {
      _hasScanned = true;
      if (!mounted) return;
      Navigator.pop(context, result.text);
    }
  }
}