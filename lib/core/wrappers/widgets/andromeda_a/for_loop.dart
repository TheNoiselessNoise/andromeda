import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaForLoopProps extends MapTraversable {
  const AndromedaForLoopProps(super.data);

  String get variable => getString('variable', '\$i');
  int get start => getInt('start');
  int get end => getInt('end');
  int get by => getInt('by', 1);
  FWidget? get wrap => get('wrap');
}

class AndromedaForLoopWidget extends AndromedaWidget {
  static const String id = 'ForLoop';
  
  AndromedaForLoopWidget({
    super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaForLoopWidgetState createState() => AndromedaForLoopWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaForLoopProps(ctx.props);

    List<AndromedaWidget> children = [];
    var currentValue = prop.start;

    while (true) {
      if (prop.by > 0 && currentValue > prop.end) break;
      if (prop.by < 0 && currentValue < prop.end) break;

      final iterationCtx = ctx.withVariable(prop.variable, currentValue);
      children.add((await iterationCtx.children).first);

      currentValue += prop.by;
    }

    AndromedaWidget? wrapWidget = ctx.render(prop.wrap, children);

    return wrapWidget ?? Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}

class AndromedaForLoopWidgetState extends AndromedaWidgetState<AndromedaForLoopWidget> {}