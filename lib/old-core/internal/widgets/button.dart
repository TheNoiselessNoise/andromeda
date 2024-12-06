import 'package:flutter/material.dart';

class CoreButtonStyleOptions {
  final Color? backgroundColor;
  final Color? hoveredBackgroundColor;
  final Color? disabledBackgroundColor;
  final Color? disabledHoveredBackgroundColor;
  
  final Color? foregroundColor;
  final Color? hoveredForegroundColor;
  final Color? disabledForegroundColor;
  final Color? disabledHoveredForegroundColor;
  
  final BorderRadius? borderRadius;
  final BorderSide? borderSide;
  final BorderSide? hoverBorderSide;
  final Color? splashColor;
  final double? elevation;
  final double? hoverElevation;
  
  const CoreButtonStyleOptions({
    this.backgroundColor,
    this.hoveredBackgroundColor,
    this.disabledBackgroundColor,
    this.disabledHoveredBackgroundColor,

    this.foregroundColor,
    this.hoveredForegroundColor,
    this.disabledForegroundColor,
    this.disabledHoveredForegroundColor,
    
    this.borderRadius,
    this.borderSide,
    this.hoverBorderSide,
    this.splashColor,
    this.elevation,
    this.hoverElevation,
  });
}

class CoreButtonOptions {
  final TextStyle? textStyle;
  final Color? overlayColor;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final EdgeInsetsGeometry padding;
  final Size? minimumSize;
  final Size? fixedSize;
  final Size? maximumSize;
  final Color? iconColor;
  final double? iconSize;
  final BorderSide? side;
  final OutlinedBorder? shape;
  final MouseCursor? mouseCursor;
  final VisualDensity? visualDensity;
  final MaterialTapTargetSize? tapTargetSize;
  final Duration? animationDuration;
  final bool? enableFeedback;
  final AlignmentGeometry? alignment;
  final InteractiveInkFeatureFactory? splashFactory;

  const CoreButtonOptions({
    this.textStyle,
    this.overlayColor,
    this.shadowColor,
    this.surfaceTintColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
    this.minimumSize,
    this.fixedSize,
    this.maximumSize,
    this.iconColor,
    this.iconSize,
    this.side,
    this.shape,
    this.mouseCursor,
    this.visualDensity,
    this.tapTargetSize,
    this.animationDuration,
    this.enableFeedback,
    this.alignment,
    this.splashFactory,
  });
}

abstract class CoreBaseButton<S extends CoreBaseButtonState> extends StatefulWidget {
  final String? id;
  final GlobalKey? formKey;
  final CoreButtonOptions? options;
  final CoreButtonStyleOptions? styleOptions;
  final bool disabled;

  final void Function(S)? onPressed;
  final void Function(S)? onLongPress;

  final Widget? child;

  const CoreBaseButton({
    super.key,

    this.id,
    this.formKey,
    this.options,
    this.styleOptions,
    this.disabled = false,

    this.onPressed,
    this.onLongPress,

    this.child,
  });

  @override
  CoreBaseButtonState createState() => CoreBaseButtonState();

  @protected
  Widget buildButton(BuildContext context, S state) {
    return Text("Button '$id' not implemented");
  }

  WidgetStateProperty<OutlinedBorder> buildShape() {
    return WidgetStateProperty.resolveWith<OutlinedBorder>((states) {
      if (states.contains(WidgetState.hovered) &&
          styleOptions?.hoverBorderSide != null) {
        return RoundedRectangleBorder(
          borderRadius:
          styleOptions?.borderRadius ?? BorderRadius.circular(8),
          side: styleOptions?.hoverBorderSide ?? BorderSide.none
        );
      }

      return RoundedRectangleBorder(
        borderRadius:
        styleOptions?.borderRadius ?? BorderRadius.circular(8),
        side: styleOptions?.borderSide ?? BorderSide.none,
      );
    });
  }

  WidgetStateProperty<Color?> buildForegroundColor() {
    return WidgetStateProperty.resolveWith<Color?>((states) {
      bool isDisabled = states.contains(WidgetState.disabled);
      bool isHovered = states.contains(WidgetState.hovered);
      
      if (isDisabled && isHovered) {
        return styleOptions?.disabledHoveredForegroundColor;
      }
      
      if (isDisabled) {
        return styleOptions?.disabledForegroundColor;
      }
      
      if (isHovered) {
        return styleOptions?.hoveredForegroundColor;
      }
      
      return styleOptions?.foregroundColor;
    });
  }

