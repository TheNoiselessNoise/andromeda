import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

abstract class CoreComponentableStatefulWidget extends CoreBaseStatefulWidget {
  final JsonC component;
  final ParentContext parentContext;

  const CoreComponentableStatefulWidget({
    super.key,
    required this.component,
    required this.parentContext,
  });

  @override
  State<StatefulWidget> createState();
}

abstract class CoreComponentableState<T extends CoreComponentableStatefulWidget> extends CoreBaseState<T> {
  JsonC get component => widget.component;
  ParentContext get parentContext => widget.parentContext;

  @override
  bool isComponent() => true;

  Widget buildHeaderComponent(JsonC headerComponent) {
    return CWBuilder.build(context, headerComponent, parentContext);
  }

  Widget buildFooterComponent(JsonC footerComponent) {
    return CWBuilder.build(context, footerComponent, parentContext);
  }
}