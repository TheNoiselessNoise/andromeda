import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaAlignStyles extends ContextableMapTraversable {
  const AndromedaAlignStyles(super.context, super.data);

  AlignmentGeometry get alignment => alignmentGeometryFromString(get('alignment')) ?? Alignment.center;
  double? get widthFactor => get('widthFactor');
  double? get heightFactor => get('heightFactor');
}

class AndromedaAlignWidget extends AndromedaWidget {
  static const String id = 'Align';

  AndromedaAlignWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaAlignWidgetState createState() => AndromedaAlignWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final style = AndromedaAlignStyles(ctx.context, ctx.styles);

    return Align(
      alignment: style.alignment,
      widthFactor: style.widthFactor,
      heightFactor: style.heightFactor,
      child: await ctx.firstChildOrNull,
    );
  }
}

class AndromedaAlignWidgetState extends AndromedaWidgetState<AndromedaAlignWidget> {}