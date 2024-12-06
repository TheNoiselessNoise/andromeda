// ignore_for_file: overridden_fields

import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

// NOTE: for future potential JSON configurable custom action
// class ActionCustom extends ActionBuilderBase {
//   static String id = 'custom';

//   ActionCustom(super.context, super.jsonAction, super.parentContext);

//   @override
//   Future<bool> process() async {
//     logAction("Custom action");
//     return true;
//   }
// }

class ActionSetPage extends ActionBuilderBase {
  static String id = 'ActionSetPage';

  ActionSetPage(super.context, super.jsonAction, super.parentContext);

  @override
  final Map<String, String> needArgs = {
    'page': ActionArgType.string
  };

  @override
  final Map<String, String> optionalArgs = {
    'args': ActionArgType.map
  };

  @override
  Future<bool> process() async {
    Map<String, dynamic> args = getActionArgs();

    String pageId = ArgumentParser.parseString(context, args['page'], parentContext);

    JsonP page = context.espoBloc.getPageOr404(pageId);
    Map<String, dynamic> pageArgs = Map<String, dynamic>.from(args['args'] ?? {});

    page = page.withArguments(
      Map<String, dynamic>.from(
        ArgumentParser.parseMap(context, args, parentContext)
      )
    );

    page = page.withArguments(
      Map<String, dynamic>.from(
        ArgumentParser.parseMap(context, pageArgs, parentContext)
      )
    );

    context.coreBloc.setPageParentContextArgument(parentContext);
    context.coreBloc.setPage(page);

    return true;
  }
}

class ActionNavigationPop extends ActionBuilderBase {
  static String id = 'ActionNavigationPop';

  ActionNavigationPop(super.context, super.jsonAction, super.parentContext);

  @override
  Future<bool> process() async {
    Navigator.of(context).pop();
    return true;
  }
}

class ActionPageBack extends ActionBuilderBase {
  static String id = 'ActionPageBack';

  ActionPageBack(super.context, super.jsonAction, super.parentContext);

  @override
  Future<bool> process() async {
    context.coreBloc.popPage();
    return true;
  }
}

class ActionOpenDrawer extends ActionBuilderBase {
  static String id = 'ActionOpenDrawer';

  ActionOpenDrawer(super.context, super.jsonAction, super.parentContext);

  @override
  Future<bool> process() async {
    if (!Scaffold.of(context).hasDrawer) {
      CoreToast.show("No drawer available");
      return false;
    } else {
      Scaffold.of(context).openDrawer();
      return true;
    }
  }
}

class ActionCloseDrawer extends ActionBuilderBase {
  static String id = 'ActionCloseDrawer';

  ActionCloseDrawer(super.context, super.jsonAction, super.parentContext);

  @override
  Future<bool> process() async {
    if (!Scaffold.of(context).hasDrawer) {
      CoreToast.show("No drawer available");
      return false;
    } else {
      Scaffold.of(context).closeDrawer();
      return true;
    }
  }
}

class ActionLogout extends ActionBuilderBase {
  static String id = 'ActionLogout';

  ActionLogout(super.context, super.jsonAction, super.parentContext);

  @override
  Future<bool> process() async {
    await EspoLoginData.deleteFromStorage();
    return true;
  }
}

class ActionEspoChangesBottomSheet extends ActionBuilderBase {
  static String id = 'ActionEspoChangesBottomSheet';

  ActionEspoChangesBottomSheet(super.context, super.jsonAction, super.parentContext);

  @override
  Future<bool> process() async {
    showBottomSheet(
      context: context,
      builder: (context) => const EspoChangesBottomSheet(),
    );
    return true;
  }
}

class ActionRefreshMetadata extends ActionBuilderBase {
  static String id = 'ActionRefreshPage';

  ActionRefreshMetadata(super.context, super.jsonAction, super.parentContext);

  @override
  Future<bool> canProcess() async {
    return (await super.canProcess() && context.mounted) && context.espoState.metadata != null;
  }

