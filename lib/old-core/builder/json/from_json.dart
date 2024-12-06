import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:andromeda/old-core/core.dart';

Widget? nullableWidgetFromComponent(BuildContext context, JsonC component, ParentContext parentContext) {
  return !component.hasData ?
    null :
    CWBuilder.build(context, component, parentContext);
}

Rect? rectFromStyle(JsonStyleRect style) {
  if (style.data.isEmpty) return null;

  if (style.hasCenter) {
    return Rect.fromCenter(
      center: Offset(style.offset.x, style.offset.y),
      width: style.width,
      height: style.height,
    );
  }

  if (style.hasCircle) {
    return Rect.fromCircle(
      center: Offset(style.offset.x, style.offset.y),
      radius: style.radius,
    );
  }

  if (style.hasLTRB) {
    return Rect.fromLTRB(
      style.left,
      style.top,
      style.right,
      style.bottom,
    );
  }

  if (style.hasLTWH) {
    return Rect.fromLTWH(
      style.left,
      style.top,
      style.width,
      style.height,
    );
  }

  if (style.offset.isNotZero && style.offset2.isNotZero) {
    return Rect.fromPoints(
      Offset(style.offset.x, style.offset.y),
      Offset(style.offset2.x, style.offset2.y),
    );
  }

  return null;
}

TextStyle textStyleFromStyle(JsonStyleTextStyle style, [BuildContext? context]) {
  return TextStyle(
    color: themeColorFromString(style.color, context),
    fontFamily: style.fontFamily,
    fontSize: style.fontSize,
    fontWeight: fontWeightFromString(style.fontWeight),
    fontStyle: fontStyleFromString(style.fontStyle),
    letterSpacing: style.letterSpacing,
  );
}

Text textSimpleFromComponent(JsonC component, [dynamic value, BuildContext? context]) {
  value ??= component.info.textInfo.value;
 
  return Text(
    (value ?? '').toString(),
    textAlign: textAlignFromString(component.info.textInfo.align),
    overflow: textOverflowFromString(component.info.textInfo.overflow),
    style: textStyleFromStyle(component.info.textInfo, context),
  );
}

Text textFromComponent(BuildContext context, JsonC component, ParentContext parentContext) {
  String value = component.info.textInfo.value ?? '';

  dynamic newValue = ArgumentParser.parse(
    context,
    value,
    parentContext,
    component.additionalData
  ) ?? '[ERROR:$value]';

  return textSimpleFromComponent(component, newValue, context);
}

Icon iconFromComponent(JsonC component, [BuildContext? context]) {
  JsonIconInfo iconInfo = component.info.iconInfo;

  List<Shadow> shadows = [];

  for (JsonStyleShadow shadow in iconInfo.shadows) {
    shadows.add(
      Shadow(
        color: themeColorFromString(shadow.color, context) ?? Colors.transparent,
        offset: Offset(shadow.offset.x, shadow.offset.y),
        blurRadius: shadow.blurRadius,
      ),
    );
  }

  return Icon(
    iconDataFromString(iconInfo.icon),
    color: themeColorFromString(iconInfo.color, context),
    size: iconInfo.size,
    fill: iconInfo.fill,
    grade: iconInfo.grade,
    opticalSize: iconInfo.opticalSize,
    textDirection: textDirectionFromString(iconInfo.textDirection),
    weight: iconInfo.weight,
    shadows: shadows,
    applyTextScaling: iconInfo.applyTextScaling,
  );
}

FaIcon faIconFromComponent(BuildContext context, JsonC component) {
  JsonFaIconInfo faIconInfo = component.info.faIconInfo;

  List<Shadow> shadows = [];

  for (JsonStyleShadow shadow in faIconInfo.shadows) {
    shadows.add(
      Shadow(
        color: themeColorFromString(shadow.color, context) ?? Colors.transparent,
        offset: Offset(shadow.offset.x, shadow.offset.y),
        blurRadius: shadow.blurRadius,
      ),
    );
  }

  return FaIcon(
    faIconDataFromString(faIconInfo.icon),
    color: themeColorFromString(faIconInfo.color, context),
    size: faIconInfo.size,
    textDirection: textDirectionFromString(faIconInfo.textDirection),
    shadows: shadows,
  );
}

