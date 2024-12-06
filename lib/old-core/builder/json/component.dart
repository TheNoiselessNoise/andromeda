import 'package:andromeda/old-core/core.dart';

class CTypes {
  static const String custom = "custom";
  static const String text = "text";
  static const String image = "image";
  static const String icon = "icon";
  static const String button = "button";
  static const String field = "field";
  static const String transField = "transField";
  static const String fieldLabel = "fieldLabel";
  static const String detail = "detail";
  static const String list = "list";
  static const String expanded = "expanded";
  static const String flexible = "flexible";
  static const String column = "column";
  static const String row = "row";
  static const String sizedBox = "sizedBox";
  static const String center = "center";
  static const String align = "align";
  static const String card = "card";
  static const String divider = "divider";
  static const String verticalDivider = "verticalDivider";
  static const String clipRRect = "clipRRect";
  static const String clipOval = "clipOval";
  static const String clipRect = "clipRect";
  static const String opacity = "opacity";
  static const String spacer = "spacer";
  static const String wrap = "wrap";
  static const String coloredBox = "coloredBox";
  static const String banner = "banner";
  static const String constrainedBox = "constrainedBox";
  static const String iconButton = "iconButton";
  static const String intrinsicHeight = "intrinsicHeight";
  static const String intrinsicWidth = "intrinsicWidth";
  static const String container = "container";
  static const String gestureDetector = "gestureDetector";
  static const String circularProgressIndicator = "circularProgressIndicator";
  static const String linearProgressIndicator = "linearProgressIndicator";
  static const String listTile = "listTile";
  static const String singleChildScrollView = "singleChildScrollView";
  static const String expansionTile = "expansionTile";
  static const String listView = "listView";
  static const String faIcon = "faIcon";
  static const String padding = "padding";
  static const String positioned = "positioned";

  static const String scaffold = "scaffold";
  static const String appBar = "appBar";
  static const String safeArea = "safeArea";
  static const String stack = "stack";
  static const String drawer = "drawer";

  static const String builder = "builder";

  static const String defaultTabController = "defaultTabController";
  static const String tab = "tab";
  static const String tabBar = "tabBar";
  static const String tabBarView = "tabBarView";

  static const String form = "form";
  static const String formInputText = "formInputText";
  static const String formInputInt = "formInputInt";
  static const String formInputDouble = "formInputDouble";
  static const String formInputEnum = "formInputEnum";
}

class SCTypes {
  static const String espoTabList = "espoTabList";

  static const String espoLoginForm = "espoLoginForm";
  static const String camera = "camera";
  static const String zebraScanner = "zebraScanner";
}

class JsonCLikeBase extends JsonSerializable {
  const JsonCLikeBase(super.data);

  JsonC applyPaddingVH([
    double vertical = 0,
    double horizontal = 0,
  ]) {
    Map<String, dynamic> info = Map<String, dynamic>.from(data['info'] ?? {});
    info['paddingStyle'] = {'vertical': vertical,'horizontal': horizontal};
    data['info'] = info;
    return JsonC(data);
  }

  JsonC applyPaddingLTRB([
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  ]) {
    Map<String, dynamic> info = Map<String, dynamic>.from(data['info'] ?? {});
    info['paddingStyle'] = {'left': left,'top': top,'right': right,'bottom': bottom};
    data['info'] = info;
    return JsonC(data);
  }

  JsonC applyPaddingAll([
    double padding = 0,
  ]) {
    Map<String, dynamic> info = Map<String, dynamic>.from(data['info'] ?? {});
    info['paddingStyle'] = {'all': padding};
    data['info'] = info;
    return JsonC(data);
  }

  List<JsonC> children(JsonC? of) {
    JsonC c = of ?? JsonC(data);
    List<JsonC> children = [];
    if (c.hasInnerComponent) children.add(c.innerComponent);
    if (c.hasInnerComponents) children.addAll(c.innerComponents ?? []);
    return children;
  }

  List<JsonC> findNearestChildren(String componentType, [JsonC? from, List<JsonC>? allFound]) {
    allFound = List<JsonC>.from(allFound ?? []);

    JsonC comp = from ?? JsonC(data);

    if (comp.type == componentType) {
      allFound.add(comp);
    }

    if (comp.hasInnerComponent) {
      List<JsonC> found = findNearestChildren(componentType, comp.innerComponent, allFound);
      if (found.isNotEmpty) allFound.addAll(found);
    }

    if (comp.hasInnerComponents) {
      for (JsonC c in comp.innerComponents ?? []) {
        List<JsonC> found = findNearestChildren(componentType, c, allFound);
        if (found.isNotEmpty) allFound.addAll(found);
      }
    }

    return allFound;
  }

