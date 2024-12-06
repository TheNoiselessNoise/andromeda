import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaColorFieldProps extends ContextableMapTraversable {
  const AndromedaColorFieldProps(super.context, super.data);

  String? get id => get('id');
  Color? get initialValue => themeColorFromString(get('initialValue'), context);
  String? get label => get('label');
  bool? get showAlpha => get('showAlpha');
  List<Color>? get presetColors => has('presetColors')
    ? getList('presetColors').map((e) => themeColorFromString(e, context)).whereType<Color>().toList()
    : null;
}

class AndromedaColorFieldWidget extends AndromedaWidget {
  static const String id = 'ColorField';

  AndromedaColorFieldWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaColorFieldWidgetState createState() => AndromedaColorFieldWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaColorFieldProps(ctx.context, ctx.props);

    return CoreColorField(
      id: prop.id ?? uniqId,
      initialValue: prop.initialValue,
      label: prop.label,
      showAlpha: prop.showAlpha,
      presetColors: prop.presetColors,
    );
  }
}

class AndromedaColorFieldWidgetState extends AndromedaWidgetState<AndromedaColorFieldWidget> {}