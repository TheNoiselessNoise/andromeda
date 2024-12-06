// ignore_for_file: overridden_fields

import 'package:andromeda/old-core/core.dart';

class ActionSetEntityValue extends ActionBuilderBase {
  static String id = 'ActionSetEntityValue';

  ActionSetEntityValue(super.context, super.jsonAction, super.parentContext);

  @override
  final Map<String, String> needArgs = {
    'data': ActionArgType.map,
  };

  @override
  Map<String, String> get optionalArgs => {
    'immediate': ActionArgType.bool,
  };

  @override
  Future<bool> canProcess() async {
    return (await super.canProcess()) && parentContext.entity is EspoEntity;
  }

  @override
  Future<bool> process() async {
    Map<String, dynamic> args = getActionArgs();
    EspoEntity entity = parentContext.entity!;

    bool immediate = args['immediate'] ?? false;
    Map<String, dynamic> data = Map<String, dynamic>.from(args['data'] ?? {});

    if (immediate) {
      EspoApi.updateEntity(
        entityType: entity.entityType,
        entityId: entity.id,
        data: data
      );
    } else {
      context.espoBloc.addToEntities(entity.newWith(data));
    }

    return true;
  }
}

class ActionSaveMetadata extends ActionBuilderBase {
  static String id = 'ActionSaveMetadata';

  ActionSaveMetadata(super.context, super.jsonAction, super.parentContext);

  @override
  Future<bool> process() async {
    await context.metadata.toStorage(
      AppConfig.defaultEspoMetadataStorageKey
    );
    return true;
  }
}

class ActionLoadMetadata extends ActionBuilderBase {
  static String id = 'ActionLoadMetadata';

  ActionLoadMetadata(super.context, super.jsonAction, super.parentContext);

  @override
  Future<bool> process() async {
    EspoMetadata? metadata = await EspoMetadata.fromStorage(
      AppConfig.defaultEspoMetadataStorageKey
    );

    if (context.mounted && metadata != null) {
      context.espoBloc.setMetadata(metadata);
    }

    return true;
  }
}

class ActionDeleteMetadata extends ActionBuilderBase {
  static String id = 'ActionDeleteMetadata';

  ActionDeleteMetadata(super.context, super.jsonAction, super.parentContext);

  @override
  Future<bool> process() async {
    await SecuredStorageService.instance.delete(
      AppConfig.defaultEspoMetadataStorageKey
    );
    return true;
  }
}