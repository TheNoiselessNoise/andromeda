import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaPaddingStyles extends ContextableMapTraversable {
  const AndromedaPaddingStyles(super.context, super.data);

  AndromedaStyleEdgeInsets get padding => AndromedaStyleEdgeInsets(getMap('padding'));
}

class AndromedaPaddingWidget extends AndromedaWidget {
  static const String id = 'Padding';
  
  AndromedaPaddingWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children,
  });

  @override
  AndromedaPaddingWidgetState createState() => AndromedaPaddingWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final style = AndromedaPaddingStyles(ctx.context, ctx.styles);

    return Padding(
      padding: edgeInsetsGeometryFromStyle(style.padding) ?? EdgeInsets.zero,
      child: await ctx.firstChildOrNull,
    );
  }
}

class AndromedaPaddingWidgetState extends AndromedaWidgetState<AndromedaPaddingWidget> {}