IconButton? iconButtonFromComponent(BuildContext context, JsonC component, ParentContext parentContext) {
  JsonIconButtonInfo iconButtonInfo = component.info.iconButtonInfo;

  if (!iconButtonInfo.hasIcon) {
    return null;
  }

  return IconButton(
    icon: iconFromComponent(iconButtonInfo.icon),
    onPressed: ActionBuilder.directFunction(context, iconButtonInfo.onPressed, parentContext),
    alignment: alignmentGeometryFromString(iconButtonInfo.alignment),
    autofocus: iconButtonInfo.autofocus,
    color: themeColorFromString(iconButtonInfo.color, context),
    constraints: boxConstraintsFromStyle(iconButtonInfo.constraints),
    disabledColor: themeColorFromString(iconButtonInfo.disabledColor, context),
    enableFeedback: iconButtonInfo.enableFeedback,
    focusColor: themeColorFromString(iconButtonInfo.focusColor, context),
    highlightColor: themeColorFromString(iconButtonInfo.highlightColor, context),
    iconSize: iconButtonInfo.iconSize,
    hoverColor: themeColorFromString(iconButtonInfo.hoverColor, context),
    isSelected: iconButtonInfo.isSelected,
    padding: edgeInsetsFromStyle(iconButtonInfo.padding),
    selectedIcon: nullableWidgetFromComponent(context, iconButtonInfo.selectedIcon, parentContext),
    splashColor: themeColorFromString(iconButtonInfo.splashColor, context),
    splashRadius: iconButtonInfo.splashRadius,
    tooltip: iconButtonInfo.tooltip,
    // TODO: this
    // style: buttonStyleFromString?,
    // visualDensity: visualDensityFromString?,
  );
}

Image? imageFromComponent(JsonC component, [BuildContext? context]) {
  JsonImageInfo imageInfo = component.info.imageInfo;

  if (imageInfo.isValidAsset) {
    return Image.asset(
      imageInfo.asset!,
      alignment: alignmentGeometryFromString(imageInfo.alignment) ?? Alignment.center,
      filterQuality: filterQualityFromString(imageInfo.filterQuality) ?? FilterQuality.low,
      scale: imageInfo.scale,
      centerSlice: rectFromStyle(imageInfo.centerSlice),
      colorBlendMode: blendModeFromString(imageInfo.blendMode),
      fit: boxFitFromString(imageInfo.fit),
      color: themeColorFromString(imageInfo.color, context),
      width: imageInfo.width,
      height: imageInfo.height,
      isAntiAlias: imageInfo.isAntiAlias,
      repeat: imageRepeatFromString(imageInfo.repeat) ?? ImageRepeat.noRepeat,
      opacity: imageInfo.opacity != null ? AlwaysStoppedAnimation(imageInfo.opacity!) : null,
    );
  }

  if (imageInfo.isValidFile) {
    return Image.file(
      File(imageInfo.file!),
      alignment: alignmentGeometryFromString(imageInfo.alignment) ?? Alignment.center,
      filterQuality: filterQualityFromString(imageInfo.filterQuality) ?? FilterQuality.low,
      scale: imageInfo.scale ?? 1.0,
      centerSlice: rectFromStyle(imageInfo.centerSlice),
      colorBlendMode: blendModeFromString(imageInfo.blendMode),
      fit: boxFitFromString(imageInfo.fit),
      color: themeColorFromString(imageInfo.color, context),
      width: imageInfo.width,
      height: imageInfo.height,
      isAntiAlias: imageInfo.isAntiAlias,
      repeat: imageRepeatFromString(imageInfo.repeat) ?? ImageRepeat.noRepeat,
      opacity: imageInfo.opacity != null ? AlwaysStoppedAnimation(imageInfo.opacity!) : null,
      errorBuilder: (context, error, stackTrace) => const Text('Error loading image'),
    );
  }

  if (imageInfo.isValidUrl) {
    return Image.network(
      imageInfo.url!,
      alignment: alignmentGeometryFromString(imageInfo.alignment) ?? Alignment.center,
      filterQuality: filterQualityFromString(imageInfo.filterQuality) ?? FilterQuality.low,
      scale: imageInfo.scale ?? 1.0,
      centerSlice: rectFromStyle(imageInfo.centerSlice),
      colorBlendMode: blendModeFromString(imageInfo.blendMode),
      fit: boxFitFromString(imageInfo.fit),
      color: themeColorFromString(imageInfo.color, context),
      width: imageInfo.width,
      height: imageInfo.height,
      isAntiAlias: imageInfo.isAntiAlias,
      repeat: imageRepeatFromString(imageInfo.repeat) ?? ImageRepeat.noRepeat,
      opacity: imageInfo.opacity != null ? AlwaysStoppedAnimation(imageInfo.opacity!) : null,
      errorBuilder: (context, error, stackTrace) => const Text('Error loading image'),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
              : null,
          ),
        );
      },
    );
  }

  if (imageInfo.isValidBase64) {
    return Image.memory(
      base64Decode(imageInfo.base64!),
      alignment: alignmentGeometryFromString(imageInfo.alignment) ?? Alignment.center,
      filterQuality: filterQualityFromString(imageInfo.filterQuality) ?? FilterQuality.low,
      scale: imageInfo.scale ?? 1.0,
      centerSlice: rectFromStyle(imageInfo.centerSlice),
      colorBlendMode: blendModeFromString(imageInfo.blendMode),
      fit: boxFitFromString(imageInfo.fit),
      color: themeColorFromString(imageInfo.color, context),
      width: imageInfo.width,
      height: imageInfo.height,
      isAntiAlias: imageInfo.isAntiAlias,
      repeat: imageRepeatFromString(imageInfo.repeat) ?? ImageRepeat.noRepeat,
      opacity: imageInfo.opacity != null ? AlwaysStoppedAnimation(imageInfo.opacity!) : null,
      errorBuilder: (context, error, stackTrace) => const Text('Error loading image'),
    );
  }

  return null;
}

