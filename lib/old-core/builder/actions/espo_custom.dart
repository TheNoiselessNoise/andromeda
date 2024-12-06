// ignore_for_file: overridden_fields

import 'package:andromeda/old-core/core.dart';

class ActionVydejka extends ActionBuilderBase {
  static String id = 'AkceNaskladnit';

  ActionVydejka(super.context, super.jsonAction, super.parentContext);

  @override
  Future<bool> canProcess() async {
    if (parentContext.entity == null) return false;
    EspoEntity? entity = parentContext.entity!;
    if (entity.id.isEmpty) return false;
    return entity.getString('status') == 'Draft';
  }

  @override
  Future<bool> process() async {
    EspoEntity entity = parentContext.entity!;

    EspoEntityChange change = EspoEntityChange.entityUpdate(entity, {
      'status': 'Received'
    });

    await EspoApi.change(change);
    
    return true;
  }
}

class ActionPrijemka extends ActionBuilderBase {
  static String id = 'AkceVyskladnit';

  ActionPrijemka(super.context, super.jsonAction, super.parentContext);

  @override
  Future<bool> canProcess() async {
    if (parentContext.entity == null) return false;
    EspoEntity? entity = parentContext.entity as EspoEntity;
    if (entity.id.isEmpty) return false;
    return entity.getString('status') == 'Reserved';
  }

  @override
  Future<bool> process() async {
    EspoEntity entity = parentContext.entity!;

    EspoEntityChange change = EspoEntityChange.entityUpdate(entity, {
      'status': 'Issued'
    });

    await EspoApi.change(change);
    
    return true;
  }
}

class ActionSetRealizationStatusToArchived extends ActionBuilderBase {
  static String id = 'AkceNastavStatusRealizaceNaArchivovano';

  ActionSetRealizationStatusToArchived(super.context, super.jsonAction, super.parentContext);

  @override
  Future<bool> canProcess() async {
    return parentContext.entity != null;
  }

  @override
  Future<bool> process() async {
    EspoEntity entity = parentContext.entity!;
    String status = entity.getString('status');

    if (status != 'Realization') {
      CoreToast.show('Status is not Realization');
      return false;
    }

    if (status == 'Archived') {
      CoreToast.show('Status is already Archived');
      return false;
    }

    EspoEntityChange change = EspoEntityChange.entityUpdate(entity, {
      'status': 'Archived'
    });

    EspoApi.change(change);
    CoreToast.show('Status set to Archived');
    return true;
  }
}