import 'package:flutter/material.dart';
import 'package:andromeda/core/_.dart';

class AndromedaTestAppPage extends StatefulWidget {
  final SAppConfig app;

  const AndromedaTestAppPage({
    super.key,
    required this.app,
  });

  @override
  State<AndromedaTestAppPage> createState() => _AndromedaTestAppPageState();
}

class _AndromedaTestAppPageState extends State<AndromedaTestAppPage> {
  SAppConfig get app => widget.app;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FScriptRoot(
        initialSource: app.content,
        loadingBuilder: (message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(message),
            ],
          )
        ),
        errorBuilder: (error, stackTrace, onReload) => ErrorHandlerWidget(
          error: error,
          stackTrace: stackTrace?.toString(),
          onReload: onReload
        ),
      ),
    );
  }
}