import 'package:andromeda/old-core/core.dart';

class CBuilder {
  static JsonC c([
    String type = "text",
    Map<String, dynamic> info = const {},
    Map<String, dynamic> cArgs = const {},
    Map<String, dynamic> additionalInfoArgs = const {},
  ]) {
    return JsonC({
      "type": type,
      "info": {type: info, ...additionalInfoArgs},
      ...cArgs,
    });
  }

  static JsonC builder(JsonC component) {
    return c(CTypes.builder, { "component": component });
  }

  static JsonC espoTabList() {
    return c(SCTypes.espoTabList);
  }

  static JsonC refreshButton([String title = "#{{Global.things.Refresh}}"]) {
    return button(textLabel(title, "#ffffff"), [ ABuilder.a(ActionRefreshPage.id) ]);
  }

  static JsonC logoutButton([String title = "#{{Global.things.LogoutButtonTitle}}", String pageId = "Login"]) {
    return button(
      textLabel(title, "#ffffff"),
      [
        ABuilder.a(ActionLogout.id),
        ABuilder.a(ActionSetPage.id, { "page": pageId })
      ]
    );
  }

  static JsonC logoutButtonListTile([
    String title = "Logout",
    String iconName = "signOut",
    String pageId = "Login"
  ]) {
    return CBuilder.c(CTypes.listTile, {
      'leading': CBuilder.faIcon(iconName),
      'title': CBuilder.textLabel(title),
      'onTap': [
        ABuilder.a(ActionLogout.id),
        ABuilder.a(ActionSetPage.id, { "page": pageId })
      ],
    });
  }

  static JsonC espoLoginForm([List<JsonA> onLoggedIn = const []]) {
    return c(SCTypes.espoLoginForm, { 'onLoggedIn': onLoggedIn });
  }

  static JsonC appBarWithLeadingDrawer([String? title, String iconName = "menu"]) {
    Map<String, dynamic> info = {
      'leading': iconButton(iconName, [
        ABuilder.a(ActionOpenDrawer.id)
      ])
    };
    if (title != null) info['title'] = textLabel(title);
    return c(CTypes.appBar, info);
  }

  static JsonC appBarWithoutLeading(String title) {
    return c(CTypes.appBar, {
      'title': textLabel(title),
      'automaticallyImplyLeading': false,
    });
  }

  static JsonC appBar(String title) {
    return c(CTypes.appBar, {
      'title': textLabel(title),
      'leading': iconButton('menu', [
        ABuilder.a(ActionOpenDrawer.id)
      ])
    });
  }

  static JsonC customDrawer([String? title]) {
    return c(CTypes.drawer, {}, {
      'component': safeArea(
        detail([
          if (title != null) ...[
            [
              textLabel(title)
            ]
          ],
          [
            row([
              expanded(
                button(
                  textLabel("DB Changes"),
                  [
                    ABuilder.a(ActionEspoChangesBottomSheet.id),
                    ABuilder.a(ActionCloseDrawer.id)
                  ]
                ).applyPaddingVH(0, 16) 
              )
            ])
          ]
        ])
      )
    });
  }

  static JsonC drawer(JsonC component, [Map<String, dynamic> info = const {}]) {
    return c(CTypes.drawer, info, { "component": component });
  }

  static JsonC textLabel(String text, [String color = "#000000", String align = 'center']) {
    return c(CTypes.text, { "value": text, "color": color, "align": align });
  }

  static JsonC button(JsonC component, [List<JsonA> onPressed = const []]) {
    return c(CTypes.button, { "onPressed": onPressed }, { "component": component });
  }

  static JsonC field(String field, [bool editable = false]) {
    return c(CTypes.field, { "editable": editable }, { "name": field });
  }

  static JsonC fieldMore(String field, [Map<String, dynamic> info = const {}]) {
    return c(CTypes.field, info, { "name": field });
  }

