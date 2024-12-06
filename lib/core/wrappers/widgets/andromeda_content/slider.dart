import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaSliderFieldProps extends MapTraversable {
  const AndromedaSliderFieldProps(super.data);

  String? get id => get('id');
  double? get initialValue => get('initialValue');
  int? get divisions => get('divisions');
  String? get label => get('label');
  double? get min => get('min');
  double? get max => get('max');
  dynamic get valueLabel => get('valueLabel');
}

class AndromedaSliderFieldWidget extends AndromedaWidget {
  static const String id = 'SliderField';
  
  AndromedaSliderFieldWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaSliderFieldWidgetState createState() => AndromedaSliderFieldWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaSliderFieldProps(ctx.props);

    return CoreSliderField(
      id: prop.id ?? uniqId,
      initialValue: prop.initialValue,
      divisions: prop.divisions,
      label: prop.label,
      min: prop.min,
      max: prop.max,
      valueLabel: ctx.prepareCustomHandler(prop.valueLabel, 1),
    );
  }
}

class AndromedaSliderFieldWidgetState extends AndromedaWidgetState<AndromedaSliderFieldWidget> {}