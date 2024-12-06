import 'package:flutter/material.dart';
import "package:andromeda/old-core/core.dart";

class ArgumentParser {
  static const String formatRegex = r'{(.*?)}';

  // '@' to replace the value directly
  static const List<String> methods = ['@'];

  // '<<' for entity
  // '##' for i18n
  // '>>' for temporary storage
  // '!!' for custom values
  // '==' for form values
  // '((' for parent entity
  static const List<String> targetModes = ['<<', '##', '>>', '!!', '==', '(('];

  static dynamic parse(BuildContext context, dynamic value, ParentContext parentContext, [
    Map<String, dynamic> formatData = const {}
  ]) {
    if (value is String) {
      return parseString(context, value, parentContext, formatData);
    }

    if (value is Map<String, dynamic>) {
      return parseMap(context, value, parentContext);
    }

    return value;
  }

  static dynamic _getValue(String method, String target, String key, BuildContext context, ParentContext parentContext) {
    // we dont care about method for now

    if (target == '((') {
      String entityKey = key.split(";").first;
      String defaultValue = key.split(";").last;
      return parentContext.parentEntity?.get(entityKey) ?? defaultValue;
    }

    if (target == '<<') {
      String entityKey = key.split(";").first;
      String defaultValue = key.split(";").last;
      return parentContext.entity?.get(entityKey) ?? defaultValue;
    }

    if (target == '>>' && context.mounted) {
      String storageKey = key.split(";").first;
      String defaultValue = key.split(";").last;
      return context.coreState.temporaryStorage?.get(storageKey) ?? defaultValue;
    }

    if (target == '!!' && context.mounted) {
      return context.metadata.customValues[key] ?? key;
    }

    if (target == '==') {
      String formId = key.split(".").first;
      String right = key.split(".").last;
      String fieldId = right.split(";").first;
      String defaultValue = right.split(";").last;
      return FormManager.getFormValue(formId, fieldId, defaultValue);
    }

    if (target == '##' && context.mounted) {
      String lang = key.split(".").first;

      if (!(context.metadata.i18n?.containsKey(lang) ?? false)) {
        lang = AppConfig.currentLanguage;
        key = "$lang.$key";
      }

      return context.metadata.get('i18n.$key') ?? key;
    }
  }

  static dynamic parseString(BuildContext context, dynamic value, ParentContext parentContext, [
    Map<String, dynamic> formatData = const {}
  ]) {
    if (value is! String) return value;
    String text = value;

    int start, end;
    String key;

    int currentLoop = 0;
    int maxLoop = 100;
    while (text.contains('{{') && text.contains('}}')) {
      start = text.lastIndexOf('{{');
      end = text.indexOf('}}', start) + 2;

      String method = start > 2 ? text.substring(start - 3, start - 2) : '';
      String target = start > 1 ? text.substring(start - 2, start) : '';

      if (start != -1 && end != -1) {
        key = text.substring(start + 2, end - 2);

        dynamic newValue = _getValue(method, target, key, context, parentContext);
        if (method == '@') return newValue;

        if (methods.contains(method)) {
          start = start - 3;
          if (start < 0) start = 0;
          text = "${text.substring(0, start)}$newValue${text.substring(end)}";
        } else if (targetModes.contains(target)) {
          start = start - 2;
          if (start < 0) start = 0;
          text = "${text.substring(0, start)}$newValue${text.substring(end)}";
        } else {
          text = "${text.substring(0, start)}$newValue${text.substring(end)}";
        }

        if (currentLoop++ >= maxLoop) return text;
      }
    }

    text = parseStringFormat(context, text, parentContext, formatData);

    return text;
  }

  static Map<String, dynamic> parseMap(BuildContext context, Map<String, dynamic> args, ParentContext parentContext) {
    return args.map((key, value) {
      return MapEntry(key, parse(context, value, parentContext));
    });
  }

  static Map<String, dynamic> parseMapFormat(BuildContext context, Map<String, dynamic> args, ParentContext parentContext, [
    Map<String, dynamic> formatData = const {},
  ]) {
    return args.map((key, value) {
      if (value is String) {
        return MapEntry(key, parseStringFormat(context, value, parentContext, formatData));
      } else if (value is Map<String, dynamic>) {
        return MapEntry(key, parseMapFormat(context, value, parentContext, formatData));
      } else if (value is List<Map<String, dynamic>>) {
        return MapEntry(key, value.map((e) => parseMapFormat(context, e, parentContext, formatData)).toList());
      } else {
        return MapEntry(key, value);
      }
    });
  }

  static String parseStringFormat(BuildContext context, String text, ParentContext parentContext, [
    Map<String, dynamic>? data = const {}
  ]) {
    List<String?> keys = parseRegex(formatRegex, text);
    for (var key in keys) {
      if (key == null) continue;
      dynamic newKey = parse(context, key, parentContext, data!);
      dynamic newValue = parse(context, data[key], parentContext, data);
      if (newValue == null) continue;
      text = text.replaceAll("{$newKey}", newValue.toString());
    }
    return text;
  }

  static List<String?> parseRegex(String regex, String value, [int group = 1]) {
    return RegExp(regex)
      .allMatches(value)
      .map((match) => match.group(group))
      .toList();
  }
}

class ActionBuilder {
  static Function? buildActions(BuildContext context, List<JsonA> actions, ParentContext parentContext) {
    List<dynamic> preparedActions = [];

    // convert json actions to functions
    for (JsonA action in actions) {
      preparedActions.add(() async {
        ActionBuilderBase? builder = ActionBuilderFactory.getAction(context, action, parentContext);
        if (builder != null) {
          await builder.execute();
        } else {
          log("ActionBuilder: Unknown action: ${action.name}");
        }
      });
    }

    if (preparedActions.isEmpty) return null;

    // join the actions
    return () async {
      for (var action in preparedActions) {
        await action();
      }
    };
  }

  static void call(BuildContext context, List<JsonA> actions, ParentContext parentContext) {
    Function? builtActions = buildActions(context, actions, parentContext);
    if (builtActions != null) {
      builtActions();
    }
  }

  static Function()? directFunction(BuildContext context, List<JsonA> actions, ParentContext parentContext) {
    Function? builtActions = buildActions(context, actions, parentContext);
    return builtActions == null ? null : () => builtActions();
  }

  static Function(dynamic)? directFunctionWithArg(BuildContext context, List<JsonA> actions, ParentContext parentContext) {
    Function? builtActions = buildActions(context, actions, parentContext);
    return builtActions == null ? null : (dynamic a) => builtActions();
  }

  static Function(dynamic, dynamic)? directFunctionWithTwoArgs(BuildContext context, List<JsonA> actions, ParentContext parentContext) {
    Function? builtActions = buildActions(context, actions, parentContext);
    return builtActions == null ? null : (dynamic a, dynamic b) => builtActions();
  }
}
