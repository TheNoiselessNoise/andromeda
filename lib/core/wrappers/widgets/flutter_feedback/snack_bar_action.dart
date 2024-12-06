import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaSnackBarActionProps extends ContextableMapTraversable {
  const AndromedaSnackBarActionProps(super.context, super.data);

  Color? get backgroundColor => themeColorFromString(get('backgroundColor'), context);
  Color? get disabledBackgroundColor => themeColorFromString(get('disabledBackgroundColor'), context);
  Color? get disabledTextColor => themeColorFromString(get('disabledTextColor'), context);
  Color? get textColor => themeColorFromString(get('textColor'), context);
  String get label => getString('label');
}

class AndromedaSnackBarActionWidget extends AndromedaWidget {
  static const String id = 'SnackBarAction';

  AndromedaSnackBarActionWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaSnackBarActionWidgetState createState() => AndromedaSnackBarActionWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaSnackBarActionProps(ctx.context, ctx.props);

    return SnackBarAction(
      backgroundColor: prop.backgroundColor,
      disabledBackgroundColor: prop.disabledBackgroundColor,
      disabledTextColor: prop.disabledTextColor,
      textColor: prop.textColor,
      label: prop.label,

      onPressed: ctx.prepareHandler('onPressed', 0),
    );
  }
}

class AndromedaSnackBarActionWidgetState extends AndromedaWidgetState<AndromedaSnackBarActionWidget> {}