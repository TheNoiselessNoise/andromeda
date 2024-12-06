
import 'package:andromeda/old-core/core.dart';

class XBuilder {
  static Map<String, dynamic> paddingAll([double padding = 0]) {
    return {'all': padding};
  }

  static Map<String, dynamic> paddingVH([double vertical = 0, double horizontal = 0]) {
    return {'vertical': vertical, 'horizontal': horizontal};
  }

  static Map<String, dynamic> paddingLTRB([double left = 0, double top = 0, double right = 0, double bottom = 0]) {
    return {'left': left, 'top': top, 'right': right, 'bottom': bottom};
  }

  static Map<String, dynamic> marginVH([double? vertical = 0, double? horizontal = 0]) {
    return {"vertical": vertical, "horizontal": horizontal};
  }

  static Map<String, dynamic> marginLTRB([double? left = 0, double? top = 0, double? right = 0, double? bottom = 0]) {
    return {"left": left, "top": top, "right": right, "bottom": bottom};
  }

  static JsonListWhenEmpty whenListEmpty({
    // component to show (instead of entity list) when list is empty
    JsonC? component,
    // component to show (instead of pagination) when list is empty
    JsonC? paginationComponent,
    // component to show (instead of whole list component) when list is empty
    JsonC? listReplaceComponent,
  }) {
    return JsonListWhenEmpty({
      "component": component?.data,
      "paginationComponent": paginationComponent?.data,
      "listReplaceComponent": listReplaceComponent?.data
    });
  }
}