  @override
  Future<bool> process() async {
    // context.espoBloc.fireMetadata();
    return true;
  }
}

class ActionSetParentContext extends ActionBuilderBase {
  static String id = 'ActionSetParentContext';

  ActionSetParentContext(super.context, super.jsonAction, super.parentContext);

  @override
  Future<bool> canProcess() async {
    return context.coreBloc.getCurrentPage().args.parentContext != null;
  }

  @override
  Future<bool> process() async {
    context.coreBloc.setPageParentContextArgument(
      context.coreBloc.getCurrentPage().args.parentContext ??
      context.espoState.currentParentContext ??
      parentContext
    );

    return true;
  }
}

class ActionUnSetParentContext extends ActionBuilderBase {
  static String id = 'ActionUnSetParentContext';

  ActionUnSetParentContext(super.context, super.jsonAction, super.parentContext);

  @override
  Future<bool> canProcess() async {
    return context.coreBloc.getCurrentPage().args.parentContext != null;
  }

  @override
  Future<bool> process() async {
    context.coreBloc.setPageParentContextArgument(null);
    return true;
  }
}

class ActionRefreshPage extends ActionBuilderBase {
  static String id = 'ActionRefreshPage';

  ActionRefreshPage(super.context, super.jsonAction, super.parentContext);

  @override
  Future<bool> canProcess() async {
    return context.coreState.pageBuilderState != null;
  }

  @override
  Future<bool> process() async {
    context.coreState.pageBuilderState?.rebuild();
    return true;
  }
}

class ActionPageWidget extends ActionBuilderBase {
  static String id = 'ActionPageWidget';

  ActionPageWidget(super.context, super.jsonAction, super.parentContext);

  @override
  final Map<String, String> needArgs = {
    'type': ActionArgType.string,
    'widget': ActionArgType.string,
  };

  @override
  Map<String, String> get optionalArgs => {
    'ignoreHistory': ActionArgType.bool,
    'appBarTitle': ActionArgType.string,
  };

  @override
  Future<bool> process() async {
    Map<String, dynamic> args = getActionArgs();

    String type = args['type'];
    String widget = args['widget'];

    JsonP page = const PageBuilder({})
      .setId('$type-$widget-$runtimeType')
      .ignoreHistory(args['ignoreHistory'] ?? false)
      .appBarTitle(args['appBarTitle'] ?? type)
      .addComponentBuilder(
        const ComponentBuilder({})
          .type(type)
          .addInfoMap(args)
      ).buildPage();

    context.coreBloc.setPageParentContextArgument(parentContext);
    context.coreBloc.setPage(page);

    return true;
  }
}

class ActionShowBasicToast extends ActionBuilderBase {
  static String id = 'ActionShowBasicToast';

  ActionShowBasicToast(super.context, super.jsonAction, super.parentContext);

  @override
  final Map<String, String> needArgs = {
    'message': ActionArgType.string
  };

  @override
  Future<bool> process() async {
    Map<String, dynamic> args = getActionArgs();

    CoreToast.show(
      ArgumentParser.parse(context, args['message'], parentContext)
    );

    return true;
  }
}

class ActionCameraTakePhoto extends ActionBuilderBase {
  static String id = 'ActionCameraTakePhoto';

  ActionCameraTakePhoto(super.context, super.jsonAction, super.parentContext);

  @override
  Future<bool> process() async {
    if (context.coreState.cameraState == null) {
      CoreToast.show("No camera available");
      return false;
    }

    context.coreState.cameraState!.takePicture();
    return true;
  }
}

class ActionCameraUnsetTakenPhoto extends ActionBuilderBase {
  static String id = 'ActionCameraUnsetTakenPhoto';

  ActionCameraUnsetTakenPhoto(super.context, super.jsonAction, super.parentContext);

  @override
  Future<bool> process() async {
    if (context.coreState.cameraState == null) {
      CoreToast.show("No camera available");
      return false;
    }

    context.coreState.cameraState!.unsetTakenPicture();
    return true;
  }
}

