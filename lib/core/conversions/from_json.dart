// import 'dart:io';
import 'package:flutter/material.dart';
import 'from_string.dart';
import 'styles.dart';

Rect? rectFromStyle(AndromedaStyleRect style) {
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

TextStyle? textStyleFromStyle(AndromedaStyleTextStyle style) {
  if (!style.hasData) return null;

  return TextStyle(
    color: style.color,
    decoration: style.decoration,
    decorationColor: style.decorationColor,
    decorationStyle: style.decorationStyle,
    decorationThickness: style.decorationThickness,
    fontFamily: style.fontFamily,
    fontSize: style.fontSize,
    fontStyle: style.fontStyle,
    fontWeight: style.fontWeight,
    height: style.height,
    letterSpacing: style.letterSpacing,
    overflow: style.overflow,
    wordSpacing: style.wordSpacing,
    textBaseline: style.textBaseline,
    backgroundColor: style.backgroundColor,
    leadingDistribution: style.leadingDistribution,
    // TODO: these
    // background: Paint?,
    // fontFamilyFallback: List<String>?,
    // fontFeatures: List<FontFeature>?,
    // fontVariations: List<FontVariation>?,
    // foreground: Paint?,
    // locale: Locale?,
    // package: String?,
    // shadows: List<Shadow>?,
  );
}

Size? sizeFromValue(dynamic value) {
  if (value is String) {
    if (value == 'zero') return Size.zero;
    if (value == 'infinite') return Size.infinite;
    return null;
  }

  if (value is List) {
    if (value.length >= 2) {
      return Size(value[0], value[1]);
    }

    return null;
  }

  if (value is Map) {
    if (value.containsKey("width") && value.containsKey("height")) {
      return Size(value['width'], value['height']);
    }

    if (value.containsKey("dimension")) {
      return Size.square(value['dimension']);
    }

    if (value.containsKey("radius")) {
      return Size.fromRadius(value['radius']);
    }

    if (value.containsKey("height")) {
      return Size.fromHeight(value['height']);
    }

    if (value.containsKey("width")) {
      return Size.fromWidth(value['width']);
    }
  }

  return null;
}

RangeValues? rangeValuesFromValue(dynamic value) {
  if (value is List && value.length >= 2) {
    return RangeValues(value[0], value[1]);
  }

  if (value is Map) {
    return RangeValues(
      value['start'] ?? 0.0,
      value['end'] ?? 0.0,
    );
  }

  return null;
}

IconThemeData? iconThemeDataFromStyle(AndromedaStyleIconThemeData style) {
  if (!style.hasData) return null;

  return IconThemeData(
    size: style.size,
    fill: style.fill,
    weight: style.weight,
    grade: style.grade,
    opticalSize: style.opticalSize,
    color: style.color,
    opacity: style.opacity,
    shadows: style.shadows.map((shadow) => shadowFromStyle(shadow)).whereType<Shadow>().toList(),
    applyTextScaling: style.applyTextScaling,
  );
}

Shadow? shadowFromStyle(AndromedaStyleShadow style) {
  if (!style.hasData) return null;

  return Shadow(
    color: style.color ?? Colors.transparent,
    offset: Offset(style.offset.x, style.offset.y),
    blurRadius: style.blurRadius,
  );
}

// Text textSimpleFromComponent(JsonC component, [dynamic value, BuildContext? context]) {
//   value ??= component.info.textInfo.value;

//   return Text(
//     (value ?? '').toString(),
//     textAlign: textAlignFromString(component.info.textInfo.align),
//     overflow: textOverflowFromString(component.info.textInfo.overflow),
//     style: textStyleFromStyle(component.info.textInfo, context),
//   );
// }

// Text textFromComponent(BuildContext context, JsonC component, ParentContext parentContext) {
//   String value = component.info.textInfo.value ?? '';

//   dynamic newValue = ArgumentParser.parse(
//     context,
//     value,
//     parentContext,
//     component.additionalData
//   ) ?? '[ERROR:$value]';

//   return textSimpleFromComponent(component, newValue, context);
// }

// Icon iconFromComponent(JsonC component, [BuildContext? context]) {
//   JsonIconInfo iconInfo = component.info.iconInfo;

//   List<Shadow> shadows = [];

//   for (AndromedaStyleShadow shadow in iconInfo.shadows) {
//     shadows.add(
//       Shadow(
//         color: themeColorFromString(shadow.color, context) ?? Colors.transparent,
//         offset: Offset(shadow.offset.x, shadow.offset.y),
//         blurRadius: shadow.blurRadius,
//       ),
//     );
//   }

//   return Icon(
//     iconDataFromString(iconInfo.icon),
//     color: themeColorFromString(iconInfo.color, context),
//     size: iconInfo.size,
//     fill: iconInfo.fill,
//     grade: iconInfo.grade,
//     opticalSize: iconInfo.opticalSize,
//     textDirection: textDirectionFromString(iconInfo.textDirection),
//     weight: iconInfo.weight,
//     shadows: shadows,
//     applyTextScaling: iconInfo.applyTextScaling,
//   );
// }

// FaIcon faIconFromComponent(BuildContext context, JsonC component) {
//   JsonFaIconInfo faIconInfo = component.info.faIconInfo;

//   List<Shadow> shadows = [];

//   for (AndromedaStyleShadow shadow in faIconInfo.shadows) {
//     shadows.add(
//       Shadow(
//         color: themeColorFromString(shadow.color, context) ?? Colors.transparent,
//         offset: Offset(shadow.offset.x, shadow.offset.y),
//         blurRadius: shadow.blurRadius,
//       ),
//     );
//   }

//   return FaIcon(
//     faIconDataFromString(faIconInfo.icon),
//     color: themeColorFromString(faIconInfo.color, context),
//     size: faIconInfo.size,
//     textDirection: textDirectionFromString(faIconInfo.textDirection),
//     shadows: shadows,
//   );
// }

// IconButton? iconButtonFromComponent(BuildContext context, JsonC component, ParentContext parentContext) {
//   JsonIconButtonInfo iconButtonInfo = component.info.iconButtonInfo;

//   if (!iconButtonInfo.hasIcon) {
//     return null;
//   }

//   return IconButton(
//     icon: iconFromComponent(iconButtonInfo.icon),
//     onPressed: ActionBuilder.directFunction(context, iconButtonInfo.onPressed, parentContext),
//     alignment: alignmentGeometryFromString(iconButtonInfo.alignment),
//     autofocus: iconButtonInfo.autofocus,
//     color: themeColorFromString(iconButtonInfo.color, context),
//     constraints: boxConstraintsFromStyle(iconButtonInfo.constraints),
//     disabledColor: themeColorFromString(iconButtonInfo.disabledColor, context),
//     enableFeedback: iconButtonInfo.enableFeedback,
//     focusColor: themeColorFromString(iconButtonInfo.focusColor, context),
//     highlightColor: themeColorFromString(iconButtonInfo.highlightColor, context),
//     iconSize: iconButtonInfo.iconSize,
//     hoverColor: themeColorFromString(iconButtonInfo.hoverColor, context),
//     isSelected: iconButtonInfo.isSelected,
//     padding: edgeInsetsFromStyle(iconButtonInfo.padding),
//     selectedIcon: nullableWidgetFromComponent(context, iconButtonInfo.selectedIcon, parentContext),
//     splashColor: themeColorFromString(iconButtonInfo.splashColor, context),
//     splashRadius: iconButtonInfo.splashRadius,
//     tooltip: iconButtonInfo.tooltip,
//     // TODO: this
//     // style: buttonStyleFromString?,
//     // visualDensity: visualDensityFromString?,
//   );
// }

// Image? imageFromComponent(JsonC component, [BuildContext? context]) {
//   JsonImageInfo imageInfo = component.info.imageInfo;

//   if (imageInfo.isValidAsset) {
//     return Image.asset(
//       imageInfo.asset!,
//       alignment: alignmentGeometryFromString(imageInfo.alignment) ?? Alignment.center,
//       filterQuality: filterQualityFromString(imageInfo.filterQuality) ?? FilterQuality.low,
//       scale: imageInfo.scale,
//       centerSlice: rectFromStyle(imageInfo.centerSlice),
//       colorBlendMode: blendModeFromString(imageInfo.blendMode),
//       fit: boxFitFromString(imageInfo.fit),
//       color: themeColorFromString(imageInfo.color, context),
//       width: imageInfo.width,
//       height: imageInfo.height,
//       isAntiAlias: imageInfo.isAntiAlias,
//       repeat: imageRepeatFromString(imageInfo.repeat) ?? ImageRepeat.noRepeat,
//       opacity: imageInfo.opacity != null ? AlwaysStoppedAnimation(imageInfo.opacity!) : null,
//     );
//   }

//   if (imageInfo.isValidFile) {
//     return Image.file(
//       File(imageInfo.file!),
//       alignment: alignmentGeometryFromString(imageInfo.alignment) ?? Alignment.center,
//       filterQuality: filterQualityFromString(imageInfo.filterQuality) ?? FilterQuality.low,
//       scale: imageInfo.scale ?? 1.0,
//       centerSlice: rectFromStyle(imageInfo.centerSlice),
//       colorBlendMode: blendModeFromString(imageInfo.blendMode),
//       fit: boxFitFromString(imageInfo.fit),
//       color: themeColorFromString(imageInfo.color, context),
//       width: imageInfo.width,
//       height: imageInfo.height,
//       isAntiAlias: imageInfo.isAntiAlias,
//       repeat: imageRepeatFromString(imageInfo.repeat) ?? ImageRepeat.noRepeat,
//       opacity: imageInfo.opacity != null ? AlwaysStoppedAnimation(imageInfo.opacity!) : null,
//       errorBuilder: (context, error, stackTrace) => const Text('Error loading image'),
//     );
//   }

//   if (imageInfo.isValidUrl) {
//     return Image.network(
//       imageInfo.url!,
//       alignment: alignmentGeometryFromString(imageInfo.alignment) ?? Alignment.center,
//       filterQuality: filterQualityFromString(imageInfo.filterQuality) ?? FilterQuality.low,
//       scale: imageInfo.scale ?? 1.0,
//       centerSlice: rectFromStyle(imageInfo.centerSlice),
//       colorBlendMode: blendModeFromString(imageInfo.blendMode),
//       fit: boxFitFromString(imageInfo.fit),
//       color: themeColorFromString(imageInfo.color, context),
//       width: imageInfo.width,
//       height: imageInfo.height,
//       isAntiAlias: imageInfo.isAntiAlias,
//       repeat: imageRepeatFromString(imageInfo.repeat) ?? ImageRepeat.noRepeat,
//       opacity: imageInfo.opacity != null ? AlwaysStoppedAnimation(imageInfo.opacity!) : null,
//       errorBuilder: (context, error, stackTrace) => const Text('Error loading image'),
//       loadingBuilder: (context, child, loadingProgress) {
//         if (loadingProgress == null) return child;
//         return Center(
//           child: CircularProgressIndicator(
//             value: loadingProgress.expectedTotalBytes != null
//               ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
//               : null,
//           ),
//         );
//       },
//     );
//   }

//   if (imageInfo.isValidBase64) {
//     return Image.memory(
//       base64Decode(imageInfo.base64!),
//       alignment: alignmentGeometryFromString(imageInfo.alignment) ?? Alignment.center,
//       filterQuality: filterQualityFromString(imageInfo.filterQuality) ?? FilterQuality.low,
//       scale: imageInfo.scale ?? 1.0,
//       centerSlice: rectFromStyle(imageInfo.centerSlice),
//       colorBlendMode: blendModeFromString(imageInfo.blendMode),
//       fit: boxFitFromString(imageInfo.fit),
//       color: themeColorFromString(imageInfo.color, context),
//       width: imageInfo.width,
//       height: imageInfo.height,
//       isAntiAlias: imageInfo.isAntiAlias,
//       repeat: imageRepeatFromString(imageInfo.repeat) ?? ImageRepeat.noRepeat,
//       opacity: imageInfo.opacity != null ? AlwaysStoppedAnimation(imageInfo.opacity!) : null,
//       errorBuilder: (context, error, stackTrace) => const Text('Error loading image'),
//     );
//   }

//   return null;
// }

Radius? radiusFromStyle(AndromedaStyleRadius style) {
  if (style.hasCircular) {
    return Radius.circular(style.circular);
  }

  if (style.hasPos) {
    return Radius.elliptical(style.x, style.y);
  }

  return null;
}

BorderRadiusGeometry? borderRadiusGeometryFromStyle(AndromedaStyleBorderRadius style) {
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

BorderRadius? borderRadiusFromStyle(AndromedaStyleBorderRadius style) {
  return borderRadiusGeometryFromStyle(style) as BorderRadius?;
}

EdgeInsets? edgeInsetsFromStyle(AndromedaStyleEdgeInsets style) {
  return edgeInsetsGeometryFromStyle(style) as EdgeInsets?;
}

Offset? offsetFromValue(dynamic value) {
  if (value is String) {
    if (value == 'zero') return Offset.zero;
    if (value == 'infinite') return Offset.infinite;
    return null;
  }

  if (value is Map) {
    if (value.containsKey("x") && value.containsKey("y")) {
      return Offset(value['x'], value['y']);
    }

    return null;
  }

  if (value is List) {
    if (value.length >= 2) {
      return Offset(value[0], value[1]);
    }

    return null;
  }

  return null;
}

SliverGridDelegate? sliverGridDelegateFromStyle(AndromedaStyleSliverGridDelegate style) {
  if (style.hasCrossAxisCount) {
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: style.crossAxisCount!,
      mainAxisSpacing: style.mainAxisSpacing,
      crossAxisSpacing: style.crossAxisSpacing,
      childAspectRatio: style.childAspectRatio,
      mainAxisExtent: style.mainAxisExtent,
    );
  }

  if (style.hasMaxCrossAxisExtent) {
    return SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: style.maxCrossAxisExtent!,
      mainAxisSpacing: style.mainAxisSpacing,
      crossAxisSpacing: style.crossAxisSpacing,
      childAspectRatio: style.childAspectRatio,
      mainAxisExtent: style.mainAxisExtent,
    );
  }

  return null;
}

