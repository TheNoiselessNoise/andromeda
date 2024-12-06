// ignore_for_file: overridden_fields

import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

typedef ActionBuilderType = ActionBuilderBase Function(BuildContext, JsonA, ParentContext);

class ActionBuilderFactory {
  static final Map<String, ActionBuilderType> _builders = {
    ActionVydejka.id: (ctx, jsonA, parentCtx) {
      return ActionVydejka(ctx, jsonA, parentCtx);
    },
    ActionPrijemka.id: (ctx, jsonA, parentCtx) {
      return ActionPrijemka(ctx, jsonA, parentCtx);
    },
    ActionSetPage.id: (ctx, jsonA, parentCtx) {
      return ActionSetPage(ctx, jsonA, parentCtx);
    },
    ActionNavigationPop.id: (ctx, jsonA, parentCtx) {
      return ActionNavigationPop(ctx, jsonA, parentCtx);
    },
    ActionPageBack.id: (ctx, jsonA, parentCtx) {
      return ActionPageBack(ctx, jsonA, parentCtx);
    },
    ActionOpenDrawer.id: (ctx, jsonA, parentCtx) {
      return ActionOpenDrawer(ctx, jsonA, parentCtx);
    },
    ActionCloseDrawer.id: (ctx, jsonA, parentCtx) {
      return ActionCloseDrawer(ctx, jsonA, parentCtx);
    },
    ActionEspoChangesBottomSheet.id: (ctx, jsonA, parentCtx) {
      return ActionEspoChangesBottomSheet(ctx, jsonA, parentCtx);
    },
    ActionSetRealizationStatusToArchived.id: (ctx, jsonA, parentCtx) {
      return ActionSetRealizationStatusToArchived(ctx, jsonA, parentCtx);
    },
    ActionRefreshPage.id: (ctx, jsonA, parentCtx) {
      return ActionRefreshPage(ctx, jsonA, parentCtx);
    },
    ActionLogout.id: (ctx, jsonA, parentCtx) {
      return ActionLogout(ctx, jsonA, parentCtx);
    },
    ActionShowBasicToast.id: (ctx, jsonA, parentCtx) {
      return ActionShowBasicToast(ctx, jsonA, parentCtx);
    },
    ActionShowBasicDialog.id: (ctx, jsonA, parentCtx) {
      return ActionShowBasicDialog(ctx, jsonA, parentCtx);
    },
    ActionShowDialogWithActions.id: (ctx, jsonA, parentCtx) {
      return ActionShowDialogWithActions(ctx, jsonA, parentCtx);
    },
    ActionPageWidget.id: (ctx, jsonA, parentCtx) {
      return ActionPageWidget(ctx, jsonA, parentCtx);
    },
    ActionCameraTakePhoto.id: (ctx, jsonA, parentCtx) {
      return ActionCameraTakePhoto(ctx, jsonA, parentCtx);
    },
    ActionCameraUnsetTakenPhoto.id: (ctx, jsonA, parentCtx) {
      return ActionCameraUnsetTakenPhoto(ctx, jsonA, parentCtx);
    },
    ActionDeveloper.id: (ctx, jsonA, parentCtx) {
      return ActionDeveloper(ctx, jsonA, parentCtx);
    },
    ActionRefreshMetadata.id: (ctx, jsonA, parentCtx) {
      return ActionRefreshMetadata(ctx, jsonA, parentCtx);
    },
    ActionSetParentContext.id: (ctx, jsonA, parentCtx) {
      return ActionSetParentContext(ctx, jsonA, parentCtx);
    },
    ActionUnSetParentContext.id: (ctx, jsonA, parentCtx) {
      return ActionUnSetParentContext(ctx, jsonA, parentCtx);
    },
    ActionSetPageFromLayout.id: (ctx, jsonA, parentCtx) {
      return ActionSetPageFromLayout(ctx, jsonA, parentCtx);
    },
    ActionSetPageFromComponent.id: (ctx, jsonA, parentCtx) {
      return ActionSetPageFromComponent(ctx, jsonA, parentCtx);
    },
    ActionTempStorageStore.id: (ctx, jsonA, parentCtx) {
      return ActionTempStorageStore(ctx, jsonA, parentCtx);
    },
    ActionTempStorageDelete.id: (ctx, jsonA, parentCtx) {
      return ActionTempStorageDelete(ctx, jsonA, parentCtx);
    },
    ActionSyncEspoChanges.id: (ctx, jsonA, parentCtx) {
      return ActionSyncEspoChanges(ctx, jsonA, parentCtx);
    },
    ActionFormSubmit.id: (ctx, jsonA, parentCtx) {
      return ActionFormSubmit(ctx, jsonA, parentCtx);
    },
    ActionCondition.id: (ctx, jsonA, parentCtx) {
      return ActionCondition(ctx, jsonA, parentCtx);
    },
    ActionGroupCondition.id: (ctx, jsonA, parentCtx) {
      return ActionGroupCondition(ctx, jsonA, parentCtx);
    },
    ActionSetEntityValue.id: (ctx, jsonA, parentCtx) {
      return ActionSetEntityValue(ctx, jsonA, parentCtx);
    },
    ActionSaveMetadata.id: (ctx, jsonA, parentCtx) {
      return ActionSaveMetadata(ctx, jsonA, parentCtx);
    },
    ActionLoadMetadata.id: (ctx, jsonA, parentCtx) {
      return ActionLoadMetadata(ctx, jsonA, parentCtx);
    },
    ActionDeleteMetadata.id: (ctx, jsonA, parentCtx) {
      return ActionDeleteMetadata(ctx, jsonA, parentCtx);
    },
  };

