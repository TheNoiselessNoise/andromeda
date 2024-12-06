import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaIconButtonProps extends ContextableMapTraversable {
  const AndromedaIconButtonProps(super.context, super.data);

  String? get tooltip => get('tooltip');
  FWidget? get selectedIcon => get('selectedIcon');
}

class AndromedaIconButtonStyles extends ContextableMapTraversable {
  const AndromedaIconButtonStyles(super.context, super.data);

  bool get autofocus => get('autofocus') ?? false;
  bool? get enableFeedback => get('enableFeedback');
  bool? get isSelected => get('isSelected');

  double? get iconSize => get('iconSize');
  double? get splashRadius => get('splashRadius');

  Color? get color => themeColorFromString(get('color'), context);
  Color? get hoverColor => themeColorFromString(get('hoverColor'), context);
  Color? get focusColor => themeColorFromString(get('focusColor'), context);
  Color? get splashColor => themeColorFromString(get('splashColor'), context);
  Color? get disabledColor => themeColorFromString(get('disabledColor'), context);
  Color? get highlightColor => themeColorFromString(get('highlightColor'), context);

  AndromedaStyleEdgeInsets get padding => AndromedaStyleEdgeInsets(getMap('padding'));
  AlignmentGeometry? get alignment => alignmentGeometryFromString(get('alignment'));
  AndromedaStyleBoxConstraints get constraints => AndromedaStyleBoxConstraints(getMap('constraints'));

  AndromedaStyleButtonStyle get style => AndromedaStyleButtonStyle(context, getMap('style'));
  MouseCursor? get mouseCursor => mouseCursorFromString(get('mouseCursor'));
  VisualDensity? get visualDensity => visualDensityFromString(get('visualDensity'));
}

class AndromedaIconButtonWidget extends AndromedaWidget {
  static const String id = 'IconButton';

  AndromedaIconButtonWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaIconButtonWidgetState createState() => AndromedaIconButtonWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaIconButtonProps(ctx.context, ctx.props);
    final style = AndromedaIconButtonStyles(ctx.context, ctx.styles);

    return IconButton(
      // styles
      autofocus: style.autofocus,
      enableFeedback: style.enableFeedback,
      isSelected: style.isSelected,
      
      iconSize: style.iconSize,
      splashRadius: style.splashRadius,
      
      color: style.color,
      hoverColor: style.hoverColor,
      focusColor: style.focusColor,
      splashColor: style.splashColor,
      disabledColor: style.disabledColor,
      highlightColor: style.highlightColor,

      padding: edgeInsetsGeometryFromStyle(style.padding),
      alignment: style.alignment,
      constraints: boxConstraintsFromStyle(style.constraints),
      
      style: buttonStyleFromStyle(style.style),
      mouseCursor: style.mouseCursor,
      visualDensity: style.visualDensity,

      // handlers
      onPressed: ctx.prepareHandler('onPressed', 0),
      
      // props
      // TODO: focusNode: FocusNode?,
      tooltip: prop.tooltip,
      selectedIcon: ctx.render(prop.selectedIcon),
      icon: await ctx.firstChild,
    );
  }
}

class AndromedaIconButtonWidgetState extends AndromedaWidgetState<AndromedaIconButtonWidget> {}