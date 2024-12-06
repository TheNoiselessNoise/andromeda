import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaFloatFieldProps extends MapTraversable {
  const AndromedaFloatFieldProps(super.data);

  String? get id => get('id');
  double? get initialValue => get('initialValue');
}

class AndromedaFloatFieldWidget extends AndromedaWidget {
  static const String id = 'FloatField';

  AndromedaFloatFieldWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaFloatFieldWidgetState createState() => AndromedaFloatFieldWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaFloatFieldProps(ctx.props);

    return CoreFloatField(
      id: prop.id ?? uniqId,
      initialValue: prop.initialValue,
    );
  }
}

class AndromedaFloatFieldWidgetState extends AndromedaWidgetState<AndromedaFloatFieldWidget> {}