  static void registerAction(String name, ActionBuilderType builder) {
    _builders[name] = builder;
  }

  static ActionBuilderBase? getAction(BuildContext context, JsonA jsonAction, ParentContext parentContext) {
    ActionBuilderType? builder = _builders[jsonAction.name];
    if (builder == null) return null;
    return builder(context, jsonAction, parentContext);
  }
}

class ActionArgType {
  static const String dynamic = 'dynamic';
  static const String string = 'string';
  static const String int = 'int';
  static const String double = 'double';
  static const String bool = 'bool';
  static const String map = 'map';
  static const String list = 'list';
  static const String listInt = 'list<int>';
  static const String listDouble = 'list<double>';
  static const String listString = 'list<string>';
  static const String listBool = 'list<bool>';
  static const String listMap = 'list<map>';
  static const String jsonC = 'jsonC';
  static const String listJsonC = 'list<JsonC>';
  static const String jsonA = 'jsonA';
  static const String listJsonA = 'list<JsonA>';
  static const String unknown = 'unknown';
}

abstract class ActionBuilderBase {
  final BuildContext context;
  final JsonA jsonAction;
  final ParentContext parentContext;

  final Map<String, String> needArgs = {};
  final Map<String, String> coreOptionalArgs = {
    '__debug__': ActionArgType.bool
  };
  final Map<String, String> optionalArgs = {};
  final Map<String, List> argOptions = {};
  final Map<String, List> argNotOptions = {};

  ActionBuilderBase(this.context, this.jsonAction, this.parentContext);

  bool get isDebug => jsonAction.args['__debug__'] ?? false;

  void logAction(String message) {
    log("\$\$ [$runtimeType] $message");
  }

  bool isTypeByStringPlus(dynamic value, String type) {
    if (type == ActionArgType.dynamic) return true;
    if (type == ActionArgType.jsonC) return value is JsonC;
    if (type == ActionArgType.listJsonC) return value is List<JsonC>;
    if (type == ActionArgType.jsonA) return value is JsonA;
    if (type == ActionArgType.listJsonA) return value is List<JsonA>;
    return isTypeByString(value, type);
  }

  String getTypeOfPlus(dynamic value) {
    if (value is JsonC) return ActionArgType.jsonC;
    if (value is List<JsonC>) return ActionArgType.listJsonC;
    if (value is JsonA) return ActionArgType.jsonA;
    if (value is List<JsonA>) return ActionArgType.listJsonA;
    return getTypeOf(value) ?? ActionArgType.dynamic;
  }

