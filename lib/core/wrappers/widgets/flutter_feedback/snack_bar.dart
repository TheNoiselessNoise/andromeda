import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaSnackBarProps extends ContextableMapTraversable {
  const AndromedaSnackBarProps(super.context, super.data);

  Clip get clipBehavior => clipFromString(get('clipBehavior')) ?? Clip.hardEdge;
  double? get actionOverflowThreshold => get('actionOverflowThreshold');
  Color? get backgroundColor => themeColorFromString(get('backgroundColor'), context);
  Color? get closeIconColor => themeColorFromString(get('closeIconColor'), context);
  AndromedaStyleDuration get duration => AndromedaStyleDuration(getMap('duration'));
  double? get elevation => get('elevation');
  HitTestBehavior? get hitTestBehavior => hitTestBehaviorFromString(get('hitTestBehavior'));
  AndromedaStyleEdgeInsets get margin => AndromedaStyleEdgeInsets(getMap('margin'));
  AndromedaStyleEdgeInsets get padding => AndromedaStyleEdgeInsets(getMap('padding'));
  bool? get showCloseIcon => get('showCloseIcon');
  double? get width => get('width');
  SnackBarBehavior? get behavior => snackBarBehaviorFromString(get('behavior'));
  DismissDirection? get dismissDirection => dismissDirectionFromString(get('dismissDirection'));
  FWidget? get action => get('action');
}

class AndromedaSnackBarWidget extends AndromedaWidget {
  static const String id = 'SnackBar';

  AndromedaSnackBarWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaSnackBarWidgetState createState() => AndromedaSnackBarWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaSnackBarProps(ctx.context, ctx.props);

    return SnackBar(
      clipBehavior: prop.clipBehavior,
      actionOverflowThreshold: prop.actionOverflowThreshold,
      backgroundColor: prop.backgroundColor,
      closeIconColor: prop.closeIconColor,
      duration: durationFromStyle(prop.duration) ?? const Duration(milliseconds: 4000),
      elevation: prop.elevation,
      hitTestBehavior: prop.hitTestBehavior,
      margin: edgeInsetsFromStyle(prop.margin),
      padding: edgeInsetsFromStyle(prop.padding),
      showCloseIcon: prop.showCloseIcon,
      width: prop.width,
      behavior: prop.behavior,
      dismissDirection: prop.dismissDirection,
      action: await ctx.renderReal<SnackBarAction?>(prop.action),

      // TODO: shape: ShapeBorder?,
      // TODO: animation: Animation<double>?,

      onVisible: ctx.prepareHandler('onVisible', 0),

      content: await ctx.firstChild,
    );
  }
}

class AndromedaSnackBarWidgetState extends AndromedaWidgetState<AndromedaSnackBarWidget> {}