  WidgetStateProperty<Color?> buildBackgroundColor() {
    return WidgetStateProperty.resolveWith<Color?>((states) {
      bool isDisabled = states.contains(WidgetState.disabled);
      bool isHovered = states.contains(WidgetState.hovered);

      if (isDisabled && isHovered) {
        return styleOptions?.disabledHoveredBackgroundColor;
      }

      if (isDisabled) {
        return styleOptions?.disabledBackgroundColor;
      }

      if (isHovered) {
        return styleOptions?.hoveredBackgroundColor;
      }

      return styleOptions?.backgroundColor;
    });
  }

  WidgetStateProperty<Color?> buildOverlayColor() {
    return WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.pressed)) {
        return styleOptions?.splashColor;
      }
      return null;
    });
  }

  WidgetStateProperty<EdgeInsetsGeometry> buildPadding() {
    return WidgetStateProperty.all(
        options?.padding ?? const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0)
    );
  }

  WidgetStateProperty<double?> buildElevation() {
    return WidgetStateProperty.resolveWith<double?>((states) {
      if (states.contains(WidgetState.hovered) &&
          styleOptions?.hoverElevation != null) {
        return styleOptions?.hoverElevation!;
      }
      return styleOptions?.elevation;
    });
  }

  ButtonStyle buildButtonStyle() {
    return ButtonStyle(
      textStyle: options?.textStyle != null ? WidgetStateProperty.all(options!.textStyle) : null,
      backgroundColor: buildBackgroundColor(),
      foregroundColor: buildForegroundColor(),
      overlayColor: buildOverlayColor(),
      shadowColor: options?.shadowColor != null ? WidgetStateProperty.all(options!.shadowColor) : null,
      surfaceTintColor: options?.surfaceTintColor != null ? WidgetStateProperty.all(options!.surfaceTintColor) : null,
      elevation: buildElevation(),
      padding: buildPadding(),
      minimumSize: options?.minimumSize != null ? WidgetStateProperty.all(options!.minimumSize) : null,
      fixedSize: options?.fixedSize != null ? WidgetStateProperty.all(options!.fixedSize) : null,
      maximumSize: options?.maximumSize != null ? WidgetStateProperty.all(options!.maximumSize) : null,
      iconColor: options?.iconColor != null ? WidgetStateProperty.all(options!.iconColor) : null,
      iconSize: options?.iconSize != null ? WidgetStateProperty.all(options!.iconSize) : null,
      side: options?.side != null ? WidgetStateProperty.all(options!.side) : null,
      shape: buildShape(),
      mouseCursor: options?.mouseCursor != null ? WidgetStateProperty.all(options!.mouseCursor) : null,
      visualDensity: options?.visualDensity,
      tapTargetSize: options?.tapTargetSize,
      animationDuration: options?.animationDuration,
      enableFeedback: options?.enableFeedback,
      alignment: options?.alignment,
      splashFactory: options?.splashFactory,
    );
  }
}

class CoreBaseButtonState extends State<CoreBaseButton<CoreBaseButtonState>> {
  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   updateFormIfAny();
    // });
  }

  // void updateFormIfAny() {
  //   final formState = context.findAncestorStateOfType<EspoBaseFormState>();
  //
  //   if (formState is EspoBaseFormState) {
  //     if (widget.id == null){
  //       Type formType = formState.widget.runtimeType;
  //       throw Exception('Form $formType does not support form fields without id (${widget.runtimeType})');
  //     }
  //
  //     if (formState.mounted) {
  //       if (formState.formFields.containsKey(widget.id!)) {
  //         formState.formFields[widget.id!] = this;
  //       }
  //
  //       if (mapValues!.isNotEmpty) {
  //         for(String key in mapValues!.keys) {
  //           formState.setFieldValue(key, mapValues![key]);
  //         }
  //       } else {
  //         formState.setFieldValue(widget.id!, _value);
  //       }
  //     }
  //   }
  // }
  //
  // void unmountFromFormIfAny() {
  //   if (widget.id != null) {
  //     final formState = context.findAncestorStateOfType<EspoBaseFormState>();
  //     if (formState is EspoBaseFormState) {
  //       if (formState.mounted) {
  //         if (formState.formFields.containsKey(widget.id!)) {
  //           formState.formFields.remove(widget.id!);
  //         }
  //       }
  //     }
  //   }
  // }

  @override
  void dispose() {
    // unmountFromFormIfAny();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.buildButton(context, this);
  }
}