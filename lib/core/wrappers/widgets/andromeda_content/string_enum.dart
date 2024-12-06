import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaStringEnumFieldProps extends MapTraversable {
  const AndromedaStringEnumFieldProps(super.data);

  String? get id => get('id');
  String? get initialValue => get('initialValue');
  List<String> get options => getList('options');
  String? get placeholder => get('placeholder');
  bool? get enableSearch => get('enableSearch');
  dynamic get labelBuilder => get('labelBuilder');
}

class AndromedaStringEnumFieldWidget extends AndromedaWidget {
  static const String id = 'StringEnumField';

  AndromedaStringEnumFieldWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaStringEnumFieldWidgetState createState() => AndromedaStringEnumFieldWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaStringEnumFieldProps(ctx.props);

    return CoreEnumField<String>(
      id: prop.id ?? uniqId,
      initialValue: prop.initialValue,
      enableSearch: prop.enableSearch,
      placeholder: prop.placeholder,
      options: prop.options,
      labelBuilder: ctx.prepareCustomHandler(prop.labelBuilder, 1),
    );
  }
}

class AndromedaStringEnumFieldWidgetState extends AndromedaWidgetState<AndromedaStringEnumFieldWidget> {}