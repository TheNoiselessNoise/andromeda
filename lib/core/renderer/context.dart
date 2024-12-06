import 'dart:async';
import 'package:flutter/material.dart';
import '../language/ast.dart';
import '../renderer/_.dart';
import '../wrappers/_.dart';

class AndromedaWidgetContext {
  final BuildContext context;
  final FWidget widgetDef;
  final WidgetInstance instance;
  final ExpressionEvaluator evaluator;
  final Environment environment;

  Map<String, dynamic> props;
  Map<String, dynamic> styles;
  Map<String, dynamic> handlers;

  AndromedaWidgetContext({
    required this.context,
    required this.widgetDef,
    required this.instance,
    required this.evaluator,
    required this.environment,

    this.props = const {},
    this.styles = const {},
    this.handlers = const {},
  });

  AndromedaWidgetContext withVariable(String name, dynamic value) {
    final newEnv = Environment(environment);
    newEnv.define(name, value);
    return AndromedaWidgetContext(
      context: context,
      widgetDef: widgetDef,
      instance: instance,
      evaluator: evaluator.newEvaluator(newEnv, instance),
      environment: newEnv,
      props: props,
      styles: styles,
      handlers: handlers,
    );
  }

  Future<List<AndromedaWidget>> get children => evaluator.evaluateRenderBlock(widgetDef.render);
  Future<Widget?> get firstChildOrNull async => (await children).firstOrNull;
  Future<Widget> get firstChild async => (await firstChildOrNull) ?? const SizedBox.shrink();

  Future<dynamic> executeHandler(dynamic handler, List<dynamic> arguments) async {
    if (arguments.isEmpty) {
      return await handler();
    } else {
      List args = arguments.map(AndromedaWrapper.wrap).toList();
      return await handler(args);
    }
  }

  dynamic callHandler(dynamic handler, int argCount) {
    switch (argCount) {
      case 0: return () => executeHandler(handler, []);
      case 1: return (arg1) => executeHandler(handler, [arg1]);
      case 2: return (arg1, arg2) => executeHandler(handler, [arg1, arg2]);
      case 3: return (arg1, arg2, arg3) => executeHandler(handler, [arg1, arg2, arg3]);
      case 4: return (arg1, arg2, arg3, arg4) => executeHandler(handler, [arg1, arg2, arg3, arg4]);
      case 5: return (arg1, arg2, arg3, arg4, arg5) => executeHandler(handler, [arg1, arg2, arg3, arg4, arg5]);
      default: throw ArgumentError('Unsupported argument count: $argCount');
    }
  }

  dynamic prepareHandler(String handlerName, int argCount) {
    if (!handlers.containsKey(handlerName)) return null;
    dynamic handler = handlers[handlerName];
    return callHandler(handler, argCount);
  }

  dynamic prepareCustomHandler(dynamic handler, int argCount) {
    if (handler is Function) {
      return callHandler(handler, argCount);
    } else {
      return null;
    }
  }

  Future<S?> renderReal<S>(FWidget? fwidget) async {
    if (fwidget == null) return null;

    AndromedaWidget widget = AndromedaConverter.widget(
      fwidget: fwidget,
      parentInstance: instance,
      environment: environment,
      evaluator: evaluator,
    );

    return (await widget.realWidget(this)) as S?;
  }

  AndromedaWidget? render(FWidget? fwidget, [List<AndromedaWidget> children = const []]) {
    if (fwidget == null) return null;
    return AndromedaConverter.widget(
      fwidget: fwidget,
      parentInstance: instance,
      environment: environment,
      evaluator: evaluator,
      children: children,
    );
  }

  Widget renderRequired(FWidget? fwidget, [List<AndromedaWidget> children = const []]) {
    return render(fwidget, children) ?? const SizedBox.shrink();
  }

  PreferredSizeWidget? renderPreferredSize(FWidget? fwidget) {
    if (fwidget == null) return null;
    Widget child = AndromedaConverter.widget(
      fwidget: fwidget,
      parentInstance: instance,
      environment: environment,
      evaluator: evaluator,
    );

    if (child is PreferredSizeWidget) return child;

    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: child,
    );
  }
}