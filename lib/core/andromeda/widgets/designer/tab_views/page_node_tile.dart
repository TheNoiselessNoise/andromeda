import 'package:flutter/material.dart';
import 'package:andromeda/core/_.dart';
import 'package:provider/provider.dart';

class DesignerPageNodeTile extends StatelessWidget {
  final PageNode node;

  const DesignerPageNodeTile({
    super.key,
    required this.node,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AndromedaDesignerState>(
      builder: (context, state, child) {
        bool isSelected = state.currentView?.node == node;

        return ListTile(
          leading: const Icon(Icons.web),
          title: Text(node.label),
          selected: state.currentView?.node == node,
          trailing: IconButton.filled(
            icon: Icon(isSelected ? Icons.visibility : Icons.visibility_off),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              state.switchView(TreeViewModel(
                type: ViewType.page,
                title: 'Page: ${node.label}',
                node: node,
              ));
            }
          ),
        );
      }
    );
  }
}