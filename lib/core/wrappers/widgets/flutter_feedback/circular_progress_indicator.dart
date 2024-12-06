import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaCircularProgressIndicatorProps extends ContextableMapTraversable {
  const AndromedaCircularProgressIndicatorProps(super.context, super.data);

  Color? get backgroundColor => themeColorFromString(get('backgroundColor'), context);
  double get strokeAlign => getDouble('strokeAlign', 0.0);
  StrokeCap? get strokeCap => strokeCapFromString(get('strokeCap'));
  double get strokeWidth => getDouble('strokeWidth', 4.0);
  Color? get color => themeColorFromString(get('color'), context);
  double? get value => get('value');
}

class AndromedaCircularProgressIndicatorWidget extends AndromedaWidget {
  static const String id = 'CircularProgressIndicator';
  
  AndromedaCircularProgressIndicatorWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaCircularProgressIndicatorWidgetState createState() => AndromedaCircularProgressIndicatorWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaCircularProgressIndicatorProps(ctx.context, ctx.props);

    return CircularProgressIndicator(
      backgroundColor: prop.backgroundColor,
      strokeAlign: prop.strokeAlign,
      strokeCap: prop.strokeCap,
      strokeWidth: prop.strokeWidth,
      color: prop.color,
      value: prop.value,

      // TODO: valueColor: Animation<Color?>?,
    );
  }
}

class AndromedaCircularProgressIndicatorWidgetState extends AndromedaWidgetState<AndromedaCircularProgressIndicatorWidget> {}