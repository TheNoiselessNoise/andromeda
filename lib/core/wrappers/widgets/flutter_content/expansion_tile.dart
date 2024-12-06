import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaExpansionTileProps extends MapTraversable {
  const AndromedaExpansionTileProps(super.data);

  bool get enabled => getBool('enabled', true);
  bool get maintainState => getBool('maintainState', false);
  bool get initiallyExpanded => getBool('initiallyExpanded', false);
  FWidget? get title => get('title');
  FWidget? get leading => get('leading');
  FWidget? get subtitle => get('subtitle');
  FWidget? get trailing => get('trailing');
}

class AndromedaExpansionTileStyles extends ContextableMapTraversable {
  const AndromedaExpansionTileStyles(super.context, super.data);

  bool? get dense => get('dense');
  bool? get enableFeedback => get('enableFeedback');
  bool get showTrailingIcon => getBool('showTrailingIcon', true);

  double? get minTileHeight => get('minTileHeight');

  Color? get iconColor => themeColorFromString(get('iconColor'), context);
  Color? get textColor => themeColorFromString(get('textColor'), context);
  Color? get backgroundColor => themeColorFromString(get('backgroundColor'), context);
  Color? get collapsedIconColor => themeColorFromString(get('collapsedIconColor'), context);
  Color? get collapsedTextColor => themeColorFromString(get('collapsedTextColor'), context);
  Color? get collapsedBackgroundColor => themeColorFromString(get('collapsedBackgroundColor'), context);

  VisualDensity? get visualDensity => visualDensityFromString(get('visualDensity'));

  AndromedaStyleEdgeInsets get tilePadding => AndromedaStyleEdgeInsets(getMap('tilePadding'));
  AndromedaStyleEdgeInsets get childrenPadding => AndromedaStyleEdgeInsets(getMap('childrenPadding'));

  Clip? get clipBehavior => clipFromString(get('clipBehavior'));
  ListTileControlAffinity? get controlAffinity => listTileControlAffinityFromString(get('controlAffinity'));
  Alignment? get expandedAlignment => alignmentFromString(get('expandedAlignment'));
  CrossAxisAlignment? get expandedCrossAxisAlignment => crossAxisAlignmentFromString(get('expandedCrossAxisAlignment'));
}

class AndromedaExpansionTileWidget extends AndromedaWidget {
  static const String id = 'ExpansionTile';

  AndromedaExpansionTileWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaExpansionTileWidgetState createState() => AndromedaExpansionTileWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaExpansionTileProps(ctx.props);
    final style = AndromedaExpansionTileStyles(ctx.context, ctx.styles);

    return ExpansionTile(
      // styles
      dense: style.dense,
      enableFeedback: style.enableFeedback,
      showTrailingIcon: style.showTrailingIcon,
      
      minTileHeight: style.minTileHeight,

      iconColor: style.iconColor,
      textColor: style.textColor,
      backgroundColor: style.backgroundColor,
      collapsedIconColor: style.collapsedIconColor,
      collapsedTextColor: style.collapsedTextColor,
      collapsedBackgroundColor: style.collapsedBackgroundColor,

      visualDensity: style.visualDensity,

      tilePadding: edgeInsetsGeometryFromStyle(style.tilePadding),
      childrenPadding: edgeInsetsGeometryFromStyle(style.childrenPadding),
      
      clipBehavior: style.clipBehavior,
      controlAffinity: style.controlAffinity,
      expandedAlignment: style.expandedAlignment,
      expandedCrossAxisAlignment: style.expandedCrossAxisAlignment,

      // TODO: shape: ShapeBorder?,
      // TODO: collapsedShape: ShapeBorder?,
      // TODO: expansionAnimationStyle: AnimationStyle?,

      // handlers
      onExpansionChanged: ctx.prepareHandler('onExpansionChanged', 1),

      // props
      // TODO: controller: ExpansionPanelController?,
      enabled: prop.enabled,
      maintainState: prop.maintainState,
      initiallyExpanded: prop.initiallyExpanded,
      title: ctx.render(prop.title) ?? const SizedBox.shrink(),
      leading: ctx.render(prop.leading),
      subtitle: ctx.render(prop.subtitle),
      trailing: ctx.render(prop.trailing),
      children: await ctx.children,
    );
  }
}

class AndromedaExpansionTileWidgetState extends AndromedaWidgetState<AndromedaExpansionTileWidget> {}