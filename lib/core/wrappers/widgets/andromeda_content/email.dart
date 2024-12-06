import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaEmailFieldProps extends MapTraversable {
  const AndromedaEmailFieldProps(super.data);

  String? get id => get('id');
  String? get initialValue => get('initialValue');
  String? get label => get('label');
  String? get placeholder => get('placeholder');
  bool? get allowMultiple => get('allowMultiple');
  bool? get validate => get('validate');
}

class AndromedaEmailFieldWidget extends AndromedaWidget {
  static const String id = 'EmailField';
  
  AndromedaEmailFieldWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaEmailFieldWidgetState createState() => AndromedaEmailFieldWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaEmailFieldProps(ctx.props);

    return CoreEmailField(
      id: prop.id ?? uniqId,
      initialValue: prop.initialValue,
      placeholder: prop.placeholder,
      label: prop.label,
      allowMultiple: prop.allowMultiple,
      validate: prop.validate,
    );
  }
}

class AndromedaEmailFieldWidgetState extends AndromedaWidgetState<AndromedaEmailFieldWidget> {}