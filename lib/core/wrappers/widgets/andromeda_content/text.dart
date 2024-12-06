import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaTextFieldProps extends MapTraversable {
  const AndromedaTextFieldProps(super.data);

  String? get id => get('id');
  String? get initialValue => get('initialValue');
}

class AndromedaTextFieldWidget extends AndromedaWidget {
  static const String id = 'TextField';
  
  AndromedaTextFieldWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaTextFieldWidgetState createState() => AndromedaTextFieldWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaTextFieldProps(ctx.props);

    return CoreTextField(
      id: prop.id ?? uniqId,
      initialValue: prop.initialValue,
    );
  }
}

class AndromedaTextFieldWidgetState extends AndromedaWidgetState<AndromedaTextFieldWidget> {}