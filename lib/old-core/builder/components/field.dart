import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

class ReadOnlyComponentField extends CoreBaseStatefulWidget {
  final JsonC component;
  final ParentContext parentContext;
  
  const ReadOnlyComponentField({super.key,
    required this.component,
    required this.parentContext,
  });

  @override
  ReadOnlyComponentFieldState createState() => ReadOnlyComponentFieldState();
}

class ReadOnlyComponentFieldState extends CoreBaseState<ReadOnlyComponentField> {
  @override
  bool isComponent() => true;

  @override
  bool useBlocWrapper() => false;

  JsonC get component => widget.component;

  ParentContext get parentContext => widget.parentContext;

  EspoEntity get entity => parentContext.entity!;

  Future<Widget> buildAttachmentMultiple(BuildContext context) async {
    EntityFieldAttachments attachments = entity.getAttachments(component.name);

    // EspoEntityList<EspoEntity>? photos = await EspoApiEntityBridge('Attachment')
    // .list(
    //   query: EspoApiQueryBuilder()
    //     .oneOf('id', attachments.ids)
    // );

    // if (photos == null || photos.list.isEmpty) return Text(stringEmptyValue);

    Map<String, File> files = await EspoApiBridge.imageFilesFromAttachments(attachments.ids);

    return EspoImageField(
      id: component.name,
      initialValue: files.values.toList(),
      readOnly: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    String? fieldType = context.metadata.getFieldType(entity.entityType, component.name);
    String value = C.STRING_EMPTY_VALUE;

    if (fieldType == EspoFieldType.Link) {
      value = entity.getLink(component.name).name;
    } else if (fieldType == EspoFieldType.Enum) {
      String newValue = entity.get(component.name, component.name);
      value = context.metadata.getI18nFieldOption(entity.entityType, component.name, newValue) ?? value;
    } else if (fieldType == EspoFieldType.Bool) {
      return Checkbox(
        value: entity.get(component.name),
        onChanged: (value) {},
      );
    } else if (fieldType == EspoFieldType.LinkMultiple) {
      EntityFieldLinkMultiple links = entity.getLinkMultiple(component.name);
      value = links.names.values.join(", ");
    } else if (fieldType == EspoFieldType.AttachmentMultiple) {
      return FutureBuilder<Widget>(
        future: buildAttachmentMultiple(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return snapshot.data ?? Text(value);
          }
        },
      );
    } else {
      dynamic newValue = entity.get(component.name);
      if (newValue != null) value = newValue.toString();
    }

    return CWBuilder.build(
      context,
      CBuilder.c(CTypes.text, { "value": value, ...component.info.textInfo.data }),
      parentContext
    );
  }
}

class EditableComponentField extends CoreBaseStatefulWidget {
  final JsonC component;
  final CoreBaseFormState formState;
  final EspoEntity entity;

  const EditableComponentField({super.key,
    required this.component,
    required this.formState,
    required this.entity,
  });

  @override
  EditableComponentFieldState createState() => EditableComponentFieldState();
}

class EditableComponentFieldState extends CoreBaseState<EditableComponentField> {
  bool inEditMode = false;
  bool changedManually = false;

  JsonFieldInfo get fieldInfo => widget.component.info.fieldInfo;

  String get name => widget.component.name;

  String get entityId => widget.entity.id;
  String get entityType {
    String? tmp = widget.component.overrideEntityType;
    if (fieldInfo.newEntity) tmp ??= coreState.currentPage?.entityType;
    return tmp ?? widget.entity.entityType;
  }

  EspoEntity get realEntity => espoBloc.getEntityById(entityType, entityId, widget.entity)!;

  dynamic get value => realEntity.get(widget.component.name);
  String? get fieldType => metadata.getFieldType(entityType, widget.component.name);

  EspoEntity? get changedEntity => espoBloc.getEntity(widget.entity, widget.entity);
  dynamic get changeValue => changedEntity?.get(widget.component.name);

  CoreEditingController? controller;

  dynamic currentlyChangedData;

  @override
  bool isComponent() => true;

