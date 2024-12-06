import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class AndromedaListViewProps extends MapTraversable {
  const AndromedaListViewProps(super.data);

  FWidget? get leading => get('leading');
  FWidget? get prototypeItem => get('prototypeItem');
}

class AndromedaListViewStyles extends ContextableMapTraversable {
  const AndromedaListViewStyles(super.context, super.data);

  bool get addAutomaticKeepAlives => getBool('addAutomaticKeepAlives', true);
  bool get addRepaintBoundaries => getBool('addRepaintBoundaries', true);
  double? get cacheExtent => get('cacheExtent');
  Clip get clipBehavior => clipFromString(get('clipBehavior')) ?? Clip.hardEdge;
  DragStartBehavior get dragStartBehavior => dragStartBehaviorFromString(get('dragStartBehavior')) ?? DragStartBehavior.start;
  HitTestBehavior get hitTestBehavior => hitTestBehaviorFromString(get('hitTestBehavior')) ?? HitTestBehavior.opaque;
  double? get itemExtent => get('itemExtent');
  AndromedaStyleEdgeInsets get padding => AndromedaStyleEdgeInsets(getMap('padding'));
  ScrollViewKeyboardDismissBehavior get keyboardDismissBehavior => scrollViewKeyboardDismissBehaviorFromString(get('keyboardDismissBehavior')) ?? ScrollViewKeyboardDismissBehavior.manual;
  bool? get primary => get('primary');
  String? get restorationId => get('restorationId');
  bool get reverse => getBool('reverse', false);
  Axis get scrollDirection => axisFromString(get('scrollDirection')) ?? Axis.vertical;
  bool get shrinkWrap => getBool('shrinkWrap', false);
}

class AndromedaListViewWidget extends AndromedaWidget {
  static const String id = 'ListView';

  AndromedaListViewWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaListViewWidgetState createState() => AndromedaListViewWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaListViewProps(ctx.props);
    final style = AndromedaListViewStyles(ctx.context, ctx.styles);

    return ListView(
      addAutomaticKeepAlives: style.addAutomaticKeepAlives,
      addRepaintBoundaries: style.addRepaintBoundaries,
      cacheExtent: style.cacheExtent,
      clipBehavior: style.clipBehavior,
      dragStartBehavior: style.dragStartBehavior,
      hitTestBehavior: style.hitTestBehavior,
      itemExtent: style.itemExtent,
      padding: edgeInsetsFromStyle(style.padding),
      keyboardDismissBehavior: style.keyboardDismissBehavior,
      primary: style.primary,
      prototypeItem: ctx.render(prop.prototypeItem),
      restorationId: style.restorationId,
      reverse: style.reverse,
      scrollDirection: style.scrollDirection,
      shrinkWrap: style.shrinkWrap,

      // TODO: controller: ScrollController?,
      // TODO: physics: ScrollPhysics?,

      itemExtentBuilder: ctx.prepareHandler('itemExtentBuilder', 2),
      
      children: await ctx.children,
    );
  }
}

class AndromedaListViewWidgetState extends AndromedaWidgetState<AndromedaListViewWidget> {}