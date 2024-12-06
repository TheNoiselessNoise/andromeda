import 'package:andromeda/old-core/core.dart';

class PBuilder {
  final EspoMetadata metadata;

  const PBuilder({required this.metadata});

  LBuilder get layoutBuilder => LBuilder(metadata);

  static Map<String, dynamic> error404PageMap() {
    return {
      "id": "404",
      "entityType": null,
      "settings": {
        "appBar": CBuilder.appBarWithoutLeading("Error 404"),
      },
      'component': CBuilder.detail([
        [
          CBuilder.row([
            CBuilder.expanded(
              CBuilder.center(
                CBuilder.textLabel('Page \'>{{currentPageId;unknown}}\' not found', "#000000"),
              ).applyPaddingVH(32, 0),
            )
          ])
        ],
        [
          CBuilder.row([
            CBuilder.expanded(
              CBuilder.button(
                CBuilder.textLabel("Go Back", "#ffffff"),
                [
                  ABuilder.a(ActionPageBack.id)
                ]
              ).applyPaddingVH(0, 32),
            ),
          ])
        ]
      ])
    };
  }

  static Map<String, dynamic> getPageOr404Map([String? pageId]) {
    return GlobalJsonData.pageDefinitions.data[pageId] ?? error404PageMap();
  }

  static JsonP error404Page() {
    Map<String, dynamic> page = error404PageMap();
    return JsonP(page['id'], page);
  }

  static JsonP getPageOr404([String? pageId]) {
    Map<String, dynamic> page = getPageOr404Map(pageId);
    return JsonP(pageId ?? '404', page);
  }

  static JsonP setupPage({
    required EspoMetadata metadata,
    String? pageId,
    String? entityType,
    JsonC? appBar,
    dynamic drawer,
  }) {
    pageId ??= Generator.rNumericString(8, 'page_');

    Map<String, dynamic> data = {
      'id': pageId,
      'settings': {
        'appBar': appBar ?? {},
        'drawer': drawer ?? {},
      }
    };

    if (entityType != null) {
      data['entityType'] = entityType;
    }

    return JsonP(pageId, data);
  }

  static JsonP? buildPage({
    required EspoMetadata metadata,
    String? entityType,
    String? pageId,
    JsonC? appBar,
    dynamic drawer,
    required List<String> layout,
    Map<String, dynamic> listInfo = const {},
  }) {
    JsonP newPage = setupPage(
      metadata: metadata,
      pageId: pageId,
      entityType: entityType,
      appBar: appBar,
      drawer: drawer,
    );

    if (layout.isNotEmpty) {
      if (layout.length != 2) return null;

      LBuilder layoutBuilder = LBuilder(metadata);
      JsonC? component = layoutBuilder.buildLayout(layout[0], layout[1],
        listInfo: listInfo
      );
      if (component == null) return null;

      newPage.addComponent(component);
    }

    return newPage;
  }
}