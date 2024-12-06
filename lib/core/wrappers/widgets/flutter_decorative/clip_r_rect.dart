import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaClipRRectProps extends ContextableMapTraversable {
  const AndromedaClipRRectProps(super.context, super.data);
}

class AndromedaClipRRectStyles extends ContextableMapTraversable {
  const AndromedaClipRRectStyles(super.context, super.data);

  Clip get clipBehavior => clipFromString(get('clipBehavior')) ?? Clip.antiAlias;
  AndromedaStyleBorderRadius get borderRadius => AndromedaStyleBorderRadius(getMap('borderRadius'));
}

class AndromedaClipRRectWidget extends AndromedaWidget {
  static const String id = 'ClipRRect';

  AndromedaClipRRectWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaClipRRectWidgetState createState() => AndromedaClipRRectWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    // final prop = AndromedaClipRRectProps(ctx.context, ctx.props);
    final style = AndromedaClipRRectStyles(ctx.context, ctx.styles);

    return ClipRRect(
      // styles
      clipBehavior: style.clipBehavior,
      borderRadius: borderRadiusGeometryFromStyle(style.borderRadius) ?? BorderRadius.zero,
      // TODO: clipper: CustomClipper<RRect>?,

      // props
      child: await ctx.firstChildOrNull,
    );
  }
}

class AndromedaClipRRectWidgetState extends AndromedaWidgetState<AndromedaClipRRectWidget> {}