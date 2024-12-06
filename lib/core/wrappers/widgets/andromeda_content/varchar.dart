import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaVarcharFieldProps extends MapTraversable {
  const AndromedaVarcharFieldProps(super.data);

  String? get id => get('id');
  String? get initialValue => get('initialValue');
  int? get maxLength => get('maxLength');
}

class AndromedaVarcharFieldWidget extends AndromedaWidget {
  static const String id = 'VarcharField';
  
  AndromedaVarcharFieldWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaVarcharFieldWidgetState createState() => AndromedaVarcharFieldWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaVarcharFieldProps(ctx.props);

    return CoreVarcharField(
      id: prop.id ?? uniqId,
      initialValue: prop.initialValue,
      maxLength: prop.maxLength,
    );
  }
}

class AndromedaVarcharFieldWidgetState extends AndromedaWidgetState<AndromedaVarcharFieldWidget> {}