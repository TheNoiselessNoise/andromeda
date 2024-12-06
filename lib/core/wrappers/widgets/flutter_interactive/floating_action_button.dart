import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaFloatingActionButtonProps extends ContextableMapTraversable {
  const AndromedaFloatingActionButtonProps(super.context, super.data);

  bool get autofocus => get('autofocus') ?? false;
  Clip get clipBehavior => clipFromString(get('clipBehavior')) ?? Clip.none;
  Color? get backgroundColor => themeColorFromString(get('backgroundColor'), context);
  double? get disabledElevation => get('disabledElevation');
  double? get elevation => get('elevation');
  bool? get enableFeedback => get('enableFeedback');
  Color? get focusColor => themeColorFromString(get('focusColor'), context);
  double? get focusElevation => get('focusElevation');
  Color? get foregroundColor => themeColorFromString(get('foregroundColor'), context);
  double? get highlightElevation => get('highlightElevation');
  Color? get hoverColor => themeColorFromString(get('hoverColor'), context);
  double? get hoverElevation => get('hoverElevation');
  bool get isExtended => getBool('isExtended', false);
  MouseCursor? get mouseCursor => mouseCursorFromString(get('mouseCursor'));
  Color? get splashColor => themeColorFromString(get('splashColor'), context);
  String? get tooltip => get('tooltip');
  bool get mini => getBool('mini', false);
  MaterialTapTargetSize? get materialTapTargetSize => materialTapTargetSizeFromString(get('materialTapTargetSize'));
}

class AndromedaFloatingActionButtonWidget extends AndromedaWidget {
  static const String id = 'FloatingActionButton';
  
  AndromedaFloatingActionButtonWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaFloatingActionButtonWidgetState createState() => AndromedaFloatingActionButtonWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaFloatingActionButtonProps(ctx.context, ctx.props);

    return FloatingActionButton(
      autofocus: prop.autofocus,
      clipBehavior: prop.clipBehavior,
      backgroundColor: prop.backgroundColor,
      disabledElevation: prop.disabledElevation,
      elevation: prop.elevation,
      enableFeedback: prop.enableFeedback,
      focusColor: prop.focusColor,
      focusElevation: prop.focusElevation,
      foregroundColor: prop.foregroundColor,
      highlightElevation: prop.highlightElevation,
      hoverColor: prop.hoverColor,
      hoverElevation: prop.hoverElevation,
      isExtended: prop.isExtended,
      mouseCursor: prop.mouseCursor,
      splashColor: prop.splashColor,
      tooltip: prop.tooltip,
      mini: prop.mini,
      materialTapTargetSize: prop.materialTapTargetSize,
      
      // TODO: heroTag: Object?,
      // TODO: focusNode: FocusNode?,
      // TODO: shape: ShapeBorder?,

      onPressed: ctx.prepareHandler('onPressed', 0),

      child: await ctx.firstChildOrNull,
    );
  }
}

class AndromedaFloatingActionButtonWidgetState extends AndromedaWidgetState<AndromedaFloatingActionButtonWidget> {}