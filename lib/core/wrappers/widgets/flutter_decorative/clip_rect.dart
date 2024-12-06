import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaClipRectProps extends ContextableMapTraversable {
  const AndromedaClipRectProps(super.context, super.data);
}

class AndromedaClipRectStyles extends ContextableMapTraversable {
  const AndromedaClipRectStyles(super.context, super.data);

  Clip get clipBehavior => clipFromString(get('clipBehavior')) ?? Clip.antiAlias;
  AndromedaStyleBorderRadius get borderRadius => AndromedaStyleBorderRadius(getMap('borderRadius'));
}

class AndromedaClipRectWidget extends AndromedaWidget {
  static const String id = 'ClipRect';

  AndromedaClipRectWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaClipRectWidgetState createState() => AndromedaClipRectWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    // final prop = AndromedaClipRectProps(ctx.context, ctx.props);
    final style = AndromedaClipRectStyles(ctx.context, ctx.styles);

    return ClipRect(
      // styles
      clipBehavior: style.clipBehavior,
      // TODO: clipper: CustomClipper<Rect>?,

      // props
      child: await ctx.firstChildOrNull,
    );
  }
}

class AndromedaClipRectWidgetState extends AndromedaWidgetState<AndromedaClipRectWidget> {}