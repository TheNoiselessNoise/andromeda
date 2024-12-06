import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaWrapStyles extends ContextableMapTraversable {
  const AndromedaWrapStyles(super.context, super.data);

  WrapAlignment get alignment => wrapAlignmentFromString(get('alignment')) ?? WrapAlignment.start;
  Clip get clipBehavior => clipFromString(get('clipBehavior')) ?? Clip.none;
  WrapCrossAlignment get crossAxisAlignment => wrapCrossAlignmentFromString(get('crossAxisAlignment')) ?? WrapCrossAlignment.start;
  Axis get direction => axisFromString(get('direction')) ?? Axis.horizontal;
  WrapAlignment get runAlignment => wrapAlignmentFromString(get('runAlignment')) ?? WrapAlignment.start;
  double get runSpacing => getDouble('runSpacing', 0.0);
  double get spacing => getDouble('spacing', 0.0);
  TextDirection? get textDirection => textDirectionFromString(get('textDirection'));
  VerticalDirection get verticalDirection => verticalDirectionFromString(get('verticalDirection')) ?? VerticalDirection.down;
}

class AndromedaWrapWidget extends AndromedaWidget {
  static const String id = 'Wrap';	
  
  AndromedaWrapWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaWrapWidgetState createState() => AndromedaWrapWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final style = AndromedaWrapStyles(ctx.context, ctx.styles);

    return Wrap(
      alignment: style.alignment,
      clipBehavior: style.clipBehavior,
      crossAxisAlignment: style.crossAxisAlignment,
      direction: style.direction,
      runAlignment: style.runAlignment,
      runSpacing: style.runSpacing,
      spacing: style.spacing,
      textDirection: style.textDirection,
      verticalDirection: style.verticalDirection,
      children: await ctx.children,
    );
  }
}

class AndromedaWrapWidgetState extends AndromedaWidgetState<AndromedaWrapWidget> {}