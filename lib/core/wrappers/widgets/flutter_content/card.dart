import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaCardStyles extends ContextableMapTraversable {
  const AndromedaCardStyles(super.context, super.data);

  bool get borderOnForeground => getBool('borderOnForeground', true);
  Clip? get clipBehavior => clipFromString(get('clipBehavior'));
  Color? get color => themeColorFromString(get('color'), context);
  double? get elevation => get('elevation');
  AndromedaStyleEdgeInsets get margin => AndromedaStyleEdgeInsets(getMap('margin'));
  Color? get shadowColor => themeColorFromString(get('shadowColor'), context);
  Color? get surfaceTintColor => themeColorFromString(get('surfaceTintColor'), context);
}

class AndromedaCardWidget extends AndromedaWidget {
  static const String id = 'Card';

  AndromedaCardWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaCardWidgetState createState() => AndromedaCardWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final style = AndromedaCardStyles(ctx.context, ctx.styles);

    return Card(
      borderOnForeground: style.borderOnForeground,
      clipBehavior: style.clipBehavior,
      color: style.color,
      elevation: style.elevation,
      margin: edgeInsetsFromStyle(style.margin),
      shadowColor: style.shadowColor,
      surfaceTintColor: style.surfaceTintColor,
      // TODO: shapeBorder: ShapeBorder?
      child: await ctx.firstChildOrNull,
    );
  }
}

class AndromedaCardWidgetState extends AndromedaWidgetState<AndromedaCardWidget> {}