class ActionShowBasicDialog extends ActionBuilderBase {
  static String id = 'ActionShowBasicDialog';

  ActionShowBasicDialog(super.context, super.jsonAction, super.parentContext);

  @override
  final Map<String, String> needArgs = {
    'title': ActionArgType.jsonC,
    'content': ActionArgType.jsonC,
  };

  @override
  Map<String, String> get optionalArgs => {
    'dismissable': ActionArgType.bool
  };

  @override
  Future<bool> process() async {
    Map<String, dynamic> args = getActionArgs();

    Widget title = CWBuilder.build(context, args['title'], parentContext);
    Widget content = CWBuilder.build(context, args['content'], parentContext);

    CoreDialog.titleTextWidgets(context,
      title: title,
      content: content,
      dismissible: args['dismissable']
    );

    return true;
  }
}

class ActionShowDialogWithActions extends ActionBuilderBase {
  static String id = 'ActionShowDialogWithActions';

  ActionShowDialogWithActions(super.context, super.jsonAction, super.parentContext);

  @override
  final Map<String, String> needArgs = {
    'title': ActionArgType.jsonC,
    'content': ActionArgType.jsonC,
    'actions': ActionArgType.listJsonC
  };

  @override
  Map<String, String> get optionalArgs => {
    'dismissable': ActionArgType.bool
  };

  @override
  Future<bool> process() async {
    Map<String, dynamic> args = getActionArgs();

    Widget title = CWBuilder.build(context, args['title'], parentContext);
    Widget content = CWBuilder.build(context, args['content'], parentContext);

    CoreDialog.titleTextWidgetsWithActions(context,
      title: title,
      content: content,
      actions: (args['actions'] as List<JsonC>)
        .map((action) => CWBuilder.build(
          context, action, parentContext
        )).toList(),
      dismissible: args['dismissable']
    );

    return true;
  }
}

class ActionSetPageFromLayout extends ActionBuilderBase {
  static String id = 'ActionSetPageFromLayout';

  ActionSetPageFromLayout(super.context, super.jsonAction, super.parentContext);

  @override
  final Map<String, String> needArgs = {
    'entityType': ActionArgType.string,
    'layoutName': ActionArgType.string,
  };

  @override
  Map<String, String> get optionalArgs => {
    'appBar': ActionArgType.jsonC,
    'drawer': ActionArgType.dynamic,
    'listInfo': ActionArgType.map
  };

  @override
  Future<bool> process() async {
    Map<String, dynamic> args = getActionArgs();

    String entityType = args['entityType'];
    String layoutName = args['layoutName'];

    JsonP? page = PBuilder.buildPage(
      metadata: context.metadata,
      layout: [entityType, layoutName],
      pageId: '$entityType/$layoutName',
      entityType: entityType,
      appBar: args['appBar'],
      drawer: args['drawer'],
      listInfo: args['listInfo'] ?? {}
    ) ?? PBuilder.error404Page();

    context.coreBloc.setPageParentContextArgument(parentContext);
    context.coreBloc.setPage(page);

    return true;
  }
}

class ActionSetPageFromComponent extends ActionBuilderBase {
  static String id = 'ActionSetPageFromComponent';

  ActionSetPageFromComponent(super.context, super.jsonAction, super.parentContext);

  @override
  final Map<String, String> needArgs = {
    'pageId': ActionArgType.string,
    'component': ActionArgType.jsonC,
  };

  @override
  Map<String, String> get optionalArgs => {
    'appBar': ActionArgType.jsonC,
    'drawer': ActionArgType.dynamic,
    'entityType': ActionArgType.string,
  };

  @override
  Future<bool> process() async {
    Map<String, dynamic> args = getActionArgs();

    JsonP page = PBuilder.setupPage(
      metadata: context.metadata,
      appBar: args['appBar'],
      drawer: args['drawer'],
      entityType: args['entityType'],
      pageId: args['pageId'],
    );

    page.addComponent(args['component']);

    context.coreBloc.setPageParentContextArgument(parentContext);
    context.coreBloc.setPage(page);

    return true;
  }
}

