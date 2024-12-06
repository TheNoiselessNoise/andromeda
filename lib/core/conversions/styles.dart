import 'package:flutter/material.dart';
import 'package:andromeda/core/base/map.dart';
import 'from_string.dart';

class AndromedaStyleTextStyle extends ContextableMapTraversable {
  const AndromedaStyleTextStyle(super.context, super.data);

  FontWeight? get fontWeight => fontWeightFromString(get('fontWeight'));
  FontStyle? get fontStyle => fontStyleFromString(get('fontStyle'));
  String? get fontFamily => get('fontFamily');
  double? get fontSize => get('fontSize');
  Color? get color => themeColorFromString(get('color'), context);
  Color? get backgroundColor => themeColorFromString(get('backgroundColor'), context);
  TextDecoration? get decoration => textDecorationFromString(get('decoration'));
  TextDecorationStyle? get decorationStyle => textDecorationStyleFromString(get('decorationStyle'));
  Color? get decorationColor => themeColorFromString(get('decorationColor'), context);
  double? get height => get('height');
  double? get decorationThickness => get('decorationThickness');
  TextLeadingDistribution? get leadingDistribution => textLeadingDistributionFromString(get('leadingDistribution'));
  double? get letterSpacing => get('letterSpacing');
  TextOverflow? get overflow => textOverflowFromString(get('overflow'));
  double? get wordSpacing => get('wordSpacing');
  TextBaseline? get textBaseline => textBaselineFromString(get('textBaseline'));
}

class AndromedaStyleIconThemeData extends ContextableMapTraversable {
  const AndromedaStyleIconThemeData(super.context, super.data);

  bool? get applyTextScaling => get('applyTextScaling');
  Color? get color => themeColorFromString(get('color'), context);
  double? get fill => get('fill');
  double? get grade => get('grade');
  double? get opacity => get('opacity');
  double? get opticalSize => get('opticalSize');
  List<AndromedaStyleShadow> get shadows => getList('shadows')
    .map((e) => AndromedaStyleShadow(context, e)).toList();
  double? get size => get('size');
  double? get weight => get('weight');
}

class AndromedaStyleShadow extends ContextableMapTraversable {
  const AndromedaStyleShadow(super.context, super.data);

  Color? get color => themeColorFromString(get('color'), context);
  AndromedaStyleOffset get offset => AndromedaStyleOffset(getMap('offset'));
  double get blurRadius => getDouble('blurRadius', 0);
}

class AndromedaStyleDuration extends MapTraversable {
  const AndromedaStyleDuration(super.data);

  dynamic get microseconds => getInt('microseconds', 0);
  dynamic get milliseconds => getInt('milliseconds', 0);
  dynamic get seconds => getInt('seconds', 0);
  dynamic get minutes => getInt('minutes', 0);
  dynamic get hours => getInt('hours', 0);
  dynamic get days => getInt('days', 0);
}

class AndromedaStylePadding extends MapTraversable {
  const AndromedaStylePadding(super.data);

  double get top => getDouble('top', 0);
  double get right => getDouble('right', 0);
  double get bottom => getDouble('bottom', 0);
  double get left => getDouble('left', 0);
  bool get hasLTRB => top > 0 || right > 0 || bottom > 0 || left > 0;

  double get all => getDouble('all', 0);
  bool get hasAll => all > 0;

  double get vertical => getDouble('vertical', 0);
  double get horizontal => getDouble('horizontal', 0);
  bool get hasVerticalHorizontal => vertical > 0 || horizontal > 0;
}

class AndromedaStyleOffset extends MapTraversable {
  const AndromedaStyleOffset(super.data);

  double get x => getDouble('dx', 0);
  double get y => getDouble('dy', 0);

  bool get isNotZero => x > 0 || y > 0;
}

class AndromedaStyleRect extends MapTraversable {
  const AndromedaStyleRect(super.data);

  AndromedaStyleOffset get offset => AndromedaStyleOffset(getMap('offset'));
  AndromedaStyleOffset get offset2 => AndromedaStyleOffset(getMap('offset2'));

