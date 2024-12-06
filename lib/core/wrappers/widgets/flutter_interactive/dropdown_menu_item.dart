import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaDropdownMenuItemProps extends ContextableMapTraversable {
  const AndromedaDropdownMenuItemProps(super.context, super.data);

  bool get enabled => getBool('enabled', true);
  dynamic get value => get('value');
}

class AndromedaDropdownMenuItemStyles extends ContextableMapTraversable {
  const AndromedaDropdownMenuItemStyles(super.context, super.data);

  AlignmentGeometry get alignment => alignmentGeometryFromString(get('alignment')) ?? AlignmentDirectional.centerStart;
}

class AndromedaDropdownMenuItemWidget extends AndromedaWidget {
  static const String id = 'DropdownMenuItem';
  
  AndromedaDropdownMenuItemWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaDropdownMenuItemWidgetState createState() => AndromedaDropdownMenuItemWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaDropdownMenuItemProps(ctx.context, ctx.props);
    final style = AndromedaDropdownMenuItemStyles(ctx.context, ctx.styles);

    // fuck type safety - no DropdownMenuItem<TYPE>

    return DropdownMenuItem(
      // styles
      alignment: style.alignment,

      // handlers
      onTap: ctx.prepareHandler('onTap', 0),

      // props
      enabled: prop.enabled,
      value: prop.value,
      child: await ctx.firstChild,
    );
  }
}

class AndromedaDropdownMenuItemWidgetState extends AndromedaWidgetState<AndromedaDropdownMenuItemWidget> {}