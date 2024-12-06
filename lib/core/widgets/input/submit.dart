import 'package:flutter/material.dart';
import 'base/form.dart';

class CoreSubmitButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final Widget child;

  const CoreSubmitButton({
    super.key,
    this.onPressed,
    this.style,
    this.child = const Text('Submit'),
  });

  @override
  Widget build(BuildContext context) {
    final formScope = CoreFormScope.of(context);

    return ListenableBuilder(
      listenable: formScope.controller,
      builder: (context, _) {
        return ElevatedButton(
          style: style,
          onPressed: formScope.controller.isSubmitting
            ? null
            : () async {
              if (onPressed != null) {
                onPressed!();
              } else {
                final formState = context.findAncestorStateOfType<CoreBaseFormState>();
                if (formState != null) {
                  await formState.submitForm();
                }
              }
            },
          child: formScope.controller.isSubmitting
            ? const SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(strokeWidth: 2)
              )
            : child,
        );
      }
    );
  }
}