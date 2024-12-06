import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaLinearProgressIndicatorProps extends ContextableMapTraversable {
  const AndromedaLinearProgressIndicatorProps(super.context, super.data);

  Color? get backgroundColor => themeColorFromString(get('backgroundColor'), context);
  AndromedaStyleBorderRadius get borderRadius => AndromedaStyleBorderRadius(getMap('borderRadius'));
  Color? get color => themeColorFromString(get('color'), context);
  double? get minHeight => get('minHeight');
  double? get value => get('value');
}

class AndromedaLinearProgressIndicatorWidget extends AndromedaWidget {
  static const String id = 'LinearProgressIndicator';

  AndromedaLinearProgressIndicatorWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaLinearProgressIndicatorWidgetState createState() => AndromedaLinearProgressIndicatorWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaLinearProgressIndicatorProps(ctx.context, ctx.props);

    return LinearProgressIndicator(
      backgroundColor: prop.backgroundColor,
      borderRadius: borderRadiusGeometryFromStyle(prop.borderRadius) ?? BorderRadius.zero,
      color: prop.color,
      minHeight: prop.minHeight,
      value: prop.value,
      // TODO: valueColor: Animation<Color?>?,
    );
  }
}

class AndromedaLinearProgressIndicatorWidgetState extends AndromedaWidgetState<AndromedaLinearProgressIndicatorWidget> {}