import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaClipPathProps extends ContextableMapTraversable {
  const AndromedaClipPathProps(super.context, super.data);
}

class AndromedaClipPathStyles extends ContextableMapTraversable {
  const AndromedaClipPathStyles(super.context, super.data);

  Clip get clipBehavior => clipFromString(get('clipBehavior')) ?? Clip.antiAlias;
  AndromedaStyleBorderRadius get borderRadius => AndromedaStyleBorderRadius(getMap('borderRadius'));
}

class AndromedaClipPathWidget extends AndromedaWidget {
  static const String id = 'ClipPath';

  AndromedaClipPathWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaClipPathWidgetState createState() => AndromedaClipPathWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    // final prop = AndromedaClipPathProps(ctx.context, ctx.props);
    final style = AndromedaClipPathStyles(ctx.context, ctx.styles);

    return ClipPath(
      // styles
      clipBehavior: style.clipBehavior,
      // TODO: clipper: CustomClipper<Path>?,

      // props
      child: await ctx.firstChildOrNull,
    );
  }
}

class AndromedaClipPathWidgetState extends AndromedaWidgetState<AndromedaClipPathWidget> {}