import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaPositionedStyles extends ContextableMapTraversable {
  const AndromedaPositionedStyles(super.context, super.data);

  double? get left => get('left');
  double? get top => get('top');
  double? get right => get('right');
  double? get bottom => get('bottom');
  double? get width => get('width');
  double? get height => get('height');
}

class AndromedaPositionedWidget extends AndromedaWidget {
  static const String id = 'Positioned';
  
  AndromedaPositionedWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children,
  });

  @override
  AndromedaPositionedWidgetState createState() => AndromedaPositionedWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final style = AndromedaPositionedStyles(ctx.context, ctx.styles);

    return Positioned(
      left: style.left,
      top: style.top,
      right: style.right,
      bottom: style.bottom,
      width: style.width,
      height: style.height,
      child: await ctx.firstChild,
    );
  }
}

class AndromedaPositionedWidgetState extends AndromedaWidgetState<AndromedaPositionedWidget> {}