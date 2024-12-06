import 'dart:async';
import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

class EspoPageComponentListBuilder extends CoreBaseStatefulWidget {
  final JsonC component;
  final ParentContext parentContext;

  const EspoPageComponentListBuilder({super.key,
    required this.component,
    required this.parentContext
  });

  @override
  EspoPageComponentListBuilderState createState() => EspoPageComponentListBuilderState();
}

class EspoPageComponentListBuilderState extends CoreBaseState<EspoPageComponentListBuilder> {
  @override
  bool isComponent() => true;

  JsonC get component => widget.component;
  JsonP get page => coreBloc.getCurrentPage();
  ParentContext get parentContext => widget.parentContext;
  String? get entityType {
    if (component.overrideEntityType != null) {
      return component.overrideEntityType;
    }

    if (parentContext.entity is EspoEntity) {
      return parentContext.entity!.entityType;
    }

    return page.entityType;
  }

  @override
  bool buildWhenEspo(EspoGlobalState previous, EspoGlobalState current) {
    EspoEntityList<EspoEntity>? prevList = previous.entityLists?[entityType];
    EspoEntityList<EspoEntity>? currList = current.entityLists?[entityType];
    return !hasCustomData && prevList != currList;
  }

  JsonListInfo get listInfo => component.info.listInfo;
  JsonListSettings get settings => listInfo.settings;

  bool _isFirstLoad = true;
  Timer? _timer;
  int refreshRate = 1000;
  bool isLoadingData = false;

  @override
  void initState() {
    super.initState();

    currentPage = settings.pagination.initial;
    currentLimit = listInfo.query.limit;

    if (listInfo.refresh.enabled) {
      refreshRate = listInfo.refresh.interval;
      _timer = Timer.periodic(
        Duration(milliseconds: refreshRate),
        (timer) => requestAndUpdateData()
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  StateSetter? settingsStateSetter;

  int currentPage = 0;
  int currentLimit = 5;
  // current filter values, e.g. varchar has two inputs (one for range, one for value)
  // <field, <range, [value1, value2, ...]>>
  Map<String, Map<String, List<dynamic>>> currentFilterValues = {};
  // controllers for each filter
  Map<String, ValueNotifier> filterControllers = {};
  // static initial filters loaded from JSON, immutable, used for every request
  List<JsonFilter> get defaultFilters => listInfo.query.defaultFilters;
  ScrollController scrollController = ScrollController();

  int get offset => currentPage * currentLimit;
  int get totalPages => (entityTotalCount / currentLimit).ceil();
  bool get hasCustomData => listInfo.customData.isNotEmpty;
  EspoEntityList<EspoEntity> get customEntityList => EspoEntityList.fromMapData({
    'total': listInfo.customData.length,
    'list': listInfo.customData
  }, entityType);

  EspoEntityList<EspoEntity> get entityList {
    if (hasCustomData) return customEntityList;
    if (entitiesExists) return espoState.entityLists![entityType]!;
    return EspoEntityList.empty();
  }
  bool get entitiesExists {
    return espoState.entityLists?.containsKey(entityType) ?? false;
  }
  int get entityTotalCount {
    if (listInfo.customData.isNotEmpty) return listInfo.customData.length;
    return entityList.total;
  }
  int get entityCurrentCount {
    if (listInfo.customData.isNotEmpty) return listInfo.customData.length;
    return entityList.list.length;
  }

  void nextPage() async {
    currentPage++;

    if (offset < entityTotalCount) {
      await requestAndUpdateData();
    } else {
      currentPage--;
    }
  }

  void prevPage() async {
    if (currentPage > 0) {
      currentPage--;
      await requestAndUpdateData();
    }
  }

  Widget buildGenericListPiece() {
    if (!listInfo.hasItemComponent) {
      return const Text('No item component specified in list');
    }

    if (listInfo.isCustomMode) {
      return CWBuilder.build(context, listInfo.itemComponent, parentContext);
    }

    return Text('Unknown list mode: ${listInfo.mode}');
  }

  Future<void> requestAndUpdateData() async {
    try {
      EspoEntityList<EspoEntity> data = await EspoApiEntityBridge(entityType!).list(
        query: EspoApiQueryBuilder()
          .addAllWhereMap(prepareDefaultFilters())
          .addAllWhereMap(prepareCurrentFilters())
          .orderBy(listInfo.query.order.by, listInfo.query.order.direction)
          .limit(currentLimit, offset)
      );

      int newTotalPages = (data.total / currentLimit).ceil();
      if (currentPage >= newTotalPages && newTotalPages > 0) {
        currentPage = totalPages - 1;
      }

      if (mounted) context.espoBloc.addEntityList(data);
    } catch (e) {
      return;
    }
  }

  Future<EspoEntityList<EspoEntity>> getEntityData() async {
    if (!entitiesExists) {
      await requestAndUpdateData();
    }
    return entityList;
  }

  Widget buildPaginationPiece() {
    if (settings.pagination.type.isEmpty) {
      return const SizedBox();
    }

    if (entityList.isEmpty) {
      if (listInfo.whenEmpty.hasPaginationComponent) {
        return CWBuilder.build(context, listInfo.whenEmpty.paginationComponent, parentContext);
      } else {
        return const SizedBox();
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: prevPage,
          )
        ),
        const SizedBox(width: 8),
        Text('${currentPage + 1} / $totalPages'),
        const SizedBox(width: 8),
        Expanded(
          child: IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: nextPage,
          )
        ),
      ],
    );
  }

