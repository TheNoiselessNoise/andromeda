import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaRangeFieldProps extends MapTraversable {
  const AndromedaRangeFieldProps(super.data);

  String? get id => get('id');
  RangeValues? get initialValue => rangeValuesFromValue(get('initialValue'));
  int? get divisions => get('divisions');
  String? get label => get('label');
  double? get min => get('min');
  double? get max => get('max');
  bool? get showLabels => get('showLabels');
  dynamic get valueLabel => get('valueLabel');
}

class AndromedaRangeFieldWidget extends AndromedaWidget {
  static const String id = 'RangeField';
  
  AndromedaRangeFieldWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaRangeFieldWidgetState createState() => AndromedaRangeFieldWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaRangeFieldProps(ctx.props);

    return CoreRangeField(
      id: prop.id ?? uniqId,
      initialValue: prop.initialValue,
      divisions: prop.divisions,
      label: prop.label,
      min: prop.min,
      max: prop.max,
      showLabels: prop.showLabels,
      valueLabel: ctx.prepareCustomHandler(prop.valueLabel, 1),
    );
  }
}

class AndromedaRangeFieldWidgetState extends AndromedaWidgetState<AndromedaRangeFieldWidget> {}