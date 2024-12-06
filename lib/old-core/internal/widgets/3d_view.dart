// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';

class ThreeDEnvironment extends StatefulWidget {
  const ThreeDEnvironment({super.key});

  @override
  ThreeDEnvironmentState createState() => ThreeDEnvironmentState();
}

class ThreeDEnvironmentState extends State<ThreeDEnvironment> {
  late Scene _scene;
  final Vector3 _rotation = Vector3.zero();
  final Vector3 _position = Vector3.zero();
  final List<Object> _rectangles = [];
  double _zoom = 10.0;
  bool _isRotationMode = true;

  void _onSceneCreated(Scene scene) {
    _scene = scene;
    _createHuePalette();
    _updateCameraZoom();
  }

  void _updateCameraZoom() {
    _scene.camera.zoom = _zoom;
    _scene.camera.position.z = 15;
    _scene.update();
  }

  void _createHuePalette() {
    const int hueSteps = 360;
    const double rectangleWidth = 0.2;
    const double rectangleHeight = 0.8;
    const double spacing = 0.05;

    for (int i = 0; i < hueSteps; i++) {
      final hue = i.toDouble();
      final rectangle = _createRectangle(
        Vector3((i - hueSteps / 2) * (rectangleWidth + spacing), 0, 0),
        HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor(),
        rectangleWidth,
        rectangleHeight,
      );
      _rectangles.add(rectangle);
      _scene.world.add(rectangle);
    }
  }

  Object _createRectangle(Vector3 position, Color color, double width, double height) {
    return Object(
      position: position,
      scale: Vector3(1.0, 1.0, 1.0),
      mesh: Mesh(
        vertices: [
          Vector3(-width / 2, -height / 2, 0),
          Vector3(width / 2, -height / 2, 0),
          Vector3(width / 2, height / 2, 0),
          Vector3(-width / 2, height / 2, 0),
        ],
        indices: [
          Polygon(0, 1, 2),
          Polygon(2, 3, 0),
        ],
        colors: List.filled(4, color),
      ),
    );
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      if (details.scale != 1.0) {
        // Handle zoom
        _zoom = (_zoom * details.scale).clamp(5.0, 20.0);
        _updateCameraZoom();
      } else if (_isRotationMode) {
        // Handle rotation
        _rotation.y += details.focalPointDelta.dx * 0.01;
        _rotation.x -= details.focalPointDelta.dy * 0.01;
      } else {
        // Handle sliding
        _position.x -= details.focalPointDelta.dx * 0.01;
        _position.y += details.focalPointDelta.dy * 0.01;
      }
      _scene.update();
    });
  }

  void _toggleRotationMode() {
    setState(() {
      _isRotationMode = !_isRotationMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('3D Cube Grid')),
      body: Center(
        child: SizedBox(
          width: 300,
          height: 300,
          child: GestureDetector(
            onScaleUpdate: _onScaleUpdate,
            onDoubleTap: _toggleRotationMode,
            child: Cube(
              onSceneCreated: _onSceneCreated,
            ),
          ),
        ),
      ),
    );
  }
}
