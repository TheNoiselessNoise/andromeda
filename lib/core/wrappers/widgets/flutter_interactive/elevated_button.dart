import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaElevatedButtonProps extends ContextableMapTraversable {
  const AndromedaElevatedButtonProps(super.context, super.data);

  bool get autofocus => get('autofocus') ?? false;
  Clip? get clipBehavior => clipFromString(get('clipBehavior'));
  IconAlignment get iconAlignment => iconAlignmentFromString(get('iconAlignment')) ?? IconAlignment.start;
  AndromedaStyleButtonStyle get style => AndromedaStyleButtonStyle(context, getMap('style'));
}

class AndromedaElevatedButtonWidget extends AndromedaWidget {
  static const String id = 'ElevatedButton';
  
  AndromedaElevatedButtonWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaElevatedButtonWidgetState createState() => AndromedaElevatedButtonWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaElevatedButtonProps(ctx.context, ctx.props);

    return ElevatedButton(
      autofocus: prop.autofocus,
      clipBehavior: prop.clipBehavior,
      iconAlignment: prop.iconAlignment,
      style: buttonStyleFromStyle(prop.style),

      onPressed: ctx.prepareHandler('onPressed', 0),
      onHover: ctx.prepareHandler('onHover', 1),
      onLongPress: ctx.prepareHandler('onLongPress', 0),
      onFocusChange: ctx.prepareHandler('onFocusChange', 1),
      child: await ctx.firstChildOrNull
    );
  }
}

class AndromedaElevatedButtonWidgetState extends AndromedaWidgetState<AndromedaElevatedButtonWidget> {}