import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

class EspoAdminEntitiesPage extends CoreBaseStatefulWidget {
  const EspoAdminEntitiesPage({
    super.key,
  });

  @override
  CoreBaseState createState() => EspoAdminEntitiesPageState();
}

class EspoAdminEntitiesPageState extends CoreBaseState<EspoAdminEntitiesPage> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      espoBloc.load();
    });
  }

  @override
  AppBar? buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFFFB700),
      automaticallyImplyLeading: false,
      title: Text(
        'Entities',
        textAlign: TextAlign.start,
        // style: CoreTheme.of(context).headlineMedium.override(
        //   color: Colors.white,
        //   fontSize: 22,
        // ),
      ),
      leading: IconButton(
        iconSize: 48,
        color: Colors.white,
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: 32,
        ),
        onPressed: () async {
          CoreNavigator.pop(context);
        },
      ),
      centerTitle: true,
      elevation: 2,
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    // if (espoState.isLoading) {
    //   return const Center(
    //     child: CircularProgressIndicator(),
    //   );
    // }

    return const SafeArea(
      top: true,
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                  //   Expanded(
                  //     child: EntitiesListComponent(),
                  //   ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}