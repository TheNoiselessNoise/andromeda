import 'package:camera/camera.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

Color? colorFromString(String? color) {
  if (color == null) {
    return null;
  }

  if (color.startsWith('#')) {
    return colorFromHex(color);
  }

  return colorFromName(color) ?? colorFromStatus(color);
}

Color? colorFromHex(String? hex) {
  if (hex == null) {
    return null;
  }

  if (hex.startsWith("#")) {
    return colorFromHex(hex.substring(1));
  }

  if (hex.length < 6 || hex.length > 8) {
    return Colors.black;
  }

  for (int i = 0; i < hex.length; i++) {
    if (!'0123456789ABCDEF'.contains(hex[i].toUpperCase())) {
      return Colors.black;
    }
  }

  if (hex.length == 6) {
    return Color(int.parse(hex, radix: 16) + 0xFF000000);
  }

  return Color(int.parse(hex, radix: 16));
}

Color? colorFromName(String? name) {
  if (name == null) {
    return null;
  }

  switch (name) {
    case 'transparent':
      return Colors.transparent;
    case 'black':
      return Colors.black;
    case 'black87':
      return Colors.black87;
    case 'black54':
      return Colors.black54;
    case 'black45':
      return Colors.black45;
    case 'black38':
      return Colors.black38;
    case 'black26':
      return Colors.black26;
    case 'black12':
      return Colors.black12;
    case 'white':
      return Colors.white;
    case 'white70':
      return Colors.white70;
    case 'white60':
      return Colors.white60;
    case 'white54':
      return Colors.white54;
    case 'white38':
      return Colors.white38;
    case 'white30':
      return Colors.white30;
    case 'white24':
      return Colors.white24;
    case 'white12':
      return Colors.white12;
    case 'white10':
      return Colors.white10;
    case 'red':
      return Colors.red;
    case 'pink':
      return Colors.pink;
    case 'purple':
      return Colors.purple;
    case 'deepPurple':
      return Colors.deepPurple;
    case 'indigo':
      return Colors.indigo;
    case 'blue':
      return Colors.blue;
    case 'lightBlue':
      return Colors.lightBlue;
    case 'cyan':
      return Colors.cyan;
    case 'teal':
      return Colors.teal;
    case 'green':
      return Colors.green;
    case 'lightGreen':
      return Colors.lightGreen;
    case 'lime':
      return Colors.lime;
    case 'yellow':
      return Colors.yellow;
    case 'amber':
      return Colors.amber;
    case 'orange':
      return Colors.orange;
    case 'deepOrange':
      return Colors.deepOrange;
    case 'brown':
      return Colors.brown;
    case 'grey':
      return Colors.grey;
    case 'blueGrey':
      return Colors.blueGrey;
    default:
      return null;
  }
}

Color? colorFromStatus(String status) {
  switch (status) {
    case 'success':
      return Colors.green;
    case 'warning':
      return Colors.orange;
    case 'danger':
      return Colors.red;
    case 'info':
      return Colors.blue;
    default:
      return null;
  }
}

TextAlign? textAlignFromString(String? value) {
  if (value == 'center') return TextAlign.center;
  if (value == 'end') return TextAlign.end;
  if (value == 'justify') return TextAlign.justify;
  if (value == 'left') return TextAlign.left;
  if (value == 'right') return TextAlign.right;
  if (value == 'start') return TextAlign.start;
  return null;
}

TextOverflow? textOverflowFromString(String? value) {
  if (value == 'clip') return TextOverflow.clip;
  if (value == 'ellipsis') return TextOverflow.ellipsis;
  if (value == 'fade') return TextOverflow.fade;
  if (value == 'visible') return TextOverflow.visible;
  return null;
}

FlexFit? flexFitFromString(String? value) {
  if (value == 'tight') return FlexFit.tight;
  if (value == 'loose') return FlexFit.loose;
  return null;
}

CrossAxisAlignment? crossAxisAlignmentFromString(String? value) {
  if (value == 'center') return CrossAxisAlignment.center;
  if (value == 'end') return CrossAxisAlignment.end;
  if (value == 'baseline') return CrossAxisAlignment.baseline;
  if (value == 'stretch') return CrossAxisAlignment.stretch;
  if (value == 'start') return CrossAxisAlignment.start;
  return null;
}

