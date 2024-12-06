import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaExpandedStyles extends ContextableMapTraversable {
  const AndromedaExpandedStyles(super.context, super.data);

  int get flex => get('flex') ?? 1;
}

class AndromedaExpandedWidget extends AndromedaWidget {
  static const String id = 'Expanded';
  
  AndromedaExpandedWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children,
  });

  @override
  AndromedaExpandedWidgetState createState() => AndromedaExpandedWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final style = AndromedaExpandedStyles(ctx.context, ctx.styles);

    return Expanded(
      flex: style.flex,
      child: await ctx.firstChild,
    );
  }
}

class AndromedaExpandedWidgetState extends AndromedaWidgetState<AndromedaExpandedWidget> {}