import 'package:andromeda/old-core/core.dart';

abstract class EspoEntityBase extends MapTraversable {
  String entityType;

  EspoEntityBase(
    this.entityType,
    super.data,
  );

  bool get isNew => id.isEmpty || id.startsWith("__new__");

  String get key => '${entityType}_$id';

  bool get deleted => getBool('deleted');
  String get id => getString('id');
  String get name => getString('name');
  String get description => getString('description');
  String get createdAt => getString('createdAt');
  String get modifiedAt => getString('modifiedAt');
  EntityFieldLink get createdBy => getLink('createdBy');
  EntityFieldLink get modifiedBy => getLink('modifiedBy');
  EntityFieldLink get assignedUser => getLink('assignedUser');
  EntityFieldLinkMultiple get teams => getLinkMultiple('teams');

  EntityFieldAttachment getAttachment(String field) {
    return EntityFieldAttachment(
      id: getString('${field}Id'),
      name: getString('${field}Name'),
      type: getString('${field}Type')
    );
  }

  EntityFieldAttachments getAttachments(String field) {
    return EntityFieldAttachments(
      ids: getList('${field}Ids'),
      names: getMap('${field}Names'),
      types: getMap('${field}Types')
    );
  }

  EntityFieldLinkMultiple getLinkMultiple(String field) {
    return EntityFieldLinkMultiple(
      ids: getList('${field}Ids'),
      names: getMap('${field}Names')
    );
  }

  EntityFieldLink getLink(String field) {
    return EntityFieldLink(
      id: getString('${field}Id'),
      name: getString('${field}Name')
    );
  }

  EntityFieldFile getFile(String field) {
    return EntityFieldFile(
        id: getString('${field}Id'),
        name: getString('${field}Name')
    );
  }

  EntityFieldImage getImage(String field) {
    return EntityFieldImage(
        id: getString('${field}Id'),
        name: getString('${field}Name')
    );
  }

  EntityFieldRelated getRelated(String field) {
    return EntityFieldRelated(
      id: getString('${field}Id'),
      name: getString('${field}Name'),
      type: getString('${field}Type')
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'entityType': entityType,
      'data': data
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory EspoEntityBase.fromRawData(Map<String, dynamic> json, [String? entityType]) {
    return EspoEntity(entityType ?? '<UNKNOWN>', json);
  }

  factory EspoEntityBase.fromMapData(Map<String, dynamic> map) {
    return EspoEntity(
      mapListWalker(map, 'entityType'),
      mapListWalker(map, 'data'),
    );
  }

  static Future<EspoEntityBase?> fromStorage(String key, [StorageService? storage]) async {
    String? jsonString = await (storage ?? AppConfig.defaultDataStorage).getString(key);
    if (jsonString.isEmpty) return null;
    final jsonObject = jsonDecode(jsonString);
    if (jsonObject == null) return null;
    return EspoEntity.fromMapData(jsonObject);
  }

  Future<void> toStorage(String key, [StorageService? storage]) async {
    return await (storage ?? AppConfig.defaultDataStorage).setString(key, toJson());
  }
}

class EspoEntity extends EspoEntityBase {
  EspoEntity(
    super.entityType,
    super.data,
  );

  EspoEntity newWith(Map<String, dynamic> newData) {
    return EspoEntity(entityType, {
      ...data,
      ...newData
    });
  }

  factory EspoEntity.fromMapData(Map<String, dynamic> map, [String? entityType]) {
    return EspoEntity(
      mapListWalker(map, 'entityType') ?? entityType,
      mapListWalker(map, 'data') ?? {},
    );
  }
}