MainAxisAlignment? mainAxisAlignmentFromString(String? value) {
  if (value == 'center') return MainAxisAlignment.center;
  if (value == 'end') return MainAxisAlignment.end;
  if (value == 'spaceAround') return MainAxisAlignment.spaceAround;
  if (value == 'spaceBetween') return MainAxisAlignment.spaceBetween;
  if (value == 'spaceEvenly') return MainAxisAlignment.spaceEvenly;
  if (value == 'start') return MainAxisAlignment.start;
  return null;
}

MainAxisSize? mainAxisSizeFromString(String? value) {
  if (value == 'max') return MainAxisSize.max;
  if (value == 'min') return MainAxisSize.min;
  return null;
}

TextBaseline? textBaselineFromString(String? value) {
  if (value == 'ideographic') return TextBaseline.ideographic;
  if (value == 'alphabetic') return TextBaseline.alphabetic;
  return null;
}

VerticalDirection? verticalDirectionFromString(String? value) {
  if (value == 'down') return VerticalDirection.down;
  if (value == 'up') return VerticalDirection.up;
  return null;
}

AlignmentDirectional? alignmentDirectionalFromString(String? value) {
  if (value == 'topStart') return AlignmentDirectional.topStart;
  if (value == 'topCenter') return AlignmentDirectional.topCenter;
  if (value == 'topEnd') return AlignmentDirectional.topEnd;
  if (value == 'centerStart') return AlignmentDirectional.centerStart;
  if (value == 'center') return AlignmentDirectional.center;
  if (value == 'centerEnd') return AlignmentDirectional.centerEnd;
  if (value == 'bottomStart') return AlignmentDirectional.bottomStart;
  if (value == 'bottomCenter') return AlignmentDirectional.bottomCenter;
  if (value == 'bottomEnd') return AlignmentDirectional.bottomEnd;
  return null;
}

AlignmentGeometry? alignmentGeometryFromString(String? value) {
  if (value == 'dirCenter') return AlignmentDirectional.center;
  if (value == 'dirTopStart') return AlignmentDirectional.topStart;
  if (value == 'dirTopCenter') return AlignmentDirectional.topCenter;
  if (value == 'dirTopEnd') return AlignmentDirectional.topEnd;
  if (value == 'dirCenterStart') return AlignmentDirectional.centerStart;
  if (value == 'dirCenterEnd') return AlignmentDirectional.centerEnd;
  if (value == 'dirBottomStart') return AlignmentDirectional.bottomStart;
  if (value == 'dirBottomCenter') return AlignmentDirectional.bottomCenter;
  if (value == 'dirBottomEnd') return AlignmentDirectional.bottomEnd;
  if (value == 'center') return Alignment.center;
  if (value == 'topCenter') return Alignment.topCenter;
  if (value == 'bottomCenter') return Alignment.bottomCenter;
  if (value == 'centerLeft') return Alignment.centerLeft;
  if (value == 'centerRight') return Alignment.centerRight;
  if (value == 'topLeft') return Alignment.topLeft;
  if (value == 'topRight') return Alignment.topRight;
  if (value == 'bottomLeft') return Alignment.bottomLeft;
  if (value == 'bottomRight') return Alignment.bottomRight;
  if (value == 'topLeft') return Alignment.topLeft;
  return null;
}

BlendMode? blendModeFromString(String? value) {
  if (value == 'clear') return BlendMode.clear;
  if (value == 'color') return BlendMode.color;
  if (value == 'colorBurn') return BlendMode.colorBurn;
  if (value == 'colorDodge') return BlendMode.colorDodge;
  if (value == 'darken') return BlendMode.darken;
  if (value == 'difference') return BlendMode.difference;
  if (value == 'dst') return BlendMode.dst;
  if (value == 'dstATop') return BlendMode.dstATop;
  if (value == 'dstIn') return BlendMode.dstIn;
  if (value == 'dstOut') return BlendMode.dstOut;
  if (value == 'dstOver') return BlendMode.dstOver;
  if (value == 'exclusion') return BlendMode.exclusion;
  if (value == 'hardLight') return BlendMode.hardLight;
  if (value == 'hue') return BlendMode.hue;
  if (value == 'lighten') return BlendMode.lighten;
  if (value == 'luminosity') return BlendMode.luminosity;
  if (value == 'modulate') return BlendMode.modulate;
  if (value == 'multiply') return BlendMode.multiply;
  if (value == 'overlay') return BlendMode.overlay;
  if (value == 'plus') return BlendMode.plus;
  if (value == 'saturation') return BlendMode.saturation;
  if (value == 'screen') return BlendMode.screen;
  if (value == 'softLight') return BlendMode.softLight;
  if (value == 'src') return BlendMode.src;
  if (value == 'srcATop') return BlendMode.srcATop;
  if (value == 'srcIn') return BlendMode.srcIn;
  if (value == 'srcOut') return BlendMode.srcOut;
  if (value == 'srcOver') return BlendMode.srcOver;
  if (value == 'xor') return BlendMode.xor;
  if (value == 'srcOver') return BlendMode.srcOver;
  return null;
}

