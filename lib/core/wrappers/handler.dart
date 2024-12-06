import 'package:andromeda/core/_.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BuiltInHandlerFunc {
  final BuildContext context;
  final List<dynamic> args;
  final Environment environment;
  final ExpressionEvaluator evaluator;
  final WidgetInstance? parentInstance;

  const BuiltInHandlerFunc({
    required this.context,
    required this.args,
    required this.environment,
    required this.evaluator,
    required this.parentInstance,
  });

  
  
}

class BuiltInHandler {
  final BuildContext context;
  final Environment environment;
  final ExpressionEvaluator evaluator;
  final WidgetInstance parentInstance;

  BuiltInHandler({
    required this.context,
    required this.environment,
    required this.evaluator,
    required this.parentInstance,
  });

  FScriptProvider getProvider(BuildContext context) => FScriptProvider.of(context)!;

  Future<dynamic> handle(String name, [List<dynamic> args = const []]) async {
    switch (name) {
      case '#log': return await _log(context, args);
      case '#showSnackBar': return await _showSnackBar(context, args);
      case '#navigate': return await _navigate(context, args);
      case '#duration': return await _duration(context, args);
      case '#delay': return await _delay(context, args);
      default: throw Exception('Unsupported builtin: $name');
    }
  }

  Future<dynamic> _log(BuildContext context, List<dynamic> args) async {
    if (args.isEmpty) return;
    for (final arg in args) {
      if (kDebugMode) print("[ANDROMEDA LOG]: $arg");
    }
  }

  Future<Duration> _duration(BuildContext context, List<dynamic> args) async {
    if (args.isEmpty) return Duration.zero;
    switch (args.length) {
      case 0: return Duration.zero;
      case 1: return Duration(days: args.first);
      case 2: return Duration(days: args.first, hours: args[1]);
      case 3: return Duration(days: args.first, hours: args[1], minutes: args[2]);
      case 4: return Duration(days: args.first, hours: args[1], minutes: args[2], seconds: args[3]);
      case 5: return Duration(days: args.first, hours: args[1], minutes: args[2], seconds: args[3], milliseconds: args[4]);
      case 6: return Duration(days: args.first, hours: args[1], minutes: args[2], seconds: args[3], milliseconds: args[4], microseconds: args[5]);
      default: throw Exception('Invalid duration arguments');
    }
  }

  Future<dynamic> _delay(BuildContext context, List<dynamic> args) async {
    if (args.isEmpty) return;
    if (args.first is! Duration) return;
    return Future.delayed(args.first);
  }

  Future<dynamic> _showSnackBar(BuildContext context, List<dynamic> args) async {
    if (args.isEmpty) return;
    if (args.first is! FWidget) return;
    // ScaffoldMessenger.of(context).showSnackBar(
    //   await FWidgetConverter.realWidget(
    //     context: context,
    //     fwidget: args.first,
    //     parentInstance: parentInstance,
    //     environment: environment,
    //     evaluator: evaluator,
    //   )
    // );
  }

  Future<dynamic> _navigate(BuildContext context, List<dynamic> args) async {
    if (args.isEmpty) return;
    final target = args[0];
    final pageArgs = args.skip(1).toList();

    final targetPage = getProvider(context).data.pages.firstWhere(
      (p) => p.name.lexeme == target.toString(),
      orElse: () => throw Exception("Page '$target' not found"),
    );

    final props = <String, dynamic>{};
    for (var i = 0; i < targetPage.params.length && i < pageArgs.length; i++) {
      props[targetPage.params[i].name.lexeme] = pageArgs[i];
    }

    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => AndromedaPage(
    //       page: targetPage,
    //       environment: environment,
    //       evaluator: evaluator,
    //       onBuiltin: handle,
    //     ),
    //   ),
    // );
  }
}