import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaSubmitButtonProps extends ContextableMapTraversable {
  const AndromedaSubmitButtonProps(super.context, super.data);

  bool get autofocus => get('autofocus') ?? false;
  Clip? get clipBehavior => clipFromString(get('clipBehavior'));
  IconAlignment get iconAlignment => iconAlignmentFromString(get('iconAlignment')) ?? IconAlignment.start;
  AndromedaStyleButtonStyle get style => AndromedaStyleButtonStyle(context, getMap('style'));
}

class AndromedaSubmitButtonWidget extends AndromedaWidget {
  static const String id = 'SubmitButton';
  
  AndromedaSubmitButtonWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaSubmitButtonWidgetState createState() => AndromedaSubmitButtonWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final style = AndromedaSubmitButtonProps(ctx.context, ctx.props);

    // TODO: properties

    return CoreSubmitButton(
      onPressed: ctx.prepareHandler('onPressed', 0),
      style: buttonStyleFromStyle(style.style),
      child: await ctx.firstChild,
    );
  }
}

class AndromedaSubmitButtonWidgetState extends AndromedaWidgetState<AndromedaSubmitButtonWidget> {}