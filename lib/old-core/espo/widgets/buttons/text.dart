import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

class EspoTextButton extends CoreBaseButton {
  const EspoTextButton({
    super.key,
    super.id,
    super.formKey,
    super.options,
    super.onPressed,
    super.onLongPress,
    super.child,
    super.disabled = false,
    super.styleOptions = const CoreButtonStyleOptions(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      disabledBackgroundColor: Colors.grey,
      disabledForegroundColor: Colors.black,
      hoveredBackgroundColor: Colors.black87,
      hoveredForegroundColor: Colors.white,
      disabledHoveredBackgroundColor: Colors.grey,
      disabledHoveredForegroundColor: Colors.black,
    ),
  });

  @override
  Widget buildButton(BuildContext context, CoreBaseButtonState state) {
    return TextButton(
      key: key,
      onPressed: disabled || onPressed == null ? null : () {
        onPressed!(state);
      },
      onLongPress: disabled || onLongPress == null ? null : () {
        onLongPress!(state);
      },
      style: buildButtonStyle(),
      child: child ?? Text(id ?? 'Button'),
    );
  }
}