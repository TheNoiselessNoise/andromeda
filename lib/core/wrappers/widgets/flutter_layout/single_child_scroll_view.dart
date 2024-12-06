import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class AndromedaSingleChildScrollViewStyles extends ContextableMapTraversable {
  const AndromedaSingleChildScrollViewStyles(super.context, super.data);

  Clip get clipBehavior => clipFromString(get('clipBehavior')) ?? Clip.hardEdge;
  DragStartBehavior get dragStartBehavior => dragStartBehaviorFromString(get('dragStartBehavior')) ?? DragStartBehavior.start;
  HitTestBehavior get hitTestBehavior => hitTestBehaviorFromString(get('hitTestBehavior')) ?? HitTestBehavior.opaque;
  ScrollViewKeyboardDismissBehavior get keyboardDismissBehavior => scrollViewKeyboardDismissBehaviorFromString(get('keyboardDismissBehavior')) ?? ScrollViewKeyboardDismissBehavior.manual;
  AndromedaStyleEdgeInsets get padding => AndromedaStyleEdgeInsets(getMap('padding'));
  bool? get primary => get('primary');
  String? get restorationId => get('restorationId');
  bool get reverse => getBool('reverse', false);
  Axis get scrollDirection => axisFromString(get('scrollDirection')) ?? Axis.vertical;
}

class AndromedaSingleChildScrollViewWidget extends AndromedaWidget {
  static const String id = 'SingleChildScrollView';
  
  AndromedaSingleChildScrollViewWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaSingleChildScrollViewWidgetState createState() => AndromedaSingleChildScrollViewWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final style = AndromedaSingleChildScrollViewStyles(ctx.context, ctx.styles);

    return SingleChildScrollView(
      clipBehavior: style.clipBehavior,
      dragStartBehavior: style.dragStartBehavior,
      hitTestBehavior: style.hitTestBehavior,
      keyboardDismissBehavior: style.keyboardDismissBehavior,
      padding: edgeInsetsFromStyle(style.padding),
      primary: style.primary,
      restorationId: style.restorationId,
      reverse: style.reverse,
      scrollDirection: style.scrollDirection,

      // TODO: controller: ScrollController?
      // TODO: physics: ScrollPhysics?

      child: await ctx.firstChildOrNull,
    );
  }
}

class AndromedaSingleChildScrollViewWidgetState extends AndromedaWidgetState<AndromedaSingleChildScrollViewWidget> {}