  @override
  bool buildWhenEspo(EspoGlobalState previous, EspoGlobalState current) {
    if (changedManually) return false;
    EspoEntity existingEntity = realEntity;
    EspoEntity? prevEntity = previous.entities?[existingEntity.key];
    EspoEntity? currEntity = current.entities?[existingEntity.key];
    dynamic prevValue = prevEntity?.get(name);
    dynamic currValue = currEntity?.get(name);
    return prevValue != currValue;
  }

  Widget buildField() {
    if (fieldType == EspoFieldType.Link) {
      EntityFieldLink link = realEntity.getLink(name);
      EntityFieldLink changedLink = changedEntity?.getLink(name) ?? link;
      return Text(changedLink.name);
    }

    if (fieldType == EspoFieldType.LinkParent) {
      EntityFieldLink link = realEntity.getLink(name);
      EntityFieldLink changedLink = changedEntity?.getLink(name) ?? link;
      return Text(changedLink.name);
    }

    if (fieldType == EspoFieldType.LinkMultiple) {
      EntityFieldLinkMultiple links = realEntity.getLinkMultiple(name);
      EntityFieldLinkMultiple changedLinks = changedEntity?.getLinkMultiple(name) ?? links;
      return Text(changedLinks.names.values.join(", "));
    }

    return Text((changeValue ?? value ?? C.STRING_EMPTY_VALUE).toString());
  }

  void updateEntity(Map<String, dynamic> newData) {
    EspoEntity newEntity = realEntity.newWith(newData);
    espoBloc.addCreateChange(newEntity, newData);
    espoBloc.addUpdateChange(newEntity, newData);
  }

  Widget buildVarcharField() {
    return EspoVarcharField(
      id: name,
      initialValue: changeValue ?? value ?? '',
      onChanged: (value, fieldState) {
        currentlyChangedData = { name: value };
      },
    );
  }

  Widget buildEnumField() {
    List<dynamic> enumOptions = List<dynamic>.from(
      context.metadata.getEnumOptions(entityType, name)
    );
    
    enumOptions.insert(0, '');

    return EspoEnumField(
      id: name,
      items: enumOptions,
      initialValue: changeValue ?? value ?? '',
      onChanged: (value, fieldState) {
        currentlyChangedData = { name: value };
      },
    );
  }

  Widget buildIntField() {
    return EspoIntField(
      id: name,
      initialValue: changeValue ?? toInt(value) ?? 0,
      onChanged: (value, fieldState) {
        currentlyChangedData = { name: value };
      },
    );
  }

  Widget buildDateTimeField() {
    DateTime? initialDateTime;
    if (changeValue != null || value != null) {
      initialDateTime = DateTime.tryParse(changeValue ?? value);
    }
    return EspoDateTimeField(
      id: name,
      initialValue: initialDateTime ?? DateTime.now(),
      onChanged: (value, fieldState) {
        currentlyChangedData = { name: value };
      },
    );
  }

  Future<Widget> buildLinkField() async {
    EntityFieldLink link = realEntity.getLink(name);
    EntityFieldLink? changedLink = changedEntity?.getLink(name);

    String foreignEntity = metadata.getLinkParam(entityType, name, 'entity');

    EspoEntityList<EspoEntity>? items = await EspoApiEntityBridge(foreignEntity)
      .list();

    return EspoLinkField(
      id: name,
      entityType: entityType,
      initialValue: changedLink?.id ?? link.id,
      onChanged: (value, fieldState) {
        currentlyChangedData = {
          '${name}Id': value,
          '${name}Name': items.list.firstWhere((element) => element.id == value).get('name')
        };
      },
      items: items.list.whereType<EspoEntity>().toList(),
      fetchItems: (String searchTerm) async {
        EspoEntityList<EspoEntity>? searchItems = await EspoApiEntityBridge(foreignEntity)
          .list(
            query: EspoApiQueryBuilder()
              .like('name', '%$searchTerm%')
              .limit(20)
          );

        return searchItems.list.whereType<EspoEntity>().toList();
      },
    );
  }

