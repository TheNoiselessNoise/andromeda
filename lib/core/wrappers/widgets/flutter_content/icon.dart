import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaIconProps extends MapTraversable {
  const AndromedaIconProps(super.data);

  String? get icon => get('icon');
}

class AndromedaIconStyles extends ContextableMapTraversable {
  const AndromedaIconStyles(super.context, super.data);

  bool? get applyTextScaling => get('applyTextScaling');
  Color? get color => themeColorFromString(get('color'), context);
  double? get size => get('size');
  double? get fill => get('fill');
  double? get grade => get('grade');
  double? get opticalSize => get('opticalSize');
  double? get weight => get('weight');
  TextDirection? get textDirection => textDirectionFromString(get('textDirection'));
}

class AndromedaIconWidget extends AndromedaWidget {
  static const String id = 'Icon';

  AndromedaIconWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaIconWidgetState createState() => AndromedaIconWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaIconProps(ctx.props);
    final style = AndromedaIconStyles(ctx.context, ctx.styles);

    return Icon(
      iconDataFromString(prop.icon),
      applyTextScaling: style.applyTextScaling,
      color: style.color,
      size: style.size,
      fill: style.fill,
      grade: style.grade,
      opticalSize: style.opticalSize,
      weight: style.weight,
      textDirection: style.textDirection,
      // TODO: shadows: List<Shadow>?
    );
  }
}

class AndromedaIconWidgetState extends AndromedaWidgetState<AndromedaIconWidget> {}