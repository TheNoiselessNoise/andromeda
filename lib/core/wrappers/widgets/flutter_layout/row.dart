import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaRowStyles extends ContextableMapTraversable {
  const AndromedaRowStyles(super.context, super.data);

  MainAxisAlignment get mainAxisAlignment => mainAxisAlignmentFromString(get('mainAxisAlignment')) ?? MainAxisAlignment.start;
  CrossAxisAlignment get crossAxisAlignment => crossAxisAlignmentFromString(get('crossAxisAlignment')) ?? CrossAxisAlignment.center;
  TextBaseline? get textBaseline => textBaselineFromString(get('textBaseline'));
  TextDirection? get textDirection => textDirectionFromString(get('textDirection'));
  VerticalDirection get verticalDirection => verticalDirectionFromString(get('verticalDirection')) ?? VerticalDirection.down;
  MainAxisSize get mainAxisSize => mainAxisSizeFromString(get('mainAxisSize')) ?? MainAxisSize.max;
}

class AndromedaRowWidget extends AndromedaWidget {
  static const String id = 'Row';
  
  AndromedaRowWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children,
  });

  @override
  AndromedaRowWidgetState createState() => AndromedaRowWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final style = AndromedaRowStyles(ctx.context, ctx.styles);

    return Row(
      mainAxisAlignment: style.mainAxisAlignment,
      crossAxisAlignment: style.crossAxisAlignment,
      textBaseline: style.textBaseline,
      textDirection: style.textDirection,
      verticalDirection: style.verticalDirection,
      mainAxisSize: style.mainAxisSize,
      children: await ctx.children,
    );
  }
}

class AndromedaRowWidgetState extends AndromedaWidgetState<AndromedaRowWidget> {}