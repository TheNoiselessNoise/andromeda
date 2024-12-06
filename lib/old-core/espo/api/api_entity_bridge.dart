import 'package:andromeda/old-core/core.dart';

class EspoApiEntityBridge {
  final String entityType;

  EspoApiEntityBridge(this.entityType);

  Future<EspoEntityList<EspoEntity>> list({
    EspoApiQueryBuilder? query,
    Map<String, String>? headers
  }) async {
    query?.entityType ??= entityType;
    String search = query?.query != null ? '?${query!.build()}' : '';

    if (AppConfig.apiDebugMode) log(query?.query);
    if (AppConfig.apiDebugMode) log('LIST: $entityType$search');

    final response = await EspoApi.getApi(
      entityType + search,
      headers: headers
    );

    return EspoEntityList.fromMapData(
      response?.toJsonMap() ?? {},
      entityType
    );
  }

  Future<EspoEntity?> get({
    required String id,
    Map<String, String>? headers
  }) async {
    final response = await EspoApi.getApi(
      '$entityType/$id',
      headers: headers
    );

    return EspoEntity.fromMapData({
      'entityType': entityType,
      'data': response?.toJsonMap() ?? {}
    });
  }

  Future<EspoEntity?> create(Map<String, dynamic> data, {
    Map<String, String>? headers
  }) async {
    final response = await EspoApi.createEntity(
      entityType: entityType,
      data: data,
      headers: headers
    );

    return EspoEntity.fromMapData({
      'entityType': entityType,
      'data': response?.toJsonMap() ?? {}
    });
  }

  Future<EspoEntity?> update({
    required String? id,
    required Map<String, dynamic>? data,
    Map<String, String>? headers
  }) async {
    if (id == null) return null;
    if (data == null) return null;

    final response = await EspoApi.updateEntity(
      entityType: entityType,
      entityId: id,
      data: data,
      headers: headers
    );

    return EspoEntity.fromMapData({
      'entityType': entityType,
      'data': response?.toJsonMap() ?? {}
    });
  }

  Future<EspoEntity?> uploadImage({
    required String? field,
    required String? filePath,
    String? imageName,
  }) async {
    if (field == null) return null;
    if (filePath == null) return null;

    final response = await EspoApi.uploadAttachmentImage(
      parentType: entityType,
      field: field,
      filePath: filePath,
      imageName: imageName
    );

    return EspoEntity.fromMapData({
      'entityType': entityType,
      'data': response?.toJsonMap() ?? {}
    });
  }
}