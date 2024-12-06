import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaFormProps extends MapTraversable {
  const AndromedaFormProps(super.data);

  String? get id => get('id');
  Map<String, dynamic> get initialValues => getMap('initialValues');
}

class AndromedaFormWidget extends AndromedaWidget {
  static const String id = 'Form';
  
  AndromedaFormWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaFormWidgetState createState() => AndromedaFormWidgetState();
}

class AndromedaFormWidgetState extends AndromedaWidgetState<AndromedaFormWidget> {
  final GlobalKey<CoreBaseFormState> _formKey = GlobalKey<CoreBaseFormState>();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaFormProps(ctx.props);

    return CoreBaseForm(
      key: _formKey,
      id: prop.id ?? uniqId,
      initialValues: prop.initialValues,
      onError: ctx.prepareHandler('onError', 1),
      onSubmit: ctx.prepareHandler('onSubmit', 1),
      child: await ctx.firstChild,
    );
  }
}