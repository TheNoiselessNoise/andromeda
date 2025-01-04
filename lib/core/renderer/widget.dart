import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/v4.dart';
import '../language/ast.dart';
import '../renderer/_.dart';
import '../wrappers/_.dart';
import '../context/app_state.dart';

class AndromedaWidget extends StatefulWidget {
  final FWidget widgetDef;
  final Environment environment;
  final ExpressionEvaluator evaluator;
  final WidgetInstance? parentInstance;
  final List<AndromedaWidget> children;
  final String widgetKey;

  AndromedaWidget({super.key,
    required this.widgetDef,
    required this.environment,
    required this.evaluator,
    required this.parentInstance,
    this.children = const [],
  }) : widgetKey = const UuidV4().toString();

  @override
  AndromedaWidgetState createState() => AndromedaWidgetState();

  String get uniqId => const UuidV4().toString();

  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    throw Exception("Method 'realWidget' not implemented in $runtimeType");
  }
}

class AndromedaWidgetState<T extends AndromedaWidget> extends State<T> with TickerProviderStateMixin {
  @protected
  bool get isntReallyWidget => false;

  AnimationController? animationController;
  Map<String, Animation> _animations = {};

  final Map<String, dynamic> _pendingUpdates = {};
  final List<StreamSubscription> _reactAppSubscriptions = [];
  final Set<String> _reactAppVars = {};
  final List<StreamSubscription> _reactParentSubscriptions = [];
  final Set<String> _reactParentVars = {};

  late WidgetInstance instance;
  late Environment localEnv;
  late ExpressionEvaluator evaluator;
  
  bool _isBatchUpdating = false;
  bool initialized = false;

  // @state - when variable is changed, widget is rebuilt
  Map<String, dynamic> state = {};
  // @reactState - when variable is changed, widget is not rebuilt
  // but sends signal
  Map<String, dynamic> reactState = {};

  AppState? get appState => widget.evaluator.appState;
  String get uniqId => const UuidV4().toString();

  WidgetInstance? _lastInstance;
  AndromedaWidget? _loadingWidget;
  String? _lastWidgetKey;

  void log(Object message) { if (kDebugMode) print("[${widget.widgetDef.type}] $message"); }
  void logOnlyText(Object message) => logOnly("Text", message);
  void logOnly(String type, Object message) { if (runtimeType.toString() == "Andromeda${type}WidgetState" && kDebugMode) { print("[$type] $message"); } }

  static final _initStatus = <String, bool>{};
  String get _initKey => "${widget.widgetDef.type}_${widget.parentInstance?.widgetDef.type ?? 'root'}";

  bool _isInitialized(String key) {
    return _initStatus[_initKey] ?? false;
    // return initialized && widget.widgetKey == _lastWidgetKey;
  }

  @override
  void initState() {
    super.initState();
    if (isntReallyWidget) return;
    _initializeWidget();
  }

  // @override
  // void didUpdateWidget(covariant T oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   _initAnimations();
  // }

  Future<void> _initAnimations() async {
    if (!widget.widgetDef.hasAnimation) return;

    animationController?.dispose();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    final animations = await evaluatedAnimation;
    final props = await evaluatedProperties;

    for (final anim in animations) {
      if (anim is AndromedaAnimationWidget) {
        final type = props['type'] ?? 'unknown';
        final animation = anim.realAnimation(props, animationController!);
        if (animation != null) _animations[type] = animation;
      }
    }

    if (_animations.isNotEmpty) {
      // animationController!.addListener(() {
      //   if (mounted) setState(() {});
      // });

      animationController!.forward();
    }
  }

