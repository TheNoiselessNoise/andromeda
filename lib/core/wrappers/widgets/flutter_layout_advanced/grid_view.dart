import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class AndromedaGridViewProps extends MapTraversable {
  const AndromedaGridViewProps(super.data);
}

class AndromedaGridViewStyles extends ContextableMapTraversable {
  const AndromedaGridViewStyles(super.context, super.data);

  bool? get primary => get('primary');
  bool get addRepaintBoundaries => getBool('addRepaintBoundaries', true);
  bool get addAutomaticKeepAlives => getBool('addAutomaticKeepAlives', true);
  bool get reverse => getBool('reverse', false);
  bool get shrinkWrap => getBool('shrinkWrap', false);

  String? get restorationId => get('restorationId');
  double? get cacheExtent => get('cacheExtent');

  Clip get clipBehavior => clipFromString(get('clipBehavior')) ?? Clip.hardEdge;
  DragStartBehavior get dragStartBehavior => dragStartBehaviorFromString(get('dragStartBehavior')) ?? DragStartBehavior.start;
  HitTestBehavior get hitTestBehavior => hitTestBehaviorFromString(get('hitTestBehavior')) ?? HitTestBehavior.opaque;
  ScrollViewKeyboardDismissBehavior get keyboardDismissBehavior => scrollViewKeyboardDismissBehaviorFromString(get('keyboardDismissBehavior')) ?? ScrollViewKeyboardDismissBehavior.manual;
  Axis get scrollDirection => axisFromString(get('scrollDirection')) ?? Axis.vertical;
  AndromedaStyleEdgeInsets get padding => AndromedaStyleEdgeInsets(getMap('padding'));
  AndromedaStyleSliverGridDelegate get gridDelegate => AndromedaStyleSliverGridDelegate(getMap('gridDelegate'));
}

class AndromedaGridViewWidget extends AndromedaWidget {
  static const String id = 'GridView';
  
  AndromedaGridViewWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaGridViewWidgetState createState() => AndromedaGridViewWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    // final prop = AndromedaGridViewProps(ctx.props);
    final style = AndromedaGridViewStyles(ctx.context, ctx.styles);

    return GridView(
      // styles
      primary: style.primary,
      addRepaintBoundaries: style.addRepaintBoundaries,
      addAutomaticKeepAlives: style.addAutomaticKeepAlives,
      reverse: style.reverse,
      shrinkWrap: style.shrinkWrap,

      restorationId: style.restorationId,
      cacheExtent: style.cacheExtent,

      clipBehavior: style.clipBehavior,
      dragStartBehavior: style.dragStartBehavior,
      hitTestBehavior: style.hitTestBehavior,
      keyboardDismissBehavior: style.keyboardDismissBehavior,
      scrollDirection: style.scrollDirection,
      padding: edgeInsetsGeometryFromStyle(style.padding),
      gridDelegate: sliverGridDelegateFromStyle(style.gridDelegate) ?? const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      
      // props
      // TODO: controller: ScrollController?,
      // TODO: physics: ScrollPhysics?,
      children: await ctx.children,
    );
  }
}

class AndromedaGridViewWidgetState extends AndromedaWidgetState<AndromedaGridViewWidget> {}