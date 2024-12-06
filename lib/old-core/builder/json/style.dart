import 'package:andromeda/old-core/core.dart';

class JsonStyleShadow extends MapTraversable {
  const JsonStyleShadow(super.data);

  String get color => getString('color', '#000000');
  JsonStyleOffset get offset => JsonStyleOffset(getMap('offset'));
  double get blurRadius => getDouble('blurRadius', 0);
}

class JsonStyleDuration extends MapTraversable {
  const JsonStyleDuration(super.data);

  dynamic get microseconds => getInt('microseconds', 0);
  dynamic get milliseconds => getInt('milliseconds', 0);
  dynamic get seconds => getInt('seconds', 0);
  dynamic get minutes => getInt('minutes', 0);
  dynamic get hours => getInt('hours', 0);
  dynamic get days => getInt('days', 0);
}

class JsonStylePadding extends MapTraversable {
  const JsonStylePadding(super.data);

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

class JsonStyleOffset extends MapTraversable {
  const JsonStyleOffset(super.data);

  double get x => getDouble('dx', 0);
  double get y => getDouble('dy', 0);

  bool get isNotZero => x > 0 || y > 0;
}

class JsonStyleRect extends MapTraversable {
  const JsonStyleRect(super.data);

  JsonStyleOffset get offset => JsonStyleOffset(getMap('offset'));
  JsonStyleOffset get offset2 => JsonStyleOffset(getMap('offset2'));

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

class JsonStyleEdgeInsets extends JsonStylePadding {
  const JsonStyleEdgeInsets(super.data);

  bool get directional => getBool('directional', false);
  bool get only => getBool('only', false);
  double get start => getDouble('start', 0);
  double get end => getDouble('end', 0);

  bool get hasStartEnd => start > 0 || end > 0;
  bool get hasBottomTop => bottom > 0 || top > 0;
}

class JsonStyleRadius extends MapTraversable {
  const JsonStyleRadius(super.data);

  double get circular => getDouble('circular', 0);
  double get x => getDouble('x', 0);
  double get y => getDouble('y', 0);

  bool get hasCircular => circular > 0;
  bool get hasPos => x > 0 || y > 0;
  
  bool get isValid => hasCircular || hasPos;
}

class JsonStyleBorderRadius extends MapTraversable {
  const JsonStyleBorderRadius(super.data);

  bool get directional => getBool('directional', false);

  // directional == true
  JsonStyleRadius get all => JsonStyleRadius(getMap('all'));
  JsonStyleRadius get topStart => JsonStyleRadius(getMap('topStart'));
  JsonStyleRadius get topEnd => JsonStyleRadius(getMap('topEnd'));
  JsonStyleRadius get bottomStart => JsonStyleRadius(getMap('bottomStart'));
  JsonStyleRadius get bottomEnd => JsonStyleRadius(getMap('bottomEnd'));
  JsonStyleRadius get start => JsonStyleRadius(getMap('start'));
  JsonStyleRadius get end => JsonStyleRadius(getMap('end'));

  // directional == false
  JsonStyleRadius get topLeft => JsonStyleRadius(getMap('topLeft'));
  JsonStyleRadius get topRight => JsonStyleRadius(getMap('topRight'));
  JsonStyleRadius get bottomLeft => JsonStyleRadius(getMap('bottomLeft'));
  JsonStyleRadius get bottomRight => JsonStyleRadius(getMap('bottomRight'));
  JsonStyleRadius get left => JsonStyleRadius(getMap('left'));
  JsonStyleRadius get right => JsonStyleRadius(getMap('right'));

  double get circular => getDouble('circular', 0);

  JsonStyleRadius get top => JsonStyleRadius(getMap('top'));
  JsonStyleRadius get bottom => JsonStyleRadius(getMap('bottom'));

  bool get hasAll => all.isValid;
  bool get isOnly => topStart.isValid || topEnd.isValid || bottomStart.isValid || bottomEnd.isValid;
  bool get isVertical => top.isValid || bottom.isValid;
  bool get isHorizontal => directional ? start.isValid || end.isValid : left.isValid || right.isValid;
  bool get isCircular => circular > 0;
}

class JsonStyleShapeBorder extends MapTraversable {
  const JsonStyleShapeBorder(super.data);

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

class JsonStyleSize extends MapTraversable {
  const JsonStyleSize(super.data);

  double get width => getDouble('width', 0);
  double get height => getDouble('height', 0);
}

class JsonStyleBoxConstraints extends MapTraversable {
  const JsonStyleBoxConstraints(super.data);
  
  double? get width => get('width');
  double? get height => get('height');
  JsonStyleSize get size => JsonStyleSize(getMap('size'));

  bool get finite => getBool('finite', false);
  bool get tight => getBool('tight', false);
  
  bool get hasSize => size.height > 0 || size.width > 0;
  bool get hasDimension => width != null || height != null;
}

class JsonStyleDecoration extends MapTraversable {
  const JsonStyleDecoration(super.data);

  String? get backgroundBlendMode => get('backgroundBlendMode');
  JsonStyleBorderRadius get borderRadius => JsonStyleBorderRadius(getMap('borderRadius'));
  String? get color => get('color');
  String get shape => getString('shape', 'rectangle');
}

class JsonStyleButton extends MapTraversable {
  const JsonStyleButton(super.data);

  String? get backgroundColor => get('backgroundColor', 'primary');
  String? get hoveredBackgroundColor => get('hoveredBackgroundColor');
  String? get disabledBackgroundColor => get('disabledBackgroundColor');
  String? get disabledHoveredBackgroundColor => get('disabledHoveredBackgroundColor');
  String? get foregroundColor => get('foregroundColor');
  String? get hoveredForegroundColor => get('hoveredForegroundColor');
  String? get disabledForegroundColor => get('disabledForegroundColor');
  String? get disabledHoveredForegroundColor => get('disabledHoveredForegroundColor');
  JsonStyleBorderRadius get borderRadius => JsonStyleBorderRadius(getMap('borderRadius'));
  // String? get borderSide => get('borderSide');
  // String? get hoverBorderSide => get('hoverBorderSide');
  String? get splashColor => get('splashColor');
  double? get elevation => get('elevation');
  double? get hoverElevation => get('hoverElevation');
}