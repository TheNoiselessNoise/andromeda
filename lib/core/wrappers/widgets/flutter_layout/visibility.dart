import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaVisibilityProps extends ContextableMapTraversable {
  const AndromedaVisibilityProps(super.context, super.data);

  bool get visible => getBool('visible', true);
  FWidget? get replacement => get('replacement');
  bool get maintainSize => getBool('maintainSize', false);
  bool get maintainState => getBool('maintainState', false);
  bool get maintainAnimation => getBool('maintainAnimation', false);
  bool get maintainInteractivity => getBool('maintainInteractivity', false);
}

class AndromedaVisibilityWidget extends AndromedaWidget {
  static const String id = 'Visibility';
  
  AndromedaVisibilityWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaVisibilityWidgetState createState() => AndromedaVisibilityWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaVisibilityProps(ctx.context, ctx.props);
    
    return Visibility(
      // props
      visible: prop.visible,
      replacement: ctx.render(prop.replacement) ?? const SizedBox.shrink(),
      maintainSize: prop.maintainSize,
      maintainState: prop.maintainState,
      maintainAnimation: prop.maintainAnimation,
      maintainInteractivity: prop.maintainInteractivity,
      child: await ctx.firstChild,
    );
  }
}

class AndromedaVisibilityWidgetState extends AndromedaWidgetState<AndromedaVisibilityWidget> {}