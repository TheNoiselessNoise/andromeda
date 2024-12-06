import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:andromeda/old-core/core.dart';

enum MetadataLoadedType {
  none,
  fromStorage,
  downloaded,
}

class EspoLoaderWidget extends CoreBaseStatefulWidget {
  const EspoLoaderWidget({super.key});

  @override
  EspoLoaderWidgetState createState() => EspoLoaderWidgetState();
}

class EspoLoaderWidgetState extends MetadataDownloaderState<EspoLoaderWidget> {
  MetadataLoadedType metadataGetType = MetadataLoadedType.none;
  bool isLoggedIn = false;
  EspoMetadata? metadataFromStorage;

  @override
  bool rebuildOnStatesInitialized() => true;

  @override
  bool get useDevMetadata => true;

  @override
  bool buildWhenEspo(EspoGlobalState previous, EspoGlobalState current) {
    return previous.metadata != current.metadata;
  }

  @override
  void onStatesInitialized() {
    super.onStatesInitialized();

    loadMetadataFromStorage();
  }

  Future<void> loadMetadataFromStorage() async {
    metadataFromStorage = await EspoMetadata.fromStorage(
      AppConfig.defaultEspoMetadataStorageKey
    );

    if ((metadataFromStorage?.hasData ?? false) && mounted) {
      setState(() {
        metadataGetType = MetadataLoadedType.fromStorage;
        context.espoBloc.setMetadata(metadataFromStorage!);
        check();
      });
    } else if (mounted) {
      downloadMetadata(context);
    }
  }

  @override
  Future<void> onMetadataDownloaded(BuildContext context) async {
    setState(() {
      metadataGetType = MetadataLoadedType.downloaded;
      check();
    });
  }

  void check() async {
    if (metadataGetType == MetadataLoadedType.none) return;

    if (metadataGetType == MetadataLoadedType.downloaded) {
      await metadataFromStorage?.toStorage(
        AppConfig.defaultEspoMetadataStorageKey
      );
    }

    if (mounted) {
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) {
          String initialPage = context.metadata.appSettings['initialPage'];

          Widget page = EspoPageBuilder(
            page: context.espoBloc.getPageOr404(initialPage)
          );

          // manages the back button (history of pages)
          return PopScope(
            canPop: false,
            child: page,
            onPopInvoked: (didPop) async {
              if (!context.mounted) return;
              handlePopInvoked(context);
            },
          );
        })
      );
    }
  }

  void handlePopInvoked(BuildContext context) {
    if (context.coreState.pageHistory?.isNotEmpty ?? false) {
      context.coreBloc.popPage();
    } else {
      scheduleMicrotask(() async {
        bool? shouldPop = await showExitDialog(context);
        if (context.mounted && (shouldPop ?? false)) {
          Navigator.of(context).pop();
          exitApp();
        }
      });
    }
  }

  void exitApp() {
    // https://stackoverflow.com/a/57534684
    if (Platform.isAndroid) {
      // NOTE: android has no problem with this, it will close the app
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      // NOTE: iOS right? NOT LIKE THIS! we should do something else...???
      // exit(0);
    }
  }

  Future<bool?> showExitDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Opravdu chcete ukončit aplikaci?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Ne'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Ano'),
            ),
          ],
        );
      }
    );
  }

  double mapValue(double value, [double m1 = 0, double m2 = 1, double r1 = 0, double r2 = 1]) {
    return r1 + (value - m1) * (r2 - r1) / (m2 - m1);
  }
  
  @override
  Widget buildMetadataProgress(BuildContext context, double progress) {
    return Center(
      child: Column(
        children: [
          const Text('Načítání metadat'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: mapValue(progress, 0, 1, 2, 10),
              backgroundColor: Colors.grey[300],
              // color: CoreTheme.of(context).primaryColor,
              // valueColor: AlwaysStoppedAnimation<Color>(
              //   CoreTheme.of(context).primaryColor
              // ),
            ),
          ),
          Text(
            '${(progress * 100).round()}%',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ]
      ),
    );
  }

  @override
  Widget buildContentOnMetadata(BuildContext context) {
    if (metadataGetType == MetadataLoadedType.none) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Column(
              children: [
                if (metadataGetType == MetadataLoadedType.fromStorage) ...[
                  const Text('Data načtena', style: TextStyle(fontSize: 20)),
                ],
                if (metadataGetType == MetadataLoadedType.downloaded) ...[
                  const Text('Data stažena', style: TextStyle(fontSize: 20)),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    return buildMetadataContent(context);
  }
}