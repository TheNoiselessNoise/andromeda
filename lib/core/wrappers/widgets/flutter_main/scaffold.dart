import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class AndromedaScaffoldProps extends MapTraversable {
  const AndromedaScaffoldProps(super.data);

  FWidget? get appBar => get('appBar');
  FWidget? get drawer => get('drawer');
  FWidget? get endDrawer => get('endDrawer');
  FWidget? get bottomNavigationBar => get('bottomNavigationBar');
  FWidget? get bottomSheet => get('bottomSheet');
  FWidget? get floatingActionButton => get('floatingActionButton');
  List<FWidget> get persistentFooterButtons => getList('persistentFooterButtons');
}

class AndromedaScaffoldStyles extends ContextableMapTraversable {
  const AndromedaScaffoldStyles(super.context, super.data);

  Color? get backgroundColor => themeColorFromString(get('backgroundColor'), context);
  DragStartBehavior get drawerDragStartBehavior => dragStartBehaviorFromString(get('drawerDragStartBehavior')) ?? DragStartBehavior.start;
  double? get drawerEdgeDragWidth => get('drawerEdgeDragWidth');
  bool get extendBody => getBool('extendBody', false);
  bool get drawerEnableOpenDragGesture => getBool('drawerEnableOpenDragGesture', true);
  Color? get drawerScrimColor => themeColorFromString(get('drawerScrimColor'), context);
  bool get endDrawerEnableOpenDragGesture => getBool('endDrawerEnableOpenDragGesture', true);
  bool get extendBodyBehindAppBar => getBool('extendBodyBehindAppBar', false);
  bool get primary => getBool('primary', true);
  String? get restorationId => get('restorationId');
  bool? get resizeToAvoidBottomInset => get('resizeToAvoidBottomInset');
  AlignmentDirectional get persistentFooterAlignment => alignmentDirectionalFromString(get('persistentFooterAlignment')) ?? AlignmentDirectional.centerEnd;
  FloatingActionButtonLocation? get floatingActionButtonLocation => floatingActionButtonLocationFromString(get('floatingActionButtonLocation'));
}

class AndromedaScaffoldWidget extends AndromedaWidget {
  static const String id = 'Scaffold';
  AndromedaScaffoldWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaScaffoldWidgetState createState() => AndromedaScaffoldWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaScaffoldProps(ctx.props);
    final style = AndromedaScaffoldStyles(ctx.context, ctx.styles);

    return Scaffold(
      appBar: ctx.renderPreferredSize(prop.appBar),
      drawer: ctx.render(prop.drawer),
      endDrawer: ctx.render(prop.endDrawer),
      bottomNavigationBar: ctx.render(prop.bottomNavigationBar),
      bottomSheet: ctx.render(prop.bottomSheet),
      floatingActionButton: ctx.render(prop.floatingActionButton),
      backgroundColor: style.backgroundColor,
      drawerDragStartBehavior: style.drawerDragStartBehavior,
      drawerEdgeDragWidth: style.drawerEdgeDragWidth,
      extendBody: style.extendBody,
      drawerEnableOpenDragGesture: style.drawerEnableOpenDragGesture,
      drawerScrimColor: style.drawerScrimColor,
      endDrawerEnableOpenDragGesture: style.endDrawerEnableOpenDragGesture,
      extendBodyBehindAppBar: style.extendBodyBehindAppBar,
      primary: style.primary,
      restorationId: style.restorationId,
      resizeToAvoidBottomInset: style.resizeToAvoidBottomInset,
      persistentFooterAlignment: style.persistentFooterAlignment,
      persistentFooterButtons: prop.persistentFooterButtons.map((e) => ctx.render(e)).whereType<Widget>().toList(),
      floatingActionButtonLocation: style.floatingActionButtonLocation,

      // TODO: floatingActionButtonAnimator: FloatingActionButtonAnimator?

      onDrawerChanged: ctx.prepareHandler('onDrawerChanged', 1),
      onEndDrawerChanged: ctx.prepareHandler('onEndDrawerChanged', 1),

      body: await ctx.firstChildOrNull
    );
  }
}

class AndromedaScaffoldWidgetState extends AndromedaWidgetState<AndromedaScaffoldWidget> {}