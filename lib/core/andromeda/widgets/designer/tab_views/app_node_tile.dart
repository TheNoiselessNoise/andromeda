import 'package:flutter/material.dart';
import 'package:andromeda/core/_.dart';
import 'package:provider/provider.dart';

class DesignerAppNodeTile extends StatelessWidget {
  final AppNode node;

  const DesignerAppNodeTile({
    super.key,
    required this.node,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AndromedaDesignerState>(
      builder: (context, state, child) {
        bool isSelected = state.currentView?.node == node;

        return ListTile(
          leading: const Icon(Icons.developer_board),
          title: const Text('App Structure'),
          selected: state.currentView?.type == ViewType.app,
          trailing: IconButton.filled(
            icon: Icon(isSelected ? Icons.visibility : Icons.visibility_off),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              state.switchView(TreeViewModel(
                type: ViewType.app,
                title: 'App Structure',
                node: node,
              ));
            }
          ),
        );
      }
    );
  }
}