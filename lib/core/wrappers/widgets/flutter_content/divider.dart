import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaDividerStyles extends ContextableMapTraversable {
  const AndromedaDividerStyles(super.context, super.data);

  Color? get color => themeColorFromString(get('color'), context);
  double? get endIndent => get('endIndent');
  double? get height => get('height');
  double? get indent => get('indent');
  double? get thickness => get('thickness');
}

class AndromedaDividerWidget extends AndromedaWidget {
  static const String id = 'Divider';
  
  AndromedaDividerWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaDividerWidgetState createState() => AndromedaDividerWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final style = AndromedaDividerStyles(ctx.context, ctx.styles);

    return Divider(
      color: style.color,
      endIndent: style.endIndent,
      height: style.height,
      indent: style.indent,
      thickness: style.thickness,
    );
  }
}

class AndromedaDividerWidgetState extends AndromedaWidgetState<AndromedaDividerWidget> {}