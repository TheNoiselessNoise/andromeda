import 'package:andromeda/core/_.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AndromedaTabBarProps extends ContextableMapTraversable {
  const AndromedaTabBarProps(super.context, super.data);

  // TODO: controller: TabController?,
  // TODO: physics: ScrollPhysics?,
}

class AndromedaTabBarStyles extends ContextableMapTraversable {
  const AndromedaTabBarStyles(super.context, super.data);

  bool get isScrollable => getBool('isScrollable', false);
  bool? get enableFeedback => get('enableFeedback');
  bool get automaticIndicatorColorAdjustment => getBool('automaticIndicatorColorAdjustment', true);

  double? get dividerHeight => get('dividerHeight');
  double get indicatorWeight => getDouble('indicatorWeight', 2.0);

  Color? get labelColor => themeColorFromString(get('labelColor'), context);
  Color? get dividerColor => themeColorFromString(get('dividerColor'), context);
  Color? get indicatorColor => themeColorFromString(get('indicatorColor'), context);
  Color? get unselectedLabelColor => themeColorFromString(get('unselectedLabelColor'), context);

  AndromedaStyleEdgeInsets get padding => AndromedaStyleEdgeInsets(getMap('padding'));
  AndromedaStyleEdgeInsets get labelPadding => AndromedaStyleEdgeInsets(getMap('labelPadding'));
  AndromedaStyleEdgeInsets get indicatorPadding => AndromedaStyleEdgeInsets(getMap('indicatorPadding'));

  AndromedaStyleTextStyle get labelStyle => AndromedaStyleTextStyle(context, getMap('labelStyle'));
  AndromedaStyleTextStyle get unselectedLabelStyle => AndromedaStyleTextStyle(context, getMap('unselectedLabelStyle'));

  MouseCursor? get mouseCursor => mouseCursorFromString(get('mouseCursor'));
  DragStartBehavior get dragStartBehavior => dragStartBehaviorFromString(get('dragStartBehavior')) ?? DragStartBehavior.start;
  AndromedaStyleDecoration get indicator => AndromedaStyleDecoration(getMap('indicator'));
  TabBarIndicatorSize? get indicatorSize => tabBarIndicatorSizeFromString(get('indicatorSize'));
  AndromedaStyleBorderRadius get splashBorderRadius => AndromedaStyleBorderRadius(getMap('splashBorderRadius'));
  TabAlignment? get tabAlignment => tabAlignmentFromString(get('tabAlignment'));
}

class AndromedaTabBarWidget extends AndromedaWidget {
  static const String id = 'TabBar';
  
  AndromedaTabBarWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaTabBarWidgetState createState() => AndromedaTabBarWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    // final prop = AndromedaTabBarProps(ctx.context, ctx.props);
    final style = AndromedaTabBarStyles(ctx.context, ctx.styles);

    return TabBar(
      // styles
      isScrollable: style.isScrollable,
      enableFeedback: style.enableFeedback,
      automaticIndicatorColorAdjustment: style.automaticIndicatorColorAdjustment,

      dividerHeight: style.dividerHeight,
      indicatorWeight: style.indicatorWeight,

      labelColor: style.labelColor,
      dividerColor: style.dividerColor,
      indicatorColor: style.indicatorColor,
      unselectedLabelColor: style.unselectedLabelColor,

      padding: edgeInsetsGeometryFromStyle(style.padding),
      labelPadding: edgeInsetsGeometryFromStyle(style.labelPadding),
      indicatorPadding: edgeInsetsGeometryFromStyle(style.indicatorPadding) ?? EdgeInsets.zero,

      labelStyle: textStyleFromStyle(style.labelStyle),
      unselectedLabelStyle: textStyleFromStyle(style.unselectedLabelStyle),
      
      mouseCursor: style.mouseCursor,
      dragStartBehavior: style.dragStartBehavior,
      indicator: decorationFromStyle(style.indicator),
      indicatorSize: style.indicatorSize,
      splashBorderRadius: borderRadiusFromStyle(style.splashBorderRadius),
      tabAlignment: style.tabAlignment,
      
      // TODO: textScaler: TextScaler?,
      // TODO: overlayColor: WidgetStateProperty<Color?>?,
      // TODO: splashFactory: InteractiveInkFeatureFactory?,

      // handlers
      onTap: ctx.prepareHandler('onTap', 1),

      // props
      // TODO: controller: TabController?,
      // TODO: physics: ScrollPhysics?,
      tabs: await ctx.children,
    );
  }
}

class AndromedaTabBarWidgetState extends AndromedaWidgetState<AndromedaTabBarWidget> {}