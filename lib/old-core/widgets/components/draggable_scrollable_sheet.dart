import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

class CoreDraggableScrollableSheet extends CoreBaseStatefulWidget {
  final Widget child;

  const CoreDraggableScrollableSheet({super.key,
    required this.child
  });

  @override
  CoreDraggableScrollableSheetState createState() => CoreDraggableScrollableSheetState();
}

class CoreDraggableScrollableSheetState extends CoreBaseState<CoreDraggableScrollableSheet> {
  @override
  bool isComponent() => true;

  @override
  bool useBlocWrapper() => false;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      snap: true,
      initialChildSize: 1,
      builder: (_, controller) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            controller: controller,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                widget.child,
              ],
            ),
          ),
        );
      },
    );
  }
}