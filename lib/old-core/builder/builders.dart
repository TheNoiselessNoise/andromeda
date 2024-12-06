// ignore_for_file: constant_identifier_names

import 'dart:math';

import 'package:collection/collection.dart';
import 'package:uuid/v4.dart';
import 'package:andromeda/old-core/core.dart';

class Generator {
  static String alpha = 'abcdefghijklmnopqrstuvwxyz';
  static String numeric = '0123456789';
  static String alphaNumeric = '$alpha$numeric';

  static List<String> used = [];

  static String prefix(String value, [String prefix='', String suffix='']) {
    return '$prefix$value$suffix';
  }

  static String uuidv4([String prefix='', String suffix='']) {
    return Generator.prefix(const UuidV4().toString(), prefix, suffix);
  }

  static String rString([String? charset, int length=8, String prefix='', String suffix='']) {
    charset = charset ?? Generator.alphaNumeric;

    String? gen;
    while (gen == null || Generator.used.contains(gen)) {
      gen = List.generate(length, (index) {
        return charset!.codeUnitAt(Random().nextInt(charset.length));
      }).map((e) => String.fromCharCode(e)).join('');
    }
    Generator.used.add(gen);
    return Generator.prefix(gen, prefix, suffix);
  }

  static String rAlphaString([int length=8, String prefix='', String suffix='']) {
    return Generator.rString(Generator.alpha, length, prefix, suffix);
  }

  static String rAlphaNumericString([int length=8, String prefix='', String suffix='']) {
    return Generator.rString(Generator.alphaNumeric, length, prefix, suffix);
  }

  static String rNumericString([int length=8, String prefix='', String suffix='']) {
    return Generator.rString(Generator.numeric, length, prefix, suffix);
  }
}

class TF {
  static String i18n(String text) {
    return "#{{$text}}";
  }
}

class LBuilder {
  final EspoMetadata? _metadata;

  LBuilder([this._metadata]);

  EspoMetadata get metadata => _metadata ?? const EspoMetadata({});

  static String iconFromIconClass(String? iconClass, [bool faIcon = true]) {
    String defaultIcon = faIcon ? C.DEFAULT_FA_ICON : C.DEFAULT_ICON;

    if (iconClass == null) return defaultIcon;

    String icon = iconClass
      .trim()
      .split(' ')
      .firstWhere((e) => e.startsWith('fa-'), orElse: () => defaultIcon);

    icon = icon.substring(3);

    if (faIcon && icon.contains('-')) {
      List<String> parts = icon.split('-');
      icon = parts.first + parts.slice(1).map((part) => part.capitalize()).join('');
    }

    return icon;
  }

  JsonC? itemToListTile(dynamic item) {
    if (item is! String) return null;
    if (metadata.scopes == null) return null;
    if (!metadata.scopes!.containsKey(item)) return null;

    Map<String, dynamic> clientDef = metadata.clientDefs?[item] ?? {};
    String iconClass = iconFromIconClass(clientDef['iconClass']);

    return CBuilder.c(CTypes.listTile, {
      'leading': CBuilder.faIcon(iconClass),
      'title': CBuilder.textLabel(TF.i18n("Global.scopeNamesPlural.$item")),
      'onTap': [
        ABuilder.a(ActionSetPage.id, { "page": "$item/list" }),
        ABuilder.a(ActionCloseDrawer.id)
      ],
    });
  }

  JsonC? getDrawer(dynamic drawer) {
    if (drawer is JsonC) return drawer;
    if (drawer is Map) return JsonC.from(drawer);
    if (drawer == "[fromTabList]") return buildDrawerFromTabListWith(false);
    if (drawer == "[fromTabList+logoutButton]") return buildDrawerFromTabListWith(true);
    return null;
  }

  JsonC buildDrawerFromTabListWith([bool addLogoutButton = false]) {
    JsonC cListView = buildDrawerTabList();

    if (addLogoutButton) {
      cListView.addC(CBuilder.logoutButton());
    }

    return buildDrawerFromListView(cListView);
  }

  JsonC buildDrawerTabList([Map<String, dynamic>? tabList]) {
    tabList = tabList ?? metadata.tabList ?? {};

    List<JsonC> listItems = [];

    for (var n in tabList.keys) {
      dynamic tab = tabList[n];

      if (tab is Map) {
        String tabType = tab['type'] ?? 'group';

        // NOTE: are there any other types?
        if (tabType != 'group') continue;

        dynamic itemList = tab['itemList'] ?? [];

        if (itemList is! List || itemList.isEmpty) continue;

        String text = tab['text'] ?? 'Unknown';
        String iconClass = iconFromIconClass(tab['iconClass']);

        JsonC cExpansionTile = CBuilder.c(CTypes.expansionTile, {
          'title': CBuilder.textLabel(text),
          'leading': CBuilder.faIcon(iconClass),
        });

        for (var item in itemList) {
          JsonC? cItem = itemToListTile(item);
          if (cItem != null) cExpansionTile.addC(cItem);
        }

        listItems.add(cExpansionTile);
      } else {
        JsonC? cItem = itemToListTile(tab);
        if (cItem != null) listItems.add(cItem);
      }
    }

    JsonC cListView = CBuilder.c(CTypes.listView);

    cListView.addC(listItems);

    return cListView;
  }