  Map<String, dynamic> getActionArgs() {
    Map<String, dynamic> args = jsonAction.args;
    Map<String, String> shouldBes = {
      ...needArgs,
      ...optionalArgs
    };

    for (var key in args.keys) {
      String type = getTypeOfPlus(args[key]);
      String shouldBeType = shouldBes[key] ?? ActionArgType.unknown;

      if (type == ActionArgType.string && shouldBeType == ActionArgType.string) {
        args[key] = ArgumentParser.parse(context, args[key], parentContext);
      }

      // Map -> JsonC

      if (type == ActionArgType.map && shouldBeType == ActionArgType.jsonC) {
        args[key] = JsonC(args[key]);
      }

      // List -> List<JsonC>

      if (type == ActionArgType.list && shouldBeType == ActionArgType.listJsonC) {
        args[key] = (args[key] as List).map((e) => JsonC.from(e)).toList();
      }

      if (type == ActionArgType.listMap && shouldBeType == ActionArgType.listJsonC) {
        args[key] = (args[key] as List).map((e) => JsonC.from(e)).toList();
      }

      // Map -> JsonA

      if (type == ActionArgType.map && shouldBeType == ActionArgType.jsonA) {
        args[key] = JsonA(args[key]);
      }

      // List -> List<JsonA>

      if (type == ActionArgType.list && shouldBeType == ActionArgType.listJsonA) {
        args[key] = (args[key] as List).map((e) => JsonA.from(e)).toList();
      }

      if (type == ActionArgType.listMap && shouldBeType == ActionArgType.listJsonA) {
        args[key] = (args[key] as List).map((e) => JsonA.from(e)).toList();
      }
    }

    return args;
  }

  Map<String, dynamic> checkArgs() {
    Map<String, dynamic> actionArgs = getActionArgs();

    Map<String, dynamic> wrong = {};
    
    Map<String, String> missingArgs = {};
    Map<String, String> wrongArgs = {};

    Map<String, String> allOptArgs = {...coreOptionalArgs, ...optionalArgs};
    Map<String, String> missingOptArgs = {};
    Map<String, List<dynamic>> wrongArgOptions = {};
    Map<String, List<dynamic>> wrongArgNotOptions = {};

    for(var key in needArgs.keys) {
      String type = needArgs[key]!;

      // missing args
      if (!actionArgs.containsKey(key) || isDebug) {
        missingArgs[key] = type;
        continue;
      }

      // type mismatch args
      if (!isTypeByStringPlus(actionArgs[key], type)) {
        wrongArgs[key] = type;
        continue;
      }

      // wrong arg options
      if (argOptions.containsKey(key) && !argOptions[key]!.contains(actionArgs[key])) {
        wrongArgOptions[key] = argOptions[key] ?? [];
        continue;
      }

      // not allowed arg options
      if (argNotOptions.containsKey(key) && argNotOptions[key]!.contains(actionArgs[key])) {
        wrongArgNotOptions[key] = argNotOptions[key] ?? [];
        continue;
      }
    }

    for(var key in allOptArgs.keys) {
      String type = allOptArgs[key]!;

      // type mismatch args
      if (actionArgs.containsKey(key) && !isTypeByStringPlus(actionArgs[key], type)) {
        wrongArgs[key] = type;
        continue;
      }

      // missing args
      if (!actionArgs.containsKey(key) && isDebug) {
        missingOptArgs[key] = type;
        continue;
      }

      // wrong arg options
      if (argOptions.containsKey(key) && actionArgs.containsKey(key) && !argOptions[key]!.contains(actionArgs[key])) {
        wrongArgOptions[key] = argOptions[key] ?? [];
        continue;
      }

      // not allowed arg options
      if (argNotOptions.containsKey(key) && actionArgs.containsKey(key) && argNotOptions[key]!.contains(actionArgs[key])) {
        wrongArgNotOptions[key] = argNotOptions[key] ?? [];
        continue;
      }
    }

    if (missingArgs.isNotEmpty) wrong['missing'] = missingArgs;
    if (wrongArgs.isNotEmpty) wrong['wrong'] = wrongArgs;
    if (missingOptArgs.isNotEmpty) wrong['missingOpt'] = missingOptArgs;
    if (wrongArgOptions.isNotEmpty) wrong['wrongArgOptions'] = wrongArgOptions;
    if (wrongArgNotOptions.isNotEmpty) wrong['wrongArgNotOptions'] = wrongArgNotOptions;

    return wrong;
  }

