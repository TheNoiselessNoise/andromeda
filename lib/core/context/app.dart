import 'package:andromeda/core/_.dart';
import 'package:flutter/material.dart';

class AndromedaAppController extends ValueNotifier<MaterialAppSettings> {
  AndromedaAppController() : super(MaterialAppSettings());

  void updateSettings(MaterialAppSettings settings) {
    value = settings;
  }
}

class MaterialAppSettings {
  String? title;

  MaterialAppSettings({
    this.title,
  });
}

class AndromedaMaterialApp extends StatelessWidget {
  final appController = AndromedaAppController();
  final Widget initialPage;

  AndromedaMaterialApp({
    super.key,
    required this.initialPage,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<MaterialAppSettings>(
      valueListenable: appController,
      builder: (context, settings, _) {
        print("######################### BUILDING APP #########################");
        print("######################## BUILDING APP ########################");
        print("####################### BUILDING APP #######################");
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: settings.title ?? 'Andromeda App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
            ),
            useMaterial3: true,
          ),
          home: Material(
            child: FScriptRoot(
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
                onReload: onReload,
              ),
              appController: appController,
            ),
          ),
        );
      },
    );
  }
}