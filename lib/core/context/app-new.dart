// import 'package:andromeda/core/_.dart';
// import 'package:flutter/material.dart';

// class AndromedaAppController extends ValueNotifier<MaterialAppSettings> {
//   static final AndromedaAppController _instance = AndromedaAppController._internal();
//   factory AndromedaAppController() => _instance;
  
//   AndromedaAppController._internal() : super(MaterialAppSettings());
  
//   void updateSettings(MaterialAppSettings settings) {
//     value = settings;
//   }
// }

// class MaterialAppSettings {
//   String? title; 
  
//   MaterialAppSettings({
//     this.title,
//   });
// }

// class AndromedaMaterialApp extends StatelessWidget {
//   const AndromedaMaterialApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<MaterialAppSettings>(
//       valueListenable: AndromedaAppController(),
//       builder: (context, settings, _) {
//         return MaterialApp(
//           debugShowCheckedModeBanner: false,
//           title: settings.title ?? 'Andromeda',
//           theme: ThemeData(
//             colorScheme: ColorScheme.fromSeed(
//               seedColor: Colors.blue,
//             ),
//             useMaterial3: true,
//           ),
//           home: Material(
//             child: FScriptRoot(
//               loadingBuilder: (message) => Center(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const CircularProgressIndicator(),
//                     const SizedBox(height: 16),
//                     Text(message),
//                   ],
//                 )
//               ),
//               errorBuilder: (error, stackTrace, onReload) => ErrorHandlerWidget(
//                 error: error,
//                 stackTrace: stackTrace?.toString(),
//                 onReload: onReload,
//               ),
//               appController: AndromedaAppController(),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class ThemedApp extends StatelessWidget {
//   final Widget child;
//   final AndromedaAppTheme theme;

//   const ThemedApp({
//     super.key,
//     required this.child,
//     required this.theme,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final currentTheme = Theme.of(context);
//     final primaryColor = theme.primary ?? currentTheme.primaryColor;

//     // TODO: support other theme properties
//     final newColorScheme = ColorScheme.fromSeed(
//       seedColor: primaryColor,
//       secondary: theme.secondary ?? currentTheme.colorScheme.secondary,
//     ).copyWith(
//       primary: primaryColor,
//       secondary: theme.secondary ?? currentTheme.colorScheme.secondary,
//     );

//     return Theme(
//       data: currentTheme.copyWith(
//         primaryColor: primaryColor,
//         colorScheme: newColorScheme,
//       ),
//       child: child,
//     );
//   }
// }

// class AndromedaAppConfig extends ContextableMapTraversable {
//   const AndromedaAppConfig(super.context, super.data);

//   String? get title => get('title');
//   Map<String, dynamic> get theme => getMap('theme');
// }

// class AndromedaAppTheme extends ContextableMapTraversable {
//   const AndromedaAppTheme(super.context, super.data);

//   Color? get primary => themeColorFromString(get('primary'), context);
//   Color? get secondary => themeColorFromString(get('secondary'), context);
// }

// class AndromedaApp extends StatefulWidget {
//   final FApp app;
//   final AndromedaAppController? appController;

//   const AndromedaCustomApp({
//     super.key, 
//     required this.app,
//     this.appController,
//   });

//   @override
//   AndromedaAppState createState() => AndromedaAppState();
// }

// class AndromedaAppState extends State<AndromedaApp> {
//   late Environment environment;
//   late ExpressionEvaluator evaluator;
//   late WidgetInstance appInstance;
//   late AppState appState;

//   AndromedaAppConfig? appConfig;
//   AndromedaAppTheme? appTheme;

//   Object? error;
//   StackTrace? stackTrace;
//   bool _initialized = false;
//   String? _lastAppId;

//   FScriptProvider get provider => FScriptProvider.of(context)!;

//   @override
//   void initState() {
//     environment = Environment();
//     appState = AppStateHolder.getInstance();
    