  void showMissingOrWrongArgsDialog(Map<String, dynamic> missingOrWrongArgs) {
    Map<String, String> missingArgs = missingOrWrongArgs['missing'] ?? {};
    Map<String, String> wrongArgs = missingOrWrongArgs['wrong'] ?? {};
    Map<String, String> missingOptArgs = missingOrWrongArgs['missingOpt'] ?? {};
    Map<String, List<dynamic>> wrongArgOptions = Map<String, List<dynamic>>.from(missingOrWrongArgs['wrongArgOptions'] ?? {});
    Map<String, List<dynamic>> wrongArgNotOptions = Map<String, List<dynamic>>.from(missingOrWrongArgs['wrongArgNotOptions'] ?? {});

    TextStyle style = const TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.bold
    );

    TextStyle styleOptional = const TextStyle(
      color: Colors.purple,
      fontWeight: FontWeight.bold
    );

    List<ListTile> missingArgsItems = missingArgs.entries.map((entry) {
      return ListTile(
        title: Text(entry.key, style: style),
        subtitle: isDebug ?
          Text(entry.value) :
          Text("Missing, should be '${entry.value}'"),
      );
    }).toList();

    List<ListTile> wrongArgsItems = wrongArgs.entries.map((entry) {
      String wrongType = getTypeOfPlus(jsonAction.args[entry.key]);

      return ListTile(
        title: Text(entry.key, style: style),
        subtitle: Text("Wrong, should be '${entry.value}', got '$wrongType'"),
      );
    }).toList();

    List<ListTile> missingOptArgsItems = missingOptArgs.entries.map((entry) {
      return ListTile(
        title: Text(entry.key, style: styleOptional),
        subtitle: isDebug ?
          Text(entry.value) :
          Text("Missing, should be '${entry.value}'"),
      );
    }).toList();

    List<ListTile> wrongArgOptionsItems = wrongArgOptions.entries.map((entry) {
      String types = entry.value.map((e) => "'$e'").join(', ');
      String option = jsonAction.args[entry.key].toString();

      return ListTile(
        title: Text(entry.key, style: style),
        subtitle: Text("Wrong option '$option', should be one of: $types"),
      );
    }).toList();

    List<ListTile> wrongArgNotOptionsItems = wrongArgNotOptions.entries.map((entry) {
      String option = jsonAction.args[entry.key].toString();

      return ListTile(
        title: Text(entry.key, style: style),
        subtitle: Text("Not allowed option '$option', choose different name")
      );
    }).toList();

    if (missingOrWrongArgs.isNotEmpty) {
      CoreDialog.titleTextWidgets(context,
        title: Text("'${jsonAction.name}' failed",
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold
          )
        ),
        content: Column(
          children: [
            if (missingArgsItems.isNotEmpty) ...[
              ...missingArgsItems,
            ],
            if (wrongArgsItems.isNotEmpty) ...[
              ...wrongArgsItems,
            ],
            if (missingOptArgsItems.isNotEmpty) ...[
              ...missingOptArgsItems,
            ],
            if (wrongArgOptions.isNotEmpty) ...[
              ...wrongArgOptionsItems
            ],
            if (wrongArgNotOptions.isNotEmpty) ...[
              ...wrongArgNotOptionsItems
            ],
          ],
        ),
      );
    }
  }

  Future<bool> canProcess() async {
    return context.mounted;
  }

  Future<bool> process();

  Future<bool> execute() async {
    Map<String, dynamic> missingOrWrongArgs = checkArgs();
    
    if (missingOrWrongArgs.isNotEmpty) {
      showMissingOrWrongArgsDialog(missingOrWrongArgs);
      return false;
    }

    if (await canProcess()) {
      logAction("(${getActionArgs()}) TRIGGER");
      return await process();
    }

    return false;
  }
}

// class ActionCustomActionName extends ActionBuilderBase {
//   static String id = 'ActionCustomActionName';

//   ActionCustomActionName(super.context, super.jsonAction, super.parentContext);

//   @override
//   final Map<String, String> needArgs = {
//     'text': ActionArgType.string
//   };

//   @override
//   final Map<String, String> optionalArgs = {
//     'justSomeOptionalArg': ActionArgType.int
//   };

//   @override
//   Future<bool> canProcess() async {
//     return true;
//   }

//   @override
//   Future<bool> process() async {
//     // do something

//     if (jsonAction.cache) {
//       context.espoState.mergePossibleEntityChange(change);
//       return true;
//     }

//     return true;
//   }
// }