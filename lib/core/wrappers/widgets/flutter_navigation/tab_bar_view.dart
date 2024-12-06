import 'package:andromeda/core/_.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AndromedaTabBarViewProps extends ContextableMapTraversable {
  const AndromedaTabBarViewProps(super.context, super.data);
}

class AndromedaTabBarViewStyles extends ContextableMapTraversable {
  const AndromedaTabBarViewStyles(super.context, super.data);

  Clip get clipBehavior => clipFromString(get('clipBehavior')) ?? Clip.hardEdge;
  double get viewportFraction => getDouble('viewportFraction', 1.0);
  DragStartBehavior get dragStartBehavior => dragStartBehaviorFromString(get('dragStartBehavior')) ?? DragStartBehavior.start;
}

class AndromedaTabBarViewWidget extends AndromedaWidget {
  static const String id = 'TabBarView';
  
  AndromedaTabBarViewWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaTabBarViewWidgetState createState() => AndromedaTabBarViewWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    // final prop = AndromedaTabBarViewProps(ctx.context, ctx.props);
    final style = AndromedaTabBarViewStyles(ctx.context, ctx.styles);

    return TabBarView(
      // styles
      clipBehavior: style.clipBehavior,
      viewportFraction: style.viewportFraction,
      dragStartBehavior: style.dragStartBehavior,
      
      // props
      // TODO: controller: TabController?,
      // TODO: physics: ScrollPhysics?,
      children: await ctx.children,
    );
  }
}

class AndromedaTabBarViewWidgetState extends AndromedaWidgetState<AndromedaTabBarViewWidget> {}