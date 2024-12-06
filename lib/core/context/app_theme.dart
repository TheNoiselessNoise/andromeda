import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class ThemedApp extends StatelessWidget {
  final Widget child;
  final AndromedaAppTheme theme;

  const ThemedApp({
    super.key,
    required this.child,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    final primary = theme.primary ?? currentTheme.primaryColor;
    final onPrimary = theme.onPrimary ?? currentTheme.colorScheme.onPrimary;
    final secondary = theme.secondary ?? currentTheme.colorScheme.secondary;

    // TODO: support other theme properties
    final newColorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      primary: primary,
      onPrimary: onPrimary,
      secondary: secondary,
    );

    return Theme(
      data: currentTheme.copyWith(
        colorScheme: newColorScheme,
        primaryColor: primary,
      ),
      child: child,
    );
  }
}

class AndromedaAppConfig extends ContextableMapTraversable {
  const AndromedaAppConfig(super.context, super.data);

  String? get title => get('title');
  Map<String, dynamic> get theme => getMap('theme');
}

class AndromedaAppTheme extends ContextableMapTraversable {
  const AndromedaAppTheme(super.context, super.data);

  Color? get primary => themeColorFromString(get('primary'), context);
  Color? get onPrimary => themeColorFromString(get('onPrimary'), context);
  Color? get secondary => themeColorFromString(get('secondary'), context);
}

class AndromedaCustomApp extends StatefulWidget {
  final FApp app;
  final AndromedaAppController? appController;

  const AndromedaCustomApp({
    super.key,
    required this.app,
    this.appController,
  });

  @override
  AndromedaAppState createState() => AndromedaAppState();
}

class AndromedaAppState extends State<AndromedaCustomApp> {
  late Environment environment;
  late ExpressionEvaluator evaluator;
  late WidgetInstance appInstance;
  late AppState appState;

  AndromedaAppConfig? appConfig;
  AndromedaAppTheme? appTheme;

  Object? error;
  StackTrace? stackTrace;
  bool _initialized = false;

  FScriptProvider get provider => FScriptProvider.of(context)!;

  @override
  void initState() {
    environment = Environment();
    appState = AppStateHolder.getInstance();

    const pageWidget = FWidget(
      '<root>',
      // stateBlock: widget.app.stateBlock,
      // styleBlock: widget.app.styleBlock,
      // renderBlock: widget.page.renderBlock
    );

    appInstance = WidgetInstance(pageWidget, environment);

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_initialized) {
        _initialize();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      _initialize();
    }
  }

  Future<void> _initialize() async {
    try {
      if (_initialized) return;

      evaluator = ExpressionEvaluator(
        environment,
        provider.data.classes,
        provider.data.functions,
        _handleBuiltin,
        appInstance
      );

      final initialState = await evaluator.evaluateStateBlock(widget.app.state);
      appState.setInitialState(initialState);

      final configMap = await evaluator.evaluateConfigBlock(widget.app.config);
      appConfig = AndromedaAppConfig(context, configMap);
      appTheme = AndromedaAppTheme(context, appConfig!.theme);

      evaluator = ExpressionEvaluator(
        environment,
        provider.data.classes,
        provider.data.functions,
        _handleBuiltin,
        appInstance,
        appState,
      );

      widget.appController?.updateSettings(
        MaterialAppSettings(
          title: appConfig?.title,
        ),
      );

      _initialized = true;
      error = null;
      stackTrace = null;
    } catch (e, st) {
      error = e;
      stackTrace = st;
    }
  }

  Future<dynamic> _handleBuiltin(String name, List<dynamic> args) async {
    try {
      return await BuiltInHandler(
        context: context,
        parentInstance: appInstance,
        environment: environment,
        evaluator: evaluator,
      ).handle(name, args);
    } catch (e, st) {
      setState(() {
        error = e;
        stackTrace = st;
      });
    }
  }

  Widget _evaluateHomePage() {
    List<FPage> pages = widget.app.pages.pages;

    pages.addAll(provider.data.pages);

    if (pages.isEmpty) {
      return const Center(child: Text('No pages found.'));
    }

    return AndromedaPage(
      page: pages.first,
      environment: environment,
      evaluator: evaluator,
      onBuiltin: _handleBuiltin,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return ErrorHandlerWidget(
        error: error.toString(),
        stackTrace: stackTrace?.toString(),
        onReload: () => setState(() {
          error = null;
          stackTrace = null;
        }),
      );
    }

    print("primary Color: ${appTheme?.primary}");
    print("config primary Color: ${appConfig?.theme['primary']}");

    return ThemedApp(
      theme: appTheme ?? AndromedaAppTheme(context, {
        'primary': 'blue',
        'secondary': 'green',
      }),
      child: _evaluateHomePage(),
    );
  }
}