import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class AndromedaCustomScrollViewProps extends MapTraversable {
  const AndromedaCustomScrollViewProps(super.data);
}

class AndromedaCustomScrollViewStyles extends ContextableMapTraversable {
  const AndromedaCustomScrollViewStyles(super.context, super.data);

  bool? get primary => get('primary');
  bool get reverse => getBool('reverse', false);
  bool get shrinkWrap => getBool('shrinkWrap', false);

  String? get restorationId => get('restorationId');
  double? get cacheExtent => get('cacheExtent');
  double get anchor => getDouble('anchor', 0.0);

  Clip get clipBehavior => clipFromString(get('clipBehavior')) ?? Clip.hardEdge;
  DragStartBehavior get dragStartBehavior => dragStartBehaviorFromString(get('dragStartBehavior')) ?? DragStartBehavior.start;
  HitTestBehavior get hitTestBehavior => hitTestBehaviorFromString(get('hitTestBehavior')) ?? HitTestBehavior.opaque;
  ScrollViewKeyboardDismissBehavior get keyboardDismissBehavior => scrollViewKeyboardDismissBehaviorFromString(get('keyboardDismissBehavior')) ?? ScrollViewKeyboardDismissBehavior.manual;
  Axis get scrollDirection => axisFromString(get('scrollDirection')) ?? Axis.vertical;
}

class AndromedaCustomScrollViewWidget extends AndromedaWidget {
  static const String id = 'CustomScrollView';
  
  AndromedaCustomScrollViewWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaCustomScrollViewWidgetState createState() => AndromedaCustomScrollViewWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    // final prop = AndromedaCustomScrollViewProps(ctx.props);
    final style = AndromedaCustomScrollViewStyles(ctx.context, ctx.styles);

    return CustomScrollView(
      // styles
      primary: style.primary,
      reverse: style.reverse,
      shrinkWrap: style.shrinkWrap,

      restorationId: style.restorationId,
      cacheExtent: style.cacheExtent,
      anchor: style.anchor,

      clipBehavior: style.clipBehavior,
      dragStartBehavior: style.dragStartBehavior,
      hitTestBehavior: style.hitTestBehavior,
      keyboardDismissBehavior: style.keyboardDismissBehavior,
      scrollDirection: style.scrollDirection,

      // props
      // TODO: scrollBehavior: ScrollBehavior?;
      // TODO: center: Key?,
      // TODO: controller: ScrollController?,
      // TODO: physics: ScrollPhysics?,
      slivers: await ctx.children,
    );
  }
}

class AndromedaCustomScrollViewWidgetState extends AndromedaWidgetState<AndromedaCustomScrollViewWidget> {}