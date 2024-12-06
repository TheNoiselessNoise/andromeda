import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaBottomNavigationBarProps extends ContextableMapTraversable {
  const AndromedaBottomNavigationBarProps(super.context, super.data);

  int get currentIndex => get('currentIndex', 0);
}

class AndromedaBottomNavigationBarStyles extends ContextableMapTraversable {
  const AndromedaBottomNavigationBarStyles(super.context, super.data);

  bool? get enableFeedback => get('enableFeedback');
  bool? get showSelectedLabels => get('showSelectedLabels');
  bool? get showUnselectedLabels => get('showUnselectedLabels');
  bool get useLegacyColorScheme => getBool('useLegacyColorScheme', true);

  double? get elevation => get('elevation', 8.0);

  double get iconSize => getDouble('iconSize', 24.0);
  double get selectedFontSize => getDouble('selectedFontSize', 14.0);
  double get unselectedFontSize => getDouble('unselectedFontSize', 12.0);

  Color? get fixedColor => themeColorFromString(get('fixedColor'), context);
  Color? get backgroundColor => themeColorFromString(get('backgroundColor'), context);
  Color? get selectedItemColor => themeColorFromString(get('selectedItemColor'), context);
  Color? get unselectedItemColor => themeColorFromString(get('unselectedItemColor'), context);

  AndromedaStyleTextStyle get selectedLabelStyle => AndromedaStyleTextStyle(context, getMap('selectedLabelStyle'));
  AndromedaStyleTextStyle get unselectedLabelStyle => AndromedaStyleTextStyle(context, getMap('unselectedLabelStyle'));

  MouseCursor? get mouseCursor => mouseCursorFromString(get('mouseCursor'));
  BottomNavigationBarType? get type => bottomNavigationBarTypeFromString(get('type'));
  BottomNavigationBarLandscapeLayout? get landscapeLayout => bottomNavigationBarLandscapeLayoutFromString(get('landscapeLayout'));
}

class AndromedaBottomNavigationBarWidget extends AndromedaWidget {
  static const String id = 'BottomNavigationBar';
  
  AndromedaBottomNavigationBarWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaBottomNavigationBarWidgetState createState() => AndromedaBottomNavigationBarWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaBottomNavigationBarProps(ctx.context, ctx.props);
    final style = AndromedaBottomNavigationBarStyles(ctx.context, ctx.styles);

    return BottomNavigationBar(
      // styles
      enableFeedback: style.enableFeedback,
      showSelectedLabels: style.showSelectedLabels,
      showUnselectedLabels: style.showUnselectedLabels,
      useLegacyColorScheme: style.useLegacyColorScheme,
      
      elevation: style.elevation,

      iconSize: style.iconSize,
      selectedFontSize: style.selectedFontSize,
      unselectedFontSize: style.unselectedFontSize,

      fixedColor: style.fixedColor,
      backgroundColor: style.backgroundColor,
      selectedItemColor: style.selectedItemColor,
      unselectedItemColor: style.unselectedItemColor,
      
      selectedLabelStyle: textStyleFromStyle(style.selectedLabelStyle),
      unselectedLabelStyle: textStyleFromStyle(style.unselectedLabelStyle),
      
      mouseCursor: style.mouseCursor,
      type: style.type,
      landscapeLayout: style.landscapeLayout,
      
      // TODO: selectedIconTheme: IconThemeData?,
      // TODO: unselectedIconTheme: IconThemeData?,

      // handlers
      onTap: ctx.prepareHandler('onTap', 1),

      // props
      currentIndex: prop.currentIndex,
      items: (await Future.wait((await ctx.children).map((item) => item.realWidget(ctx)))).whereType<BottomNavigationBarItem>().toList(),
    );
  }
}

class AndromedaBottomNavigationBarWidgetState extends AndromedaWidgetState<AndromedaBottomNavigationBarWidget> {}