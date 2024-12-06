import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaListTileProps extends MapTraversable {
  const AndromedaListTileProps(super.data);

  FWidget? get title => get('title');
  FWidget? get leading => get('leading');
  FWidget? get subtitle => get('subtitle');
  FWidget? get trailing => get('trailing');
}

class AndromedaListTileStyles extends ContextableMapTraversable {
  const AndromedaListTileStyles(super.context, super.data);

  bool get autofocus => getBool('autofocus', false);
  bool get enabled => getBool('enabled', true);
  AndromedaStyleEdgeInsets get contentPadding => AndromedaStyleEdgeInsets(getMap('contentPadding'));
  bool? get dense => get('dense');
  bool? get enableFeedback => get('enableFeedback');
  Color? get focusColor => themeColorFromString(get('focusColor'), context);
  double? get horizontalTitleGap => get('horizontalTitleGap');
  Color? get hoverColor => themeColorFromString(get('hoverColor'), context);
  Color? get iconColor => themeColorFromString(get('iconColor'), context);
  bool get isThreeLine => getBool('isThreeLine', false);
  AndromedaStyleTextStyle get leadingAndTrailingTextStyle => AndromedaStyleTextStyle(context, getMap('leadingAndTrailingTextStyle'));
  double? get minLeadingWidth => get('minLeadingWidth');
  double? get minTileHeight => get('minTileHeight');
  double? get minVerticalPadding => get('minVerticalPadding');
  MouseCursor? get mouseCursor => mouseCursorFromString(get('mouseCursor'));
  bool get selected => getBool('selected', false);
  Color? get selectedColor => themeColorFromString(get('selectedColor'), context);
  Color? get selectedTileColor => themeColorFromString(get('selectedTileColor'), context);
  Color? get splashColor => themeColorFromString(get('splashColor'), context);
  AndromedaStyleTextStyle get subtitleTextStyle => AndromedaStyleTextStyle(context, getMap('subtitleTextStyle'));
  Color? get textColor => themeColorFromString(get('textColor'), context);
  Color? get tileColor => themeColorFromString(get('tileColor'), context);
  AndromedaStyleTextStyle get titleTextStyle => AndromedaStyleTextStyle(context, getMap('titleTextStyle'));
  VisualDensity? get visualDensity => visualDensityFromString(get('visualDensity'));
  ListTileStyle? get style => listTileStyleFromString(get('style'));
  ListTileTitleAlignment? get titleAlignment => listTileTitleAlignmentFromString(get('titleAlignment'));
}

class AndromedaListTileWidget extends AndromedaWidget {
  static const String id = 'ListTile';

  AndromedaListTileWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaListTileWidgetState createState() => AndromedaListTileWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaListTileProps(ctx.props);
    final style = AndromedaListTileStyles(ctx.context, ctx.styles);

    return ListTile(
      title: ctx.render(prop.title),
      leading: ctx.render(prop.leading),
      subtitle: ctx.render(prop.subtitle),
      trailing: ctx.render(prop.trailing),
      autofocus: style.autofocus,
      enabled: style.enabled,
      contentPadding: edgeInsetsFromStyle(style.contentPadding),
      dense: style.dense,
      enableFeedback: style.enableFeedback,
      focusColor: style.focusColor,
      horizontalTitleGap: style.horizontalTitleGap,
      hoverColor: style.hoverColor,
      iconColor: style.iconColor,
      isThreeLine: style.isThreeLine,
      leadingAndTrailingTextStyle: textStyleFromStyle(style.leadingAndTrailingTextStyle),
      minLeadingWidth: style.minLeadingWidth,
      minTileHeight: style.minTileHeight,
      minVerticalPadding: style.minVerticalPadding,
      mouseCursor: style.mouseCursor,
      selected: style.selected,
      selectedColor: style.selectedColor,
      selectedTileColor: style.selectedTileColor,
      splashColor: style.splashColor,
      subtitleTextStyle: textStyleFromStyle(style.subtitleTextStyle),
      textColor: style.textColor,
      tileColor: style.tileColor,
      titleTextStyle: textStyleFromStyle(style.titleTextStyle),
      visualDensity: style.visualDensity,
      style: style.style,
      titleAlignment: style.titleAlignment,

      // TODO: focusNode: FocusNode?
      // TODO: shape: ShapeBorder?,

      onFocusChange: ctx.prepareHandler('onFocusChange', 1),
      onLongPress: ctx.prepareHandler('onLongPress', 0),
      onTap: ctx.prepareHandler('onTap', 0),
    );
  }
}

class AndromedaListTileWidgetState extends AndromedaWidgetState<AndromedaListTileWidget> {}