Radius? radiusFromStyle(JsonStyleRadius style) {
  if (style.hasCircular) {
    return Radius.circular(style.circular);
  }

  if (style.hasPos) {
    return Radius.elliptical(style.x, style.y);
  }

  return null;
}

BorderRadiusGeometry? borderRadiusGeometryFromStyle(JsonStyleBorderRadius style) {
  if (style.directional) {
    if (style.isOnly) {
      return BorderRadiusDirectional.only(
        topStart: radiusFromStyle(style.topStart) ?? Radius.zero,
        topEnd: radiusFromStyle(style.topEnd) ?? Radius.zero,
        bottomStart: radiusFromStyle(style.bottomStart) ?? Radius.zero,
        bottomEnd: radiusFromStyle(style.bottomEnd) ?? Radius.zero,
      );
    }

    if (style.hasAll) {
      return BorderRadiusDirectional.all(radiusFromStyle(style.all) ?? Radius.zero);
    }

    if (style.isVertical) {
      return BorderRadiusDirectional.vertical(
        top: radiusFromStyle(style.top) ?? Radius.zero,
        bottom: radiusFromStyle(style.bottom) ?? Radius.zero,
      );
    }

    if (style.isHorizontal) {
      return BorderRadiusDirectional.horizontal(
        start: radiusFromStyle(style.start) ?? Radius.zero,
        end: radiusFromStyle(style.end) ?? Radius.zero,
      );
    }

    if (style.isCircular) {
      return BorderRadiusDirectional.circular(style.circular);
    }
  } else {
    if (style.hasAll) {
      return BorderRadius.all(radiusFromStyle(style.all) ?? Radius.zero);
    }

    if (style.isOnly) {
      return BorderRadius.only(
        topLeft: radiusFromStyle(style.topLeft) ?? Radius.zero,
        topRight: radiusFromStyle(style.topRight) ?? Radius.zero,
        bottomLeft: radiusFromStyle(style.bottomLeft) ?? Radius.zero,
        bottomRight: radiusFromStyle(style.bottomRight) ?? Radius.zero,
      );
    }

    if (style.isVertical) {
      return BorderRadius.vertical(
        top: radiusFromStyle(style.top) ?? Radius.zero,
        bottom: radiusFromStyle(style.bottom) ?? Radius.zero,
      );
    }

    if (style.isHorizontal) {
      return BorderRadius.horizontal(
        left: radiusFromStyle(style.left) ?? Radius.zero,
        right: radiusFromStyle(style.right) ?? Radius.zero,
      );
    }

    if (style.isCircular) {
      return BorderRadius.circular(style.circular);
    }
  }

  return null;
}

BorderRadius? borderRadiusFromStyle(JsonStyleBorderRadius style) {
  return borderRadiusGeometryFromStyle(style) as BorderRadius?;
}

EdgeInsetsGeometry? edgeInsetsFromStyle(JsonStyleEdgeInsets style) {
  if (style.directional) {
    if (style.hasStartEnd || style.hasBottomTop) {
      if (style.only) {
        return EdgeInsetsDirectional.only(
          start: style.start,
          end: style.end,
          top: style.top,
          bottom: style.bottom,
        );
      } else {
        return EdgeInsetsDirectional.fromSTEB(
          style.start,
          style.top,
          style.end,
          style.bottom,
        );
      }
    }

    if (style.hasAll) {
      return EdgeInsetsDirectional.all(style.all);
    }

    if (style.hasVerticalHorizontal) {
      return EdgeInsetsDirectional.symmetric(
        vertical: style.vertical,
        horizontal: style.horizontal,
      );
    }
  } else {
    if (style.hasAll) {
      return EdgeInsets.all(style.all);
    }

    if (style.hasVerticalHorizontal) {
      return EdgeInsets.symmetric(
        vertical: style.vertical,
        horizontal: style.horizontal,
      );
    }

    if (style.hasLTRB) {
      if (style.only) {
        return EdgeInsets.only(
          left: style.left,
          top: style.top,
          right: style.right,
          bottom: style.bottom,
        );
      } else {
        return EdgeInsets.fromLTRB(
          style.left,
          style.top,
          style.right,
          style.bottom,
        );
      }
    }
  }

  return null;
}