EdgeInsetsGeometry? edgeInsetsGeometryFromStyle(AndromedaStyleEdgeInsets style) {
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

TextHeightBehavior? textHeightBehaviorFromStyle(AndromedaStyleTextHeightBehavior style) {
  if (!style.hasData) return null;

  return TextHeightBehavior(
    applyHeightToFirstAscent: style.applyHeightToFirstAscent,
    applyHeightToLastDescent: style.applyHeightToLastDescent,
    leadingDistribution: textLeadingDistributionFromString(style.leadingDistribution) ?? TextLeadingDistribution.proportional,
  );
}

StrutStyle? strutStyleFromStyle(AndromedaStyleStrutStyle style) {
  if (!style.hasData) return null;

  return StrutStyle(
    fontFamily: style.fontFamily,
    fontFamilyFallback: style.fontFamilyFallback,
    fontSize: style.fontSize,
    height: style.height,
    leading: style.leading,
    fontWeight: fontWeightFromString(style.fontWeight),
    fontStyle: fontStyleFromString(style.fontStyle),
    forceStrutHeight: style.forceStrutHeight,
  );
}

BoxConstraints? boxConstraintsFromStyle(AndromedaStyleBoxConstraints style) {
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
      sizeFromValue(style.size) ?? Size.zero,
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

Decoration? decorationFromStyle(AndromedaStyleDecoration style, [BuildContext? context]) {
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

// CoreButtonStyleOptions buttonStyleOptionsFromStyle(AndromedaStyleButton style, [BuildContext? context]) {
//   return CoreButtonStyleOptions(
//     backgroundColor: themeColorFromString(style.backgroundColor, context),
//     hoveredBackgroundColor: themeColorFromString(style.hoveredBackgroundColor, context),
//     disabledBackgroundColor: themeColorFromString(style.disabledBackgroundColor, context),
//     disabledHoveredBackgroundColor: themeColorFromString(style.disabledHoveredBackgroundColor, context),
//     foregroundColor: themeColorFromString(style.foregroundColor, context),
//     hoveredForegroundColor: themeColorFromString(style.hoveredForegroundColor, context),
//     disabledForegroundColor: themeColorFromString(style.disabledForegroundColor, context),
//     disabledHoveredForegroundColor: themeColorFromString(style.disabledHoveredForegroundColor, context),
//     borderRadius: borderRadiusFromStyle(style.borderRadius),
//     // borderSide: themeColorFromString(style.borderSide, context),
//     // hoverBorderSide: themeColorFromString(style.hoverBorderSide, context),
//     splashColor: themeColorFromString(style.splashColor, context),
//     elevation: style.elevation,
//     hoverElevation: style.hoverElevation,
//   );
// }

ButtonStyle? buttonStyleFromStyle(AndromedaStyleButtonStyle style) {
  ColorScheme colorScheme = Theme.of(style.context).colorScheme;

  return ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.disabled)) {
        if (states.contains(WidgetState.hovered)) {
          return themeColorFromString(style.disabledHoveredBackgroundColor, style.context) ?? colorScheme.onSurface.withOpacity(0.12);
        }

        return themeColorFromString(style.disabledBackgroundColor, style.context) ?? colorScheme.onSurface.withOpacity(0.12);
      }

      if (states.contains(WidgetState.hovered)) {
        return themeColorFromString(style.hoveredBackgroundColor, style.context) ?? colorScheme.onSurface.withOpacity(0.8);
      }

      return themeColorFromString(style.backgroundColor, style.context) ?? colorScheme.primary;
    }),
    foregroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.disabled)) {
        if (states.contains(WidgetState.hovered)) {
          return themeColorFromString(style.disabledHoveredForegroundColor, style.context) ?? colorScheme.onSurface.withOpacity(0.38);
        }

        return themeColorFromString(style.disabledForegroundColor, style.context) ?? colorScheme.onSurface.withOpacity(0.38);
      }

      if (states.contains(WidgetState.hovered)) {
        return themeColorFromString(style.hoveredForegroundColor, style.context) ?? colorScheme.onPrimary;
      }

      return themeColorFromString(style.foregroundColor, style.context) ?? colorScheme.onPrimary;
    }),
    overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.disabled)) {
        if (states.contains(WidgetState.hovered)) {
          return themeColorFromString(style.disabledHoveredOverlayColor, style.context) ?? Colors.transparent;
        }

        return themeColorFromString(style.disabledOverlayColor, style.context) ?? Colors.transparent;
      }

      if (states.contains(WidgetState.hovered)) {
        return themeColorFromString(style.hoveredOverlayColor, style.context) ?? colorScheme.onPrimary.withOpacity(0.08);
      }

      return themeColorFromString(style.overlayColor, style.context) ?? Colors.transparent;
    }),
    shadowColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.disabled)) {
        if (states.contains(WidgetState.hovered)) {
          return themeColorFromString(style.disabledHoveredShadowColor, style.context) ?? colorScheme.shadow.withOpacity(0.0);
        }

        return themeColorFromString(style.disabledShadowColor, style.context) ?? colorScheme.shadow.withOpacity(0.0);
      }

      if (states.contains(WidgetState.hovered)) {
        return themeColorFromString(style.hoveredShadowColor, style.context) ?? colorScheme.shadow.withOpacity(0.0);
      }

      return themeColorFromString(style.shadowColor, style.context) ?? colorScheme.shadow;
    }),
    elevation: WidgetStateProperty.resolveWith<double?>((states) {
      if (states.contains(WidgetState.disabled)) {
        if (states.contains(WidgetState.hovered)) {
          return style.disabledHoveredElevation;
        }

        return style.disabledElevation;
      }

      if (states.contains(WidgetState.hovered)) {
        return style.hoverElevation;
      }

      return style.elevation;
    }),
    // shape: WidgetStateProperty.resolveWith<OutlinedBorder>((states) {
    //   if (states.contains(WidgetState.disabled)) {
    //     if (states.contains(WidgetState.hovered)) {
    //       // TODO: shapeFromStyle
    //     }

    //     // TODO: shapeFromStyle
    //   }

    //   // TODO: shapeFromStyle
    // }),

    // TODO: other
  );
}

Duration? durationFromStyle(AndromedaStyleDuration style) {
  if (!style.hasData) return null;

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