class ActionDeveloper extends ActionBuilderBase {
  static String id = 'ActionDeveloper';

  ActionDeveloper(super.context, super.jsonAction, super.parentContext);

  @override
  final Map<String, String> needArgs = {
    'what': ActionArgType.string,
  };

  @override
  Map<String, String> get optionalArgs => {};

  @override
  Future<bool> process() async {
    Map<String, dynamic> args = getActionArgs();
    String what = args['what'] ?? '';

    if (what == "something") {
      // do something
    }

    return false;
  }
}

class ActionTempStorageStore extends ActionBuilderBase {
  static String id = 'ActionTempStorageStore';

  ActionTempStorageStore(super.context, super.jsonAction, super.parentContext);

  @override
  final Map<String, String> needArgs = {
    'name': ActionArgType.string,
    'value': ActionArgType.dynamic,
  };

  @override
  Map<String, String> get optionalArgs => {
    'onKeyExists': ActionArgType.listJsonA,
    'afterSet': ActionArgType.listJsonA,
    'parseKey': ActionArgType.bool,
    'parseValue': ActionArgType.bool,
    'parseData': ActionArgType.bool
  };

  @override
  Map<String, List> get argNotOptions => {
    'name': C.TEMP_STORAGE_RESERVED_KEYS
  };

  @override
  Future<bool> process() async {
    Map<String, dynamic> args = getActionArgs();

    dynamic name = args['name'];
    dynamic value = args['value'];

    if ((args['parseData'] ?? false) || (args['parseKey'] ?? false)) {
      name = ArgumentParser.parse(context, name, parentContext);
    }

    if ((args['parseData'] ?? false) || (args['parseValue'] ?? false)) {
      value = ArgumentParser.parse(context, value, parentContext);
    }

    if (context.coreState.temporaryStorage?.hasKey(name) ?? false) {
      List<JsonA> onKeyExists = List<JsonA>.from(args['onKeyExists'] ?? []);
      ActionBuilder.call(context, onKeyExists, parentContext);
      return false;
    }

    context.coreBloc.setToTemporaryStorage(name, value);

    List<JsonA> afterSet = List<JsonA>.from(args['afterSet'] ?? []);
    ActionBuilder.call(context, afterSet, parentContext);
    return true;
  }
}

class ActionTempStorageDelete extends ActionBuilderBase {
  static String id = 'ActionTempStorageDelete';

  ActionTempStorageDelete(super.context, super.jsonAction, super.parentContext);

  @override
  final Map<String, String> needArgs = {
    'name': ActionArgType.string
  };

  @override
  Map<String, String> get optionalArgs => {
    'onKeyMissing': ActionArgType.listJsonA,
    'afterDelete': ActionArgType.listJsonA,
    'parseKey': ActionArgType.bool
  };

  @override
  Map<String, List> get argNotOptions => {
    'name': C.TEMP_STORAGE_RESERVED_KEYS
  };

  @override
  Future<bool> process() async {
    Map<String, dynamic> args = getActionArgs();

    dynamic name = args['name'];

    if (args['parseKey'] ?? false) {
      name = ArgumentParser.parse(context, name, parentContext);
    }

    bool hasKey = context.coreState.temporaryStorage?.hasKey(name) ?? true;

    if (!hasKey) {
      List<JsonA> onKeyMissing = List<JsonA>.from(args['onKeyMissing'] ?? []);
      ActionBuilder.call(context, onKeyMissing, parentContext);
      return false;
    }

    context.coreBloc.deleteFromTemporaryStorage(name);

    List<JsonA> afterDelete = List<JsonA>.from(args['afterDelete'] ?? []);
    ActionBuilder.call(context, afterDelete, parentContext);
    return true;
  }
}

class ActionSyncEspoChanges extends ActionBuilderBase {
  static String id = 'ActionSyncEspoChanges';