BoxConstraints? boxConstraintsFromStyle(JsonStyleBoxConstraints style) {
  if (style.tight) {
    if (style.finite) {
      return BoxConstraints.tightForFinite(
        width: style.width ?? double.infinity,
        height: style.height ?? double.infinity,
      );
    } else {
      return BoxConstraints.tightFor(
        width: style.width ?? double.infinity,
        height: style.height ?? double.infinity,
      );
    }
  }

  if (style.tight) {
    return BoxConstraints.tight(
      Size(
        style.width ?? double.infinity,
        style.height ?? double.infinity,
      ),
    );
  }

  if (style.hasSize) {
    return BoxConstraints.loose(
      Size(
        style.size.width,
        style.size.height,
      ),
    );
  }

  if (style.hasDimension) {
    return BoxConstraints.expand(
      width: style.width ?? double.infinity,
      height: style.height ?? double.infinity,
    );
  }

  return null;
}

Decoration? decorationFromStyle(JsonStyleDecoration style, [BuildContext? context]) {
  if (style.data.isEmpty) return null;
  
  return BoxDecoration(
    backgroundBlendMode: blendModeFromString(style.backgroundBlendMode),
    borderRadius: borderRadiusFromStyle(style.borderRadius),
    color: themeColorFromString(style.color, context),
    shape: boxShapeFromString(style.shape) ?? BoxShape.rectangle,
    // TODO: DecorationImage
    // TODO: Gradient
    // TODO: BoxShadow
    // TODO: BoxBorder 
  );
}

CoreButtonStyleOptions buttonStyleOptionsFromStyle(JsonStyleButton style, [BuildContext? context]) {
  return CoreButtonStyleOptions(
    backgroundColor: themeColorFromString(style.backgroundColor, context),
    hoveredBackgroundColor: themeColorFromString(style.hoveredBackgroundColor, context),
    disabledBackgroundColor: themeColorFromString(style.disabledBackgroundColor, context),
    disabledHoveredBackgroundColor: themeColorFromString(style.disabledHoveredBackgroundColor, context),
    foregroundColor: themeColorFromString(style.foregroundColor, context),
    hoveredForegroundColor: themeColorFromString(style.hoveredForegroundColor, context),
    disabledForegroundColor: themeColorFromString(style.disabledForegroundColor, context),
    disabledHoveredForegroundColor: themeColorFromString(style.disabledHoveredForegroundColor, context),
    borderRadius: borderRadiusFromStyle(style.borderRadius),
    // borderSide: themeColorFromString(style.borderSide, context),
    // hoverBorderSide: themeColorFromString(style.hoverBorderSide, context),
    splashColor: themeColorFromString(style.splashColor, context),
    elevation: style.elevation,
    hoverElevation: style.hoverElevation,
  );
}

Duration durationFromStyle(JsonStyleDuration style) {
  int days = 0;
  if (style.days is String) days = durationFromString(style.days);
  if (style.days is int) days = style.days;

  int hours = 0;
  if (style.hours is String) hours = durationFromString(style.hours);
  if (style.hours is int) hours = style.hours;

  int minutes = 0;
  if (style.minutes is String) minutes = durationFromString(style.minutes);
  if (style.minutes is int) minutes = style.minutes;

  int seconds = 0;
  if (style.seconds is String) seconds = durationFromString(style.seconds);
  if (style.seconds is int) seconds = style.seconds;

  int microseconds = 0;
  if (style.microseconds is String) microseconds = durationFromString(style.microseconds);
  if (style.microseconds is int) microseconds = style.microseconds;

  int milliseconds = 0;
  if (style.milliseconds is String) milliseconds = durationFromString(style.milliseconds);
  if (style.milliseconds is int) milliseconds = style.milliseconds;

  return Duration(
    days: days,
    hours: hours,
    minutes: minutes,
    seconds: seconds,
    microseconds: microseconds,
    milliseconds: milliseconds,
  );
}