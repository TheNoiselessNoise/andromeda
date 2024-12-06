import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaContainerStyles extends ContextableMapTraversable {
  const AndromedaContainerStyles(super.context, super.data);

  AlignmentGeometry? get alignment => alignmentGeometryFromString(get('alignment'));
  Clip get clipBehavior => clipFromString(get('clipBehavior')) ?? Clip.none;
  Color? get color => themeColorFromString(get('color'), context);
  AndromedaStyleBoxConstraints get boxConstraints => AndromedaStyleBoxConstraints(getMap('constraints'));
  AndromedaStyleDecoration get decoration => AndromedaStyleDecoration(getMap('decoration'));
  AndromedaStyleDecoration get foregroundDecoration => AndromedaStyleDecoration(getMap('foregroundDecoration'));
  double? get height => get('height');
  double? get width => get('width');
  AndromedaStyleEdgeInsets get margin => AndromedaStyleEdgeInsets(getMap('margin'));
  AndromedaStyleEdgeInsets get padding => AndromedaStyleEdgeInsets(getMap('padding'));
  AlignmentGeometry? get transformAlignment => alignmentGeometryFromString(get('transformAlignment'));
  // TODO: transform: Matrix4?
}

class AndromedaContainerWidget extends AndromedaWidget {
  static const String id = 'Container';
  
  AndromedaContainerWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaContainerWidgetState createState() => AndromedaContainerWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final style = AndromedaContainerStyles(ctx.context, ctx.styles);

    return Container(
      alignment: style.alignment,
      clipBehavior: style.clipBehavior,
      color: style.color,
      constraints: boxConstraintsFromStyle(style.boxConstraints),
      decoration: decorationFromStyle(style.decoration),
      foregroundDecoration: decorationFromStyle(style.foregroundDecoration),
      height: style.height,
      width: style.width,
      margin: edgeInsetsFromStyle(style.margin),
      padding: edgeInsetsFromStyle(style.padding),
      transformAlignment: style.transformAlignment,
      child: await ctx.firstChildOrNull,
    );
  }
}

class AndromedaContainerWidgetState extends AndromedaWidgetState<AndromedaContainerWidget> {}