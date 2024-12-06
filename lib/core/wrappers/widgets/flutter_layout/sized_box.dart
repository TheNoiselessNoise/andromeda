import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaSizedBoxStyles extends ContextableMapTraversable {
  const AndromedaSizedBoxStyles(super.context, super.data);

  double? get width => get('width');
  double? get height => get('height');
}

class AndromedaSizedBoxWidget extends AndromedaWidget {
  static const String id = 'SizedBox';
  
  AndromedaSizedBoxWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaSizedBoxWidgetState createState() => AndromedaSizedBoxWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final style = AndromedaSizedBoxStyles(ctx.context, ctx.styles);

    return SizedBox(
      width: style.width,
      height: style.height,
      child: await ctx.firstChildOrNull,
    );
  }
}

class AndromedaSizedBoxWidgetState extends AndromedaWidgetState<AndromedaSizedBoxWidget> {}