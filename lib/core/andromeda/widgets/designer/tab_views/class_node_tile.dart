import 'package:flutter/material.dart';
import 'package:andromeda/core/_.dart';
import 'package:provider/provider.dart';

class DesignerClassNodeTile extends StatelessWidget {
  final ClassNode node;

  const DesignerClassNodeTile({
    super.key,
    required this.node,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AndromedaDesignerState>(
      builder: (context, state, child) {
        ClassMethodNode? constructor = state.getClassConstructor(node);
        bool isSelected = state.currentView?.node == node;
        
        return ExpansionTile(
          leading: const Icon(Icons.class_),
          title: Text(node.label),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          subtitle: constructor != null ? Row(
            children: [
              const Icon(Icons.last_page),
              const SizedBox(width: 8),
              Text(constructor.signature),
            ],
          ) : null,
          collapsedTextColor: isSelected ? Theme.of(context).colorScheme.primary : null,
          textColor: isSelected ? Theme.of(context).colorScheme.primary : null,
          trailing: IconButton.filled(
            icon: Icon(isSelected ? Icons.visibility : Icons.visibility_off),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              state.switchView(TreeViewModel(
                type: ViewType.class_,
                title: 'Class: ${node.name}',
                node: node,
              ));
            }
          ),
          children: [
            if (node.propertyList.isNotEmpty) ...[
              const Divider(),
              Text(
                'Properties',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const Divider(),
              ...node.propertyList.map((prop) {
                bool isSelected = state.currentView?.node == prop;
                
                return ListTile(
                  leading: const Icon(Icons.fiber_manual_record),
                  title: Text("${prop.name} (${prop.valueTypeString})"),
                  subtitle: Row(
                    children: [
                      const Icon(Icons.arrow_right_alt),
                      const SizedBox(width: 8),
                      Text(prop.value),
                    ],
                  ),
                  selected: isSelected,
                );
              }),
            ],

            if (node.methodList.isNotEmpty) ...[
              if (node.propertyList.isNotEmpty) const Divider(),

              Text(
                'Methods',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const Divider(),
              ...node.methodList.map((method) {
                bool isSelected = state.currentView?.node == method;
                
                return ListTile(
                  leading: const Icon(Icons.fiber_manual_record),
                  title: Text(method.signature),
                  subtitle: Row(
                    children: [
                      const Icon(Icons.keyboard_return),
                      const SizedBox(width: 8),
                      Text(method.lastStatement),
                    ],
                  ),
                  selected: isSelected,
                );
              }),
            ],
          ],
        );
      }
    );
  }
}