import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaClipOvalProps extends ContextableMapTraversable {
  const AndromedaClipOvalProps(super.context, super.data);
}

class AndromedaClipOvalStyles extends ContextableMapTraversable {
  const AndromedaClipOvalStyles(super.context, super.data);

  Clip get clipBehavior => clipFromString(get('clipBehavior')) ?? Clip.antiAlias;
  AndromedaStyleBorderRadius get borderRadius => AndromedaStyleBorderRadius(getMap('borderRadius'));
}

class AndromedaClipOvalWidget extends AndromedaWidget {
  static const String id = 'ClipOval';

  AndromedaClipOvalWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaClipOvalWidgetState createState() => AndromedaClipOvalWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    // final prop = AndromedaClipOvalProps(ctx.context, ctx.props);
    final style = AndromedaClipOvalStyles(ctx.context, ctx.styles);

    return ClipOval(
      // styles
      clipBehavior: style.clipBehavior,
      // TODO: clipper: CustomClipper<Rect>?,

      // props
      child: await ctx.firstChildOrNull,
    );
  }
}

class AndromedaClipOvalWidgetState extends AndromedaWidgetState<AndromedaClipOvalWidget> {}