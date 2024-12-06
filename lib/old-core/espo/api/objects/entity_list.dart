import 'package:andromeda/old-core/core.dart';

abstract class EspoEntityListBase<T extends EspoEntityBase> extends MapTraversable {
  int total = 0;
  List<T> list = [];
  String? entityType;

  EspoEntityListBase(super.data, {
    this.entityType,
    this.total = 0,
    this.list = const [],
  });

  T get first => list.first;
  T get last => list.last;
  bool get isEmpty => list.isEmpty;
  bool get isNotEmpty => list.isNotEmpty;

  T? firstWhereField(String field, dynamic value) {
    try {
      return list.firstWhere((entity) => entity.get(field) == value);
    } catch (e) {
      return null;
    }
  }

  T? firstWhere(bool Function(T?) test) {
    try {
      return list.firstWhere((entity) => test(entity));
    } catch (e) {
      return null;
    }
  }

  List<T?> where(bool Function(T?) test) {
    return list.where((entity) => test(entity)).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'entityType': entityType,
      'total': total,
      'list': list.map((e) => e.toMap()).toList()
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory EspoEntityListBase.empty() {
    throw UnimplementedError("empty must be implemented in subclass");
  }

  factory EspoEntityListBase.fromRawData(Map<String, dynamic> json, [String? entityType]) {
    throw UnimplementedError("fromRawData must be implemented in subclass");
  }

  factory EspoEntityListBase.fromMapData(Map<String, dynamic> map) {
    throw UnimplementedError("fromMapData must be implemented in subclass");
  }

  static Future<EspoEntityListBase?> fromStorage(String key, [StorageService? storage]) async {
    String? jsonString = await (storage ?? AppConfig.defaultDataStorage).getString(key);
    if (jsonString.isEmpty) return null;
    final jsonObject = jsonDecode(jsonString);
    if (jsonObject == null) return null;
    return EspoEntityList.fromMapData(jsonObject);
  }

  Future<void> toStorage(String key, [StorageService? storage]) async {
    return await (storage ?? AppConfig.defaultDataStorage).setString(key, toJson());
  }

  T? getByIndex(int? index) {
    if (index == null) return null;
    return index >= 0 && index < list.length ? list[index] : null;
  }

  T? getById(String? id) {
    if (id == null) return null;
    for(T? entity in list) {
      if (entity?.id == id) return entity;
    }
    return null;
  }

  void add(T? entity) {
    if (entity != null) {
      list.add(entity);
    }
  }

  void addAll(List<T> entities) {
    list.addAll(entities);
  }
}

class EspoEntityList<T extends EspoEntityBase> extends EspoEntityListBase<T> {
  EspoEntityList(super.data, {
    super.entityType,
    super.total = 0,
    super.list = const []
  });

  factory EspoEntityList.empty() {
    return EspoEntityList(const {},
      total: 0,
      list: []
    );
  }

  factory EspoEntityList.fromMapData(Map<String, dynamic> map, [String? entityType]) {
    return EspoEntityList<T>(map,
      total: mapListWalker(map, 'total') ?? 0,
      list: (mapListWalker(map, 'list') ?? []).map<EspoEntity>((e) => EspoEntity.fromMapData({
        'entityType': entityType,
        'data': e
      })).toList(),
      entityType: entityType
    );
  }

  static Future<EspoEntityList<EspoEntity>?> fromStorage(String key, [StorageService? storage]) async {
    String? jsonString = await (storage ?? AppConfig.defaultDataStorage).getString(key);
    if (jsonString.isEmpty) return null;
    final jsonObject = jsonDecode(jsonString);
    if (jsonObject == null) return null;
    return EspoEntityList.fromMapData(jsonObject);
  }
}