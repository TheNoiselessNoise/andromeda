import 'package:andromeda/core/_.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AndromedaGestureDetectorProps extends MapTraversable {
  const AndromedaGestureDetectorProps(super.data);

  HitTestBehavior? get hitTestBehavior => hitTestBehaviorFromString(get('hitTestBehavior'));
  DragStartBehavior get dragStartBehavior => dragStartBehaviorFromString(get('dragStartBehavior')) ?? DragStartBehavior.start;
}

class AndromedaGestureDetectorWidget extends AndromedaWidget {
  static const String id = 'GestureDetector';
  
  AndromedaGestureDetectorWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaGestureDetectorWidgetState createState() => AndromedaGestureDetectorWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaGestureDetectorProps(ctx.props);

    return GestureDetector(
      behavior: prop.hitTestBehavior,
      dragStartBehavior: prop.dragStartBehavior,

      onTap: ctx.prepareHandler('onTap', 0),
      onTapUp: ctx.prepareHandler('onTapUp', 1),
      onTapDown: ctx.prepareHandler('onTapDown', 1),
      onTapCancel: ctx.prepareHandler('onTapCancel', 0),

      onDoubleTap: ctx.prepareHandler('onDoubleTap', 0),
      onDoubleTapDown: ctx.prepareHandler('onDoubleTapDown', 1),
      onDoubleTapCancel: ctx.prepareHandler('onDoubleTapCancel', 0),

      onLongPress: ctx.prepareHandler('onLongPress', 0),
      onLongPressUp: ctx.prepareHandler('onLongPressUp', 0),
      onLongPressEnd: ctx.prepareHandler('onLongPressEnd', 1),
      onLongPressDown: ctx.prepareHandler('onLongPressDown', 1),
      onLongPressStart: ctx.prepareHandler('onLongPressStart', 1),
      onLongPressCancel: ctx.prepareHandler('onLongPressCancel', 0),
      onLongPressMoveUpdate: ctx.prepareHandler('onLongPressMoveUpdate', 1),

      onForcePressEnd: ctx.prepareHandler('onForcePressEnd', 1),
      onForcePressPeak: ctx.prepareHandler('onForcePressPeak', 1),
      onForcePressStart: ctx.prepareHandler('onForcePressStart', 1),
      onForcePressUpdate: ctx.prepareHandler('onForcePressUpdate', 1),

      onHorizontalDragEnd: ctx.prepareHandler('onHorizontalDragEnd', 1),
      onHorizontalDragDown: ctx.prepareHandler('onHorizontalDragDown', 1),
      onHorizontalDragStart: ctx.prepareHandler('onHorizontalDragStart', 1),
      onHorizontalDragCancel: ctx.prepareHandler('onHorizontalDragCancel', 0),
      onHorizontalDragUpdate: ctx.prepareHandler('onHorizontalDragUpdate', 1),

      onPanEnd: ctx.prepareHandler('onPanEnd', 1),
      onPanDown: ctx.prepareHandler('onPanDown', 1),
      onPanStart: ctx.prepareHandler('onPanStart', 1),
      onPanCancel: ctx.prepareHandler('onPanCancel', 0),
      onPanUpdate: ctx.prepareHandler('onPanUpdate', 1),

      onScaleEnd: ctx.prepareHandler('onScaleEnd', 1),
      onScaleStart: ctx.prepareHandler('onScaleStart', 1),
      onScaleUpdate: ctx.prepareHandler('onScaleUpdate', 1),

      onSecondaryLongPress: ctx.prepareHandler('onSecondaryLongPress', 0),
      onSecondaryLongPressUp: ctx.prepareHandler('onSecondaryLongPressUp', 0),
      onSecondaryLongPressEnd: ctx.prepareHandler('onSecondaryLongPressEnd', 1),
      onSecondaryLongPressDown: ctx.prepareHandler('onSecondaryLongPressDown', 1),
      onSecondaryLongPressStart: ctx.prepareHandler('onSecondaryLongPressStart', 1),
      onSecondaryLongPressCancel: ctx.prepareHandler('onSecondaryLongPressCancel', 0),
      onSecondaryLongPressMoveUpdate: ctx.prepareHandler('onSecondaryLongPressMoveUpdate', 1),

      onSecondaryTap: ctx.prepareHandler('onSecondaryTap', 0),
      onSecondaryTapUp: ctx.prepareHandler('onSecondaryTapUp', 1),
      onSecondaryTapDown: ctx.prepareHandler('onSecondaryTapDown', 1),
      onSecondaryTapCancel: ctx.prepareHandler('onSecondaryTapCancel', 0),

      onTertiaryLongPress: ctx.prepareHandler('onTertiaryLongPress', 0),
      onTertiaryLongPressUp: ctx.prepareHandler('onTertiaryLongPressUp', 0),
      onTertiaryLongPressEnd: ctx.prepareHandler('onTertiaryLongPressEnd', 1),
      onTertiaryLongPressDown: ctx.prepareHandler('onTertiaryLongPressDown', 1),
      onTertiaryLongPressStart: ctx.prepareHandler('onTertiaryLongPressStart', 1),
      onTertiaryLongPressCancel: ctx.prepareHandler('onTertiaryLongPressCancel', 0),
      onTertiaryLongPressMoveUpdate: ctx.prepareHandler('onTertiaryLongPressMoveUpdate', 1),

      onTertiaryTapUp: ctx.prepareHandler('onTertiaryTapUp', 1),
      onTertiaryTapDown: ctx.prepareHandler('onTertiaryTapDown', 1),
      onTertiaryTapCancel: ctx.prepareHandler('onTertiaryTapCancel', 0),

      onVerticalDragEnd: ctx.prepareHandler('onVerticalDragEnd', 1),
      onVerticalDragDown: ctx.prepareHandler('onVerticalDragDown', 1),
      onVerticalDragStart: ctx.prepareHandler('onVerticalDragStart', 1),
      onVerticalDragCancel: ctx.prepareHandler('onVerticalDragCancel', 0),
      onVerticalDragUpdate: ctx.prepareHandler('onVerticalDragUpdate', 1),
      
      child: await ctx.firstChildOrNull,
    );
  }
}

class AndromedaGestureDetectorWidgetState extends AndromedaWidgetState<AndromedaGestureDetectorWidget> {}