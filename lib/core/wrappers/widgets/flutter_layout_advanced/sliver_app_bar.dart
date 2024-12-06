import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AndromedaSliverAppBarProps extends MapTraversable {
  const AndromedaSliverAppBarProps(super.data);

  List<FWidget> get actions => getList('actions');
  FWidget? get leading => get('leading');
  FWidget? get title => get('title');
  FWidget? get bottom => get('bottom');
  FWidget? get flexibleSpace => get('flexibleSpace');
}

class AndromedaSliverAppBarStyles extends ContextableMapTraversable {
  const AndromedaSliverAppBarStyles(super.context, super.data);

  bool get snap => getBool('snap', false);
  bool get pinned => getBool('pinned', false);
  bool get stretch => getBool('stretch', false);
  bool get primary => getBool('primary', true);
  bool get floating => getBool('floating', false);
  bool? get centerTitle => get('centerTitle');
  bool get forceElevated => getBool('forceElevated', false);
  bool get automaticallyImplyLeading => getBool('automaticallyImplyLeading', true);
  bool get forceMaterialTransparency => getBool('forceMaterialTransparency', false);

  double? get elevation => get('elevation');
  double? get titleSpacing => get('titleSpacing');
  double? get leadingWidth => get('leadingWidth');
  double get toolbarHeight => getDouble('toolbarHeight', 56.0);
  double? get expandedHeight => get('expandedHeight');
  double? get collapsedHeight => get('collapsedHeight');
  double get stretchTriggerOffset => getDouble('stretchTriggerOffset', 100.0);
  double? get scrolledUnderElevation => get('scrolledUnderElevation');
  
  Color? get shadowColor => themeColorFromString(get('shadowColor'), context);
  Color? get backgroundColor => themeColorFromString(get('backgroundColor'), context);
  Color? get foregroundColor => themeColorFromString(get('foregroundColor'), context);
  Color? get surfaceTintColor => themeColorFromString(get('surfaceTintColor'), context);
  
  Clip? get clipBehavior => clipFromString(get('clipBehavior'));
  
  AndromedaStyleIconThemeData get iconTheme => AndromedaStyleIconThemeData(context, getMap('iconTheme'));
  AndromedaStyleIconThemeData get actionsIconTheme => AndromedaStyleIconThemeData(context, getMap('actionsIconTheme'));
  AndromedaStyleTextStyle get titleTextStyle => AndromedaStyleTextStyle(context, getMap('titleTextStyle'));
  AndromedaStyleTextStyle get toolbarTextStyle => AndromedaStyleTextStyle(context, getMap('toolbarTextStyle'));
  SystemUiOverlayStyle? get systemOverlayStyle => systemUiOverlayStyleFromString(get('systemOverlayStyle'));
}

class AndromedaSliverAppBarWidget extends AndromedaWidget {
  static const String id = 'SliverAppBar';

  AndromedaSliverAppBarWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaSliverAppBarWidgetState createState() => AndromedaSliverAppBarWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaSliverAppBarProps(ctx.props);
    final style = AndromedaSliverAppBarStyles(ctx.context, ctx.styles);

    return SliverAppBar(
      // styles
      snap: style.snap,
      pinned: style.pinned,
      stretch: style.stretch,
      primary: style.primary,
      floating: style.floating,
      centerTitle: style.centerTitle,
      forceElevated: style.forceElevated,
      automaticallyImplyLeading: style.automaticallyImplyLeading,
      forceMaterialTransparency: style.forceMaterialTransparency,


      elevation: style.elevation,
      titleSpacing: style.titleSpacing,
      leadingWidth: style.leadingWidth,
      toolbarHeight: style.toolbarHeight,
      expandedHeight: style.expandedHeight,
      collapsedHeight: style.collapsedHeight,
      stretchTriggerOffset: style.stretchTriggerOffset,
      scrolledUnderElevation: style.scrolledUnderElevation,

      shadowColor: style.shadowColor,
      backgroundColor: style.backgroundColor,
      foregroundColor: style.foregroundColor,
      surfaceTintColor: style.surfaceTintColor,

      clipBehavior: style.clipBehavior,
      
      iconTheme: iconThemeDataFromStyle(style.iconTheme),
      actionsIconTheme: iconThemeDataFromStyle(style.actionsIconTheme),
      titleTextStyle: textStyleFromStyle(style.titleTextStyle),
      toolbarTextStyle: textStyleFromStyle(style.toolbarTextStyle),
      systemOverlayStyle: style.systemOverlayStyle,

      // TODO: shape: ShapeBorder?,

      // handlers
      onStretchTrigger: ctx.prepareHandler('onStretchTrigger', 0),

      // props
      bottom: ctx.renderPreferredSize(prop.bottom),
      leading: ctx.render(prop.leading),
      title: ctx.render(prop.title),
      flexibleSpace: ctx.render(prop.flexibleSpace),
      actions: prop.actions.map((e) => ctx.render(e)).whereType<Widget>().toList(),
    );
  }
}

class AndromedaSliverAppBarWidgetState extends AndromedaWidgetState<AndromedaSliverAppBarWidget> {}