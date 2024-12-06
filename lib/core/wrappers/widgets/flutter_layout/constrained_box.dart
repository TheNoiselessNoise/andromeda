import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaConstrainedBoxStyles extends ContextableMapTraversable {
  const AndromedaConstrainedBoxStyles(super.context, super.data);

  AndromedaStyleBoxConstraints get constraints => AndromedaStyleBoxConstraints(getMap('constraints'));
}

class AndromedaConstrainedBoxWidget extends AndromedaWidget {
  static const String id = 'ConstrainedBox';
  
  AndromedaConstrainedBoxWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaConstrainedBoxWidgetState createState() => AndromedaConstrainedBoxWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final style = AndromedaConstrainedBoxStyles(ctx.context, ctx.styles);

    return ConstrainedBox(
      constraints: boxConstraintsFromStyle(style.constraints) ?? const BoxConstraints(),
      child: await ctx.firstChildOrNull,
    );
  }
}

class AndromedaConstrainedBoxWidgetState extends AndromedaWidgetState<AndromedaConstrainedBoxWidget> {}