FilterQuality? filterQualityFromString(String? value) {
  if (value == 'high') return FilterQuality.high;
  if (value == 'low') return FilterQuality.low;
  if (value == 'medium') return FilterQuality.medium;
  if (value == 'none') return FilterQuality.none;
  return null;
}

BoxFit? boxFitFromString(String? value) {
  if (value == 'contain') return BoxFit.contain;
  if (value == 'cover') return BoxFit.cover;
  if (value == 'fill') return BoxFit.fill;
  if (value == 'fitHeight') return BoxFit.fitHeight;
  if (value == 'fitWidth') return BoxFit.fitWidth;
  if (value == 'scaleDown') return BoxFit.scaleDown;
  if (value == 'none') return BoxFit.none;
  return null;
}

StackFit? stackFitFromString(String? value) {
  if (value == 'expand') return StackFit.expand;
  if (value == 'loose') return StackFit.loose;
  if (value == 'passthrough') return StackFit.passthrough;
  return null;
}

ImageRepeat? imageRepeatFromString(String? value) {
  if (value == 'noRepeat') return ImageRepeat.noRepeat;
  if (value == 'repeat') return ImageRepeat.repeat;
  if (value == 'repeatX') return ImageRepeat.repeatX;
  if (value == 'repeatY') return ImageRepeat.repeatY;
  return null;
}

FontWeight? fontWeightFromString(String? value) {
  if (value == 'bold') return FontWeight.bold;
  if (value == 'normal') return FontWeight.normal;
  if (value == '100') return FontWeight.w100;
  if (value == '200') return FontWeight.w200;
  if (value == '300') return FontWeight.w300;
  if (value == '400') return FontWeight.w400;
  if (value == '500') return FontWeight.w500;
  if (value == '600') return FontWeight.w600;
  if (value == '700') return FontWeight.w700;
  if (value == '800') return FontWeight.w800;
  if (value == '900') return FontWeight.w900;
  return null;
}

FontStyle? fontStyleFromString(String? value) {
  if (value == 'italic') return FontStyle.italic;
  if (value == 'normal') return FontStyle.normal;
  return null;
}

Clip? clipFromString(String? value) {
  if (value == 'antiAlias') return Clip.antiAlias;
  if (value == 'antiAliasWithSaveLayer') return Clip.antiAliasWithSaveLayer;
  if (value == 'hardEdge') return Clip.hardEdge;
  if (value == 'none') return Clip.none;
  return null;
}

TextDirection? textDirectionFromString(String? value) {
  if (value == 'ltr') return TextDirection.ltr;
  if (value == 'rtl') return TextDirection.rtl;
  return null;
}

WrapAlignment? wrapAlignmentFromString(String? value) {
  if (value == 'center') return WrapAlignment.center;
  if (value == 'end') return WrapAlignment.end;
  if (value == 'spaceAround') return WrapAlignment.spaceAround;
  if (value == 'spaceBetween') return WrapAlignment.spaceBetween;
  if (value == 'spaceEvenly') return WrapAlignment.spaceEvenly;
  if (value == 'start') return WrapAlignment.start;
  return null;
}

WrapCrossAlignment? wrapCrossAlignmentFromString(String? value) {
  if (value == 'center') return WrapCrossAlignment.center;
  if (value == 'end') return WrapCrossAlignment.end;
  if (value == 'start') return WrapCrossAlignment.start;
  return null;
}

Axis? axisFromString(String? value) {
  if (value == 'horizontal') return Axis.horizontal;
  if (value == 'vertical') return Axis.vertical;
  return null;
}

BannerLocation? bannerLocationFromString(String? value) {
  if (value == 'bottomEnd') return BannerLocation.bottomEnd;
  if (value == 'bottomStart') return BannerLocation.bottomStart;
  if (value == 'topEnd') return BannerLocation.topEnd;
  if (value == 'topStart') return BannerLocation.topStart;
  return null;
}