  JsonC buildDrawerFromListView(JsonC cListView) {
    JsonC cDrawer = CBuilder.c(CTypes.drawer);
    JsonC cSafeArea = CBuilder.c(CTypes.safeArea);
    cSafeArea.addC(cListView);
    cDrawer.addC(cSafeArea);
    return cDrawer;
  }

  JsonC buildDrawerFromTabList([Map<String, dynamic>? tabList = const {}]) {
    return buildDrawerFromListView(buildDrawerTabList(tabList));
  }

  List<int> range(int start, int end) {
    return List<int>.generate(end - start, (index) => start + index);
  }

  JsonC buildLayoutDetailWithTabs(dynamic layout, [int fieldsForRow = 2]) {
    if (layout is! List) return CBuilder.c(CTypes.container);

    print("Building detail layout with tabs...");

    List<String> iconNames = List<int>.generate(layout.length, (index) => index)
      .map((index) => C.DEFAULT_ICON).toList();

    JsonC cColumn = CBuilder.c(CTypes.column);
    JsonC cExpanded = CBuilder.c(CTypes.expanded);
    JsonC cDTC = CBuilder.c(CTypes.defaultTabController, {
      'length': layout.length,
      'initialIndex': 0,
    });
    JsonC cTabBar = tabBarFromIconNames(iconNames);
    JsonC cInnerColumn = CBuilder.c(CTypes.column);
    JsonC cInnerExpanded = CBuilder.c(CTypes.expanded);
    JsonC cTabBarView = CBuilder.c(CTypes.tabBarView);

    List preparedLayout = [];

    for (var tab in layout) {
      if (tab is! Map) continue;

      List rows = tab['rows'] ?? [];
      List preparedTab = [];

      for (var r in rows) {
        if (r is! List) continue;

        List preparedFields = [];

        for (var c in r) {
          if (c is! Map) continue;
          preparedFields.add(c);

          if (preparedFields.length >= fieldsForRow) {
            preparedTab.add(preparedFields);
            preparedFields = [];
          }
        }

        if (preparedFields.length >= fieldsForRow) {
          preparedTab.add(preparedFields);
          preparedFields = [];
        }

        if (preparedFields.isNotEmpty) {
          preparedTab.add(preparedFields);
        }
      }

      if (preparedTab.isNotEmpty) {
        preparedLayout.add(preparedTab);
      }
    }

    for (var tab in preparedLayout) {
      JsonC cDetail = CBuilder.c(CTypes.detail);

      for (var row in tab) {
        if (row is! List) continue;
        row = row.whereNot((e) => e is! List).toList();

        List<JsonC> headers = row.map((e) {
          return CBuilder.c(CTypes.fieldLabel)
            .addCArgs({ 'name': e['name'] })
            .addInfo(CTypes.text, { 'fontWeight': 'bold' });
        }).toList();

        cDetail.addC(headers);

        List<JsonC> fields = row.map((e) {
          return CBuilder.c(CTypes.field)
            .addCArgs({ 'name': e['name'] });
        }).toList();

        cDetail.addC(fields);
      }

      JsonC cSCSV = CBuilder.c(CTypes.singleChildScrollView);

      cSCSV.addC(cDetail);

      cTabBarView.addC(cSCSV);
    }

    cInnerExpanded.addC(cTabBarView);
    cInnerColumn.addC(cTabBar);
    cInnerColumn.addC(cInnerExpanded);
    cDTC.addC(cInnerColumn);
    cExpanded.addC(cDTC);
    cColumn.addC(cExpanded);

    return cColumn;
  }

  JsonC buildLayoutDetail(dynamic layout, [int fieldsForRow = 2]) {
    if (layout is! List) return CBuilder.c(CTypes.container);

    print("Building detail layout...");

    List preparedLayout = [];

    JsonC cColumn = CBuilder.c(CTypes.column);

    for (var section in layout) {
      if (section is! Map) continue;

      List rows = section['rows'] ?? [];

      List preparedSection = [];

      for (var r in rows) {
        if (r is! List) continue;

        List preparedFields = [];

        for (var c in r) {
          if (c is! Map) continue;
          preparedFields.add(c);

          if (preparedFields.length >= fieldsForRow) {
            preparedSection.add(preparedFields);
            preparedFields = [];
          }
        }

        if (preparedFields.length >= fieldsForRow) {
          preparedSection.add(preparedFields);
          preparedFields = [];
        }

        if (preparedFields.isNotEmpty) {
          preparedSection.add(preparedFields);
        }
      }

      if (preparedSection.isNotEmpty) {
        preparedLayout.add(preparedSection);
      }
    }

    for (var section in preparedLayout) {
      JsonC cDetail = CBuilder.c(CTypes.detail);

      for (var row in section) {
        if (row is! List) continue;
        row = row.whereNot((e) => e is! Map).toList();

        List<JsonC> headers = row.map((e) {
          return CBuilder.c(CTypes.fieldLabel)
            .addCArgs({ 'name': e['name'] })
            .addInfo(CTypes.text, { 'fontWeight': 'bold' });
        }).toList();

        cDetail.addC(headers);

        List<JsonC> fields = row.map((e) {
          return CBuilder.c(CTypes.field)
            .addCArgs({ 'name': e['name'] });
        }).toList();

        cDetail.addC(fields);
      }

      cColumn.addC(cDetail);
    }

    return cColumn;
  }

