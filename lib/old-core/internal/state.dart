import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:andromeda/old-core/core.dart';

enum CoreStateResultStatus {
  success,
  error
}

class CoreStateResult {
  final CoreStateResultStatus status;
  String? message;

  CoreStateResult({
    required this.status,
    this.message
  });

  factory CoreStateResult.success(String? message) {
    return CoreStateResult(
      status: CoreStateResultStatus.success,
      message: message
    );
  }

  factory CoreStateResult.error(String? message) {
    return CoreStateResult(
      status: CoreStateResultStatus.error,
      message: message
    );
  }
}

abstract class GlobalBlocInstance<T> extends Cubit<T> {
  bool _initialized = false;
  bool _initializing = false;
  bool get initialized => _initialized;
  bool get initializing => _initializing;
  void setInitialized(bool value) {
    _initialized = value;
  }

  GlobalBlocInstance(super.initialState);

  @protected
  Future<void> initStateLogic() async {
    log('[!!!] $runtimeType.initStateLogic was not overriden');
  }

  /*
  ()(Filtr)()
  ()(db)(result)()
  ()(db)(result)(error)
  ()(db)(result)(null?)? ?
  */

  Future<void> initState() async {
    if (_initialized) {
      return;
    }
    _initializing = true;
    await initStateLogic();
    setInitialized(true);
  }

  void logBloc(dynamic message) {
    log('## [$runtimeType] $message');
  }

  void updateState(T newState) {
    emit(newState);
  }

  Future<CoreStateResult> updateWrapper(Function() func) async {
    try {
      await func();
      return CoreStateResult.success('');
    } catch (e) {
      return CoreStateResult.error(e.toString());
    }
  }
}

extension BuildContextGlobalStateExtension on BuildContext {
  CoreGlobalBloc get coreBloc {
    return read<CoreGlobalBloc>();
  }

  CoreGlobalState get coreState {
    return coreBloc.state;
  }

  EspoGlobalBloc get espoBloc {
    return read<EspoGlobalBloc>();
  }

  EspoGlobalState get espoState {
    return espoBloc.state;
  }

  EspoMetadata get metadata {
    return espoState.metadata ?? const EspoMetadata({});
  }

  bool get isCoreStateInitializing {
    return coreBloc.initializing;
  }

  bool get isCoreStateInitialized {
    return coreBloc.initialized;
  }

  bool get isEspoStateInitializing {
    return espoBloc.initializing;
  }

  bool get isEspoStateInitialized {
    return espoBloc.initialized;
  }

  bool get areStatesInitialized {
    return isCoreStateInitialized && isEspoStateInitialized;
  }

  @protected
  void updateCoreState(CoreGlobalState newState) {
    if (!mounted || !isCoreStateInitialized) {
      return;
    }
    coreBloc.updateState(newState);
  }

  @protected
  void updateEspoState(EspoGlobalState newState) {
    if (!mounted || !isEspoStateInitialized) {
      return;
    }
    espoBloc.updateState(newState);
  }

  void safeSetState(VoidCallback fn) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        (this as Element).markNeedsBuild();
        fn();
      }
    });
  }
}

abstract class CoreBaseStatelessWidget extends StatelessWidget {
  const CoreBaseStatelessWidget({super.key});
}

abstract class CoreBaseStatefulWidget extends StatefulWidget {
  const CoreBaseStatefulWidget({super.key});
}

abstract class CoreBaseState<T extends CoreBaseStatefulWidget> extends State<T> with TickerProviderStateMixin {
  late AnimationController animationController;
  late TextEditingController textController;
  final unfocusNode = FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool onStatesInitializedCalled = false;

  CoreGlobalBloc get coreBloc => context.coreBloc;
  CoreGlobalState get coreState => context.coreState;

  EspoGlobalBloc get espoBloc => context.espoBloc;
  EspoGlobalState get espoState => context.espoState;
  EspoMetadata get metadata => context.metadata;

  int logStateCounter = 0;
  void logState(dynamic message) {
    logStateCounter++;
    log('($logStateCounter) @@ [$runtimeType] $message');
  }

