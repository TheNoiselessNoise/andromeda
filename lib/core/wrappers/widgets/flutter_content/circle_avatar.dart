import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaCircleAvatarStyles extends ContextableMapTraversable {
  const AndromedaCircleAvatarStyles(super.context, super.data);

  double? get minRadius => get('minRadius');
  double? get maxRadius => get('maxRadius');
  double? get radius => get('radius');
  Color? get backgroundColor => themeColorFromString(get('backgroundColor'), context);
  Color? get foregroundColor => themeColorFromString(get('foregroundColor'), context);
}

class AndromedaCircleAvatarWidget extends AndromedaWidget {
  static const String id = 'CircleAvatar';

  AndromedaCircleAvatarWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaCircleAvatarWidgetState createState() => AndromedaCircleAvatarWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final style = AndromedaCircleAvatarStyles(ctx.context, ctx.styles);

    return CircleAvatar(
      minRadius: style.minRadius,
      maxRadius: style.maxRadius,
      radius: style.radius,
      backgroundColor: style.backgroundColor,
      foregroundColor: style.foregroundColor,
      // TODO: backgroundImage: ImageProvider<Object>?
      // TODO: foregroundImage: ImageProvider<Object>?
      // (Object, StackTrace)
      onBackgroundImageError: ctx.prepareHandler('onBackgroundImageError', 2),
      // (Object, StackTrace)
      onForegroundImageError: ctx.prepareHandler('onForegroundImageError', 2),
      child: await ctx.firstChildOrNull,
    );
  }
}

class AndromedaCircleAvatarWidgetState extends AndromedaWidgetState<AndromedaCircleAvatarWidget> {}