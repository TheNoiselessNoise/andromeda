import 'dart:async';

import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';
import 'update_checker.dart';

final GlobalKey<FScriptWidgetState> scriptWidgetKey = GlobalKey<FScriptWidgetState>();

class ScriptReloadService {
  static final ScriptReloadService _instance = ScriptReloadService._();
  factory ScriptReloadService() => _instance;
  ScriptReloadService._();

  Future<void> reload() async {
    if (scriptWidgetKey.currentState != null) {
      await scriptWidgetKey.currentState!.handleReload();
    }
  }
}

class ScriptContent {
  final String source;

  ScriptContent({required this.source});

  factory ScriptContent.fromJson(Map<String, dynamic> json) {
    return ScriptContent(source: json['source'] as String);
  }
}

// First let's create a provider to hold our parsed data
class FScriptData {
  final FApp? app;
  final Map<String, FClass> classes;
  final Map<String, FFunction> functions;
  final List<FPage> pages;
  final DateTime lastUpdated;

  FScriptData({
    this.app,
    required this.classes,
    required this.functions,
    required this.pages,
    required this.lastUpdated,
  });
}

class FScriptProvider extends InheritedWidget {
  final FScriptData data;
  final Function() onReload;

  const FScriptProvider({
    super.key,
    required this.data,
    required this.onReload,
    required super.child,
  });

  static FScriptProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FScriptProvider>();
  }

  @override
  bool updateShouldNotify(FScriptProvider oldWidget) {
    return data.lastUpdated != oldWidget.data.lastUpdated;
  }
}

// Main widget that handles the source code and parsing
class FScriptWidget extends StatefulWidget {
  final String? initialSource;
  final String? scriptPath;
  final FScriptApiService? apiService;
  final Widget Function(String message)? loadingBuilder;
  final Widget Function(String error, StackTrace? stackTrace, VoidCallback onReload)? errorBuilder;
  final Duration reloadDebounce;
  final AndromedaAppController? appController;

  const FScriptWidget._({
    super.key,
    this.initialSource,
    this.scriptPath,
    this.apiService,
    this.loadingBuilder,
    this.errorBuilder,
    this.reloadDebounce = const Duration(seconds: 1),
    this.appController,
  }) : assert (
    (initialSource != null) || (scriptPath != null && apiService != null),
    'Either initialSource or scriptPath and apiService must be provided',
  );

  factory FScriptWidget({
    Key? key,
    String? initialSource,
    String? scriptPath,
    FScriptApiService? apiService,
    Widget Function(String message)? loadingBuilder,
    Widget Function(String error, StackTrace? stackTrace, VoidCallback onReload)? errorBuilder,
    Duration reloadDebounce = const Duration(seconds: 1),
    AndromedaAppController? appController,
  }) {
    return FScriptWidget._(
      key: scriptWidgetKey,
      initialSource: initialSource,
      scriptPath: scriptPath,
      apiService: apiService,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      reloadDebounce: reloadDebounce,
      appController: appController,
    );
  }

  @override
  State<FScriptWidget> createState() => FScriptWidgetState();
}

class FScriptWidgetState extends State<FScriptWidget> {
  FScriptData? _data;
  Object? _error;
  StackTrace? _stackTrace;
  bool _loading = true;
  Timer? _reloadDebounce;
  String? _currentSource;
  UpdateChecker? updateChecker;

  @override
  void initState() {
    super.initState();

    if (widget.apiService != null) {
      updateChecker = UpdateChecker(
        apiService: widget.apiService!,
        scriptPath: widget.scriptPath!,
      );
      updateChecker?.startChecking();
    }

    _currentSource = widget.initialSource;
    if (_currentSource != null) {
      _parseSource(_currentSource!);
    } else {
      _loadFromApi();
    }
  }

  @override
  void dispose() {
    _reloadDebounce?.cancel();
    updateChecker?.dispose();
    super.dispose();
  }

  Future<void> _loadFromApi() async {
    assert(widget.apiService != null && widget.scriptPath != null);
    try {
      final content = await widget.apiService!.fetchScript(widget.scriptPath!);
      
      if (mounted) {
        setState(() {
          _currentSource = content.source;
          _parseSource(content.source);
        });
      }
    } catch (e, st) {
      if (mounted) {
        setState(() {
          _error = e;
          _stackTrace = st;
          _loading = false;
        });
      }
    }
  }

  void _parseSource(String source) {
    try {
      final lexer = Lexer(source);
      final tokens = lexer.scanTokens();
      final parser = Parser(tokens);
      final declarations = parser.parse();

      final app = declarations.whereType<FApp>().firstOrNull;

      final classes = Map.fromEntries(
        declarations.whereType<FClass>()
          .map((c) => MapEntry(c.name.lexeme, c))
      );

      final functions = Map.fromEntries(
        declarations.whereType<FFunction>()
          .map((f) => MapEntry(f.name.lexeme, f))
      );

      final pages = declarations.whereType<FPage>().toList();

      setState(() {
        _data = FScriptData(
          app: app,
          classes: classes,
          functions: functions,
          pages: pages,
          lastUpdated: DateTime.now(),
        );
        _loading = false;
      });
    } catch (e, st) {
      setState(() {
        _error = e;
        _stackTrace = st;
        _loading = false;
      });
    }
  }

  Future<void> handleReload() async {
    if (_reloadDebounce?.isActive ?? false) return;
    _reloadDebounce = Timer(widget.reloadDebounce, () {});

    setState(() {
      _loading = true;
    });

    // In development mode, just reparse the initial source
    if (widget.initialSource != null) {
      _parseSource(widget.initialSource!);
      return;
    }

    // In production mode, fetch from API
    try {
      final newContent = await widget.apiService!.fetchScript(widget.scriptPath!);
      
      // Only update if source actually changed
      if (newContent.source != _currentSource) {
        if (mounted) {
          setState(() {
            _currentSource = newContent.source;
            _parseSource(newContent.source);
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _loading = false;
          });
        }
      }
    } catch (e, st) {
      if (mounted) {
        setState(() {
          _error = e;
          _stackTrace = st;
          _loading = false;
        });
      }
    }
  }

  Future<void> _handleUpdate() async {
    final source = await updateChecker?.fetchUpdate();
    if (source != null) {
      setState(() {
        _currentSource = source;
        _parseSource(source);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      // TODO: this hangs here if script cannot be downloaded (for example server is down)
      return widget.loadingBuilder?.call('Loading script...') ?? 
        const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return widget.errorBuilder?.call(
        _error.toString(), 
        _stackTrace,
        handleReload,
      ) ?? ErrorHandlerWidget(
        error: _error.toString(),
        stackTrace: _stackTrace?.toString(),
        onReload: handleReload,
      );
    }

    try {
      final app = _data!.app;
      if (app == null) {
        throw Exception('No App declaration found in source');
      }

      return UpdateNotifier(
        onUpdate: _handleUpdate,
        child: FScriptProvider(
          data: _data!,
          onReload: handleReload,
          child: AndromedaCustomApp(
            app: app,
            appController: widget.appController,
          ),
        ),
      );
    } catch (e, st) {
      return ErrorHandlerWidget(
        error: e.toString(),
        stackTrace: st.toString(),
        onReload: handleReload,
      );
    }
  }
}