  JsonC? findNearestChild(String componentType, [JsonC? from]) {
    JsonC comp = from ?? JsonC(data);
    
    if (comp.type == componentType) return comp;

    if (comp.hasInnerComponent) {
      JsonC? found = findNearestChild(componentType, comp.innerComponent);
      if (found != null) return found;
    }

    if (comp.hasInnerComponents) {
      for (JsonC c in comp.innerComponents ?? []) {
        JsonC? found = findNearestChild(componentType, c);
        if (found != null) return found;
      }
    }

    return null;
  }
}

class JsonC extends JsonCLikeBase {
  const JsonC(super.data);

  String get type => getString('type', 'text');
  String? get overrideEntityType => get('overrideEntityType');
  Map<String, dynamic> get additionalData => getMap('additionalData');

  JsonCInfo get info => JsonCInfo(getMap('info'));

  // for field
  String get name => getString('name', '<_NO_NAME_>');

  // special components
  bool get isEspoTabList => type == SCTypes.espoTabList;
  bool get isEspoLoginForm => type == SCTypes.espoLoginForm;
  bool get isCamera => type == SCTypes.camera;
  bool get isZebraScanner => type == SCTypes.zebraScanner;

  // normal components
  bool get isCustom => type == CTypes.custom;
  bool get isText => type == CTypes.text;
  bool get isImage => type == CTypes.image;
  bool get isIcon => type == CTypes.icon;
  bool get isButton => type == CTypes.button;
  bool get isFieldLabel => type == CTypes.fieldLabel;
  bool get isField => type == CTypes.field;
  bool get isTransField => type == CTypes.transField;
  bool get isDetail => type == CTypes.detail;
  bool get isList => type == CTypes.list;
  bool get isExpanded => type == CTypes.expanded;
  bool get isFlexible => type == CTypes.flexible;
  bool get isColumn => type == CTypes.column;
  bool get isRow => type == CTypes.row;
  bool get isSizedBox => type == CTypes.sizedBox;
  bool get isCenter => type == CTypes.center;
  bool get isAlign => type == CTypes.align;
  bool get isCard => type == CTypes.card;
  bool get isDivider => type == CTypes.divider;
  bool get isVerticalDivider => type == CTypes.verticalDivider;
  bool get isClipRRect => type == CTypes.clipRRect;
  bool get isClipOval => type == CTypes.clipOval;
  bool get isClipRect => type == CTypes.clipRect;
  bool get isOpacity => type == CTypes.opacity;
  bool get isSpacer => type == CTypes.spacer;
  bool get isWrap => type == CTypes.wrap;
  bool get isColoredBox => type == CTypes.coloredBox;
  bool get isBanner => type == CTypes.banner;
  bool get isConstrainedBox => type == CTypes.constrainedBox;
  bool get isIconButton => type == CTypes.iconButton;
  bool get isIntrinsicHeight => type == CTypes.intrinsicHeight;
  bool get isIntrinsicWidth => type == CTypes.intrinsicWidth;
  bool get isContainer => type == CTypes.container;
  bool get isGestureDetector => type == CTypes.gestureDetector;
  bool get isCircularProgressIndicator => type == CTypes.circularProgressIndicator;
  bool get isLinearProgressIndicator => type == CTypes.linearProgressIndicator;
  bool get isListTile => type == CTypes.listTile;
  bool get isSingleChildScrollView => type == CTypes.singleChildScrollView;
  bool get isExpansionTile => type == CTypes.expansionTile;
  bool get isListView => type == CTypes.listView;
  bool get isFaIcon => type == CTypes.faIcon;
  bool get isPadding => type == CTypes.padding;
  bool get isPositioned => type == CTypes.positioned;

  bool get isScaffold => type == CTypes.scaffold;
  bool get isAppBar => type == CTypes.appBar;
  bool get isSafeArea => type == CTypes.safeArea;
  bool get isStack => type == CTypes.stack;
  bool get isDrawer => type == CTypes.drawer;

  bool get isBuilder => type == CTypes.builder;

  bool get isDefaultTabController => type == CTypes.defaultTabController;
  bool get isTab => type == CTypes.tab;
  bool get isTabBar => type == CTypes.tabBar;
  bool get isTabBarView => type == CTypes.tabBarView;

  bool get isForm => type == CTypes.form;
  bool get isFormInput => [
    CTypes.formInputText,
    CTypes.formInputInt,
    CTypes.formInputDouble,
    CTypes.formInputEnum,
  ].contains(type); 

  bool get isSpecial => [
    SCTypes.espoTabList,
    SCTypes.espoLoginForm,
    SCTypes.camera,
    SCTypes.zebraScanner,
  ].contains(type);