  ActionSyncEspoChanges(super.context, super.jsonAction, super.parentContext);

  @override
  Future<bool> canProcess() {
    return Future.value(context.espoState.entityChanges?.isNotEmpty ?? false);
  }

  @override
  Future<bool> process() async {
    await context.espoBloc.fireEspoChanges();
    if (context.mounted) CoreSnackbar.basic(context, "Changes sent to server");
    return true;
  }
}

class ActionFormSubmit extends ActionBuilderBase {
  static String id = 'ActionFormSubmit';

  ActionFormSubmit(super.context, super.jsonAction, super.parentContext);

  @override
  final Map<String, String> needArgs = {
    'formId': ActionArgType.string
  };

  @override
  Future<bool> canProcess() {
    return Future.value(FormManager.formStates.containsKey(getActionArgs()['formId']));
  }

  @override
  Future<bool> process() async {
    Map<String, dynamic> args = getActionArgs();
    FormManager.formStates[args['formId']]?.submit();
    return true;
  }
}

class ConditionOperators {
  static const String equals = 'equals';
  static const String notEquals = 'notEquals';
  static const String greaterThan = 'greaterThan';
  static const String greaterThanOrEqual = 'greaterThanOrEqual';
  static const String lessThan = 'lessThan';
  static const String lessThanOrEqual = 'lessThanOrEqual';
  static const String empty = 'empty';
  static const String notEmpty = 'notEmpty';
  static const String contains = 'contains';
  static const String notContains = 'notContains';

  static List<String> get all => [
    equals,
    notEquals,
    greaterThan,
    greaterThanOrEqual,
    lessThan,
    lessThanOrEqual,
    empty,
    notEmpty,
    contains,
    notContains
  ];
}

class ConditionBuilder {
  static bool checkEmpty(dynamic left, dynamic right) {
    if (left is String) return left.isEmpty;
    if (left is List) return left.isEmpty;
    if (left is Map) return left.isEmpty;
    return false;
  }

  static bool checkContains(dynamic left, dynamic right) {
    if (left is String) return left.contains(right);
    if (left is List) return left.contains(right);
    if (left is Map) return left.containsKey(right);
    return false;
  }

  static bool compare(dynamic left, dynamic right, String operator) {
    switch (operator) {
      case ConditionOperators.equals:
        return left == right;
      case ConditionOperators.notEquals:
        return left != right;
      case ConditionOperators.greaterThan:
        return left > right;
      case ConditionOperators.greaterThanOrEqual:
        return left >= right;
      case ConditionOperators.lessThan:
        return left < right;
      case ConditionOperators.lessThanOrEqual:
        return left <= right;
      case ConditionOperators.empty:
        return checkEmpty(left, right);
      case ConditionOperators.notEmpty:
        return !checkEmpty(left, right);
      case ConditionOperators.contains:
        return checkContains(left, right);
      case ConditionOperators.notContains:
        return !checkContains(left, right);
      default:
        return false;
    }
  }
}

class ActionCondition extends ActionBuilderBase {
  static String id = 'ActionCondition';

  ActionCondition(super.context, super.jsonAction, super.parentContext);

  @override
  final Map<String, String> needArgs = {
    'left': ActionArgType.dynamic,
    'right': ActionArgType.dynamic,
    'operator': ActionArgType.string,
  };

  @override
  final Map<String, List> argOptions = {
    'operator': ConditionOperators.all
  };

  @override
  Map<String, String> get optionalArgs => {
    'onTrue': ActionArgType.listJsonA,
    'onFalse': ActionArgType.listJsonA,
    'parseLeft': ActionArgType.bool,
    'parseRight': ActionArgType.bool,
  };