BoxShape? boxShapeFromString(String? value) {
  if (value == 'circle') return BoxShape.circle;
  if (value == 'rectangle') return BoxShape.rectangle;
  return null;
}

bool isTypeByString(dynamic value, String type) {
  if (type == 'bool') return value is bool;
  if (type == 'int') return value is int;
  if (type == 'double') return value is double;
  if (type == 'string') return value is String;
  if (type == 'map') return value is Map;
  if (type == 'list<int>') return value is List<int>;
  if (type == 'list<double>') return value is List<double>;
  if (type == 'list<string>') return value is List<String>;
  if (type == 'list<map>') return value is List<Map>;
  if (type == 'list') return value is List;
  return false;
}

String? getTypeOf(dynamic value) {
  if (value is bool) return 'bool';
  if (value is int) return 'int';
  if (value is double) return 'double';
  if (value is String) return 'string';
  if (value is Map) return 'map';
  if (value is List<int>) return 'list<int>';
  if (value is List<double>) return 'list<double>';
  if (value is List<String>) return 'list<string>';
  if (value is List<Map>) return 'list<map>';
  if (value is List) return 'list';
  return null;
}

FlashMode? getFlashModeFromString(String? value) {
  if (value == 'auto') return FlashMode.auto;
  if (value == 'off') return FlashMode.off;
  if (value == 'always') return FlashMode.always;
  if (value == 'torch') return FlashMode.torch;
  return null;
}

CameraLensDirection? getCameraLensDirectionFromString(String? value) {
  if (value == 'front') return CameraLensDirection.front;
  if (value == 'back') return CameraLensDirection.back;
  if (value == 'external') return CameraLensDirection.external;
  return null;
}

StrokeCap strokeCapFromString(String? value) {
  if (value == 'butt') return StrokeCap.butt;
  if (value == 'round') return StrokeCap.round;
  if (value == 'square') return StrokeCap.square;
  return StrokeCap.butt;
}

Color? themeColorFromString(String? value, [BuildContext? context]) {
  // if (value == 'primary') return CoreTheme.of(context).primary;
  // if (value == 'secondary') return CoreTheme.of(context).secondary;
  // if (value == 'tertiary') return CoreTheme.of(context).tertiary;
  // if (value == 'alternate') return CoreTheme.of(context).alternate;
  // if (value == 'primaryText') return CoreTheme.of(context).primaryText;
  // if (value == 'secondaryText') return CoreTheme.of(context).secondaryText;
  // if (value == 'primaryBackground') return CoreTheme.of(context).primaryBackground;
  // if (value == 'secondaryBackground') return CoreTheme.of(context).secondaryBackground;
  // if (value == 'accent1') return CoreTheme.of(context).accent1;
  // if (value == 'accent2') return CoreTheme.of(context).accent2;
  // if (value == 'accent3') return CoreTheme.of(context).accent3;
  // if (value == 'accent4') return CoreTheme.of(context).accent4;
  // if (value == 'success') return CoreTheme.of(context).success;
  // if (value == 'warning') return CoreTheme.of(context).warning;
  // if (value == 'error') return CoreTheme.of(context).error;
  // if (value == 'info') return CoreTheme.of(context).info;
  // if (value == 'primaryBtnText') return CoreTheme.of(context).primaryBtnText;
  // if (value == 'lineColor') return CoreTheme.of(context).lineColor;
  return colorFromHex(value);
}

FloatingActionButtonLocation? floatingActionButtonLocationFromString(String? value) {
  if (value == 'centerDocked') return FloatingActionButtonLocation.centerDocked;
  if (value == 'centerFloat') return FloatingActionButtonLocation.centerFloat;
  if (value == 'centerTop') return FloatingActionButtonLocation.centerTop;
  if (value == 'endDocked') return FloatingActionButtonLocation.endDocked;
  if (value == 'endFloat') return FloatingActionButtonLocation.endFloat;
  if (value == 'endTop') return FloatingActionButtonLocation.endTop;
  if (value == 'miniCenterDocked') return FloatingActionButtonLocation.miniCenterDocked;
  if (value == 'miniCenterFloat') return FloatingActionButtonLocation.miniCenterFloat;
  if (value == 'miniCenterTop') return FloatingActionButtonLocation.miniCenterTop;
  if (value == 'miniEndDocked') return FloatingActionButtonLocation.miniEndDocked;
  if (value == 'miniEndFloat') return FloatingActionButtonLocation.miniEndFloat;
  if (value == 'miniEndTop') return FloatingActionButtonLocation.miniEndTop;
  if (value == 'miniStartDocked') return FloatingActionButtonLocation.miniStartDocked;
  if (value == 'miniStartFloat') return FloatingActionButtonLocation.miniStartFloat;
  if (value == 'miniStartTop') return FloatingActionButtonLocation.miniStartTop;
  if (value == 'startDocked') return FloatingActionButtonLocation.startDocked;
  if (value == 'startFloat') return FloatingActionButtonLocation.startFloat;
  if (value == 'startTop') return FloatingActionButtonLocation.startTop;
  return null;
}

