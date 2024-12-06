import 'dart:async';

import 'package:flutter/material.dart';
import '../api/_.dart';
import 'config.dart';
import 'script.dart';
import 'app.dart';

// First let's create a provider to hold our parsed data
class FScriptRoot extends StatefulWidget {
  final String? initialSource;
  final FScriptApiService? apiService;
  final Widget Function(String message)? loadingBuilder;
  final Widget Function(String error, StackTrace? stackTrace, VoidCallback onReload)? errorBuilder;
  final AndromedaAppController? appController;

  const FScriptRoot({
    super.key,
    this.initialSource,
    this.apiService,
    this.loadingBuilder,
    this.errorBuilder,
    this.appController,
  });

  @override
  State<FScriptRoot> createState() => _FScriptRootState();
}

class _FScriptRootState extends State<FScriptRoot> {
  FScriptApiService? _apiService;
  bool _loading = true;
  // ignore: unused_field
  String? _error;

  @override
  void initState() {
    super.initState();

    if (widget.apiService != null) {
      _initApiService(widget.apiService!.baseUrl, widget.apiService!.apiKey);
    } else {
      if (widget.initialSource == null) {
        _loadConfig();
      }
    }
  }

  Future<void> _loadConfig() async {
    try {
      final config = await FScriptConfig().getConfig();
      if (config != null) {
        final (server, apiKey) = config;
        _initApiService(server, apiKey);
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _initApiService(String server, String apiKey) {
    setState(() {
      _apiService = FScriptApiService(
        baseUrl: server,
        apiKey: apiKey,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Developer mode with initial source
    if (widget.initialSource != null) {
      return FScriptWidget(
        initialSource: widget.initialSource!,
        loadingBuilder: widget.loadingBuilder,
        errorBuilder: widget.errorBuilder,
      );
    }

    // Loading config
    if (_loading) {
      return widget.loadingBuilder?.call('Loading configuration...') ??
          const Center(child: CircularProgressIndicator());
    }

    // No config yet, show config screen
    if (_apiService == null) {
      return FScriptConfigScreen(
        onConfigured: (server, apiKey) {
          _initApiService(server, apiKey);
        },
      );
    }

    // Normal mode with API service
    return FScriptWidget(
      apiService: _apiService!,
      // TODO: define this somewhere
      scriptPath: 'main.andromeda',
      loadingBuilder: widget.loadingBuilder,
      errorBuilder: widget.errorBuilder,
      appController: widget.appController,
    );
  }
}
