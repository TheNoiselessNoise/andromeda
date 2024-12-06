import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaFlexibleStyles extends ContextableMapTraversable {
  const AndromedaFlexibleStyles(super.context, super.data);

  int get flex => get('flex') ?? 1;
  FlexFit get fit => flexFitFromString(get('fit')) ?? FlexFit.loose;
}

class AndromedaFlexibleWidget extends AndromedaWidget {
  static const String id = 'Flexible';
  
  AndromedaFlexibleWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children,
  });

  @override
  AndromedaFlexibleWidgetState createState() => AndromedaFlexibleWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final style = AndromedaFlexibleStyles(ctx.context, ctx.styles);

    return Flexible(
      flex: style.flex,
      fit: style.fit,
      child: await ctx.firstChild,
    );
  }
}

class AndromedaFlexibleWidgetState extends AndromedaWidgetState<AndromedaFlexibleWidget> {}