import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaInkWellProps extends ContextableMapTraversable {
  const AndromedaInkWellProps(super.context, super.data);

  bool get autofocus => getBool('autofocus', false);
  bool get canRequestFocus => getBool('canRequestFocus', true);
  bool? get enableFeedback => get('enableFeedback');
  Color? get focusColor => themeColorFromString(get('focusColor'), context);
  Color? get highlightColor => themeColorFromString(get('highlightColor'), context);
  Color? get hoverColor => themeColorFromString(get('hoverColor'), context);
  AndromedaStyleDuration get hoverDuration => AndromedaStyleDuration(getMap('hoverDuration'));
  MouseCursor? get mouseCursor => mouseCursorFromString(get('mouseCursor'));
  double? get radius => get('radius');
  Color? get splashColor => themeColorFromString(get('splashColor'), context);
  AndromedaStyleBorderRadius get borderRadius => AndromedaStyleBorderRadius(getMap('borderRadius'));
}

class AndromedaInkWellWidget extends AndromedaWidget {
  static const String id = 'InkWell';
  
  AndromedaInkWellWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaInkWellWidgetState createState() => AndromedaInkWellWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaInkWellProps(ctx.context, ctx.props);

    return InkWell(
      autofocus: prop.autofocus,
      canRequestFocus: prop.canRequestFocus,
      enableFeedback: prop.enableFeedback,
      focusColor: prop.focusColor,
      highlightColor: prop.highlightColor,
      hoverColor: prop.hoverColor,
      hoverDuration: durationFromStyle(prop.hoverDuration),
      mouseCursor: prop.mouseCursor,
      radius: prop.radius,
      splashColor: prop.splashColor,
      borderRadius: borderRadiusFromStyle(prop.borderRadius),

      // TODO: overlayColor: WidgetStateProperty<Color?>?,
      // TODO: splashFactory: InteractiveInkFeatureFactory?,
      // TODO: statesController: WidgetStatesController?,
      // TODO: focusNode: FocusNode?,
      // TODO: customBorder: ShapeBorder?,

      onTap: ctx.prepareHandler('onTap', 0),
      onTapUp: ctx.prepareHandler('onTapUp', 1),
      onTapDown: ctx.prepareHandler('onTapDown', 1),
      onTapCancel: ctx.prepareHandler('onTapCancel', 0),

      onSecondaryTap: ctx.prepareHandler('onSecondaryTap', 0),
      onSecondaryTapUp: ctx.prepareHandler('onSecondaryTapUp', 1),
      onSecondaryTapDown: ctx.prepareHandler('onSecondaryTapDown', 1),
      onSecondaryTapCancel: ctx.prepareHandler('onSecondaryTapCancel', 0),

      onDoubleTap: ctx.prepareHandler('onDoubleTap', 0),
      onLongPress: ctx.prepareHandler('onLongPress', 0),

      onHover: ctx.prepareHandler('onHover', 1),
      onFocusChange: ctx.prepareHandler('onFocusChange', 1),
      onHighlightChanged: ctx.prepareHandler('onHighlightChanged', 1),

      child: await ctx.firstChildOrNull,
    );
  }
}

class AndromedaInkWellWidgetState extends AndromedaWidgetState<AndromedaInkWellWidget> {}