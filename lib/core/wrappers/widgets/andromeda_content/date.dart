import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaDateFieldProps extends MapTraversable {
  const AndromedaDateFieldProps(super.data);

  String? get id => get('id');
  DateTime? get initialValue => dateTimeFromString(get('initialValue'));
  DateTime? get firstDate => dateTimeFromString(get('firstDate'));
  DateTime? get lastDate => dateTimeFromString(get('lastDate'));
  String? get placeholder => get('placeholder');
}

class AndromedaDateFieldWidget extends AndromedaWidget {
  static const String id = 'DateField';
  
  AndromedaDateFieldWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaDateFieldWidgetState createState() => AndromedaDateFieldWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaDateFieldProps(ctx.props);

    return CoreDateField(
      id: prop.id ?? uniqId,
      initialValue: prop.initialValue,
      firstDate: prop.firstDate,
      lastDate: prop.lastDate,
      placeholder: prop.placeholder,
    );
  }
}

class AndromedaDateFieldWidgetState extends AndromedaWidgetState<AndromedaDateFieldWidget> {}