//     super.initState();

//     // NOTE: on Hot Reload makes children rebuild exactly once
//     // WidgetsBinding.instance.addPostFrameCallback((_) {
//     //   if (!_initialized) {
//     //     _initialize();
//     //   }
//     // });

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!_initialized || widget.app.name.lexeme != _lastAppId) {
//         _initialize();
//       }
//     });
//   }

//   // NOTE: on Hot Reload makes children rebuild numerous times
//   // @override
//   // void didChangeDependencies() {
//   //   super.didChangeDependencies();

//   //   if (!_initialized) {
//   //     _initialized = true;
//   //     _initialize();
//   //   }
//   // }

//   void _initialize() async {
//     try {
//       if (_initialized && widget.app.name.lexeme == _lastAppId) return;

//       const pageWidget = FWidget(
//         '<root>',
//         // stateBlock: widget.app.stateBlock,
//         // styleBlock: widget.app.styleBlock,
//         // renderBlock: widget.page.renderBlock
//       );

//       appInstance = WidgetInstance(pageWidget, environment);

//       evaluator = ExpressionEvaluator(
//         environment,
//         provider.data.classes,
//         provider.data.functions,
//         _handleBuiltin,
//         appInstance
//       );

//       if (!_initialized || widget.app.name.lexeme != _lastAppId) {
//         final initialState = await evaluator.evaluateStateBlock(widget.app.state);
//         appState.setInitialState(initialState);
//       }

//       // ignore: use_build_context_synchronously
//       appConfig = await _evaluateConfig(context, evaluator);
//       // ignore: use_build_context_synchronously
//       appTheme = AndromedaAppTheme(context, appConfig!.theme);

//       evaluator = ExpressionEvaluator(
//         environment,
//         provider.data.classes,
//         provider.data.functions,
//         _handleBuiltin,
//         appInstance,
//         appState,
//       );

//       widget.appController?.updateSettings(
//         MaterialAppSettings(
//           title: appConfig?.title,
//         ),
//       );

//       error = null;
//       stackTrace = null;
//       _lastAppId = widget.app.name.lexeme;
//     } catch (e, st) {
//       error = e;
//       stackTrace = st;
//     } finally {
//       _initialized = true;
//     }
//   }

//   Future<dynamic> _handleBuiltin(String name, List<dynamic> args) async {
//     try {
//       return await BuiltInHandler(
//         context: context,
//         parentInstance: appInstance,
//         environment: environment,
//         evaluator: evaluator,
//       ).handle(name, args);
//     } catch (e, st) {
//       setState(() {
//         error = e;
//         stackTrace = st;
//       });
//     }
//   }

//   Future<AndromedaAppConfig> _evaluateConfig(BuildContext context, ExpressionEvaluator evaluator) async {
//     final configMap = await evaluator.evaluateConfigBlock(widget.app.config);
//     // ignore: use_build_context_synchronously
//     return AndromedaAppConfig(context, configMap);
//   }

//   Widget _evaluateHomePage() {
//     List<FPage> pages = widget.app.pages.pages;

//     pages.addAll(provider.data.pages);

//     if (pages.isEmpty) {
//       return const Center(child: Text('No pages found.'));
//     }

//     return AndromedaPage(
//       page: pages.first,
//       environment: environment,
//       evaluator: evaluator,
//       onBuiltin: _handleBuiltin,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!_initialized) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (error != null) {
//       return ErrorHandlerWidget(
//         error: error.toString(),
//         stackTrace: stackTrace?.toString(),
//         onReload: () => setState(() {
//           error = null;
//           stackTrace = null;
//         }),
//       );
//     }

//     return ThemedApp(
//       theme: appTheme ?? AndromedaAppTheme(context, {
//         'primary': 'blue',
//         'secondary': 'green',
//       }),
//       child: _evaluateHomePage(),
//     );
//   }
// }