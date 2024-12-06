import 'package:andromeda/core/_.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AndromedaSwitchListTileProps extends MapTraversable {
  const AndromedaSwitchListTileProps(super.data);

  bool get value => getBool('value', false);
  FWidget? get title => get('title');
  FWidget? get subtitle => get('subtitle');
  FWidget? get secondary => get('secondary');
}

class AndromedaSwitchListTileStyles extends ContextableMapTraversable {
  const AndromedaSwitchListTileStyles(super.context, super.data);

  bool? get dense => get('dense');
  bool get selected => getBool('selected', false);
  bool get autofocus => getBool('autofocus', false);
  bool get isThreeLine => getBool('isThreeLine', false);
  bool? get enableFeedback => get('enableFeedback');

  double? get splashRadius => get('splashRadius');

  Color? get tileColor => themeColorFromString(get('tileColor'), context);
  Color? get hoverColor => themeColorFromString(get('hoverColor'), context);
  Color? get activeColor => themeColorFromString(get('activeColor'), context);
  Color? get activeTrackColor => themeColorFromString(get('activeTrackColor'), context);
  Color? get selectedTileColor => themeColorFromString(get('selectedTileColor'), context);
  Color? get inactiveThumbColor => themeColorFromString(get('inactiveThumbColor'), context);
  Color? get inactiveTrackColor => themeColorFromString(get('inactiveTrackColor'), context);

  MouseCursor? get mouseCursor => mouseCursorFromString(get('mouseCursor'));
  VisualDensity? get visualDensity => visualDensityFromString(get('visualDensity'));
  AndromedaStyleEdgeInsets get contentPadding => AndromedaStyleEdgeInsets(getMap('contentPadding'));
  ListTileControlAffinity get controlAffinity => listTileControlAffinityFromString(get('controlAffinity')) ?? ListTileControlAffinity.platform;
  DragStartBehavior get dragStartBehavior => dragStartBehaviorFromString(get('dragStartBehavior')) ?? DragStartBehavior.start;
  MaterialTapTargetSize? get materialTapTargetSize => materialTapTargetSizeFromString(get('materialTapTargetSize'));
}

class AndromedaSwitchListTileWidget extends AndromedaWidget {
  static const String id = 'SwitchListTile';

  AndromedaSwitchListTileWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaSwitchListTileWidgetState createState() => AndromedaSwitchListTileWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaSwitchListTileProps(ctx.props);
    final style = AndromedaSwitchListTileStyles(ctx.context, ctx.styles);

    return SwitchListTile(
      title: ctx.render(prop.title),
      subtitle: ctx.render(prop.subtitle),
      secondary: ctx.render(prop.secondary),
      
      dense: style.dense,
      selected: style.selected,
      autofocus: style.autofocus,
      isThreeLine: style.isThreeLine,
      enableFeedback: style.enableFeedback,
      
      splashRadius: style.splashRadius,
      
      tileColor: style.tileColor,
      hoverColor: style.hoverColor,
      activeColor: style.activeColor,
      activeTrackColor: style.activeTrackColor,
      selectedTileColor: style.selectedTileColor,
      inactiveThumbColor: style.inactiveThumbColor,
      inactiveTrackColor: style.inactiveTrackColor,
      
      mouseCursor: style.mouseCursor,
      visualDensity: style.visualDensity,
      contentPadding: edgeInsetsFromStyle(style.contentPadding),
      controlAffinity: style.controlAffinity,
      dragStartBehavior: style.dragStartBehavior,
      materialTapTargetSize: style.materialTapTargetSize,

      // TODO: focusNode: FocusNode?
      // TODO: shape: ShapeBorder?,
      // TODO: activeThumbImage: ImageProvider<Object>?,
      // TODO: inactiveThumbImage: ImageProvider<Object>?,
      // TODO: overlayColor: WidgetStateProperty<Color?>?,
      // TODO: thumbColor: WidgetStateProperty<Color?>?,
      // TODO: thumbIcon: WidgetStateProperty<Icon?>?,
      // TODO: trackColor: WidgetStateProperty<Color?>?,
      // TODO: trackOutlineColor: WidgetStateProperty<Color?>?,      

      onFocusChange: ctx.prepareHandler('onFocusChange', 1),
      onChanged: ctx.prepareHandler('onChanged', 1),
      onActiveThumbImageError: ctx.prepareHandler('onActiveThumbImageError', 2),
      onInactiveThumbImageError: ctx.prepareHandler('onInactiveThumbImageError', 2),

      value: prop.value,
    );
  }
}

class AndromedaSwitchListTileWidgetState extends AndromedaWidgetState<AndromedaSwitchListTileWidget> {}