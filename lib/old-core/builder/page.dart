import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

class EspoPageBuilder extends CoreBaseStatefulWidget {
  final JsonP? page;

  const EspoPageBuilder({super.key,
    this.page,
  });

  @override
  EspoPageBuilderState createState() => EspoPageBuilderState();
}

class EspoPageBuilderState extends CoreBaseState<EspoPageBuilder> {
  JsonP get page => coreBloc.getCurrentPage(widget.page);
  ParentContext get parentContext => espoState.currentParentContext ?? ParentContext();

  @override
  bool useSingleChildScrollViewForSafeArea() => false;

  @override
  bool useStackForSafeArea() => false;

  @override
  bool useSafeArea() => true;

  @override
  bool buildWhenCore(CoreGlobalState previous, CoreGlobalState current) {
    bool rebuild = previous.currentPage != current.currentPage;

    if (rebuild) {
      logState("REBUILD TO PAGE: ${current.currentPage!.id}");
    }

    return rebuild;
  }

  // @override
  // bool buildWhenEspo(EspoGlobalState previous, EspoGlobalState current) {
  //   return previous.currentParentContext != current.currentParentContext;
  // }

  @override
  void initState() {
    super.initState();
    coreBloc.setPageBuilderState(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      if (page.id == 'Login') {
        handlePermissions(() async => onInit());
      }
    });
  }

  Future<void> onInit() async {
    if (!AppConfig.useApiUser && page.settings.onLoggedInUser.isNotEmpty) {
      CoreDialog.titledLoading(context, "Přihlašování...");
      bool loggedIn = await EspoLoginUser.checkLoggedIn();
      if (mounted) {
        CoreNavigator.popLast(context);
        if (loggedIn) {
          CoreSnackbar.basic(context, "Proběhlo automatické přihlášení");
          ActionBuilder.call(context, page.settings.onLoggedInUser, parentContext);
        }
      }
    }

    if (AppConfig.useApiUser && mounted) {
      ActionBuilder.call(context, page.settings.onLoggedInUser, parentContext);
    }
  }

  @override
  AppBar? buildAppBar(BuildContext context) {
    if (!page.settings.hasAppBar) return null;
    JsonC appBar = page.settings.appBar;
    Widget widget = CWBuilder.build(context, appBar, parentContext);
    return widget is AppBar ? widget : null;
  }

  @override
  Drawer? buildDrawer(BuildContext context) {
    dynamic drawer = page.settings.drawer;
    JsonC? cDrawer = LBuilder(context.metadata).getDrawer(drawer);
    Widget? widget = cDrawer is JsonC ? CWBuilder.build(context, cDrawer, parentContext) : null;
    return widget is Drawer ? widget : null;
  }

  @override
  Widget buildContent(BuildContext context) {
    return Builder(
      builder: (context) {
        return CWBuilder.build(context, page.component, parentContext);
      },
    );
  }
}