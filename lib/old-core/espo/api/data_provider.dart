import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

abstract class DataProvider {
  Future<EspoEntity?> getEntity(String entityType, String id);

  static DataProvider create([BuildContext? context]) {
    if (context == null /*|| isOnline */) {
      return DataProviderOnline();
    }

    return DataProviderOffline(context);
  }
}

class DataProviderOnline extends DataProvider {
  @override
  Future<EspoEntity?> getEntity(String entityType, String id) async {
    return await EspoApiEntityBridge(entityType).get(id: id);
  }
}

class DataProviderOffline extends DataProvider {
  late BuildContext context;
  DataProviderOffline(this.context);

  @override
  Future<EspoEntity?> getEntity(String entityType, String id) async {
    return context.espoState.entities?["$entityType:$id"];
  }
}