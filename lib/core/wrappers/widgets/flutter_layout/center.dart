import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaCenterStyles extends ContextableMapTraversable {
  const AndromedaCenterStyles(super.context, super.data);

  double? get heightFactor => get('heightFactor');
  double? get widthFactor => get('widthFactor');
}

class AndromedaCenterWidget extends AndromedaWidget {
  static const String id = 'Center';
  
  AndromedaCenterWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children,
  });

  @override
  AndromedaCenterWidgetState createState() => AndromedaCenterWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final style = AndromedaCenterStyles(ctx.context, ctx.styles);

    return Center(
      heightFactor: style.heightFactor,
      widthFactor: style.widthFactor,
      child: children.first
    );
  }
}

class AndromedaCenterWidgetState extends AndromedaWidgetState<AndromedaCenterWidget> {}