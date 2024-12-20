import 'package:flutter/material.dart';
import 'package:andromeda/core/_.dart';
import 'package:provider/provider.dart';

class DesignerFunctionNodeTile extends StatelessWidget {
  final FunctionNode node;

  const DesignerFunctionNodeTile({
    super.key,
    required this.node,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AndromedaDesignerState>(
      builder: (context, state, child) {
        bool isSelected = state.currentView?.node == node;
        
        return ListTile(
          leading: const Icon(Icons.fiber_manual_record),
          title: Text(node.signature),
          subtitle: Row(
            children: [
              const Icon(Icons.keyboard_return),
              const SizedBox(width: 8),
              Text(node.lastStatement),
            ],
          ),
          selected: isSelected,
          trailing: IconButton.filled(
            icon: Icon(isSelected ? Icons.visibility : Icons.visibility_off),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              state.switchView(TreeViewModel(
                type: ViewType.function,
                title: 'Function: ${node.name}',
                node: node,
              ));
            }
          ),
        );
      }
    );
  }
}