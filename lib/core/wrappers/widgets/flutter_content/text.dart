import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaTextProps extends ContextableMapTraversable {
  const AndromedaTextProps(super.context, super.data);

  dynamic get text => get('text');
}

class AndromedaTextStyles extends ContextableMapTraversable {
  const AndromedaTextStyles(super.context, super.data);

  bool? get softWrap => get('softWrap');
  TextOverflow? get overflow => textOverflowFromString(get('overflow'));
  Color? get selectionColor => themeColorFromString(get('selectionColor'), context);
  TextAlign? get textAlign => textAlignFromString(get('textAlign'));
  int? get maxLines => get('maxLines');
  TextDirection? get textDirection => textDirectionFromString(get('textDirection'));
  TextWidthBasis? get textWidthBasis => textWidthBasisFromString(get('textWidthBasis'));
  AndromedaStyleTextHeightBehavior get textHeightBehavior => AndromedaStyleTextHeightBehavior(getMap('textHeightBehavior'));
  AndromedaStyleTextStyle get style => AndromedaStyleTextStyle(context, getMap('style'));
  AndromedaStyleStrutStyle get strutStyle => AndromedaStyleStrutStyle(getMap('strutStyle'));
}

class AndromedaTextWidget extends AndromedaWidget {
  static const String id = 'Text';

  AndromedaTextWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaTextWidgetState createState() => AndromedaTextWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaTextProps(ctx.context, ctx.props);
    final style = AndromedaTextStyles(ctx.context, ctx.styles);

    return Text(
      prop.text.toString(),

      style: textStyleFromStyle(style.style),

      softWrap: style.softWrap,
      overflow: style.overflow,
      selectionColor: style.selectionColor,
      textAlign: style.textAlign,
      maxLines: style.maxLines,
      textDirection: style.textDirection,
      textWidthBasis: style.textWidthBasis,
      textHeightBehavior: textHeightBehaviorFromStyle(style.textHeightBehavior),
      strutStyle: strutStyleFromStyle(style.strutStyle),
    );
  }
}

class AndromedaTextWidgetState extends AndromedaWidgetState<AndromedaTextWidget> {}