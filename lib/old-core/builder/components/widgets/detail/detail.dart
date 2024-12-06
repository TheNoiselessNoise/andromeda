import 'dart:async';
import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

class EspoPageComponentDetailBuilder extends CoreBaseStatefulWidget {
  final JsonC component;
  final ParentContext parentContext;

  const EspoPageComponentDetailBuilder({super.key,
    required this.component,
    required this.parentContext
  });

  @override
  EspoPageComponentDetailBuilderState createState() => EspoPageComponentDetailBuilderState();
}

class EspoPageComponentDetailBuilderState extends CoreBaseState<EspoPageComponentDetailBuilder> {
  @override
  bool isComponent() => true;

  JsonC get component => widget.component;
  JsonP get page => coreBloc.getCurrentPage();
  ParentContext get parentContext => widget.parentContext;
  String? get entityType => parentContext.entity?.entityType ?? page.entityType;

  JsonDetailInfo get detailInfo => component.info.detailInfo;
  JsonDetailSettings get settings => detailInfo.settings;

  bool _isFirstLoad = true;
  Timer? _timer;
  int refreshRate = 1000;

  @override
  void initState() {
    super.initState();

    if (settings.refresh.enabled) {
      refreshRate = settings.refresh.interval;
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

  @override
  bool buildWhenEspo(EspoGlobalState previous, EspoGlobalState current) {
    if (parentContext.entity is EspoEntity) return false;
    if (entityType == null) return false;
    EspoEntity? prevEntity = previous.entities?[parentContext.entity?.key];
    EspoEntity? currEntity = current.entities?[parentContext.entity?.key];
    return prevEntity != currEntity;
  }

  String? get entityId => parentContext.entity?.id;

  bool get entityExists {
    return espoState.entities?.containsKey(parentContext.entity?.key) ?? false;
  }
  
  Future<void> requestAndUpdateData() async {
    if (entityType == null || entityId == null) return;

    try {
      EspoEntity? data = await EspoApiEntityBridge(entityType!).get(id: entityId!);

      if (mounted && data != null) {
        espoBloc.addToEntities(data);
      }
    } catch (e) {
      return;
    }
  }

  Future<EspoEntity?> getData() async {
    if (!entityExists) await requestAndUpdateData();
    return parentContext.entity;
  }

  Widget buildContentComponents(BuildContext context, ParentContext parentContext) {
    return Column(
      children: [
        ...component.detailComponents.map((row) {
          return Row(
            children: row.map((cell) {
              return Expanded(
                child: CWBuilder.build(context, cell, parentContext)
              );
            }).toList(),
          );
        }),
      ]
    );
  }

  Widget buildContentData() {
    _isFirstLoad = false;

    if (detailInfo.noForm) {
      return buildContentComponents(context, parentContext);
    }

    return CoreBaseForm(
      id: detailInfo.formId,
      builder: (key, context, formState) {
        return buildContentComponents(
          context,
          parentContext.withFormState(formState)
        );
      },
      onSubmit: (formState) {
        // when we change entity data, rebuild form
        formState.rebuild();

        // call onFormSubmit actions
        ActionBuilder.call(context, detailInfo.onFormSubmit, parentContext);
      },
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          if (_isFirstLoad) {
            return const CircularProgressIndicator();
          } else if (entityType != null && entityId != null) {
            return buildContentData();
          }
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        return buildContentData();
      },
    );
  }
}