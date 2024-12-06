import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaRefreshIndicatorProps extends ContextableMapTraversable {
  const AndromedaRefreshIndicatorProps(super.context, super.data);
}

class AndromedaRefreshIndicatorStyles extends ContextableMapTraversable {
  const AndromedaRefreshIndicatorStyles(super.context, super.data);

  double get displacement => getDouble('displacement', 40.0);
  double get edgeOffset => getDouble('edgeOffset', 0.0);
  double get strokeWidth => getDouble('strokeWidth', 2.5);

  Color? get color => themeColorFromString(get('color'), context);
  Color? get backgroundColor => themeColorFromString(get('backgroundColor'), context);

  RefreshIndicatorTriggerMode get triggerMode => refreshIndicatorTriggerModeFromString(get('triggerMode')) ?? RefreshIndicatorTriggerMode.onEdge;
}

class AndromedaRefreshIndicatorWidget extends AndromedaWidget {
  static const String id = 'RefreshIndicator';
  
  AndromedaRefreshIndicatorWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaRefreshIndicatorWidgetState createState() => AndromedaRefreshIndicatorWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    // final prop = AndromedaRefreshIndicatorProps(ctx.context, ctx.props);
    final style = AndromedaRefreshIndicatorStyles(ctx.context, ctx.styles);

    return RefreshIndicator(
      // styles
      displacement: style.displacement,
      edgeOffset: style.edgeOffset,
      strokeWidth: style.strokeWidth,

      color: style.color,
      backgroundColor: style.backgroundColor,
      
      triggerMode: style.triggerMode,

      // handlers
      onRefresh: ctx.prepareHandler('onRefresh', 0),
      notificationPredicate: ctx.prepareHandler('notificationPredicate', 1) ?? defaultScrollNotificationPredicate,
      
      // props
      child: await ctx.firstChild,
    );
  }
}

class AndromedaRefreshIndicatorWidgetState extends AndromedaWidgetState<AndromedaRefreshIndicatorWidget> {}