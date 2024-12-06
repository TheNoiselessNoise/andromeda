import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaSafeAreaStyles extends ContextableMapTraversable {
  const AndromedaSafeAreaStyles(super.context, super.data);

  bool get bottom => getBool('bottom', true);
  bool get left => getBool('left', true);
  bool get top => getBool('top', true);
  bool get right => getBool('right', true);
  bool get maintainBottomViewPadding => getBool('maintainBottomViewPadding', false);
  AndromedaStyleEdgeInsets get minimum => AndromedaStyleEdgeInsets(getMap('minimum'));
}

class AndromedaSafeAreaWidget extends AndromedaWidget {
  static const String id = 'SafeArea';
  AndromedaSafeAreaWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaSafeAreaWidgetState createState() => AndromedaSafeAreaWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final style = AndromedaSafeAreaStyles(ctx.context, ctx.styles);

    return SafeArea(
      bottom: style.bottom,
      left: style.left,
      top: style.top,
      right: style.right,
      maintainBottomViewPadding: style.maintainBottomViewPadding,
      minimum: edgeInsetsFromStyle(style.minimum) ?? EdgeInsets.zero,
      child: await ctx.firstChild,
    );
  }
}

class AndromedaSafeAreaWidgetState extends AndromedaWidgetState<AndromedaSafeAreaWidget> {}