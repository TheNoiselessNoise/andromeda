import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaPopupMenuButtonProps extends ContextableMapTraversable {
  const AndromedaPopupMenuButtonProps(super.context, super.data);

  Clip get clipBehavior => clipFromString(get('clipBehavior')) ?? Clip.none;
  double? get elevation => get('elevation');
  bool? get enableFeedback => get('enableFeedback');
  String? get tooltip => get('tooltip');
  Color? get color => themeColorFromString(get('color'), context);
  AndromedaStyleBoxConstraints get constraints => AndromedaStyleBoxConstraints(getMap('constraints'));
  bool get enabled => getBool('enabled', true);
  FWidget? get icon => get('icon');
  Color? get iconColor => themeColorFromString(get('iconColor'), context);
  double? get iconSize => get('iconSize');
  dynamic get initialValue => get('initialValue');
  AndromedaStyleEdgeInsets get menuPadding => AndromedaStyleEdgeInsets(getMap('menuPadding'));
  Offset get offset => offsetFromValue(get('offset')) ?? Offset.zero;
  AndromedaStyleEdgeInsets get padding => AndromedaStyleEdgeInsets(getMap('padding'));
  PopupMenuPosition? get position => popupMenuPositionFromString(get('position'));
  Color? get shadowColor => themeColorFromString(get('shadowColor'), context);
  double? get splashRadius => get('splashRadius');
  AndromedaStyleButtonStyle get style => AndromedaStyleButtonStyle(context, getMap('style'));
  Color? get surfaceTintColor => themeColorFromString(get('surfaceTintColor'), context);
  bool get useRootNavigator => getBool('useRootNavigator', false);

  dynamic get itemBuilder => get('itemBuilder');
}

class AndromedaPopupMenuButtonWidget extends AndromedaWidget {
  static const String id = 'PopupMenuButton';

  AndromedaPopupMenuButtonWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaPopupMenuButtonWidgetState createState() => AndromedaPopupMenuButtonWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaPopupMenuButtonProps(ctx.context, ctx.props);

    return PopupMenuButton(
      clipBehavior: prop.clipBehavior,
      elevation: prop.elevation,
      enableFeedback: prop.enableFeedback,
      tooltip: prop.tooltip,
      color: prop.color,
      constraints: boxConstraintsFromStyle(prop.constraints),
      enabled: prop.enabled,
      icon: ctx.render(prop.icon),
      iconColor: prop.iconColor,
      iconSize: prop.iconSize,
      initialValue: prop.initialValue,
      menuPadding: edgeInsetsGeometryFromStyle(prop.menuPadding),
      offset: prop.offset,
      padding: edgeInsetsGeometryFromStyle(prop.padding) ?? const EdgeInsets.all(8.0),
      position: prop.position,
      shadowColor: prop.shadowColor,
      splashRadius: prop.splashRadius,
      style: buttonStyleFromStyle(prop.style),
      surfaceTintColor: prop.surfaceTintColor,
      useRootNavigator: prop.useRootNavigator,
      
      onCanceled: ctx.prepareHandler('onCanceled', 0),
      onOpened: ctx.prepareHandler('onOpened', 0),
      onSelected: ctx.prepareHandler('onSelected', 1),

      itemBuilder: ctx.prepareCustomHandler(prop.itemBuilder, 1),
      
      // TODO: popUpAnimationStyle: AnimationStyle?,
      // TODO: shape: ShapeBorder?,

      child: await ctx.firstChildOrNull,
    );
  }
}

class AndromedaPopupMenuButtonWidgetState extends AndromedaWidgetState<AndromedaPopupMenuButtonWidget> {}