import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:andromeda/core/_.dart';

class ToolboxTabProperties extends StatefulWidget {
  final TabController tabController;

  const ToolboxTabProperties({
    super.key,
    required this.tabController,
  });

  @override
  State<ToolboxTabProperties> createState() => _ToolboxTabPropertiesState();
}

class _ToolboxTabPropertiesState extends State<ToolboxTabProperties> {
  final ScrollController _scrollController = ScrollController();

  Widget buildPropertiesForApp(BuildContext context, AppNode node) {
    return const Text('App properties not implemented');
  }

  Widget buildPropertiesForPage(BuildContext context, PageNode node) {
    return const Text('Page properties not implemented');
  }

  Widget buildPropertiesForWidget(BuildContext context, WidgetNode node) {
    return const Text('Widget properties not implemented');
  }

  Widget buildPropertiesForClass(BuildContext context, ClassNode node) {
    return const Text('Class properties not implemented');
  }

  void showParameterEditDialog(BuildContext context, ParameterNode parameter) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit parameter'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: parameter.name,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
              TextFormField(
                initialValue: parameter.value,
                decoration: const InputDecoration(
                  labelText: 'Value',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> scrollToEnd() async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;

    if (maxScroll > 0 && currentScroll < maxScroll) {
      await _scrollController.animateTo(
        maxScroll,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    }
  }

  Widget buildPropertiesForFunction(BuildContext context, FunctionNode node) {
    final state = Provider.of<AndromedaDesignerState>(context, listen: false);

    // TODO: add some button to choose a value for the function parameter
    // value can be:
    //   'global variable'                  ({global: true})
    //   'app state variable'               ({appState: true})
    //   'any parent widget state variable' ({parentState: true})
    //   'local variable'                   ({local: true})
    //   'built-in function'                ({builtin: true})
    //   maybe some other...

    // TODO: add/remove function parameters and it's default values

    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Parameters',
            style: Theme.of(context).textTheme.titleMedium,
          ),

          if (node.parameterList.isEmpty) ...[
            const SizedBox(height: 16),
            const Text('No parameters'),
          ],

          ...node.parameterList.map((param) {
            return Column(
              children: [
                if (param != node.parameterList.first) const Divider(),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(param.name),
                          
                          if (param.value == null && param.valueType != ParameterType.null_) ...[
                            const Text('No default value'),
                          ] else ...[
                            Text(param.value ?? 'null'),
                          ],
                        ],
                      ),
                    ),

                    IconButton.filled(
                      icon: const Icon(Icons.edit),
                      onPressed: () => showParameterEditDialog(context, param),
                    ),
                    const SizedBox(width: 16),
                    IconButton.filled(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        // TODO: check if the parameter is used in the function code
                        state.removeChild(param);
                      }
                    ),
                  ],
                )
              ],
            );
          }),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                    ),
                    backgroundColor: WidgetStatePropertyAll<Color>(Theme.of(context).colorScheme.primary),
                    foregroundColor: WidgetStatePropertyAll<Color>(Theme.of(context).colorScheme.onPrimary),
                  ),
                  onPressed: () async {
                    state.addNodeParameter();
                    await scrollToEnd();
                  },
                  child: const Text('Add parameter'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildPropertiesForCode(BuildContext context, CodeNode node) {
    final state = Provider.of<AndromedaDesignerState>(context, listen: false);

    return Form(
      child: Column(
        children: [
          TextFormField(
            maxLines: null,
            initialValue: node.code,
            decoration: const InputDecoration(
              labelText: 'Code',
            ),
            onChanged: (value) => state.setNodeCode(value),
          ),
        ],
      ),
    );
  }

  Widget buildTitle(BuildContext context, Node node) {
    if (node is FunctionNode) return Text(node.signature);
    if (node is CodeNode) return const Text('Code');
    return Text('No title for: ${node.runtimeType}');
  }

  Widget buildProperties(BuildContext context, Node node) {
    if (node is AppNode) return buildPropertiesForApp(context, node);
    if (node is PageNode) return buildPropertiesForPage(context, node);
    if (node is WidgetNode) return buildPropertiesForWidget(context, node);
    if (node is ClassNode) return buildPropertiesForClass(context, node);
    if (node is FunctionNode) return buildPropertiesForFunction(context, node);
    if (node is CodeNode) return buildPropertiesForCode(context, node);
    return Text('No properties for: ${node.runtimeType}');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AndromedaDesignerState>(
      builder: (context, state, child) {
        if (state.selectedNode == null) {
          return const Center(
            child: Text('Select a node to view its properties'),
          );
        }

        Node node = state.selectedNode!;
        
        return SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              buildTitle(context, node),
              const Divider(),
              buildProperties(context, node),
            ],
          ),
        );
      },
    );
  }
}