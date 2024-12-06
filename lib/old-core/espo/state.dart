import 'package:collection/collection.dart';
import 'package:andromeda/old-core/core.dart';

enum EspoEntityChangeType {
  create,
  update,
  delete,
}

class EspoEntityChange extends MapTraversable {
  EspoEntityChange(super.data);

  DateTime get changedAt => getDateTime('changedAt') ?? DateTime.now();

  bool get isCreate => type.toUpperCase() == RequestType.post.toUpperCase();
  bool get isUpdate => type.toUpperCase() == RequestType.put.toUpperCase();
  bool get isDelete => type.toUpperCase() == RequestType.delete.toUpperCase();

  String get id => getString('id');
  String get type => getString('type');
  EspoEntityChangeType? get changeType {
    if (isCreate) return EspoEntityChangeType.create;
    if (isUpdate) return EspoEntityChangeType.update;
    if (isDelete) return EspoEntityChangeType.delete;
    return null;
  }
  Map<String, dynamic> get entityData => getMap('entityData');
  Map<String, dynamic> get changeData => getMap('changeData');

  EspoEntity get entity => EspoEntity.fromMapData(entityData);

  factory EspoEntityChange.entityCreate(EspoEntity entity, [Map<String, dynamic> additionalData = const {}]) {
    EspoEntity entityWithChanges = entity.newWith(additionalData);
    return EspoEntityChange({
      'id': entity.key,
      'type': RequestType.post,
      'entityData': entityWithChanges.toMap(),
      'changeData': entityWithChanges.data,
      'changedAt': DateTime.now().toIso8601String(),
    });
  }

  factory EspoEntityChange.entityUpdate(EspoEntity entity, [Map<String, dynamic> changes = const {}]) {
    return EspoEntityChange({
      'id': entity.key,
      'type': RequestType.put,
      'entityData': entity.toMap(),
      'changeData': changes,
      'changedAt': DateTime.now().toIso8601String(),
    });
  }

  factory EspoEntityChange.entityDelete(EspoEntity entity) {
    return EspoEntityChange({
      'id': entity.key,
      'type': RequestType.delete,
      'entityData': entity.toMap(),
      'changeData': const {},
      'changedAt': DateTime.now().toIso8601String(),
    });
  }

  @override
  String toString() {
    return 'EspoEntityChange(id: $id, type: $type, entityType: ${entity.entityType})';
  }
}

class EspoGlobalState {
  // storage for entity lists <entityType, entityList>
  Map<String, EspoEntityList<EspoEntity>>? entityLists;

  // storage for individual entities <entityType:entityId, entity>
  Map<String, EspoEntity>? entities;

  EspoMetadata? metadata;

  // storage for entity changes, <changeId, change>
  Map<String, EspoEntityChange>? entityChanges;

  // storage for new entities <entityType, entity>
  Map<String, EspoEntity>? newEntities = {};

  ParentContext? currentParentContext;

  EspoGlobalState({
    this.entityLists,
    this.entities,
    this.metadata,
    this.entityChanges,
    this.newEntities,
    this.currentParentContext,
  });

  EspoGlobalState updateWith(EspoGlobalState newState) {
    return EspoGlobalState(
      entityLists: newState.entityLists ?? entityLists,
      entities: newState.entities ?? entities,
      metadata: newState.metadata ?? metadata,
      entityChanges: newState.entityChanges ?? entityChanges,
      newEntities: newState.newEntities ?? newEntities,
      currentParentContext: newState.currentParentContext ?? currentParentContext,
    );
  }
}

class EspoGlobalBloc extends GlobalBlocInstance<EspoGlobalState> {
  EspoGlobalBloc() : super(EspoGlobalState());

  @override
  Future<void> initStateLogic() async {
    // await loadMetadata();
  }

  @override
  void updateState(EspoGlobalState newState) {
    emit(state.updateWith(newState));
  }

  void addCreateChange(EspoEntity entity, [Map<String, dynamic> newData = const {}]) {
    addToEntities(entity);
    addEntityChange(
      getExistingChange(entity, EspoEntityChangeType.create) ??
      EspoEntityChange.entityCreate(entity, newData)
    );
  }

  void addUpdateChange(EspoEntity entity, [Map<String, dynamic> newData = const {}]) {
    addToEntities(entity);
    addEntityChange(
      getExistingChange(entity, EspoEntityChangeType.update) ??
      EspoEntityChange.entityUpdate(entity, newData)
    );
  }

  void setParentContext(ParentContext parentContext) {
    updateState(EspoGlobalState(currentParentContext: parentContext));
  }