  static JsonC transField(String field, [bool editable = false]) {
    return c(CTypes.transField, { "editable": editable }, { "name": field });
  }

  static JsonC fieldLabel(String field, [String? overrideEntityType]) {
    Map<String, dynamic> cArgs = { "name": field };
    if (overrideEntityType != null) cArgs["overrideEntityType"] = overrideEntityType;
    return c(CTypes.fieldLabel, {}, cArgs);
  }

  static JsonC fieldLabelBold(String field) {
    return c(CTypes.fieldLabel, {}, { "name": field }, {
      "text": { "fontWeight": "bold" }
    });
  }

  static JsonC fieldNewEntity(String field, [String? overrideEntityType]) {
    return c(CTypes.field, { "editable": true, "newEntity": true }, {
      "name": field,
      "overrideEntityType": overrideEntityType
    });
  }

  static JsonC expanded(JsonC component) {
    return c(CTypes.expanded, {}, { "component": component });
  }

  static JsonC flexible(JsonC component) {
    return c(CTypes.flexible, {}, { "component": component });
  }

  static JsonC column(List<JsonC> components, [Map<String, dynamic> info = const {}]) {
    return c(CTypes.column, {
      "mainAxisAlignment": "start",
      "crossAxisAlignment": "start",
      ...info
    }, { "components": components });
  }

  static JsonC row(List<JsonC> components, [Map<String, dynamic> info = const {}]) {
    return c(CTypes.row, {
      "mainAxisAlignment": "start",
      "crossAxisAlignment": "start",
      ...info
    }, { "components": components });
  }

  static JsonC positioned(JsonC component, [Map<String, dynamic> info = const {}]) {
    return c(CTypes.positioned, info, { "component": component });
  }

  static JsonC stack(List<JsonC> components, [Map<String, dynamic> info = const {}]) {
    return c(CTypes.stack, info, { "components": components });
  }

  static JsonC center(JsonC component) {
    return c(CTypes.center, {}, { "component": component });
  }

  static JsonC imageUrl(String url, [Map<String, dynamic> info = const {}]) {
    return c(CTypes.image, { "type": "url", "url": url, ...info });
  }

  static JsonC imageAsset(String asset, [Map<String, dynamic> info = const {}]) {
    return c(CTypes.image, { "type": "asset", "asset": asset, ...info });
  }

  static JsonC imageBase64(String base64, [Map<String, dynamic> info = const {}]) {
    return c(CTypes.image, { "type": "base64", "base64": base64, ...info });
  }

  static JsonC sizedBox([double? width, double? height, JsonC? component]) {
    return c(CTypes.sizedBox, { "width": width, "height": height }, { "component": component });
  }

  static JsonC card(JsonC component) {
    return c(CTypes.card, {}, { "component": component });
  }

  static JsonC faIcon(String icon, [String? color]) {
    return c(CTypes.faIcon, { "icon": icon, "color": color });
  }

  static JsonC paddingVH(double vertical, double horizontal, JsonC component) {
    return c(CTypes.padding, {
      "padding": { "vertical": vertical, "horizontal": horizontal }
    }, { "component": component });
  }

  static JsonC icon(String icon, [String? color]) {
    return c(CTypes.icon, { "icon": icon, "color": color });
  }

  static JsonC iconButton(dynamic iconName, [List<JsonA> onPressed = const []]) {
    return c(CTypes.iconButton, {
      "icon": iconName is JsonC ? iconName : icon(iconName),
      "onPressed": onPressed
    });
  }

  static JsonC divider([double height = 3, double thickness = 3.0, String color = "#000000"]) {
    return c(CTypes.divider, { "height": height, "thickness": thickness, "color": color });
  }

  static JsonC verticalDivider([double width = 25.0, double thickness = 2.0, String color = "#000000"]) {
    return c(CTypes.verticalDivider, { "width": width, "thickness": thickness, "color": color });
  }