  double get width => getDouble('width', 0);
  double get height => getDouble('height', 0);
  
  double get radius => getDouble('radius', 0);

  double get left => getDouble('left', 0);
  double get top => getDouble('top', 0);
  double get right => getDouble('right', 0);
  double get bottom => getDouble('bottom', 0);

  bool get hasCenter => offset.isNotZero && width > 0 && height > 0;
  bool get hasCircle => offset.isNotZero && radius > 0;
  bool get hasLTRB => left > 0 || top > 0 || right > 0 || bottom > 0;
  bool get hasLTWH => left > 0 || top > 0 || width > 0 || height > 0;
}

class AndromedaStyleTextHeightBehavior extends MapTraversable {
  const AndromedaStyleTextHeightBehavior(super.data);

  bool get applyHeightToFirstAscent => getBool('applyHeightToFirstAscent', true);
  bool get applyHeightToLastDescent => getBool('applyHeightToLastDescent', true);
  String get leadingDistribution => getString('leadingDistribution', 'proportional');
}

class AndromedaStyleEdgeInsets extends AndromedaStylePadding {
  const AndromedaStyleEdgeInsets(super.data);

  bool get directional => getBool('directional', false);
  bool get only => getBool('only', false);
  double get start => getDouble('start', 0);
  double get end => getDouble('end', 0);

  bool get hasStartEnd => start > 0 || end > 0;
  bool get hasBottomTop => bottom > 0 || top > 0;
}

class AndromedaStyleSliverGridDelegate extends MapTraversable {
  const AndromedaStyleSliverGridDelegate(super.data);

  int? get crossAxisCount => get('crossAxisCount');
  double? get maxCrossAxisExtent => get('maxCrossAxisExtent');

  double get mainAxisSpacing => getDouble('mainAxisSpacing', 0);
  double get crossAxisSpacing => getDouble('crossAxisSpacing', 0);
  double get childAspectRatio => getDouble('childAspectRatio', 0);
  double? get mainAxisExtent => get('mainAxisExtent');

  bool get hasCrossAxisCount => crossAxisCount != null;
  bool get hasMaxCrossAxisExtent => maxCrossAxisExtent != null;
}

class AndromedaStyleRadius extends MapTraversable {
  const AndromedaStyleRadius(super.data);

  double get circular => getDouble('circular', 0);
  double get x => getDouble('x', 0);
  double get y => getDouble('y', 0);

  bool get hasCircular => circular > 0;
  bool get hasPos => x > 0 || y > 0;
  
  bool get isValid => hasCircular || hasPos;
}

class AndromedaStyleBorderRadius extends MapTraversable {
  const AndromedaStyleBorderRadius(super.data);

  bool get directional => getBool('directional', false);

  // directional == true
  AndromedaStyleRadius get all => AndromedaStyleRadius(getMap('all'));
  AndromedaStyleRadius get topStart => AndromedaStyleRadius(getMap('topStart'));
  AndromedaStyleRadius get topEnd => AndromedaStyleRadius(getMap('topEnd'));
  AndromedaStyleRadius get bottomStart => AndromedaStyleRadius(getMap('bottomStart'));
  AndromedaStyleRadius get bottomEnd => AndromedaStyleRadius(getMap('bottomEnd'));
  AndromedaStyleRadius get start => AndromedaStyleRadius(getMap('start'));
  AndromedaStyleRadius get end => AndromedaStyleRadius(getMap('end'));

  // directional == false
  AndromedaStyleRadius get topLeft => AndromedaStyleRadius(getMap('topLeft'));
  AndromedaStyleRadius get topRight => AndromedaStyleRadius(getMap('topRight'));
  AndromedaStyleRadius get bottomLeft => AndromedaStyleRadius(getMap('bottomLeft'));
  AndromedaStyleRadius get bottomRight => AndromedaStyleRadius(getMap('bottomRight'));
  AndromedaStyleRadius get left => AndromedaStyleRadius(getMap('left'));
  AndromedaStyleRadius get right => AndromedaStyleRadius(getMap('right'));

  double get circular => getDouble('circular', 0);