  @override
  Future<bool> process() async {
    Map<String, dynamic> args = getActionArgs();

    dynamic left = args['left'];
    if (args['parseLeft'] ?? false) {
      left = ArgumentParser.parse(context, left, parentContext);
    }

    dynamic right = args['right'];
    if (args['parseRight'] ?? false) {
      right = ArgumentParser.parse(context, right, parentContext);
    }

    bool result = ConditionBuilder.compare(left, right, args['operator']);

    if (result) {
      List<JsonA> onTrue = List<JsonA>.from(args['onTrue'] ?? []);
      ActionBuilder.call(context, onTrue, parentContext);
    } else {
      List<JsonA> onFalse = List<JsonA>.from(args['onFalse'] ?? []);
      ActionBuilder.call(context, onFalse, parentContext);
    }

    return result;
  }
}

class GroupConditionOperators {
  static const String and = 'and';
  static const String or = 'or';

  static List<String> get all => [
    and,
    or
  ];
}

class ActionGroupCondition extends ActionBuilderBase {
  static String id = 'ActionGroupCondition';

  ActionGroupCondition(super.context, super.jsonAction, super.parentContext);

  @override
  final Map<String, String> needArgs = {
    'operator': ActionArgType.string,
    'conditions': ActionArgType.listJsonA,
  };

  @override
  final Map<String, List> argOptions = {
    'operator': GroupConditionOperators.all
  };

  @override
  Map<String, String> get optionalArgs => {
    'onTrue': ActionArgType.listJsonA,
    'onFalse': ActionArgType.listJsonA,
  };

  bool isCondition(ActionBuilderBase? value) {
    if (value == null) return false;
    return [
      ActionCondition.id,
      ActionGroupCondition.id
    ].contains(value.jsonAction.name);
  }

  @override
  Future<bool> process() async {
    Map<String, dynamic> args = getActionArgs();

    List<JsonA> conditions = List<JsonA>.from(args['conditions'] ?? []);

    bool? result;

    for (JsonA condition in conditions) {
      if (!context.mounted) return false;

      ActionBuilderBase? builder = ActionBuilderFactory.getAction(context, condition, parentContext);

      if (!isCondition(builder)) {
        // print("ActionGroupCondition: Unknown condition: ${condition.name}");
        return false;
      }

      bool conditionResult = await builder!.execute();
      if (args['operator'] == GroupConditionOperators.and) {
        result = result == null ? conditionResult : result && conditionResult;
      } else if (args['operator'] == GroupConditionOperators.or) {
        result = result == null ? conditionResult : result || conditionResult;
      }
    }

    if ((result ?? false) && context.mounted) {
      List<JsonA> onTrue = List<JsonA>.from(args['onTrue'] ?? []);
      ActionBuilder.call(context, onTrue, parentContext);
    } else if (context.mounted) {
      List<JsonA> onFalse = List<JsonA>.from(args['onFalse'] ?? []);
      ActionBuilder.call(context, onFalse, parentContext);
    }

    return result ?? false;
  }
}

// class ActionStore extends ActionBuilderBase {
//   static String id = 'ActionStore';

//   ActionStore(super.context, super.jsonAction, super.parentContext);

//   @override
//   final Map<String, String> needArgs = {
//     'name': ActionArgType.string,
//     'value': ActionArgType.dynamic,
//     'onKeyExists': ActionArgType.listJsonA,
//     'afterSet': ActionArgType.listJsonA
//   };

//   @override
//   Map<String, String> get optionalArgs => {};

//   @override
//   Future<bool> process() async {
//     Map<String, dynamic> args = getActionArgs();

//     dynamic name = ArgumentParser.parse(context, args['name'], parentContext);
//     dynamic value = ArgumentParser.parse(context, args['value'], parentContext);

//     TemporaryStorage? storage = context.coreState.temporaryStorage;

//     if (storage?.hasKey(name) ?? false) {
//       List<JsonA> onKeyExists = (args['onKeyExists'] ?? []) as List<JsonA>;
//       ActionBuilder.call(context, onKeyExists, parentContext);
//       return;
//     }

//     storage?.set(name, value);

//     List<JsonA> afterSet = (args['afterSet'] ?? []) as List<JsonA>;
//     ActionBuilder.call(context, afterSet, parentContext);
//     return true;
//   }
// }