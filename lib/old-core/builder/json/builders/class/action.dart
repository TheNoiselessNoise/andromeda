import 'package:andromeda/old-core/core.dart';

class ABuilder {
  static JsonA a(String name, [Map<String, dynamic> args = const {}]) {
    return JsonA({
      "on": "immediate",
      "name": name,
      "args": args
    });
  }

  static JsonA actionSetPage(String page, [Map<String, dynamic> args = const {}]) {
    return a(ActionSetPage.id, {"page": page, "args": args});
  }
}