  Future<void> _initializeWidget() async {
    if (_initStatus[_initKey] == true) {
      localEnv = Environment(widget.environment);
      instance = WidgetInstance(widget.widgetDef, localEnv);
      instance.setFlutterWidgetState(this);
      if (widget.parentInstance != null) instance.setParentWidget(widget.parentInstance!);
      final stateEvaluator = widget.evaluator.newEvaluator(localEnv, instance);
      state = await stateEvaluator.evaluateStateBlock(widget.widgetDef.state);
      reactState = await stateEvaluator.evaluateStateBlock(widget.widgetDef.reactState);
      instance.setInitialState({ ...state, ...reactState, });
      evaluator = widget.evaluator.newEvaluator(localEnv, instance);
      initialized = true;
      await _initAppReact();
      await _initParentReact();
      await _initAnimations();
      return;
    }

    if (_isInitialized(widget.widgetKey)) {
      logOnlyText("⏭️ Skipping initialization for ${widget.widgetDef.type} - already initialized");
      return;
    }

    // if (_isInitialized(widget.widgetKey) && _lastInstance != null) {
    //   instance = _lastInstance!;
    //   localEnv = instance.environment;
    //   instance.setFlutterWidgetState(this);

    //   if (widget.parentInstance != null) {
    //     instance.setParentWidget(widget.parentInstance!);
    //   }

    //   evaluator = widget.evaluator.newEvaluator(localEnv, instance);

    //   if (widget.widgetDef.hasLoading) {
    //     logOnlyText("❗️ ${widget.widgetDef.type} has loading widget");
    //     _loadingWidget = (await evaluatedLoading).firstOrNull;
    //     logOnlyText("❗️ Loading widget: $_loadingWidget");
    //   }

    //   await _initAppReact();
    //   await _initParentReact();
    //   await _initAnimations();
    //   return;
    // }

    if (_isInitialized(widget.widgetKey)) return;

    print("🚀 Initializing widget ${widget.widgetDef.type}");
    
    localEnv = Environment(widget.environment);
    instance = WidgetInstance(widget.widgetDef, localEnv);
    instance.setFlutterWidgetState(this);

    if (widget.parentInstance != null) {
      instance.setParentWidget(widget.parentInstance!);
    }

    final stateEvaluator = widget.evaluator.newEvaluator(localEnv, instance);
    state = await stateEvaluator.evaluateStateBlock(widget.widgetDef.state);
    reactState = await stateEvaluator.evaluateStateBlock(widget.widgetDef.reactState);
    instance.setInitialState({ ...state, ...reactState, });

    evaluator = widget.evaluator.newEvaluator(localEnv, instance);
    
    if (widget.widgetDef.hasLoading) {
      logOnlyText("⛔️ ${widget.widgetDef.type} has loading widget");
      _loadingWidget = (await evaluatedLoading).firstOrNull;
      logOnlyText("⛔️ Loading widget: $_loadingWidget");
    }

    await _initAppReact();
    await _initParentReact();
    await _initAnimations();
    
    _lastInstance = instance;
    _lastWidgetKey = widget.widgetKey;
    _initStatus[_initKey] = true;
    initialized = true;
    print("✨ Finished initializing ${widget.widgetDef.type}");
  }

  void setInitalState(Map<String, dynamic> initialState) {
    state = initialState;
  }

  Future<void> _initParentReact() async {
    for (final sub in _reactParentSubscriptions) {
      sub.cancel();
    }
    _reactParentSubscriptions.clear();
    _reactParentVars.clear();

    _reactParentVars.addAll(await evaluatedReactParent);

    final ancestors = instance.getAncestors();
    for (final ancestor in ancestors) {
      if (ancestor.parentWidget != null) {
        _reactParentSubscriptions.add(
          ancestor.parentWidget!.stateStream.listen((signal) {
            if (_reactParentVars.contains(signal.name)) {
              if (mounted) setState(() {});
            }
          })
        );
      }
    }
  }

  Future<void> _initAppReact() async {
    if (appState == null) return;
    for (final sub in _reactAppSubscriptions) {
      sub.cancel();
    }
    _reactAppSubscriptions.clear();
    _reactAppVars.clear();

    _reactAppVars.addAll(await evaluatedReactApp);

    _reactAppSubscriptions.add(
      appState!.stateStream.listen((signal) {
        if (_reactAppVars.contains(signal.name)) {
          if (mounted) setState(() {});
        }
      })
    );
  }

  bool hasReactStateVar(String name) => reactState.containsKey(name);
  bool hasStateVar(String name) => state.containsKey(name) || hasReactStateVar(name);
  dynamic getStateVar(String name) => reactState[name] ?? state[name];

