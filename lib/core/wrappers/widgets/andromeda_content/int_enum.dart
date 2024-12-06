import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

// TODO: something is wrong with the immediate callbacks (like labelBuilder)
// Undefined variable '$...'

class AndromedaIntEnumFieldProps extends MapTraversable {
  const AndromedaIntEnumFieldProps(super.data);

  String? get id => get('id');
  int? get initialValue => getIntOrNull('initialValue');
  List<int> get options => getList('options').map((e) => toInt(e)).whereType<int>().toList();
  String? get placeholder => get('placeholder');
  bool? get enableSearch => get('enableSearch');
  dynamic get labelBuilder => get('labelBuilder');
}

class AndromedaIntEnumFieldWidget extends AndromedaWidget {
  static const String id = 'IntEnumField';
  
  AndromedaIntEnumFieldWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaIntEnumFieldWidgetState createState() => AndromedaIntEnumFieldWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaIntEnumFieldProps(ctx.props);

    return CoreEnumField<int>(
      id: prop.id ?? uniqId,
      initialValue: prop.initialValue,
      enableSearch: prop.enableSearch,
      placeholder: prop.placeholder,
      options: prop.options,
      labelBuilder: ctx.prepareCustomHandler(prop.labelBuilder, 1),
    );
  }
}

class AndromedaIntEnumFieldWidgetState extends AndromedaWidgetState<AndromedaIntEnumFieldWidget> {}