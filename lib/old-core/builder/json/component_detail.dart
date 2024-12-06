import 'package:andromeda/old-core/core.dart';

class JsonDetailRefresh extends MapTraversable {
  const JsonDetailRefresh(super.data);

  bool get enabled => getBool('enabled', false);
  int get interval => getInt('interval', 0);
}

class JsonDetailSettings extends MapTraversable {
  const JsonDetailSettings(super.data);

  JsonDetailRefresh get refresh => JsonDetailRefresh(getMap('refresh'));
}