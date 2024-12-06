import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaAnimationProps extends MapTraversable {
  const AndromedaAnimationProps(super.data);

  String get type => getString('type', 'fade');
  int get duration => getInt('duration', 300);
  double get from => getDouble('from', 0.0);
  double get to => getDouble('to', 1.0);
  Curve get curve => curveFromString(get('curve')) ?? Curves.linear;
}

class AndromedaAnimationWidget extends AndromedaWidget {
  static const String id = 'Animation';
  
  AndromedaAnimationWidget({
    super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaAnimationWidgetState createState() => AndromedaAnimationWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    throw Exception('Animation cannot be used as a widget');
  }

  Animation? realAnimation(Map<String, dynamic> props, AnimationController controller) {
    final prop = AndromedaAnimationProps(props);

    controller.duration = Duration(milliseconds: prop.duration);

    if (prop.type == 'fade') {
      return Tween<double>(begin: prop.from, end: prop.to).animate(controller);
    }

    if (prop.type == 'scale') {
      return Tween<double>(begin: prop.from, end: prop.to)
        .animate(CurvedAnimation(
          parent: controller,
          curve: prop.curve
        )
      );
    }

    return null;
  }
}

class AndromedaAnimationWidgetState extends AndromedaWidgetState<AndromedaAnimationWidget> {
  @override
  bool get isntReallyWidget => true;
}