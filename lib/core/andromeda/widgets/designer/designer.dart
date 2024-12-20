import 'package:flutter/material.dart';
import 'package:andromeda/core/_.dart';
import 'package:provider/provider.dart';

class AndromedaDesigner extends StatefulWidget {
  final SAppConfig app;

  const AndromedaDesigner({
    super.key,
    required this.app,
  });

  @override
  State<AndromedaDesigner> createState() => _AndromedaDesignerState();
}

class _AndromedaDesignerState extends State<AndromedaDesigner> with SingleTickerProviderStateMixin {
  final TransformationController _transformationController = TransformationController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 3,
      vsync: this,
    );
  }

  void _resetView() {
    _transformationController.value = Matrix4.identity();
  }

  void _showToolbox(BuildContext context) async {
    final state = Provider.of<AndromedaDesignerState>(context, listen: false);

    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return DefaultTabController(
          length: 3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(icon: Icon(Icons.widgets)),
                  Tab(icon: Icon(Icons.settings)),
                  Tab(icon: Icon(Icons.format_list_bulleted)),
                ],
              ),
              ChangeNotifierProvider.value(
                value: state,
                child: Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      ToolboxTabWidgets(tabController: _tabController),
                      ToolboxTabProperties(tabController: _tabController),
                      ToolboxTabViews(tabController: _tabController),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AndromedaDesignerState(app: widget.app),
      child: Consumer<AndromedaDesignerState>(
        builder: (context, state, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                state.currentView?.title ?? "Designer",
                style: Theme.of(context).textTheme.titleMedium
              ),
            ),
            body: Column(
              children: [
                if (state.currentView != null) ...[
                  Expanded(
                    child: InteractiveViewer(
                      transformationController: _transformationController,
                      boundaryMargin: const EdgeInsets.all(double.infinity),
                      minScale: 0.1,
                      maxScale: 4.0,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: TreeNodeWidget(
                            node: state.currentView!.node,
                            level: 0,
                            tabController: _tabController,
                            showToolbox: _showToolbox,
                          ),
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: Center(
                      child: Text(
                        'Select a view from the Tools panel',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                ],

                if (state.currentDragStatus != null) ...[
                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            state.currentDragStatus!,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                Row(
                  children: [
                    // TODO: remove, only dev
                    Expanded(
                      child: IconButton(
                        icon: const Icon(Icons.developer_board),
                        onPressed: () {
                          state.switchView(TreeViewModel(
                            type: ViewType.app,
                            title: 'App Structure',
                            node: state.appNode,
                          ));
                          state.toggleExpandFullNode(state.appNode);
                        },
                        tooltip: 'App Structure',
                      ),
                    ),

                    if (state.currentView != null) ...[
                      Expanded(
                        child: IconButton(
                          icon: const Icon(Icons.compress),
                          onPressed: _resetView,
                          tooltip: 'Reset View',
                        ),
                      ),
                    ],

                    Expanded(
                      child: IconButton(
                        icon: const Icon(Icons.code),
                        onPressed: _resetView, // TODO: Toggle between code and design view
                        tooltip: 'Code View',
                      ),
                    ),

                    Expanded(
                      child: IconButton(
                        icon: const Icon(Icons.subject),
                        onPressed: _resetView, // TODO: Open log
                        tooltip: 'Open Log',
                      ),
                    ),

                    Expanded(
                      child: IconButton(
                        icon: const Icon(Icons.play_arrow),
                        onPressed: _resetView, // TODO: Preview
                        tooltip: 'Preview',
                      ),
                    ),

                    Expanded(
                      child: IconButton(
                        icon: const Icon(Icons.build),
                        onPressed: () { _showToolbox(context); },
                        tooltip: 'Toolbox',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}