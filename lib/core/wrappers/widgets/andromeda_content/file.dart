import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class AndromedaFileFieldProps extends MapTraversable {
  const AndromedaFileFieldProps(super.data);

  String? get id => get('id');
  bool? get allowMultiple => get('allowMultiple');
  FileType? get acceptedType => fileTypeFromString(get('acceptedType'));
  FWidget? get placeholder => get('placeholder');
  String? get label => get('label');
  double? get maxSizeInMB => get('maxSizeInMB');
}

class AndromedaFileFieldWidget extends AndromedaWidget {
  static const String id = 'FileField';
  
  AndromedaFileFieldWidget({super.key,
    required super.widgetDef,
    required super.environment,
    required super.evaluator,
    required super.parentInstance,
    super.children
  });

  @override
  AndromedaFileFieldWidgetState createState() => AndromedaFileFieldWidgetState();

  @override
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    final prop = AndromedaFileFieldProps(ctx.props);

    return CoreFileField(
      id: prop.id ?? uniqId,
      acceptedType: prop.acceptedType,
      allowMultiple: prop.allowMultiple,
      label: prop.label,
      maxSizeInMB: prop.maxSizeInMB,
      placeholder: ctx.render(prop.placeholder),
    );
  }
}

class AndromedaFileFieldWidgetState extends AndromedaWidgetState<AndromedaFileFieldWidget> {}