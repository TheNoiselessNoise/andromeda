import 'package:andromeda/old-core/core.dart';

class PageBuilder extends MapTraversable {
  const PageBuilder(super.data);

  PageBuilder setId(String id) {
    Map<String, dynamic> newData = dataCopy;
    newData['id'] = id;
    return PageBuilder(newData);
  }

  PageBuilder ignoreHistory([bool ignore = true]) {
    Map<String, dynamic> newData = dataCopy;
    newData['settings'] = Map<String, dynamic>.from(newData['settings'] ?? {});
    newData['settings']['ignoreHistory'] = ignore;
    return PageBuilder(newData);
  }

  PageBuilder appBarTitle(String title) {
    Map<String, dynamic> newData = dataCopy;
    newData['settings'] = Map<String, dynamic>.from(newData['settings'] ?? {});
    newData['settings']['appBar'] = Map<String, dynamic>.from(newData['settings']['appBar'] ?? {});
    newData['settings']['appBar']['title'] = title;
    return PageBuilder(newData);
  }

  PageBuilder addComponent(Map<String, dynamic> section) {
    Map<String, dynamic> newData = dataCopy;
    newData['components'] = newData['components'] ?? [];
    newData['components'].add(section);
    return PageBuilder(newData);
  }

  PageBuilder addComponentBuilder(ComponentBuilder builder) {
    return addComponent(builder.build());
  }

  Map<String, dynamic> build() {
    return data;
  }

  JsonP buildPage() {
    return JsonP(data['id'] ?? 'unknown', data);
  }
}