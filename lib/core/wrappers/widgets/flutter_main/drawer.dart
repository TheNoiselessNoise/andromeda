import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaDrawerStyles extends ContextableMapTraversable {
  const AndromedaDrawerStyles(super.context, super.data);

  Color? get backgroundColor => themeColorFromString(get('backgroundColor'), context);
  Clip? get clipBehavior => clipFromString(get('clipBehavior'));
  double? get elevation => get('elevation');
  Color? get shadowColor => themeColorFromString(get('shadowColor'), context);
  Color? get surfaceTintColor => themeColorFromString(get('surfaceTintColor'), context);
  double? get width => get('width');
}

class AndromedaDrawerWidget extends AndromedaWidget {
  static const String id = 'Drawer';
  
  AndromedaDrawerWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaDrawerWidgetState createState() => AndromedaDrawerWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final style = AndromedaDrawerStyles(ctx.context, ctx.styles);

    return Drawer(
      backgroundColor: style.backgroundColor,
      clipBehavior: style.clipBehavior,
      elevation: style.elevation,
      shadowColor: style.shadowColor,
      surfaceTintColor: style.surfaceTintColor,
      width: style.width,
      // TODO: shape: ShapeBorder?
      child: await ctx.firstChildOrNull,
    );
  }
}

class AndromedaDrawerWidgetState extends AndromedaWidgetState<AndromedaDrawerWidget> {}