  Widget buildEntityRecordPiece(EspoEntity entity, ParentContext pContext) {
    if (listInfo.isCustomMode) {
      return CWBuilder(context).buildComponent(context, listInfo.itemComponent, pContext);
    }

    return Text('Unknown list mode: ${listInfo.mode}');
  }

  Widget buildEntityListView(EspoEntityList<EspoEntity> data) {
    if (data.isEmpty && listInfo.whenEmpty.hasComponent) {
      return CWBuilder.build(context, listInfo.whenEmpty.component, parentContext);
    }

    List<Widget> children = data.list.map((entity) {
      espoBloc.addToEntities(entity);

      ParentContext newParentContext = parentContext.withEntity(entity);
      espoBloc.setParentContext(newParentContext);

      return InkWell(
        onTap: () async {
          if (listInfo.onItemTap.isEmpty) return;
          EspoEntity? entityDetail = await EspoApiEntityBridge(entityType!).get(id: entity.id);
          if (entityDetail == null && mounted) {
            CoreSnackbar.basic(context, "Failed to load entity detail");
            return;
          }
          ParentContext pContext = parentContext.withEntity(entityDetail!);
          espoBloc.setParentContext(pContext);
          if (mounted) context.espoBloc.addToEntities(entityDetail);
          if (mounted) ActionBuilder.call(context, listInfo.onItemTap, pContext);
        },
        onDoubleTap: () async {
          if (listInfo.onItemDoubleTap.isEmpty) return;
          EspoEntity? entityDetail = await EspoApiEntityBridge(entityType!).get(id: entity.id);
          if (entityDetail == null && mounted) {
            CoreSnackbar.basic(context, "Failed to load entity detail");
            return;
          }
          ParentContext pContext = parentContext.withEntity(entityDetail!);
          espoBloc.setParentContext(pContext);
          if (mounted) context.espoBloc.addToEntities(entityDetail);
          if (mounted) ActionBuilder.call(context, listInfo.onItemDoubleTap, pContext);
        },
        child: Container(
          // color: CoreTheme.of(context).secondaryBackground,
          child: buildEntityRecordPiece(entity, newParentContext),
        )
      );
    }).toList();

    if (listInfo.hasDivideBy) {
      Widget divideBy = CWBuilder.build(context, listInfo.divideBy, parentContext);
      children = children.divide(divideBy).toList();
    }

    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: const ScrollPhysics(),
      children: children,
    );
  }

  Widget buildEntityListPiece() {
    if (hasCustomData) {
      return buildEntityListView(customEntityList);
    }

    return FutureBuilder<EspoEntityList<EspoEntity>>(
      future: getEntityData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          if (_isFirstLoad) {
            return const CircularProgressIndicator();
          } else {
            EspoEntityList<EspoEntity> existing = espoState.entityLists?[entityType!] ?? EspoEntityList.empty();
            return buildEntityListView(existing);
          }
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.hasData) {
          _isFirstLoad = false;
          return buildEntityListView(snapshot.data!);
        }

        return const Text('Unknown error');
      },
    );
  }

  Future<void> setSettingsAndRequest(Function func) async {
    func();
    await requestAndUpdateData();
    if (settingsStateSetter != null) {
      settingsStateSetter!(() {});
    }
  }

  Widget buildLimitsPiece() {
    return Column(
      children: [
        DropdownButton<int>(
          value: currentLimit,
          items: settings.limits.options.map((e) {
            return DropdownMenuItem<int>(
              value: e,
              child: Text('$e items'),
            );
          }).toList(),
          onChanged: (value) async {
            setSettingsAndRequest(() {
              currentLimit = value!;
              currentPage = 0;
            });
          },
        ),
      ],
    );
  }

  List<Map<String, dynamic>> prepareDefaultFilters() {
    return defaultFilters.map((e) {
      return ArgumentParser.parseMap(context, e.toMap(), parentContext);
    }).toList(); 
  }

  List<Map<String, dynamic>> prepareCurrentFilters() {
    List<Map<String, dynamic>> currentFilters = [];

    for (String field in currentFilterValues.keys) {
      Map<String, List<dynamic>> values = currentFilterValues[field] ?? {};
      for (String range in values.keys) {
        currentFilters.add(
          EspoApiQueryParamBuilder.fromTypeFieldValue(range, field, values[range] ?? [])
        );
      }
    }

    return currentFilters;
  }

  void unsetListFilter(String field) {
    currentFilterValues.remove(field);
  }

  void unsetListFilterRange(String field, String range) {
    currentFilterValues[field]?.remove(range);
  }

  void setListFilterValue(String field, String range, dynamic value) {
    currentFilterValues[field] = {
      range: value is List ? value : [value]
    };
  }

  void setListFilterValueAt(String field, String range, dynamic value, int index) {
    List<dynamic>? values = currentFilterValues[field]?[field] ?? [];
    if (values.length <= index){
      values.add(value);
    } else {
      values[index] = value;
    }
  }

  dynamic getListFilterValueAt(String field, String range, int index) {
    List<dynamic>? values = currentFilterValues[field]?[field] ?? [];
    if (values.length <= index) return null;
    return values[index];
  }

  Widget buildSettingsFilterPiece() {
    return Column(
      children: settings.filters.fields.keys.map((field) {
        String? fieldType = context.metadata.getFieldType(entityType!, field);

        if (fieldType == null) {
          return Text('Unknown field type: $field');
        }

        List<dynamic>? definedSearchRanges = settings.filters.fields[field];
        if (definedSearchRanges?.isEmpty ?? false) {
          definedSearchRanges = SearchRanges.getSearchRanges(fieldType);
        }
        definedSearchRanges ??= [];

        return buildSettingsFilterField(
          field,
          fieldType,
          List<String>.from(definedSearchRanges)
        );
      }).toList(),
    );
  }

  Widget buildSettingsFilterField(String fieldName, String fieldType, [List<String> searchRanges = const []]) {
    String fieldLabel = Translator.field(context, entityType!, fieldName);

    return CoreBaseForm(
      builder: (key, context, state) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(fieldLabel,
                    style: const TextStyle(fontSize: 18),
                  )
                ),
              ],
            ),

            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ListFilterWidget(
                    entityType: entityType!,
                    field: fieldName,
                    fieldType: fieldType,
                    searchRanges: searchRanges,
                    formState: state,
                    listState: this,
                  )
                ),

                Expanded(
                  flex: 0,
                  child: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setSettingsAndRequest(() {
                        currentFilterValues.remove(fieldName);
                        state.unsetFieldValue(fieldName);

                        filterControllers[fieldName]?.value = const TextEditingValue(
                          text: '',
                          selection: TextSelection.collapsed(offset: 0)
                        );
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      }
    );
  }
 
  Widget centeredTitle(String title) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
      ),
    );
  }

  Widget centeredMainTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24),
        ),
      ),
    );
  }

  Widget buildSettingsInformation() {
    String entityName = Translator.entitySingular(context, entityType!);

    return Column(
      children: [
        Text('Entity: $entityType${entityName.isEmpty ? '' : ' ($entityName)'}'),
        Text('Total: $entityTotalCount'),
        Text('Filtered: $entityCurrentCount'),
      ],
    );
  }

  Widget buildSettingsContent() {
    bool enableSettings = settings.filters.fields.isNotEmpty || settings.limits.enabled;

    return Column(
      children: [
        if (settings.information.enabled) ...[
          centeredMainTitle('Information'),
          buildSettingsInformation(),
        ],

        if (enableSettings) ...[
          centeredMainTitle('Settings'),

          if (settings.limits.enabled) ...[
            centeredTitle('Limit'),
            const Divider(),
            buildLimitsPiece(),
            const SizedBox(height: 32),
          ],

          if (settings.filters.enabled && settings.filters.fields.isNotEmpty) ...[
            centeredTitle('Filters'),
            const Divider(),
            buildSettingsFilterPiece(),
          ],
        ],
      ],
    ).pad(16, 0, 16, 0);
  }

  Widget buildListSettingsPiece() {
    bool renderPagination = settings.pagination.enabled;
    bool showSettings = settings.shouldShowSettings;

    return Container(
      // color: CoreTheme.of(context).accent1,
      child: Column(
        children: [
          Row(
            children: [
              if (renderPagination)
                Expanded(child: buildPaginationPiece()),

              if (showSettings)
                Expanded(
                  flex: renderPagination ? 0 : 1,
                  child: Container(
                    // color: CoreTheme.of(context).accent2,
                    child: IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewInsets.bottom
                              ),
                              child: DraggableScrollableSheet(
                                expand: false,
                                snap: true,
                                initialChildSize: 0.85,
                                builder: (_, controller) {
                                  return Container(
                                    padding: const EdgeInsets.all(16),
                                    child: SingleChildScrollView(
                                      controller: controller,
                                      child: StatefulBuilder(
                                        builder: (context, stateSetter) {
                                          settingsStateSetter = stateSetter;
                                          return buildSettingsContent();    
                                        },
                                      ),
                                    ),
                                  );
                                }
                              ),
                            );
                          }
                        );
                      },
                    ),
                  ),
                ),

              if (settings.refreshButton.enabled) ...[
                Expanded(
                  flex: 0,
                  child: IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () async {
                      await requestAndUpdateData();
                    },
                  ),
                ),
              ],
            ],
          )
        ],
      ),
    );
  }

  Widget buildListHeaderPiece() {
    return Row(
      children: [
        Expanded(
          child: CWBuilder.build(context, listInfo.headerComponent, parentContext)
        ),
      ],
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    Widget child = entityType == null
      ? buildGenericListPiece()
      : buildEntityListPiece();

    if (entityList.isEmpty && listInfo.whenEmpty.hasListReplaceComponent) {
      return CWBuilder.build(context, listInfo.whenEmpty.listReplaceComponent, parentContext);
    }

    return Column(
      children: [
        buildListSettingsPiece(),
        if (listInfo.hasHeaderComponent) ...[
          buildListHeaderPiece(),
        ],
        child
      ],
    );
  }
}