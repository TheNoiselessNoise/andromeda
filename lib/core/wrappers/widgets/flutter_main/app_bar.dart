import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AndromedaAppBarProps extends MapTraversable {
  const AndromedaAppBarProps(super.data);

  List<FWidget> get actions => getList('actions');
  FWidget? get leading => get('leading');
  FWidget? get title => get('title');
  FWidget? get bottom => get('bottom');
  FWidget? get flexibleSpace => get('flexibleSpace');
}

class AndromedaAppBarStyles extends ContextableMapTraversable {
  const AndromedaAppBarStyles(super.context, super.data);

  bool get primary => getBool('primary', true);
  bool? get centerTitle => get('centerTitle');
  bool get automaticallyImplyLeading => getBool('automaticallyImplyLeading', true);
  bool get forceMaterialTransparency => getBool('forceMaterialTransparency', false);

  double? get elevation => get('elevation');
  double? get titleSpacing => get('titleSpacing');
  double? get leadingWidth => get('leadingWidth');
  double? get toolbarHeight => get('toolbarHeight');
  double get bottomOpacity => getDouble('bottomOpacity', 1.0);
  double get toolbarOpacity => getDouble('toolbarOpacity', 1.0);
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

class AndromedaAppBarWidget extends AndromedaWidget {
  static const String id = 'AppBar';

  AndromedaAppBarWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaAppBarWidgetState createState() => AndromedaAppBarWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaAppBarProps(ctx.props);
    final style = AndromedaAppBarStyles(ctx.context, ctx.styles);

    return AppBar(
      // styles
      primary: style.primary,
      centerTitle: style.centerTitle,
      automaticallyImplyLeading: style.automaticallyImplyLeading,
      forceMaterialTransparency: style.forceMaterialTransparency,

      elevation: style.elevation,
      titleSpacing: style.titleSpacing,
      leadingWidth: style.leadingWidth,
      toolbarHeight: style.toolbarHeight,
      bottomOpacity: style.bottomOpacity,
      toolbarOpacity: style.toolbarOpacity,
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
      // TODO: shape: ShapeBorder?

      // handlers
      notificationPredicate: ctx.prepareHandler('notificationPredicate', 1) ?? defaultScrollNotificationPredicate,

      // props
      bottom: ctx.renderPreferredSize(prop.bottom),
      leading: ctx.render(prop.leading),
      title: ctx.render(prop.title),
      flexibleSpace: ctx.render(prop.flexibleSpace),
      actions: prop.actions.map((e) => ctx.render(e)).whereType<Widget>().toList(),
    );
  }
}

class AndromedaAppBarWidgetState extends AndromedaWidgetState<AndromedaAppBarWidget> {}