  Future<Widget> buildLinkParentField() async {
    List<dynamic> what = metadata.getFieldParam(entityType, name, 'entityList', []);
    EntityFieldLink link = realEntity.getLink(name);
    EntityFieldLink? changedLink = changedEntity?.getLink(name);

    String currentEntityType = what.first;

    EspoEntityList<EspoEntity>? items = await EspoApiEntityBridge(
      currentEntityType
    ).list();

    return EspoLinkParentField(
      id: name,
      initialEntityType: currentEntityType,
      initialValue: changedLink?.id ?? link.id,
      onChanged: (value, fieldState) {
        currentlyChangedData = {
          '${name}Id': value,
          '${name}Name': items.list.firstWhereOrNull((element) => element.id == value)?.name
        };
      },
      items: items.list.whereType<EspoEntity>().toList(),
      fetchItems: (String searchTerm) async {
        EspoEntityList<EspoEntity>? searchItems = await EspoApiEntityBridge(currentEntityType)
           .list(
            query: EspoApiQueryBuilder()
              .like('name', '%$searchTerm%')
              .limit(20)
          );

        return searchItems.list.whereType<EspoEntity>().toList();
      },
    );
  }
  
  Future<Widget> buildLinkMultipleField() async {
    EntityFieldLinkMultiple links = realEntity.getLinkMultiple(name);
    EntityFieldLinkMultiple? changedLinks = changedEntity?.getLinkMultiple(name);
    String foreignEntity = metadata.getLinkParam(entityType, name, 'entity');          

    EspoEntityList<EspoEntity>? items = await EspoApiEntityBridge(foreignEntity)
      .list();

    return EspoLinkMultipleField(
      id: name,
      initialValue: changedLinks?.ids ?? links.ids,
      onChanged: (value, fieldState) {
        Map<String, dynamic> names = value?.asMap().map((index, id) {
          EspoEntity? item = items.list.firstWhereOrNull((element) => element.id == id);
          return MapEntry(id, item?.get('name'));
        }) ?? {};

        currentlyChangedData = {
          '${name}Ids': value,
          '${name}Names': names
        };
      },
      items: items.list.whereType<EspoEntity>().toList(),
      fetchItems: (String searchTerm) async {
        EspoEntityList<EspoEntity>? searchItems = await EspoApiEntityBridge(foreignEntity)
          .list(
            query: EspoApiQueryBuilder()
              .like('name', '%$searchTerm%')
              .limit(20)
          );

        return searchItems.list.whereType<EspoEntity>().toList();
      },
      isMultiple: fieldType == EspoFieldType.LinkMultiple,
    );
  }

  Future<Widget> buildEditField() async {
    if (fieldType == EspoFieldType.Varchar) {
      return buildVarcharField();
    }

    if (fieldType == EspoFieldType.Enum) {
      return buildEnumField();
    }

    if (fieldType == EspoFieldType.Number) {
      return buildVarcharField();
    }

    if (fieldType == EspoFieldType.Int) {
      return buildIntField();
    }

    if (fieldType == EspoFieldType.DateTime) {
      return buildDateTimeField();
    }

    if (fieldType == EspoFieldType.Link) {
      return buildLinkField();
    }

    if (fieldType == EspoFieldType.LinkMultiple) {
      return buildLinkMultipleField();
    }

    if (fieldType == EspoFieldType.LinkParent) {
      return buildLinkParentField();
    }

    if (fieldType == EspoFieldType.Foreign) {
      return buildField();
    }

    return Text("Field '$name' ($fieldType) not implemented");
  }

  @override
  Widget buildContent(BuildContext context) {
    Widget field = !inEditMode ? buildField() : FutureBuilder(
      future: buildEditField(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return snapshot.data ?? const Text('Error: Unknown');
        }
      },
    );

    return Row(
      children: [
        Expanded(child: field),
        IconButton(
          icon: Icon(inEditMode ? Icons.save : Icons.edit),
          onPressed: () {
            if (inEditMode && currentlyChangedData != null) {
              updateEntity(currentlyChangedData);
              currentlyChangedData = null;
            }

            setState(() {
              changedManually = true;
              inEditMode = !inEditMode;
            });
          },
        ),
        if (inEditMode) ...[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              espoBloc.removeEntityField(widget.entity, name);

              setState(() {
                inEditMode = false;
              });
            },
          ),
        ],
      ],
    );
  }
}
