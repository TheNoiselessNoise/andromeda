import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaChipProps extends ContextableMapTraversable {
  const AndromedaChipProps(super.context, super.data);

  FWidget? get label => get('label');
  FWidget? get avatar => get('avatar');
  FWidget? get deleteIcon => get('deleteIcon');
  String? get deleteButtonTooltipMessage => get('deleteButtonTooltipMessage');
}

class AndromedaChipStyles extends ContextableMapTraversable {
  const AndromedaChipStyles(super.context, super.data);

  bool get autofocus => getBool('autofocus', false);

  double? get elevation => get('elevation');

  Color? get shadowColor => themeColorFromString(get('shadowColor'), context);
  Color? get backgroundColor => themeColorFromString(get('backgroundColor'), context);
  Color? get deleteIconColor => themeColorFromString(get('deleteIconColor'), context);
  Color? get surfaceTintColor => themeColorFromString(get('surfaceTintColor'), context);

  AndromedaStyleBoxConstraints get avatarBoxConstraints => AndromedaStyleBoxConstraints(getMap('avatarBoxConstraints'));
  AndromedaStyleBoxConstraints get deleteIconBoxConstraints => AndromedaStyleBoxConstraints(getMap('deleteIconBoxConstraints'));

  AndromedaStyleEdgeInsets get padding => AndromedaStyleEdgeInsets(getMap('padding'));
  AndromedaStyleEdgeInsets get labelPadding => AndromedaStyleEdgeInsets(getMap('labelPadding'));

  AndromedaStyleTextStyle get labelStyle => AndromedaStyleTextStyle(context, getMap('labelStyle'));
  Clip get clipBehavior => clipFromString(get('clipBehavior')) ?? Clip.antiAlias;
  VisualDensity? get visualDensity => visualDensityFromString(get('visualDensity'));
  MaterialTapTargetSize? get materialTapTargetSize => materialTapTargetSizeFromString(get('materialTapTargetSize'));
}

class AndromedaChipWidget extends AndromedaWidget {
  static const String id = 'Chip';

  AndromedaChipWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaChipWidgetState createState() => AndromedaChipWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaChipProps(ctx.context, ctx.props);
    final style = AndromedaChipStyles(ctx.context, ctx.styles);

    return Chip(
      // styles
      autofocus: style.autofocus,

      elevation: style.elevation,

      shadowColor: style.shadowColor,
      backgroundColor: style.backgroundColor,
      deleteIconColor: style.deleteIconColor,
      surfaceTintColor: style.surfaceTintColor,

      avatarBoxConstraints: boxConstraintsFromStyle(style.avatarBoxConstraints),
      deleteIconBoxConstraints: boxConstraintsFromStyle(style.deleteIconBoxConstraints),

      padding: edgeInsetsGeometryFromStyle(style.padding),
      labelPadding: edgeInsetsGeometryFromStyle(style.labelPadding),

      labelStyle: textStyleFromStyle(style.labelStyle),
      clipBehavior: style.clipBehavior,
      visualDensity: style.visualDensity,
      materialTapTargetSize: style.materialTapTargetSize,

      // TODO: side: BorderSide?,
      // TODO: shape: OutlinedBorder?,
      // TODO: iconTheme: IconThemeData?,
      // TODO: color: WidgetStateProperty<Color?>?,
      // TODO: chipAnimationStyle: ChipAnimationStyle?,

      // handlers
      onDeleted: ctx.prepareHandler('onDeleted', 0),

      // props
      // TODO: focusNode: FocusNode?,
      deleteButtonTooltipMessage: prop.deleteButtonTooltipMessage,
      label: ctx.renderRequired(prop.label),
      avatar: ctx.render(prop.avatar),
      deleteIcon: ctx.render(prop.deleteIcon),
    );
  }
}

class AndromedaChipWidgetState extends AndromedaWidgetState<AndromedaChipWidget> {}