  JsonC buildCompleteDetail(String scope, [bool editableFields = false]) {
    if (metadata.entityDefs == null) return CBuilder.c(CTypes.container);
    if (metadata.entityDefs![scope] == null) return CBuilder.c(CTypes.container);
    if (metadata.entityDefs![scope]! is! Map) return CBuilder.c(CTypes.container);

    Map<String, dynamic> entityDefs = Map<String, dynamic>.from(metadata.entityDefs![scope]);
    if (entityDefs['fields'] is! Map) return CBuilder.c(CTypes.container);

    JsonC cDetail = CBuilder.c(CTypes.detail);

    for (var fieldName in entityDefs['fields'].keys) {
      JsonC cHeader = CBuilder.c(CTypes.fieldLabel)
        .addCArgs({ 'name': fieldName })
        .addInfo(CTypes.text, { 'fontWeight': 'bold' });

      JsonC cField = CBuilder.c(CTypes.field)
        .addCArgs({ 'name': fieldName });

      if (editableFields) {
        cField = CBuilder.c(CTypes.field)
          .addInfoArgs({ 'editable': true })
          .addCArgs({ 'name': fieldName });
      }

      cDetail.addC([cHeader]);
      cDetail.addC([cField]);
      cDetail.addC([CBuilder.sizedBox(0, 16)]);
    }

    return cDetail;
  }

  JsonC buildLayoutList(String scope, dynamic layout, {
    Map<String, dynamic> listInfo = const {}
  }) {
    if (layout is! List) return CBuilder.c(CTypes.container);

    print("Building list layout...");

    JsonC cDetail = CBuilder.c(CTypes.detail);

    for (var field in layout) {
      if (field is! Map) continue;

      JsonC cHeader = CBuilder.c(CTypes.fieldLabel)
        .addCArgs({ 'name': field['name'] })
        .addInfo(CTypes.text, { 'fontWeight': 'bold' });

      if (field.containsKey('label')) {
        cHeader = CBuilder.c(CTypes.text, {
          'value': field['label'],
          'fontWeight': 'bold',
          'align': 'center',
          'color': '#000000'
        });
      }

      List<JsonC> row = [
        cHeader,
        CBuilder.c(CTypes.field).addCArgs({ 'name': field['name'] })
      ];

      cDetail.addC(row);
    }

    JsonC cSCSV = CBuilder.c(CTypes.singleChildScrollView);

    JsonC cList = CBuilder.list(
      onItemTap: [
        ABuilder.actionSetPage("$scope/detail")
      ],
      itemComponent: cDetail.applyPaddingAll(8),
      divideByComponent: CBuilder.c(CTypes.sizedBox, { 'height': 16.0 }),
      enableRefreshButton: true
    );

    if (listInfo.isNotEmpty) {
      cList.addInfoArgs(listInfo);
    }

    cSCSV.addC(cList);

    return cSCSV;
  }

  JsonC tabBarFromIconNames(List<String> iconNames) {
    List<JsonC> tabs = iconNames.map((iconName) {
      return CBuilder.c(CTypes.tab, {
        'icon': CBuilder.icon(iconName),
      });
    }).toList();

    return CBuilder.c(CTypes.tabBar, {
      'tabs': tabs,
      'labelColor': 'primary',
      'unselectedLabelColor': '#000000',
    });
  }

  JsonC? buildLayout(String scope, String layoutName, {
    Map<String, dynamic> listInfo = const {}
  }) {
    if (metadata.layouts == null) return null;
    if (metadata.layouts![scope] == null) return null;
    if (metadata.layouts![scope]![layoutName] == null) return null;

    dynamic layout = metadata.layouts![scope]![layoutName];

    if (layout is! List) return null;
    if (layout.any((e) => e is! Map)) return null;

    JsonC? cLayout;

    List allRows = layout.where((e) => e['rows'] != null).toList();
    if (allRows.length == layout.length) {
      bool hasTabs = layout.any((e) => e['tabBreak'] != null);

      if (hasTabs) {
        cLayout = buildLayoutDetailWithTabs(layout);
      } else {
        cLayout = buildLayoutDetail(layout);
      }
    } else {
      cLayout = buildLayoutList(scope, layout,
        listInfo: listInfo
      );
    }

    return cLayout;
  }
}