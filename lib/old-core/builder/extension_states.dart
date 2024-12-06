import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

class MetadataDownloaderState<T extends CoreBaseStatefulWidget> extends CoreBaseState<T> {
  bool metadataError = false;
  int? metadataErrorStatusCode = 0;
  double metadataLength = 0;
  double metadataRecieved = 0;
  double metadataProgress = 0;
  bool metadataDownloading = false;
  bool debugDownload = false;
  bool debugError = false;
  bool useDevMetadata = false;

  @override
  bool requireMetadata() => true;

  @override
  bool buildWhenEspo(EspoGlobalState previous, EspoGlobalState current) {
    return previous.metadata != current.metadata;
  }

  @protected
  Future<void> onMetadataDownloaded(BuildContext context) async {
    // do nothing
  }

  @protected
  Widget buildContentOnMetadata(BuildContext context) {
    return const Text("Metadata načtena");
  }

  @override
  Widget buildOnNoMetadata(BuildContext context) {
    return buildContent(context);
  }

  @protected
  Widget buildOnMetadataError(BuildContext context, int statusCode) {
    return Center(
      child: Column(
        children: [
          const Text("Chyba při načítání metadat"),
          ElevatedButton(
            onPressed: () => handlePermissions(() async => await downloadMetadata(context)),
            child: const Text("Znovu načíst"),
          ),
        ],
      ),
    );
  }

  @protected
  Widget buildMetadataProgress(BuildContext context, double progress) {
    return Center(
      child: Column(
        children: [
          Text("${(metadataProgress * 100).toStringAsFixed(2)}%"),
          LinearProgressIndicator(value: metadataProgress),
        ],
      ),
    );
  }

  Future<void> downloadMetadata(BuildContext context) async {
    if (debugError || debugDownload) return;

    if (metadataDownloading) return;
    if (espoState.metadata != null) return;
    
    // NOTE: this is crucial
    // if app has a login page, we can't get metadata without a user
    // so we instead use the api user
    bool useApiUser = AppConfig.useApiUser;
    EspoApi.useApiUser = true;

    int? metadataSize = await EspoApi.metadataLength();

    if (metadataSize == null) {
      setState(() {
        metadataError = true;
        metadataErrorStatusCode = -1;
      });
      return;
    }

    metadataDownloading = true;
    metadataLength = metadataSize.toDouble();

    await EspoApi.streamApi(
      url: EspoApiPoints.metadata,
      onError: (error) => setState(() {
        EspoApi.useApiUser = useApiUser;
        metadataError = true;
        metadataErrorStatusCode = -1;
      }),
      onUpdateProgress: (progress) {
        setState(() {
          metadataRecieved = progress;
          metadataProgress = progress / metadataLength;
        });
      },
      onDone: (data) async {
        metadataDownloading = false;
        EspoApi.useApiUser = useApiUser;
        EspoMetadata metadata = EspoMetadata.fromString(utf8.decode(data));
        if (useDevMetadata && context.mounted) metadata = await assignDevMetadata(context, metadata);
        if (context.mounted) espoBloc.setMetadata(metadata);
        if (context.mounted) onMetadataDownloaded(context);
      },
      onStatusCode: (statusCode) => setState(() {
        EspoApi.useApiUser = useApiUser;
        metadataError = true;
        metadataErrorStatusCode = statusCode;
      }),
    );
  }

  Future<EspoMetadata> assignDevMetadata(BuildContext context, EspoMetadata metadata) async {
    Map<String, dynamic> appSettings = Map<String, dynamic>.from(metadata.appSettings);
    Map<String, dynamic> pageDefinitions = Map<String, dynamic>.from(metadata.pageDefinitions);
    Map<String, dynamic> customMetadata = Map<String, dynamic>.from(metadata.customMetadata);
    Map<String, dynamic> customValues = Map<String, dynamic>.from(metadata.customValues);
    Map<String, dynamic> customComponents = Map<String, dynamic>.from(metadata.customComponents);

    myMergeMaps(appSettings, GlobalJsonData.appSettings.toMap());
    myMergeMaps(pageDefinitions, GlobalJsonData.pageDefinitions.toMap());
    myMergeMaps(customMetadata, GlobalJsonData.customMetadata.toMap());
    myMergeMaps(customValues, GlobalJsonData.customValues.toMap());
    myMergeMaps(customComponents, GlobalJsonData.customComponents.toMap());

    Map<String, dynamic> metadataData = Map<String, dynamic>.from(metadata.data);
    myMergeMaps(metadataData, GlobalJsonData.customMetadata.toMap());

    return EspoMetadata({
      ...metadataData,
      "appSettings": appSettings,
      "pageDefinitions": pageDefinitions,
      "customMetadata": customMetadata,
      "customValues": customValues,
      "customComponents": customComponents,
    });
  }

  @protected
  Widget buildMetadataContent(BuildContext context) {
    if (debugError || metadataError) {
      return buildOnMetadataError(context, metadataErrorStatusCode!);
    } else if (debugDownload || (metadataDownloading && metadataProgress > 0 && metadataLength > 0)) {
      return buildMetadataProgress(context, metadataProgress);
    } else {
      return buildContentOnMetadata(context); 
    }
  }
}