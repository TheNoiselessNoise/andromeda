import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

// TODO: initialValue from URL

class AndromedaImageFieldProps extends MapTraversable {
  const AndromedaImageFieldProps(super.data);

  String? get id => get('id');
  String? get placeholder => get('placeholder');
  bool? get allowMultiple => get('allowMultiple');
  String? get label => get('label');
  double? get maxSizeInMB => get('maxSizeInMB');
  BoxFit? get previewFit => boxFitFromString(get('previewFit'));
  double? get previewWidth => get('previewWidth');
  double? get previewHeight => get('previewHeight');
}

class AndromedaImageFieldWidget extends AndromedaWidget {
  static const String id = 'ImageField';
  
  AndromedaImageFieldWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaImageFieldWidgetState createState() => AndromedaImageFieldWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaImageFieldProps(ctx.props);

    return CoreImageField(
      id: prop.id ?? uniqId,
      // TODO: initialValue: prop.initialValue,
      allowMultiple: prop.allowMultiple,
      label: prop.label,
      maxSizeInMB: prop.maxSizeInMB,
      previewFit: prop.previewFit,
      previewWidth: prop.previewWidth,
      previewHeight: prop.previewHeight,
    );
  }
}

class AndromedaImageFieldWidgetState extends AndromedaWidgetState<AndromedaImageFieldWidget> {}