import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaColumnStyles extends ContextableMapTraversable {
  const AndromedaColumnStyles(super.context, super.data);

  MainAxisAlignment get mainAxisAlignment => mainAxisAlignmentFromString(get('mainAxisAlignment')) ?? MainAxisAlignment.start;
  CrossAxisAlignment get crossAxisAlignment => crossAxisAlignmentFromString(get('crossAxisAlignment')) ?? CrossAxisAlignment.center;
  TextBaseline? get textBaseline => textBaselineFromString(get('textBaseline'));
  TextDirection? get textDirection => textDirectionFromString(get('textDirection'));
  VerticalDirection get verticalDirection => verticalDirectionFromString(get('verticalDirection')) ?? VerticalDirection.down;
  MainAxisSize get mainAxisSize => mainAxisSizeFromString(get('mainAxisSize')) ?? MainAxisSize.max;
}

class AndromedaColumnWidget extends AndromedaWidget {
  static const String id = 'Column';
  
  AndromedaColumnWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaColumnWidgetState createState() => AndromedaColumnWidgetState();
}

class AndromedaColumnWidgetState extends AndromedaWidgetState<AndromedaColumnWidget> {
  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final style = AndromedaColumnStyles(ctx.context, ctx.styles);
    
    return Column(
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