DragStartBehavior? dragStartBehaviorFromString(String? value) {
  if (value == 'down') return DragStartBehavior.down;
  if (value == 'start') return DragStartBehavior.start;
  return null;
}

ListTileTitleAlignment? listTileTitleAlignmentFromString(String? value) {
  if (value == 'bottom') return ListTileTitleAlignment.bottom;
  if (value == 'center') return ListTileTitleAlignment.center;
  if (value == 'threeLine') return ListTileTitleAlignment.threeLine;
  if (value == 'titleHeight') return ListTileTitleAlignment.titleHeight;
  if (value == 'top') return ListTileTitleAlignment.top;
  return null;
}

ListTileStyle? listTileStyleFromString(String? value) {
  if (value == 'list') return ListTileStyle.list;
  if (value == 'drawer') return ListTileStyle.drawer;
  return null;
}

VisualDensity? visualDensityFromString(String? value) {
  if (value == 'adaptivePlatformDensity') return VisualDensity.adaptivePlatformDensity;
  if (value == 'comfortable') return VisualDensity.comfortable;
  if (value == 'compact') return VisualDensity.compact;
  if (value == 'standard') return VisualDensity.standard;
  return null;
}

int durationFromString(String? value) {
  if (value == 'microsecondsPerMillisecond') return Duration.microsecondsPerMillisecond;
  if (value == 'millisecondsPerSecond') return Duration.millisecondsPerSecond;
  if (value == 'secondsPerMinute') return Duration.secondsPerMinute;
  if (value == 'minutesPerHour') return Duration.minutesPerHour;
  if (value == 'hoursPerDay') return Duration.hoursPerDay;
  if (value == 'microsecondsPerSecond') return Duration.microsecondsPerSecond;
  if (value == 'microsecondsPerMinute') return Duration.microsecondsPerMinute;
  if (value == 'microsecondsPerHour') return Duration.microsecondsPerHour;
  if (value == 'microsecondsPerDay') return Duration.microsecondsPerDay;
  if (value == 'millisecondsPerMinute') return Duration.millisecondsPerMinute;
  if (value == 'millisecondsPerHour') return Duration.millisecondsPerHour;
  if (value == 'millisecondsPerDay') return Duration.millisecondsPerDay;
  if (value == 'secondsPerHour') return Duration.secondsPerHour;
  if (value == 'secondsPerDay') return Duration.secondsPerDay;
  if (value == 'minutesPerDay') return Duration.minutesPerDay;
  return 0;
}

TabBarIndicatorSize? tabBarIndicatorSizeFromString(String? value) {
  if (value == 'label') return TabBarIndicatorSize.label;
  if (value == 'tab') return TabBarIndicatorSize.tab;
  return null;
}

TabAlignment? tabAlignmentFromString(String? value) {
  if (value == 'center') return TabAlignment.center;
  if (value == 'fill') return TabAlignment.fill;
  if (value == 'start') return TabAlignment.start;
  if (value == 'startOffset') return TabAlignment.startOffset;
  return null;
}

ListTileControlAffinity? listTileControlAffinityFromString(String? value) {
  if (value == 'leading') return ListTileControlAffinity.leading;
  if (value == 'platform') return ListTileControlAffinity.platform;
  if (value == 'trailing') return ListTileControlAffinity.trailing;
  return null;
}

ScrollViewKeyboardDismissBehavior? scrollViewKeyboardDismissBehaviorFromString(String? value) {
  if (value == 'manual') return ScrollViewKeyboardDismissBehavior.manual;
  if (value == 'onDrag') return ScrollViewKeyboardDismissBehavior.onDrag;
  return null;
}