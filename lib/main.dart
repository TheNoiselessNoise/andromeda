import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/_.dart';

// TODO: rename @props to @prop
// TODO: Reload button in ErrorHandlerWidget should also download the latest script

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await TranslationManager().init();
  await ThemeManager().init();
  
  // ErrorWidget.builder = (FlutterErrorDetails details) {
  //   return ErrorHandlerWidget(
  //     error: details.exception.toString(),
  //     stackTrace: details.stack.toString(),
  //     onReload: () => ScriptReloadService().reload(),
  //   );
  // };

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: TranslationManager()),
        ChangeNotifierProvider.value(value: ThemeManager()),
      ],
      child: const AndromedaApp(
        initialPage: AndromedaInitialPage()
      )
    ),
  );
}