  BuildContext get buildContext => context;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    textController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _initializeStates();

      if (checkPermissionsAfterStateInit() && !isComponent()) {
        await handlePermissions();
      }
    });
  }

  // NOTE: Override this method so the widget is considered as a component
  //       (meaning no scaffold, no perm check, ...)
  //       (because default implementation is to consider the widget as a page)
  @protected
  bool isComponent() => false;

  @protected
  bool useUnfocusNode() => false;

  // NOTE: Override this method to disable the scaffold
  @protected
  bool useScaffold() => true;

  // NOTE: Override this method to disable the bloc wrapper
  @protected
  bool useBlocWrapper() => true;

  // NOTE: Override this method to disable the safe area
  @protected
  bool useSafeArea() => true;

  // NOTE: Override this method to disable the single child scroll view
  @protected
  bool useSingleChildScrollViewForSafeArea() => true;

  @protected
  bool useStackForSafeArea() => false;
 
  // NOTE: Override this method to disable checking permissions on state init
  @protected
  bool checkPermissionsAfterStateInit() => false;

  // NOTE: Override this to enable default (AppConfig.requiredPermissions) permission check
  @protected
  bool checkDefaultPermissions() => true;

  @protected
  bool rebuildOnStatesInitialized() => false;

  // NOTE: Override this method to enable permission check
  @protected
  List<Permission> checkPermissions() => [];

  @protected
  bool requireMetadata() => false;

  Future<void> handlePermissions([Function()? onGranted]) async {
    List<Permission> permissions = [];

    if (checkDefaultPermissions()) {
      permissions = AppConfig.requiredPermissions;
    }

    List<Permission> definedPermissions = checkPermissions();

    if (definedPermissions.isNotEmpty) {
      permissions = definedPermissions;
    }

    if (permissions.isEmpty) {
      if (onGranted != null) {
        onGranted();
      }
    }

    if (!(await CorePermissions.areGranted(permissions))){
      if (mounted){
        await CorePermissions.handle(context, permissions);
      }
    } else {
      if (onGranted != null) {
        onGranted();
      }
    }
  }

  Future<void> _initializeStates() async {
    if (onStatesInitializedCalled) {
      return;
    }

    // log("@@ $runtimeType @ _initializeStates()");

    if (!context.isCoreStateInitialized && !context.isCoreStateInitializing) {
      // log("@@ > $runtimeType -- initializing core state");
      await coreBloc.initState();
    }

    if (mounted && !context.isEspoStateInitialized && !context.isEspoStateInitializing) {
      // log("@@ > $runtimeType -- initializing espo state");
      await espoBloc.initState();
    }

    if (mounted && context.areStatesInitialized) {
      // log("@@ > $runtimeType @ onStatesInitialized()");
      onStatesInitializedCalled = true;
      onStatesInitialized();
    }
  }

  void rebuild() {
    if (mounted) {
      setState(() {});
    }
  }

  @protected
  void onStatesInitialized() {
    // NOTE: rebuild the widget after initilization
    if (rebuildOnStatesInitialized()) {
      logState("REBUILD ON STATES INITIALIZED");
      rebuild();
    }
  }

  @protected
  Future<void> onCoreUpdate(BuildContext context, CoreGlobalState state) async {
    // log("CORE UPDATE");
  }

  @protected
  bool buildWhenCore(CoreGlobalState previous, CoreGlobalState current) {
    // NOTE: default functionality is to NOT rebuild the bloc
    return false;
  }

  @protected
  Future<void> onEspoUpdate(BuildContext context, EspoGlobalState state) async {
    // log("ESPO UPDATE");
  }

  @protected
  bool buildWhenEspo(EspoGlobalState previous, EspoGlobalState current) {
    // NOTE: default functionality is to NOT rebuild the bloc
    return false;
  }

  @protected
  void updateCoreState(CoreGlobalState newState) {
    if (!mounted || !context.isCoreStateInitialized) {
      return;
    }
    context.updateCoreState(newState);
  }

  @protected
  void updateEspoState(EspoGlobalState newState) {
    if (!mounted || !context.isEspoStateInitialized) {
      return;
    }
    context.updateEspoState(newState);
  }

  @override
  void dispose() {
    animationController.dispose();
    textController.dispose();
    super.dispose();
  }

  @protected
  Widget buildInitializingStates(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: CoreTheme.of(context).primaryBackground,
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @protected
  AppBar? buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0x00FFFFFF),
      automaticallyImplyLeading: false,
      title: Text(
        'Override buildAppBar :)',
        textAlign: TextAlign.start,
        // style: CoreTheme.of(context).typography.headlineMedium.override(
        //   color: Colors.white,
        // ),
      )
    );
  }

  @protected
  Drawer? buildDrawer(BuildContext context) {
    return null;
  }

  @protected
  Widget buildOnNoMetadata(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: CoreTheme.of(context).primaryBackground,
      ),
      child: Center(
        child: Text('No metadata ($runtimeType requires it)'),
      ),
    );
  }
  
  @protected
  Widget buildContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: CoreTheme.of(context).primaryBackground,
      ),
      child: const Text('Override buildContent :)',)
    );
  }

  @protected
  Widget overrideBuild(BuildContext context) {
    if (requireMetadata() && espoState.metadata == null) {
      return buildOnNoMetadata(context);
    }

    if(!useUnfocusNode()) {
      return buildContent(context);
    }

    // logState("UNFOCUS NODE");

    return GestureDetector(
      onTap: () => unfocusNode.canRequestFocus
        ? FocusScope.of(context).requestFocus(unfocusNode)
        : FocusScope.of(context).unfocus(),
      child: buildContent(context),
    );
  }

  @protected
  Widget buildBlocWrapper(BuildContext context) {
    if (!useBlocWrapper()) {
      return buildScaffold(context);
    }

    // logState("BLOC WRAPPER");

    // HELL YEAH!
    return BlocListener<CoreGlobalBloc, CoreGlobalState>(
      listener: onCoreUpdate,
      child: BlocBuilder<CoreGlobalBloc, CoreGlobalState>(
        buildWhen: buildWhenCore,
        builder: (context, state) {
          return BlocListener<EspoGlobalBloc, EspoGlobalState>(
            listener: onEspoUpdate,
            child: BlocBuilder<EspoGlobalBloc, EspoGlobalState>(
              buildWhen: buildWhenEspo,
              builder: (context, state) {
                return buildScaffold(context);
              },
            )
          );
        },
      )
    );
  }

  @protected
  Widget buildSafeAreaInner(BuildContext context) {
    if (isComponent()) {
      return overrideBuild(context);
    }

    if (useSingleChildScrollViewForSafeArea()) {
      return SingleChildScrollView(
        child: overrideBuild(context),
      );
    }

    if (useStackForSafeArea()) {
      return Stack(
        children: [
          overrideBuild(context),
        ],
      );
    }

    return overrideBuild(context);
  }

  @protected
  Widget buildSafeArea(BuildContext context) {
    if (!useSafeArea() || isComponent()) {
      return buildSafeAreaInner(context);
    }

    // logState("SAFE AREA");

    return SafeArea(
      child: buildSafeAreaInner(context),
    );
  }

  @protected
  Widget buildScaffold(BuildContext context) {
    if (!useScaffold() || isComponent()) {
      return buildSafeArea(context);
    }

    // logState("SCAFFOLD");

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: scaffoldKey,
      // backgroundColor: CoreTheme.of(context).primaryBackground,
      appBar: buildAppBar(context),
      drawer: buildDrawer(context),
      body: Builder(builder: (context) { return buildSafeArea(context); }),
    );
  }

  @override
  Widget build(BuildContext context) {
    // logState("REBUILDING");

    if (!context.areStatesInitialized) {
      return buildInitializingStates(context);
    }

    if (PlatformInfo.isIOS()) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    return buildBlocWrapper(context);
  }
}