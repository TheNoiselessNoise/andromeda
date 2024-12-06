import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaAlertDialogProps extends ContextableMapTraversable {
  const AndromedaAlertDialogProps(super.context, super.data);

  List<FWidget> get actions => getList('actions');
  FWidget? get title => get('title');
  FWidget? get icon => get('icon');
}

class AndromedaAlertDialogStyles extends ContextableMapTraversable {
  const AndromedaAlertDialogStyles(super.context, super.data);

  Clip get clipBehavior => clipFromString(get('clipBehavior')) ?? Clip.hardEdge;
  Color? get backgroundColor => themeColorFromString(get('backgroundColor'), context);
  double? get elevation => get('elevation');
  MainAxisAlignment? get actionsAlignment => mainAxisAlignmentFromString(get('actionsAlignment'));
  OverflowBarAlignment? get actionsOverflowAlignment => overflowBarAlignmentFromString(get('actionsOverflowAlignment'));
  double? get actionsOverflowButtonSpacing => get('actionsOverflowButtonSpacing');
  VerticalDirection? get actionsOverflowDirection => verticalDirectionFromString(get('actionsOverflowDirection'));
  AndromedaStyleEdgeInsets get actionsPadding => AndromedaStyleEdgeInsets(getMap('actionsPadding'));
  AlignmentGeometry? get alignment => alignmentGeometryFromString(get('alignment'));
  AndromedaStyleEdgeInsets get buttonPadding => AndromedaStyleEdgeInsets(getMap('buttonPadding'));
  AndromedaStyleEdgeInsets get contentPadding => AndromedaStyleEdgeInsets(getMap('contentPadding'));
  AndromedaStyleTextStyle get contentTextStyle => AndromedaStyleTextStyle(context, getMap('contentTextStyle'));
  Color? get iconColor => themeColorFromString(get('iconColor'), context);
  AndromedaStyleEdgeInsets get iconPadding => AndromedaStyleEdgeInsets(getMap('iconPadding'));
  AndromedaStyleEdgeInsets get insetPadding => AndromedaStyleEdgeInsets(getMap('insetPadding'));
  bool get scrollable => getBool('scrollable', false);
  Color? get shadowColor => themeColorFromString(get('shadowColor'), context);
  Color? get surfaceTintColor => themeColorFromString(get('surfaceTintColor'), context);
  AndromedaStyleEdgeInsets get titlePadding => AndromedaStyleEdgeInsets(getMap('titlePadding'));
  AndromedaStyleTextStyle get titleTextStyle => AndromedaStyleTextStyle(context, getMap('titleTextStyle'));
}

class AndromedaAlertDialogWidget extends AndromedaWidget {
  static const String id = 'AlertDialog';
  
  AndromedaAlertDialogWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaAlertDialogWidgetState createState() => AndromedaAlertDialogWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaAlertDialogProps(ctx.context, ctx.props);
    final style = AndromedaAlertDialogStyles(ctx.context, ctx.styles);

    return AlertDialog(
      clipBehavior: style.clipBehavior,
      backgroundColor: style.backgroundColor,
      elevation: style.elevation,
      actions: prop.actions.map((e) => ctx.render(e)).whereType<Widget>().toList(),
      icon: ctx.render(prop.icon),
      title: ctx.render(prop.title),
      actionsAlignment: style.actionsAlignment,
      actionsOverflowAlignment: style.actionsOverflowAlignment,
      actionsOverflowButtonSpacing: style.actionsOverflowButtonSpacing,
      actionsOverflowDirection: style.actionsOverflowDirection,
      actionsPadding: edgeInsetsGeometryFromStyle(style.actionsPadding),
      alignment: style.alignment,
      buttonPadding: edgeInsetsGeometryFromStyle(style.buttonPadding),
      contentPadding: edgeInsetsGeometryFromStyle(style.contentPadding),
      contentTextStyle: textStyleFromStyle(style.contentTextStyle),
      iconColor: style.iconColor,
      iconPadding: edgeInsetsGeometryFromStyle(style.iconPadding),
      insetPadding: edgeInsetsFromStyle(style.insetPadding),
      scrollable: style.scrollable,
      shadowColor: style.shadowColor,
      surfaceTintColor: style.surfaceTintColor,
      titlePadding: edgeInsetsGeometryFromStyle(style.titlePadding),
      titleTextStyle: textStyleFromStyle(style.titleTextStyle),

      // TODO: shape: ShapeBorder?,

      content: await ctx.firstChildOrNull,
    );
  }
}

class AndromedaAlertDialogWidgetState extends AndromedaWidgetState<AndromedaAlertDialogWidget> {}