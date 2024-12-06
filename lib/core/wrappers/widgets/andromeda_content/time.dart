import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaTimeFieldProps extends MapTraversable {
  const AndromedaTimeFieldProps(super.data);

  String? get id => get('id');
  TimeOfDay? get initialValue => timeOfDayFromString(get('initialValue'));
  String? get placeholder => get('placeholder');
}

class AndromedaTimeFieldWidget extends AndromedaWidget {
  static const String id = 'TimeField';
  
  AndromedaTimeFieldWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaTimeFieldWidgetState createState() => AndromedaTimeFieldWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaTimeFieldProps(ctx.props);

    return CoreTimeField(
      id: prop.id ?? uniqId,
      initialValue: prop.initialValue,
      placeholder: prop.placeholder,
    );
  }
}

class AndromedaTimeFieldWidgetState extends AndromedaWidgetState<AndromedaTimeFieldWidget> {}