import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaPasswordFieldProps extends MapTraversable {
  const AndromedaPasswordFieldProps(super.data);

  String? get id => get('id');
  String? get initialValue => get('initialValue');
  String? get placeholder => get('placeholder');
  String? get label => get('label');
  bool? get showStrengthIndicator => get('showStrengthIndicator');
}

class AndromedaPasswordFieldWidget extends AndromedaWidget {
  static const String id = 'PasswordField';
  
  AndromedaPasswordFieldWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaPasswordFieldWidgetState createState() => AndromedaPasswordFieldWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaPasswordFieldProps(ctx.props);

    return CorePasswordField(
      id: prop.id ?? uniqId,
      initialValue: prop.initialValue,
      placeholder: prop.placeholder,
      label: prop.label,
      showStrengthIndicator: prop.showStrengthIndicator,
    );
  }
}

class AndromedaPasswordFieldWidgetState extends AndromedaWidgetState<AndromedaPasswordFieldWidget> {}