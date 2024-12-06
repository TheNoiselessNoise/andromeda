import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaDropdownButtonProps extends ContextableMapTraversable {
  const AndromedaDropdownButtonProps(super.context, super.data);

  dynamic get value => get('value');
  FWidget? get icon => get('icon');
  FWidget? get hint => get('hint');
  FWidget? get underline => get('underline');
  FWidget? get disabledHint => get('disabledHint');
  dynamic get selectedItemBuilder => get('selectedItemBuilder');
}

class AndromedaDropdownButtonStyles extends ContextableMapTraversable {
  const AndromedaDropdownButtonStyles(super.context, super.data);

  bool get autofocus => get('autofocus') ?? false;
  bool? get enableFeedback => get('enableFeedback');
  bool get isDense => getBool('isDense', false);
  bool get isExpanded => getBool('isExpanded', false);

  int get elevation => getInt('elevation', 8);
  double get iconSize => getDouble('iconSize', 24.0);
  double get itemHeight => getDouble('itemHeight', 48.0);
  double? get menuMaxHeight => get('menuMaxHeight');
  double? get menuWidth => get('menuWidth');

  Color? get focusColor => themeColorFromString(get('focusColor'), context);
  Color? get dropdownColor => themeColorFromString(get('dropdownColor'), context);
  Color? get iconDisabledColor => themeColorFromString(get('iconDisabledColor'), context);
  Color? get iconEnabledColor => themeColorFromString(get('iconEnabledColor'), context);

  AndromedaStyleTextStyle get style => AndromedaStyleTextStyle(context, getMap('style'));
  AndromedaStyleEdgeInsets get padding => AndromedaStyleEdgeInsets(getMap('padding'));
  AlignmentGeometry get alignment => alignmentGeometryFromString(get('alignment')) ?? AlignmentDirectional.centerStart;
  AndromedaStyleBorderRadius get borderRadius => AndromedaStyleBorderRadius(getMap('borderRadius'));
}

class AndromedaDropdownButtonWidget extends AndromedaWidget {
  static const String id = 'DropdownButton';
  AndromedaDropdownButtonWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaDropdownButtonWidgetState createState() => AndromedaDropdownButtonWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaDropdownButtonProps(ctx.context, ctx.props);
    final style = AndromedaDropdownButtonStyles(ctx.context, ctx.styles);

    // fuck type safety - no DropdownButton<TYPE>

    return DropdownButton(
      // styles
      autofocus: style.autofocus,
      enableFeedback: style.enableFeedback,
      isDense: style.isDense,
      isExpanded: style.isExpanded,
      
      elevation: style.elevation,
      iconSize: style.iconSize,
      itemHeight: style.itemHeight,
      menuMaxHeight: style.menuMaxHeight,
      menuWidth: style.menuWidth,
      
      focusColor: style.focusColor,
      dropdownColor: style.dropdownColor,
      iconDisabledColor: style.iconDisabledColor,
      iconEnabledColor: style.iconEnabledColor,

      style: textStyleFromStyle(style.style),
      padding: edgeInsetsGeometryFromStyle(style.padding),
      alignment: style.alignment,
      borderRadius: borderRadiusFromStyle(style.borderRadius),

      // handlers
      onTap: ctx.prepareHandler('onTap', 0),
      onChanged: ctx.prepareHandler('onChanged', 1),

      // props
      // TODO: focusNode: FocusNode?,
      value: prop.value,
      icon: ctx.render(prop.icon),
      hint: ctx.render(prop.hint),
      underline: ctx.render(prop.underline),
      disabledHint: ctx.render(prop.disabledHint),
      selectedItemBuilder: ctx.prepareCustomHandler(prop.selectedItemBuilder, 1),
      items: (await Future.wait((await ctx.children).map((e) => e.realWidget(ctx)))).whereType<DropdownMenuItem>().toList(),
    );
  }
}

class AndromedaDropdownButtonWidgetState extends AndromedaWidgetState<AndromedaDropdownButtonWidget> {}