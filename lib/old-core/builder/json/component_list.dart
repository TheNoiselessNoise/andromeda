import 'package:andromeda/old-core/core.dart';

class ListModes {
  static const String custom = "custom";
  static const String compact = "compact";
  static const String expanded = "expanded";
}

class PaginationTypes {
  static const String arrows = "arrows"; // arrows (left and right)
  static const String infinite = "infinite"; // load more on scroll
}

class JsonListPagination extends MapTraversable {
  const JsonListPagination(super.data);

  bool get enabled => getBool('enabled', false);
  int get initial => getInt('default', 0);
  String get type => getString('type', PaginationTypes.arrows);
}

class JsonListQuery extends MapTraversable {
  const JsonListQuery(super.data);

  List<JsonFilter> get defaultFilters => getList('defaultFilters')
    .map((e) => JsonFilter(e))
    .toList();
  JsonOrder get order => JsonOrder(getMap('order'));
  int get limit => getInt('limit', 10);
}

class JsonListFilters extends MapTraversable {
  const JsonListFilters(super.data);

  bool get enabled => getBool('enabled', false);
  Map<String, List<dynamic>> get fields => getMap('fields');
}

class JsonListLimits extends MapTraversable {
  const JsonListLimits(super.data);

  bool get enabled => getBool('enabled', false);
  List<int> get options => getList('options');
}

class JsonListSettingsInformation extends MapTraversable {
  const JsonListSettingsInformation(super.data);

  bool get enabled => getBool('enabled', false);
}

class JsonListRefresh extends MapTraversable {
  const JsonListRefresh(super.data);

  bool get enabled => getBool('enabled', false);
  int get interval => getInt('interval', 0);
}

class JsonListWhenEmpty extends MapTraversable {
  const JsonListWhenEmpty(super.data);

  JsonC get component => JsonC(getMap('component'));
  JsonC get paginationComponent => JsonC(getMap('paginationComponent'));
  JsonC get listReplaceComponent => JsonC(getMap('listReplaceComponent'));

  bool get hasComponent => component.hasData;
  bool get hasPaginationComponent => paginationComponent.hasData;
  bool get hasListReplaceComponent => listReplaceComponent.hasData;
}

class JsonListRefreshButton extends MapTraversable {
  const JsonListRefreshButton(super.data);

  bool get enabled => getBool('enabled', false);
}

class JsonListSettings extends MapTraversable {
  const JsonListSettings(super.data);

  JsonListSettingsInformation get information => JsonListSettingsInformation(getMap('information'));
  JsonListLimits get limits => JsonListLimits(getMap('limits'));
  JsonListPagination get pagination => JsonListPagination(getMap('pagination'));
  JsonListFilters get filters => JsonListFilters(getMap('filters'));
  JsonListRefreshButton get refreshButton => JsonListRefreshButton(getMap('refreshButton'));

  bool get shouldShowSettings {
    bool hasFilters = filters.enabled;
    bool hasLimits = limits.enabled && limits.options.length > 1;
    bool hasInformation = information.enabled;
    return hasFilters || hasLimits || hasInformation;
  }
}
