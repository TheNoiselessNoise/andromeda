import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaPlaceholderStyles extends ContextableMapTraversable {
  const AndromedaPlaceholderStyles(super.context, super.data);

  Color get color => themeColorFromString(get('color'), context) ?? const Color(0xFF455A64);
  double get strokeWidth => getDouble('strokeWidth', 2.0);
  double get fallbackHeight => getDouble('fallbackHeight', 400.0);
  double get fallbackWidth => getDouble('fallbackWidth', 400.0);
}

class AndromedaPlaceholderWidget extends AndromedaWidget {
  static const String id = 'Placeholder';
  
  AndromedaPlaceholderWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaPlaceholderWidgetState createState() => AndromedaPlaceholderWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final style = AndromedaPlaceholderStyles(ctx.context, ctx.styles);

    return Placeholder(
      color: style.color,
      strokeWidth: style.strokeWidth,
      fallbackHeight: style.fallbackHeight,
      fallbackWidth: style.fallbackWidth,
      child: await ctx.firstChildOrNull,
    );
  }
}

class AndromedaPlaceholderWidgetState extends AndromedaWidgetState<AndromedaPlaceholderWidget> {}