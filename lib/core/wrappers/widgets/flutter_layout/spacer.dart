import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaSpacerStyles extends ContextableMapTraversable {
  const AndromedaSpacerStyles(super.context, super.data);

  int get flex => getInt('flex', 1);
}

class AndromedaSpacerWidget extends AndromedaWidget {
  static const String id = 'Spacer';
  
  AndromedaSpacerWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaSpacerWidgetState createState() => AndromedaSpacerWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final style = AndromedaSpacerStyles(ctx.context, ctx.styles);
    
    return Spacer(flex: style.flex);
  }
}

class AndromedaSpacerWidgetState extends AndromedaWidgetState<AndromedaSpacerWidget> {}