  EspoEntityChange? getExistingChange(EspoEntity entity, EspoEntityChangeType type) {
    return state.entityChanges?.values.firstWhereOrNull((change) {
      return change.entity.key == entity.key && change.changeType == type;
    });
  }

  EspoEntity getNewEntity(String entityType) {
    EspoEntity? entity = state.entities?.values.firstWhereOrNull((e) {
      return e.entityType == entityType && e.isNew;
    });

    if (entity == null) {
      entity = EspoEntity(entityType, {
        'id': Generator.rNumericString(8, '__new__')
      });
      addToEntities(entity);
    }

    return entity;
  }

  void addEntityList(EspoEntityList<EspoEntity> entityList) {
    updateState(EspoGlobalState(
      entityLists: {
        ...state.entityLists ?? {},
        entityList.entityType!: entityList
      }
    ));
  }

  EspoEntity? getEntityById(String entityType, String id, [EspoEntity? defaultEntity]) {
    EspoEntity? fromEntities = state.entities?["${entityType}_$id"];
    EspoEntity? fromEntityList = state.entityLists?[entityType]?.getById(id);
    EspoEntity? finalEntity = fromEntities ?? fromEntityList ?? defaultEntity;
    finalEntity?.entityType = entityType;
    return finalEntity;
  }

  void setMetadata(EspoMetadata? metadata) {
    updateState(EspoGlobalState(metadata: metadata));
  }

  void addToNewEntities(EspoEntity? entity) {
    if (entity == null) return;
    Map<String, EspoEntity>? newEntities = Map<String, EspoEntity>.from(state.newEntities ?? {});
    newEntities[entity.key] = entity;
    updateState(EspoGlobalState(newEntities: newEntities));
  }

  void addToEntities(EspoEntity? entity) {
    if (entity == null) return;
    Map<String, EspoEntity>? newEntities = Map<String, EspoEntity>.from(state.entities ?? {});
    newEntities[entity.key] = entity;
    updateState(EspoGlobalState(entities: newEntities));
  }

  void removeEntity(EspoEntity entity) {
    if (entity.entityType.isEmpty || entity.id.isEmpty) return;
    Map<String, EspoEntity>? newEntities = Map<String, EspoEntity>.from(state.entities ?? {});
    newEntities.remove(entity.key);
    updateState(EspoGlobalState(entities: newEntities));
  }

  void removeEntityField(EspoEntity entity, String field) {
    if (entity.entityType.isEmpty || entity.id.isEmpty) return;
    EspoEntity? oldEntity = state.entities?[entity.key];
    if (oldEntity == null) return;
    Map<String, dynamic> newEntityData = Map<String, dynamic>.from(oldEntity.data);
    newEntityData.remove(field);
    Map<String, EspoEntity>? newEntities = Map<String, EspoEntity>.from(state.entities ?? {});
    newEntities[entity.key] = EspoEntity(entity.entityType, newEntityData);
    updateState(EspoGlobalState(entities: newEntities));
  }

  EspoEntity? getEntity([EspoEntity? fromEntity, EspoEntity? defaultEntity]) {
    if (fromEntity == null) return defaultEntity;
    EspoEntity? entity = state.entities?[fromEntity.key];
    return entity ?? defaultEntity ?? EspoEntity(fromEntity.entityType, const {});
  }

  void addEntityChange(EspoEntityChange change) {
    EspoEntityChange? oldChange = state.entityChanges?[change.id];

    oldChange?.merge(change);

    updateState(EspoGlobalState(entityChanges: {
      ...state.entityChanges ?? {},
      change.entity.key: oldChange ?? change
    }));
  }

  Future<void> fireEspoChange(EspoEntityChange change) async {
    await EspoApi.change(change);

    Map<String, EspoEntityChange> changes = Map<String, EspoEntityChange>.from(state.entityChanges ?? {});
    changes.remove(change.id);    

    updateState(EspoGlobalState(entityChanges: changes));
  }

  Future<void> fireEspoChanges() async {
    Map<String, EspoEntityChange> changes = Map<String, EspoEntityChange>.from(state.entityChanges ?? {});

    for (EspoEntityChange change in changes.values) {
      await EspoApi.change(change);
    }

    updateState(EspoGlobalState(entityChanges: {}));
  }

  JsonP getPageOr404([String? pageId]) {
    return PBuilder.getPageOr404(pageId);
  }

  // Future<CoreStateResult> loadMetadata() async {
  //   return await updateWrapper(() async {
  //     setMetadata(await EspoApiBridge.metadata());
  //   });
  // }

  Future<CoreStateResult> load() async {
    return await updateWrapper(() async {
      // await loadMetadata();
    });
  }
}