  AndromedaStyleRadius get top => AndromedaStyleRadius(getMap('top'));
  AndromedaStyleRadius get bottom => AndromedaStyleRadius(getMap('bottom'));

  bool get hasAll => all.isValid;
  bool get isOnly => topStart.isValid || topEnd.isValid || bottomStart.isValid || bottomEnd.isValid;
  bool get isVertical => top.isValid || bottom.isValid;
  bool get isHorizontal => directional ? start.isValid || end.isValid : left.isValid || right.isValid;
  bool get isCircular => circular > 0;
}

class AndromedaStyleStrutStyle extends MapTraversable {
  const AndromedaStyleStrutStyle(super.data);

  String? get fontFamily => get('fontFamily');
  List<String>? get fontFamilyFallback => get('fontFamilyFallback');
  double? get fontSize => get('fontSize');
  double? get height => get('height');
  double? get leading => get('leading');
  String? get fontWeight => get('fontWeight');
  String? get fontStyle => get('fontStyle');
  bool? get forceStrutHeight => get('forceStrutHeight');
  String? get leadingDistribution => get('leadingDistribution');
}

class AndromedaStyleShapeBorder extends MapTraversable {
  const AndromedaStyleShapeBorder(super.data);

  // TODO: this
  /*
    BeveledRectangleBorder
    Border.fromBorderSide(side)
    Border.symmetric()
    BorderDirectional
    CircleBorder
    ContinuousRectangleBorder
    LinearBorder
    OutlineInputBorder
    OvalBorder
    RoundedRectangleBorder
    StadiumBorder
    StarBorder
    StarBorder.polygon
    UnderlineInputBorder
  */
}

class AndromedaStyleBoxConstraints extends MapTraversable {
  const AndromedaStyleBoxConstraints(super.data);
  
  double? get width => get('width');
  double? get height => get('height');
  dynamic get size => get('size');

  bool get finite => getBool('finite', false);
  bool get tight => getBool('tight', false);
  
  bool get hasSize => size != null;
  bool get hasDimension => width != null || height != null;
}

class AndromedaStyleDecoration extends MapTraversable {
  const AndromedaStyleDecoration(super.data);

  String? get backgroundBlendMode => get('backgroundBlendMode');
  AndromedaStyleBorderRadius get borderRadius => AndromedaStyleBorderRadius(getMap('borderRadius'));
  String? get color => get('color');
  String get shape => getString('shape', 'rectangle');
}

class AndromedaStyleButtonStyle extends ContextableMapTraversable {
  const AndromedaStyleButtonStyle(super.context, super.data);

  String? get backgroundColor => get('backgroundColor');
  String? get hoveredBackgroundColor => get('hoveredBackgroundColor');
  String? get disabledBackgroundColor => get('disabledBackgroundColor');
  String? get disabledHoveredBackgroundColor => get('disabledHoveredBackgroundColor');
  String? get foregroundColor => get('foregroundColor');
  String? get hoveredForegroundColor => get('hoveredForegroundColor');
  String? get disabledForegroundColor => get('disabledForegroundColor');
  String? get disabledHoveredForegroundColor => get('disabledHoveredForegroundColor');
  String? get overlayColor => get('overlayColor');
  String? get hoveredOverlayColor => get('hoveredOverlayColor');
  String? get disabledOverlayColor => get('disabledOverlayColor');
  String? get disabledHoveredOverlayColor => get('disabledHoveredOverlayColor');
  String? get shadowColor => get('shadowColor');
  String? get hoveredShadowColor => get('hoveredShadowColor');
  String? get disabledShadowColor => get('disabledShadowColor');
  String? get disabledHoveredShadowColor => get('disabledHoveredShadowColor');
  // String? get borderSide => get('borderSide');
  // String? get hoverBorderSide => get('hoverBorderSide');
  String? get splashColor => get('splashColor');
  double? get elevation => get('elevation');
  double? get hoveredElevation => get('hoveredElevation');
  double? get disabledElevation => get('disabledElevation');
  double? get disabledHoveredElevation => get('disabledHoveredElevation');
  double? get hoverElevation => get('hoverElevation');
}