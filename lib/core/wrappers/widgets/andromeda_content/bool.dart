import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaBoolFieldProps extends MapTraversable {
  const AndromedaBoolFieldProps(super.data);

  String? get id => get('id');
  bool? get initialValue => get('initialValue');
  bool get triState => getBool('triState', false);
  String? get label => get('label');
}

class AndromedaBoolFieldWidget extends AndromedaWidget {
  static const String id = 'BoolField';
  
  AndromedaBoolFieldWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaBoolFieldWidgetState createState() => AndromedaBoolFieldWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaBoolFieldProps(ctx.props);

    return CoreBoolField(
      id: prop.id ?? uniqId,
      initialValue: prop.initialValue,
      triState: prop.triState,
      label: prop.label,
    );
  }
}

class AndromedaBoolFieldWidgetState extends AndromedaWidgetState<AndromedaBoolFieldWidget> {}