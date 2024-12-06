import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaDateTimeFieldProps extends MapTraversable {
  const AndromedaDateTimeFieldProps(super.data);

  String? get id => get('id');
  DateTime? get initialValue => dateTimeFromString(get('initialValue'));
  DateTime? get firstDate => dateTimeFromString(get('firstDate'));
  DateTime? get lastDate => dateTimeFromString(get('lastDate'));
  String? get placeholder => get('placeholder');
}

class AndromedaDateTimeFieldWidget extends AndromedaWidget {
  static const String id = 'DateTimeField';

  AndromedaDateTimeFieldWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaDateTimeFieldWidgetState createState() => AndromedaDateTimeFieldWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaDateTimeFieldProps(ctx.props);

    return CoreDateTimeField(
      id: prop.id ?? uniqId,
      initialValue: prop.initialValue,
      firstDate: prop.firstDate,
      lastDate: prop.lastDate,
      placeholder: prop.placeholder,
    );
  }
}

class AndromedaDateTimeFieldWidgetState extends AndromedaWidgetState<AndromedaDateTimeFieldWidget> {}