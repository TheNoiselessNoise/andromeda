import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaBottomSheetProps extends ContextableMapTraversable {
  const AndromedaBottomSheetProps(super.context, super.data);

  dynamic get builder => get('builder');
}

class AndromedaBottomSheetStyles extends ContextableMapTraversable {
  const AndromedaBottomSheetStyles(super.context, super.data);

  bool get enableDrag => get('enableDrag', true);
  bool? get showDragHandle => get('showDragHandle');

  double? get elevation => get('elevation', 8.0);

  Color? get shadowColor => themeColorFromString(get('shadowColor'), context);
  Color? get dragHandleColor => themeColorFromString(get('dragHandleColor'), context);
  Color? get backgroundColor => themeColorFromString(get('backgroundColor'), context);

  Clip? get clipBehavior => clipFromString(get('clipBehavior'));
  Size? get dragHandleSize => sizeFromValue(get('dragHandleSize'));
  AndromedaStyleBoxConstraints get constraints => AndromedaStyleBoxConstraints(getMap('constraints'));
}

class AndromedaBottomSheetWidget extends AndromedaWidget {
  static const String id = 'BottomSheet';
  
  AndromedaBottomSheetWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaBottomSheetWidgetState createState() => AndromedaBottomSheetWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaBottomSheetProps(ctx.context, ctx.props);
    final style = AndromedaBottomSheetStyles(ctx.context, ctx.styles);

    return BottomSheet(
      // styles
      enableDrag: style.enableDrag,
      showDragHandle: style.showDragHandle,

      elevation: style.elevation,
      
      shadowColor: style.shadowColor,
      dragHandleColor: style.dragHandleColor,
      backgroundColor: style.backgroundColor,
      
      clipBehavior: style.clipBehavior,
      dragHandleSize: style.dragHandleSize,
      constraints: boxConstraintsFromStyle(style.constraints),

      // TODO: animationController: AnimationController?,
      // TODO: shape: ShapeBorder?,
      
      // handlers
      onClosing: ctx.prepareHandler('onClosing', 0),
      onDragEnd: ctx.prepareHandler('onDragEnd', 2),
      onDragStart: ctx.prepareHandler('onDragStart', 1),

      // props
      builder: ctx.prepareCustomHandler(prop.builder, 1),
    );
  }
}

class AndromedaBottomSheetWidgetState extends AndromedaWidgetState<AndromedaBottomSheetWidget> {}