  static JsonC intrinsicHeight(JsonC component) {
    return c(CTypes.intrinsicHeight, {}, { "component": component });
  }

  static JsonC intrinsicWidth(JsonC component) {
    return c(CTypes.intrinsicWidth, {}, { "component": component });
  }

  static JsonC tabBarView(List<JsonC> components, [Map<String, dynamic> info = const {}]) {
    return c(CTypes.tabBarView, info, { "components": components });
  }

  static JsonC defaultTabController(JsonC component, [Map<String, dynamic> info = const {}]) {
    return c(CTypes.defaultTabController, info, { "component": component });
  }

  static JsonC tab(JsonC component, [Map<String, dynamic> info = const {}]) {
    return c(CTypes.tab, info, { "component": component });
  }

  static JsonC tabBar(List<JsonC> tabs, [Map<String, dynamic> info = const {}]) {
    return c(CTypes.tabBar, { "tabs": tabs, ...info });
  }

  static JsonC safeArea(JsonC component, [Map<String, dynamic> info = const {}]) {
    return c(CTypes.safeArea, info, { "component": component });
  }

  static JsonC container(JsonC component, [Map<String, dynamic> info = const {}]) {
    return c(CTypes.container, info, { "component": component });
  }

  static JsonC clipRRect(JsonC component, [Map<String, dynamic> info = const {}]) {
    return c(CTypes.clipRRect, {
      "borderRadius": { "circular": 16.0 }, ...info
    }, { "component": component });
  }

  static JsonC clipOval(JsonC component) {
    return c(CTypes.clipOval, {}, { "component": component });
  }

  static JsonC clipRect(JsonC component) {
    return c(CTypes.clipRect, {}, { "component": component });
  }

  static JsonC gestureDetector(JsonC component, [Map<String, dynamic> info = const {}]) {
    return c(CTypes.gestureDetector, info, { "component": component });
  }

  static JsonC opacity(JsonC component, [double opacity = 0.25]) {
    return c(CTypes.opacity, { "opacity": opacity }, { "component": component });
  }

  static JsonC spacer() {
    return c(CTypes.spacer);
  }

  static JsonC wrap(List<JsonC> components) {
    return c(CTypes.wrap, { "spacing": 32.0 }, { "components": components });
  }

  static JsonC coloredBox(JsonC component, [String color = "#000000"]) {
    return c(CTypes.coloredBox, { "color": color }, { "component": component });
  }

  static JsonC banner(JsonC component) {
    return c(CTypes.banner, {
      "fontSize": 11.0, "color": "#ffffff", "location": "topEnd"
    }, { "component": component });
  }

  static JsonC constrainedBox(JsonC component) {
    return c(CTypes.constrainedBox, {
      "constraints": { "width": 100.0, "height": 10.0, "tight": true }
    }, { "component": component });
  }

  static JsonC circularProgressIndicator() {
    return c(CTypes.circularProgressIndicator);
  }

  static JsonC linearProgressIndicator() {
    return c(CTypes.linearProgressIndicator);
  }

  static JsonC detailNoForm(List<List<JsonC>> components, [int continuousRefresh = 0]) {
    return c(CTypes.detail, {
      "noForm": true,
      "settings": {
        "refresh": { "enabled": continuousRefresh > 0, "interval": continuousRefresh }
      }
    }, { "components": components });
  }

  static JsonC detail(List<List<JsonC>> components, [int continuousRefresh = 0]) {
    return c(CTypes.detail, {
      "settings": {
        "refresh": { "enabled": continuousRefresh > 0, "interval": continuousRefresh }
      }
    }, { "components": components });
  }

  static JsonC textFormatted(String text, [Map<String, dynamic> data = const {}, String color = "#000000"]) {
    return c(CTypes.text, { "value": text, "color": color }, { "additionalData": data });
  }

  static JsonC custom(String name, [Map<String, dynamic> replacements = const {}]) {
    return c(CTypes.custom, { "name": name }, { "additionalData": replacements });
  }