  void setStateVar(String name, dynamic value) {
    if (_isBatchUpdating) {
      _pendingUpdates[name] = value;
    } else if (state[name] != value) {
      final oldValue = state[name];
      if (hasReactStateVar(name)) {
        reactState[name] = value;
        instance.signalStateChange(name, value, oldValue);
      } else {
        setState(() { state[name] = value; });
      }
    }
  }

  void beginUpdate() => _isBatchUpdating = true;

  void endUpdate() {
    if (_isBatchUpdating) {
      _isBatchUpdating = false;

      bool hasChanges = false;
      for (var entry in _pendingUpdates.entries) {
        if (state[entry.key] != entry.value) {
          final oldValue = state[entry.key];
          state[entry.key] = entry.value;
          instance.signalStateChange(entry.key, entry.value, oldValue);
          hasChanges = true;
        }
      }

      if (hasChanges && mounted) {
        _pendingUpdates.clear();
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    for (final sub in _reactAppSubscriptions) {
      sub.cancel();
    }
    for (final sub in _reactParentSubscriptions) {
      sub.cancel();
    }
    instance.dispose();
    super.dispose();
  }

  ExpressionEvaluator get newEvaluator => widget.evaluator.newEvaluator(localEnv, instance);
  Future<bool> get evaluatedCondition => newEvaluator.evaluateConditionBlock(widget.widgetDef.condition);
  Future<List<AndromedaWidget>> get evaluatedConditionRender => evaluator.evaluateRenderBlock(widget.widgetDef.conditionRender);
  Future<List<AndromedaWidget>> get evaluatedLoading => evaluator.evaluateRenderBlock(widget.widgetDef.loading);
  Future<List<AndromedaWidget>> get evaluatedAnimation => evaluator.evaluateRenderBlock(widget.widgetDef.animation);
  Future<Map<String, dynamic>> get evaluatedProperties => evaluator.evaluatePropBlock(widget.widgetDef.prop);
  Future<Map<String, dynamic>> get evaluatedStyles => evaluator.evaluatePropBlock(widget.widgetDef.style);
  Future<Map<String, dynamic>> get evaluatedHandlers => evaluator.evaluateEventBlock(widget.widgetDef.event);
  Future<List<String>> get evaluatedReactApp => evaluator.evaluateReactBlock(widget.widgetDef.reactApp);
  Future<List<String>> get evaluatedReactParent => evaluator.evaluateReactBlock(widget.widgetDef.reactParent); 
  
  // TODO: repetitive
  Future<dynamic> executeHandler(dynamic handler, List<dynamic> arguments) async {
    if (arguments.isEmpty) {
      return await handler();
    } else {
      List args = arguments.map(AndromedaWrapper.wrap).toList();
      return await handler(args);
    }
  }

  // TODO: repetitive
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

  Future<dynamic> prepareHandler(String handlerName, int argCount) async {
    final availableHandlers = await evaluatedHandlers;
    if (!availableHandlers.containsKey(handlerName)) return null;
    dynamic handler = availableHandlers[handlerName];
    return callHandler(handler, argCount);
  }

  Future<dynamic> prepareCustomHandler(dynamic handler, int argCount) async {
    if (handler is Function) {
      return callHandler(handler, argCount);
    } else {
      return null;
    }
  }

  AndromedaWidget? render(FWidget? fwidget, AndromedaWidgetContext ctx, [List<AndromedaWidget> children = const []]) {
    if (fwidget == null) return null;
    return AndromedaConverter.widget(
      fwidget: fwidget,
      parentInstance: ctx.instance,
      environment: ctx.environment,
      evaluator: ctx.evaluator,
      children: children,
    );
  }

  Future<AndromedaWidgetContext> get widgetContext async {
    final props = await evaluatedProperties;
    final styles = await evaluatedStyles;
    final handlers = await evaluatedHandlers;

    return AndromedaWidgetContext(
      // ignore: use_build_context_synchronously
      context: context,
      widgetDef: widget.widgetDef,
      instance: instance,
      evaluator: evaluator,
      environment: localEnv,

      props: props,
      styles: styles,
      handlers: handlers,
    );
  }

  // ** --- Access from Andromeda --- **
  // NOTE: Override in AndromedaWidget's state classes
  Future<dynamic> getProperty(String name) async {
    switch (name) {
      case '\$type': return runtimeType;
      case '\$parent': return widget.parentInstance?.flutterWidgetState;
      case '\$instance': return instance;
      case '\$parentInstance': return widget.parentInstance;
      case '\$animation': return AndromedaWrapper.wrap(animationController);
      default: throw Exception("Property '$name' not found in $runtimeType");
    }
  }

  Future<dynamic> setProperty(String name, dynamic value) async {
    throw Exception("Property '$name' is read-only in $runtimeType");
  }

  // NOTE: Override in AndromedaWidget's state classes
  Future<dynamic> callMethod(String name, List<dynamic> args) async {
    switch (name) {
      case 'toString':
        return runtimeType;
      default: throw Exception("Method '$name' not found in $runtimeType");
    }
  }

  void expectAtLeastArgs(int count, List<dynamic> args, String name) {
    if (args.length < count) {
      throw Exception("Expected at least $count arguments for method '$name', but got ${args.length}");
    }
  }

  void expectAtMostArgs(int count, List<dynamic> args, String name) {
    if (args.length > count) {
      throw Exception("Expected at most $count arguments for method '$name', but got ${args.length}");
    }
  }

  void expectExactArgs(int count, List<dynamic> args, String name) {
    if (args.length != count) {
      throw Exception("Expected exactly $count arguments for method '$name', but got ${args.length}");
    }
  }

  void expectArgumentType<S>(dynamic arg, String name) {
    if (arg is! S) {
      throw Exception("Expected argument '$name' to be of type $S, but got ${arg.runtimeType}");
    }
  }
  // ** --- ------------------ --- **

  // NOTE: you can override it here and not use it in the Widget class itself (if you need access to the state)
  // NOTE: i am making it inside Widget class for simplicity for basic Flutter widgets that don't need access to the state
  Future<Widget> realWidget(AndromedaWidgetContext ctx) async {
    Widget w = await widget.realWidget(ctx);

    if (_animations.isNotEmpty) {
      w = AnimatedBuilder(
        animation: animationController!,
        builder: (context, child) {
          Widget current = child ?? w;

          if (_animations.containsKey('fade')) {
            final anim = _animations['fade'] as Animation<double>;
            current = Opacity(
              opacity: anim.value,
              child: current,
            );
          }

          if (_animations.containsKey('scale')) {
            final anim = _animations['scale'] as Animation<double>;
            current = Transform.scale(
              scale: anim.value,
              child: current,
            );
          }

          return current;
        },
        child: w,
      );
    }

    return w;
  }

  Future<Widget> createWidget() async {
    _loadingWidget = (await evaluatedLoading).firstOrNull;
    AndromedaWidgetContext ctx = await widgetContext;
    if (!(await evaluatedCondition)) {
      final conditionRender = await evaluatedConditionRender;
      return conditionRender.firstOrNull ?? const SizedBox.shrink();
    }
    return await realWidget(ctx);
  }

  @override
  Widget build(BuildContext context) {
    if (initialized) {
      return FutureBuilder<Widget>(
        future: createWidget(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            throw snapshot.error!;
          }

          if (!snapshot.hasData) {
            return _loadingWidget ?? const Center(child: CircularProgressIndicator());
          }

          logOnlyText("Building 1...");
          return snapshot.data!;
        },
      );
    }

    return FutureBuilder<void>(
      future: _initializeWidget(),
      builder: (context, initSnapshot) {
        if (initSnapshot.hasError) {
          throw initSnapshot.error!;
        }

        if (!initialized) {
          return _loadingWidget ?? const SizedBox.shrink();
        }

        return FutureBuilder<Widget>(
          future: createWidget(),
          builder: (context, createSnapshot) {
            if (createSnapshot.hasError) {
              throw createSnapshot.error!;
            }

            if (!createSnapshot.hasData) {
              return _loadingWidget ?? const Center(child: CircularProgressIndicator());
            }
            
            logOnlyText("Building 2...");
            return createSnapshot.data!;
          },
        );
      },
    );
  }
}