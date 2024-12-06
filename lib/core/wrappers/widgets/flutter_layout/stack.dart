import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaStackStyles extends ContextableMapTraversable {
  const AndromedaStackStyles(super.context, super.data);

  Clip get clipBehavior => clipFromString(get('clipBehavior')) ?? Clip.hardEdge;
  AlignmentGeometry get alignment => alignmentGeometryFromString(get('alignment')) ?? AlignmentDirectional.topStart;
  TextDirection? get textDirection => textDirectionFromString(get('textDirection'));
  StackFit get fit => stackFitFromString(get('fit')) ?? StackFit.loose;
}

class AndromedaStackWidget extends AndromedaWidget {
  static const String id = 'Stack';
  
  AndromedaStackWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaStackWidgetState createState() => AndromedaStackWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final style = AndromedaStackStyles(ctx.context, ctx.styles);

    return Stack(
      clipBehavior: style.clipBehavior,
      alignment: style.alignment,
      textDirection: style.textDirection,
      fit: style.fit,
      children: await ctx.children,
    );
  }
}

class AndromedaStackWidgetState extends AndromedaWidgetState<AndromedaStackWidget> {}