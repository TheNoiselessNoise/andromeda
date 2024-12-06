import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaTextButtonProps extends ContextableMapTraversable {
  const AndromedaTextButtonProps(super.context, super.data);
}

class AndromedaTextButtonStyles extends ContextableMapTraversable {
  const AndromedaTextButtonStyles(super.context, super.data);

  bool get autofocus => get('autofocus') ?? false;
  Clip? get clipBehavior => clipFromString(get('clipBehavior'));
  IconAlignment get iconAlignment => iconAlignmentFromString(get('iconAlignment')) ?? IconAlignment.start;
  AndromedaStyleButtonStyle get style => AndromedaStyleButtonStyle(context, getMap('style'));
}

class AndromedaTextButtonWidget extends AndromedaWidget {
  static const String id = 'TextButton';
  
  AndromedaTextButtonWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaTextButtonWidgetState createState() => AndromedaTextButtonWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    // final prop = AndromedaTextButtonProps(ctx.context, ctx.props);
    final style = AndromedaTextButtonStyles(ctx.context, ctx.styles);

    return TextButton(
      // styles
      autofocus: style.autofocus,
      clipBehavior: style.clipBehavior,
      iconAlignment: style.iconAlignment,
      style: buttonStyleFromStyle(style.style),

      // handlers
      onPressed: ctx.prepareHandler('onPressed', 0),
      onHover: ctx.prepareHandler('onHover', 1),
      onLongPress: ctx.prepareHandler('onLongPress', 0),
      onFocusChange: ctx.prepareHandler('onFocusChange', 1),

      // props
      // TODO: focusNode: FocusNode?,
      // TODO: statesController: WidgetStatesController?,
      child: await ctx.firstChild,
    );
  }
}

class AndromedaTextButtonWidgetState extends AndromedaWidgetState<AndromedaTextButtonWidget> {}