import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:andromeda/core/_.dart';

class ToolboxTabViews extends StatelessWidget {
  final TabController tabController;

  const ToolboxTabViews({
    super.key,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AndromedaDesignerState>(
      builder: (context, state, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'App',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              DesignerAppNodeTile(node: state.appNode),

              const Divider(),
              Text(
                'Pages',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              ...state.appNode.pageList.map((page) => DesignerPageNodeTile(node: page)),

              const Divider(),
              Text(
                'Classes',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              ...state.classNodes.map((cls) => DesignerClassNodeTile(node: cls)),

              const Divider(),
              Text(
                'Functions',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              ...state.functionNodes.map((func) => DesignerFunctionNodeTile(node: func)),
            ],
          ),
        );
      },
    );
  }
}