  static JsonC form(String id, [JsonC? component, List<JsonA> onSubmit = const []]) {
    return c(CTypes.form, { "id": id, "onSubmit": onSubmit }, { "component": component });
  }

  static JsonC formInputText(String id, [String defaultValue = '']) {
    return c(CTypes.formInputText, { "id": id, "defaultValue": defaultValue });
  }

  static JsonC formInputInt(String id, [int defaultValue = 0]) {
    return c(CTypes.formInputInt, { "id": id, "defaultValue": defaultValue });
  }

  static JsonC formInputDouble(String id, [double defaultValue = 0]) {
    return c(CTypes.formInputDouble, { "id": id, "defaultValue": defaultValue });
  }

  static JsonC formInputEnum(String id, [dynamic defaultValue]) {
    return c(CTypes.formInputEnum, { "id": id, "defaultValue": defaultValue });
  }
  
  static JsonC singleChildScrollView(JsonC component) {
    return c(CTypes.singleChildScrollView, {}, { "component": component });
  }

  static JsonC listView(List<JsonC> components, [Map<String, dynamic> info = const {}]) {
    return c(CTypes.listView, info, { "components": components });
  }

  static JsonC listTile(JsonC title, [Map<String, dynamic> info = const {}]) {
    return c(CTypes.listTile, { "title": title, ...info });
  }

  static JsonC list({
    String mode = "custom",
    String? overrideEntityType,
    List<Map<String, dynamic>> defaultFilters = const [],
    String? defaultOrderBy = "createdAt",
    String? defaultOrderDirection = "desc",
    List<Map<String, dynamic>> customData = const [],
    JsonC? headerComponent,
    JsonC? itemComponent,
    bool useParentContext = false,
    int continuousRefresh = 0,
    List<JsonA> onItemTap = const [],
    List<JsonA> onItemDoubleTap = const [],
    bool enableSettings = true,
    bool enableSettingsInformation = true,
    bool enableSettingsLimits = true,
    bool enableSettingsPagination = true,
    bool enableSettingsFilters = true,
    JsonC? divideByComponent,
    Map<String, dynamic>? settingsFiltersFields,
    JsonListWhenEmpty? whenEmpty,
    bool enableRefreshButton = false,
  }) {
    Map<String, dynamic> cArgs = {};
    Map<String, dynamic> info = {
      "mode": mode,
      "query": {
        "defaultFilters": defaultFilters,
        "limit": 5
      },
      "refresh": {
        "enabled": continuousRefresh > 0,
        "interval": continuousRefresh
      },
      "useParentContext": useParentContext,
      "customData": customData,
      "onItemTap": onItemTap,
      "onItemDoubleTap": onItemDoubleTap,
      "headerComponent": headerComponent,
      "itemComponent": itemComponent,
      "whenEmpty": whenEmpty,
      "divideBy": divideByComponent,
    };

    if (defaultOrderBy != null) {
      info["query"]["order"] = {
        "by": defaultOrderBy,
        "direction": defaultOrderDirection ?? "desc"
      };
    }

    if (enableSettings) {
      info["settings"] = {
        "information": {
          "enabled": enableSettingsInformation
        },
        "refreshButton": {
          "enabled": enableRefreshButton
        },
        "limits": {
          "enabled": enableSettingsLimits,
          "options": [5, 10, 20],
        },
        "pagination": {
          "enabled": enableSettingsPagination,
          "initial": 0,
        },
        "filters": {
          "enabled": enableSettingsFilters,
          "fields": settingsFiltersFields ?? {
            // "name": ["contains", "equals"],
            // "createdAt": ["between"]
            // "name": [],
            // "createdAt": []
          },
        }
      };
    }

    if (overrideEntityType != null) {
      cArgs["overrideEntityType"] = overrideEntityType;
    }

    return c(CTypes.list, info, cArgs);
  }
}
