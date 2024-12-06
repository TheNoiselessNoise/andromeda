import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaBadgeProps extends ContextableMapTraversable {
  const AndromedaBadgeProps(super.context, super.data);

  FWidget? get label => get('label');
}

class AndromedaBadgeStyles extends ContextableMapTraversable {
  const AndromedaBadgeStyles(super.context, super.data);

  bool get isLabelVisible => getBool('isLabelVisible', true);

  double? get smallSize => get('smallSize');
  double? get largeSize => get('largeSize');

  Color? get textColor => themeColorFromString(get('textColor'), context);
  Color? get backgroundColor => themeColorFromString(get('backgroundColor'), context);

  Offset? get offset => offsetFromValue(get('offset'));
  AndromedaStyleTextStyle get textStyle => AndromedaStyleTextStyle(context, getMap('textStyle'));
  AlignmentGeometry? get alignment => alignmentGeometryFromString(get('alignment'));
  AndromedaStyleEdgeInsets get padding => AndromedaStyleEdgeInsets(getMap('padding'));
}

class AndromedaBadgeWidget extends AndromedaWidget {
  static const String id = 'Badge';

  AndromedaBadgeWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaBadgeWidgetState createState() => AndromedaBadgeWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaBadgeProps(ctx.context, ctx.props);
    final style = AndromedaBadgeStyles(ctx.context, ctx.styles);

    return Badge(
      // styles
      isLabelVisible: style.isLabelVisible,

      smallSize: style.smallSize,
      largeSize: style.largeSize,
      
      textColor: style.textColor,
      backgroundColor: style.backgroundColor,
      
      offset: style.offset,
      textStyle: textStyleFromStyle(style.textStyle),
      alignment: style.alignment,
      padding: edgeInsetsGeometryFromStyle(style.padding),

      // props
      label: ctx.render(prop.label),
      child: await ctx.firstChildOrNull,
    );
  }
}

class AndromedaBadgeWidgetState extends AndromedaWidgetState<AndromedaBadgeWidget> {}