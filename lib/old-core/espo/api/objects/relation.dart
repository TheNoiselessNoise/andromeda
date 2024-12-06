import 'package:andromeda/old-core/core.dart';

abstract class EspoEntityRelationMapBase<T extends EspoEntityListBase, S extends EspoEntityListBase> extends MapTraversable {
  T? primary;
  S? related;
  String? field;

  EspoEntityRelationMapBase(super.data, {
    this.primary,
    this.related,
    this.field,
  });

  Map<String, dynamic> toMap() {
    return {
      'primary': primary?.toMap(),
      'related': related?.toMap()
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  S? getRelated(String? id) {
    if (id != null) {
      Map<String, S> map = toRelationMap();

      if (map.containsKey(id)) {
        return map[id]!;
      }
    }

    return null;
  }

  Map<String, S> toRelationMap() {
    if (primary == null || related == null) return {};

    Map<String, S> map = {};
    for (EspoEntityBase? entity in primary!.list) {
      if (entity == null) continue;
      String? id = entity.id;

      if (!map.containsKey(id)) {
        map[id] = EspoEntityList.empty() as S;
      }

      for (EspoEntityBase? relatedEntity in related!.list) {
        if (relatedEntity == null) continue;
        String relatedId = relatedEntity.getString('${field}Id');
        if (relatedId.isNotEmpty && id == relatedId) {
          map[id]!.list.add(relatedEntity);
        }
      }
    }

    return map;
  }

  factory EspoEntityRelationMapBase.fromLists(T primary, S related, [String? field]) {
    throw UnimplementedError("fromLists must be implemented in subclass");
  }

  factory EspoEntityRelationMapBase.fromRawData(Map<String, dynamic> json) {
    throw UnimplementedError("fromRawData must be implemented in subclass");
  }

  factory EspoEntityRelationMapBase.fromMapData(Map<String, dynamic> map) {
    throw UnimplementedError("fromMapData must be implemented in subclass");
  }

  static Future<EspoEntityRelationMapBase?> fromStorage(String key, [StorageService? storage]) async {
    String? jsonString = await (storage ?? AppConfig.defaultDataStorage).getString(key);
    if (jsonString.isEmpty) return null;
    final jsonObject = jsonDecode(jsonString);
    if (jsonObject == null) return null;
    return EspoEntityRelationMapBase.fromMapData(jsonObject);
  }

  Future<void> toStorage(String key, [StorageService? storage]) async {
    return await (storage ?? AppConfig.defaultDataStorage).setString(key, toJson());
  }
}

class EspoEntityRelationMap<T extends EspoEntityList<EspoEntity>, S extends EspoEntityList<EspoEntity>> extends EspoEntityRelationMapBase<T, S> {
  EspoEntityRelationMap(super.data, {
    super.primary,
    super.related,
    super.field,
  });

  factory EspoEntityRelationMap.fromMapData(Map<String, dynamic> map) {
    return EspoEntityRelationMap(const {},
      primary: EspoEntityList.fromMapData(mapListWalker(map, 'primary')) as T,
      related: EspoEntityList.fromMapData(mapListWalker(map, 'related')) as S,
      field: mapListWalker(map, 'field')
    );
  }

  factory EspoEntityRelationMap.fromLists(T primary, S related, [String? field]) {
    return EspoEntityRelationMap(const {},
      primary: primary,
      related: related,
      field: field
    );
  }

  static Future<EspoEntityRelationMap?> fromStorage(String key, [StorageService? storage]) async {
    String? jsonString = await (storage ?? AppConfig.defaultDataStorage).getString(key);
    if (jsonString.isEmpty) return null;
    final jsonObject = jsonDecode(jsonString);
    if (jsonObject == null) return null;
    return EspoEntityRelationMap.fromMapData(jsonObject);
  }
}