  bool get hasNoChild => [
    CTypes.field,
    CTypes.text,
    CTypes.list,
    CTypes.image,
    CTypes.icon,
    CTypes.divider,
    CTypes.verticalDivider,
    CTypes.spacer,
    CTypes.iconButton,
    CTypes.circularProgressIndicator,
    CTypes.linearProgressIndicator,
    CTypes.formInputText,
    CTypes.formInputInt,
    CTypes.formInputDouble,
    CTypes.formInputEnum,
    CTypes.fieldLabel,
    CTypes.scaffold,
    CTypes.appBar,
    CTypes.listTile,
    CTypes.tabBar,
    CTypes.faIcon,
    CTypes.builder,
  ].contains(type);

  bool get canBeWithoutInnerComponent => [
    CTypes.button,
    CTypes.sizedBox,
    CTypes.align,
    CTypes.card,
    CTypes.clipRRect,
    CTypes.clipOval,
    CTypes.clipRect,
    CTypes.opacity,
    CTypes.coloredBox,
    CTypes.banner,
    CTypes.constrainedBox,
    CTypes.intrinsicHeight,
    CTypes.intrinsicWidth,
    CTypes.container,
    CTypes.gestureDetector,
    CTypes.form,
    CTypes.align,
    CTypes.tab,
    CTypes.singleChildScrollView,
    CTypes.drawer,
    CTypes.padding,
  ].contains(type);

  bool get hasInnerComponentData => innerComponent.data.isNotEmpty;
  bool get hasInnerComponent => [
    CTypes.button,
    CTypes.expanded,
    CTypes.flexible,
    CTypes.sizedBox,
    CTypes.center,
    CTypes.align,
    CTypes.card,
    CTypes.clipRRect,
    CTypes.clipOval,
    CTypes.clipRect,
    CTypes.opacity,
    CTypes.coloredBox,
    CTypes.banner,
    CTypes.constrainedBox,
    CTypes.intrinsicHeight,
    CTypes.intrinsicWidth,
    CTypes.container,
    CTypes.gestureDetector,
    CTypes.form,
    CTypes.safeArea,
    CTypes.defaultTabController,
    CTypes.tab,
    CTypes.singleChildScrollView,
    CTypes.drawer,
    CTypes.padding,
    CTypes.positioned,
  ].contains(type);

  bool get hasInnerComponentsData => innerComponents?.isNotEmpty ?? false;
  bool get hasInnerComponents => [
    CTypes.detail,
    CTypes.column,
    CTypes.row,
    CTypes.wrap,
    CTypes.tabBarView,
    CTypes.expansionTile,
    CTypes.listView,
    CTypes.stack
  ].contains(type);

  JsonC get innerComponent => JsonC.from(getMap('component'));
  List<JsonC>? get innerComponents => getList('components')
    .map((e) => JsonC.from(e)).toList();

  // for 'detail' component
  List<List<JsonC>> get detailComponents {
    List<List<JsonC>> components = [];

    for (var row in getList('components')) {
      List<JsonC> rowComponents = [];

    for (var component in row) {
        rowComponents.add(JsonC.from(component));
      }

      components.add(rowComponents);
    }

    return components;
  }

  static JsonC byType(String type, [Map<String, dynamic> additionalData = const {}]) {
    return JsonC({"type": type, ...additionalData});
  }

  JsonC addInfoArgs(Map<String, dynamic> args) {
    Map<String, dynamic> info = getMap('info.$type');
    data['info'] = { ...getMap('info'), type: info..addAll(args) };
    return this;
  }

  JsonC addInfo(String key, Map<String, dynamic> info) {
    data['info'] = { ...getMap('info'), key: info };
    return this;
  }

  JsonC addCArgs(Map<String, dynamic> args) {
    data.addAll(args);
    return this;
  }

  void addCs(dynamic components) {
    if (hasNoChild) return;

    if (components is! List) {
      return addC(components);
    }

    for (var component in components) {
      addC(component);
    }
  }

  void addC(dynamic component) {
    if (hasNoChild) return;
    
    List<JsonC> components = [];
    if (component is JsonC) {
      components.add(component);
    } else if (component is List<JsonC>) {
      components.addAll(component);
    }

    if (hasInnerComponent) {
      data['component'] = component.data;
    }
    
    if (hasInnerComponents) {
      List<Map<String, dynamic>> newComponentsData = components.map((e) {
        return e.data;
      }).toList();

      if (isDetail) {
        List<List<Map<String, dynamic>>> oldComponents = detailComponents.map((e) {
          return e.map((e) => e.data).toList();
        }).toList();

        data['components'] = oldComponents..addAll([newComponentsData]);
      } else {
        List<Map<String, dynamic>> newComponents = (innerComponents ?? []).map((e) {
          return e.data;
        }).toList();
        data['components'] = newComponents..addAll(newComponentsData);
      }
    }
  }

  static JsonC from(dynamic data) {
    if (data is Map<String, dynamic>) return JsonC(data);
    if (data is JsonC) return data;
    return const JsonC({});
  }
}
