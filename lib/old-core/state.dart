import 'dart:ui';
import 'core.dart';

class CoreGlobalState {
  // Currently selected locale
  Locale? currentLocale = Locale(AppConfig.currentLanguage);

  JsonP? currentPage;
  List<JsonP>? pageHistory;
  Map<String, dynamic>? currentPageArgs;

  EspoPageBuilderState? pageBuilderState;
  CoreBaseCameraState? cameraState;
  CoreBaseZebraScannerState? zebraScannerState;

  // storage for key value pairs
  TemporaryStorage? temporaryStorage;

  ParentContext? parentContext;

  CoreGlobalState({
    this.currentLocale,
    this.currentPage,
    this.currentPageArgs,
    this.pageHistory,
    this.pageBuilderState,
    this.cameraState,
    this.zebraScannerState,
    this.temporaryStorage,
    this.parentContext,
  });

  CoreGlobalState updateWith(CoreGlobalState newState) {
    return CoreGlobalState(
      currentLocale: newState.currentLocale ?? currentLocale,
      currentPage: newState.currentPage ?? currentPage,
      currentPageArgs: newState.currentPageArgs ?? currentPageArgs,
      pageHistory: newState.pageHistory ?? pageHistory,
      pageBuilderState: newState.pageBuilderState ?? pageBuilderState,
      cameraState: newState.cameraState ?? cameraState,
      zebraScannerState: newState.zebraScannerState ?? zebraScannerState,
      temporaryStorage: newState.temporaryStorage ?? temporaryStorage,
      parentContext: newState.parentContext ?? parentContext,
    );
  }
}

class CoreGlobalBloc extends GlobalBlocInstance<CoreGlobalState> {
  CoreGlobalBloc() : super(CoreGlobalState());

  @override
  Future<void> initStateLogic() async {
    await load();
  }

  @override
  void updateState(CoreGlobalState newState) {
    emit(state.updateWith(newState));
  }

  Future<CoreStateResult> updateLocale({
    Locale? newLocale
  }) async {
    return await updateWrapper(() async {
      if (newLocale != null) {
        newLocale = newLocale;
      } else {
        String lang = await AppConfig.defaultDataStorage.getString('currentLocale', AppConfig.currentLanguage);
        newLocale = lang.toLocale();
      }

      AppConfig.currentLanguage = newLocale!.toLocaleString();
      updateState(CoreGlobalState(currentLocale: newLocale));
      await AppConfig.defaultDataStorage.setString('currentLocale', newLocale!.toLocaleString());
    });
  }

  void setPageBuilderState(EspoPageBuilderState? state) {
    updateState(CoreGlobalState(pageBuilderState: state));
  }

  void setCameraState(CoreBaseCameraState? state) {
    updateState(CoreGlobalState(cameraState: state));
  }

  void setZebraScannerState(CoreBaseZebraScannerState? state) {
    updateState(CoreGlobalState(zebraScannerState: state));
  }

  JsonP getCurrentPage([JsonP? defaultPage]) {
    return state.currentPage ?? defaultPage ?? PBuilder.error404Page();
  }

  void setPageParentContextArgument(ParentContext? context) {
    Map<String, dynamic> args = Map<String, dynamic>.from(state.currentPageArgs ?? {});
    args['parentContext'] = context;
    updateState(CoreGlobalState(currentPageArgs: args));
  }

  void popPage() {
    List<JsonP> history = state.pageHistory ?? [];
    if (history.isNotEmpty) {
      JsonP page = history.removeLast();

      updateState(CoreGlobalState(
        currentPage: page,
        pageHistory: history
      ));
    }
  }

  void addPageToHistory(JsonP page) {
    if (page.settings.ignoreHistory) return;
    List<JsonP> history = state.pageHistory ?? [];
    history.add(page);
    updateState(CoreGlobalState(pageHistory: history));
  }

  void setPage(JsonP page) {
    setToTemporaryStorage('currentPageId', page.id);
    page = page.withArguments(state.currentPageArgs ?? {});
    List<JsonP> history = state.pageHistory ?? [];
    if (state.currentPage != null && !state.currentPage!.settings.ignoreHistory) {
      history.add(state.currentPage!);
    }
    updateState(CoreGlobalState(
      currentPage: page,
      pageHistory: history,
    ));
  }

  void setTemporaryStorage(TemporaryStorage storage) {
    updateState(CoreGlobalState(temporaryStorage: storage));
  }

  void setToTemporaryStorage(String key, dynamic value) {
    setTemporaryStorage(TemporaryStorage({
      ...state.temporaryStorage?.data ?? {},
      key: value
    }));
  }

  void deleteFromTemporaryStorage(String key) {
    Map<String, dynamic> data = Map<String, dynamic>.from(state.temporaryStorage?.data ?? {});
    data.remove(key);
    setTemporaryStorage(TemporaryStorage(data));
  }

  Future<CoreStateResult> load({bool notify = true}) async {
    return await updateWrapper(() async {
      setTemporaryStorage(TemporaryStorage({}));
    });
  }
}