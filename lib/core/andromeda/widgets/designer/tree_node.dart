import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:andromeda/core/_.dart';

class TreeNodeWidget extends StatefulWidget {
  final Node node;
  final int level;
  final TabController tabController;
  final Function(BuildContext) showToolbox;

  const TreeNodeWidget({
    super.key,
    required this.node,
    required this.level,
    required this.tabController,
    required this.showToolbox,
  });

  @override
  State<TreeNodeWidget> createState() => _TreeNodeWidgetState();
}

class _TreeNodeWidgetState extends State<TreeNodeWidget> {
  DropPosition? _dropPosition;

  bool isParentOf(Node possibleChild, Node possibleParent) {
    Node? current = possibleChild;
    while (current != null) {
      if (current.id == possibleParent.id) {
        return true;
      }
      current = current.parent;
    }
    return false;
  }

  void _showErrorToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String? checkMoveNode(Node node, Node target, DropPosition position) {
    final state = Provider.of<AndromedaDesignerState>(context, listen: false);
    final viewType = state.currentView?.type;

    if (node.id == target.id) {
      return "Can't drop onto itself";
    }

    if (isParentOf(target, node)) {
      return "Can't drop onto its child";
    }

    if (viewType == ViewType.function && target is FunctionNode) {
      if (position != DropPosition.inside) {
        return "Can't drop before or after a function";
      }
    }

    if (target is AppNode) {
      if (position != DropPosition.inside) {
        return "Can't drop before or after the app";
      }

      if (node is! PageNode) {
        return "Can't drop a non-page into the app";
      }
    }

    if (node is! PageNode && target is PageNode) {
      if (position != DropPosition.inside) {
        return "Can't drop a non-page before or after a page";
      }

      if (target.children.isNotEmpty) {
        return "Page can only have one root";
      }
    }

    if (node is WidgetNode && target is FunctionNode) {
      return "Can't drop a widget into a function";
    }

    if (node is CodeNode && target is CodeNode) {
      if (position == DropPosition.inside) {
        return "Can't drop code into another code";
      }
    }

    return null;
  }

  DropPosition _getDropPosition(Offset relativeOffset) {
    const threshold = 0.25;
    final height = relativeOffset.dy;
    
    if (height < threshold) {
      return DropPosition.before;
    } else if (height > (1 - threshold)) {
      return DropPosition.after;
    } else {
      return DropPosition.inside;
    }
  }

  Widget _buildNodeContent(
    BuildContext context,
    Node node,
    bool isExpanded,
    bool hasChildren,
    bool isSelected,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(4),
        color: isSelected
            ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
            : Colors.transparent,
      ),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () => Provider.of<AndromedaDesignerState>(context, listen: false).toggleExpandNode(node.id),
        onDoubleTap: () {
          final state = Provider.of<AndromedaDesignerState>(context, listen: false);
          state.toggleSelectNode(node);
          if (state.selectedNode == node) {
            widget.tabController.index = 1;
            widget.showToolbox(context);
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasChildren) ...[
              Icon(
                isExpanded ? Icons.expand_more : Icons.chevron_right,
                size: 20,
              ),
            ],
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  node.signature,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: node.icon,
            ),
          ],
        ),
      ),
    );
  }

  String stringifyMove(Node source, Node target, DropPosition position) {
    return "Drop '${source.label}' ${position.name} '${target.label}'";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AndromedaDesignerState>(
      builder: (context, state, child) {
        final bool isExpanded = state.expandedNodes.contains(widget.node.id);
        final List<dynamic> children = widget.node.items() as List<dynamic>;
        final bool hasChildren = children.isNotEmpty;
        final bool isSelected = state.selectedNode?.id == widget.node.id;

        return DragTarget<DragData>(
          onWillAcceptWithDetails: (details) => true,
          onAcceptWithDetails: (details) {
            final sourceNode = details.data.node;
            final targetNode = widget.node;
            final position = _dropPosition ?? DropPosition.inside;
            final check = checkMoveNode(sourceNode, targetNode, position);

            state.setDragStatus(null);

            if (check != null) {
              _showErrorToast(context, check);
              return;
            }

            state.moveNode(sourceNode, targetNode, position);
          },
          onLeave: (data) {
            setState(() { _dropPosition = null; });
            state.setDragStatus(null);
          },
          onMove: (details) {
            final RenderBox box = context.findRenderObject() as RenderBox;
            final localPosition = box.globalToLocal(details.offset);
            final size = box.size;
            final relativeOffset = Offset(
              localPosition.dx / size.width,
              localPosition.dy / size.height,
            );
            
            final newPosition = _getDropPosition(relativeOffset);
            if (newPosition != _dropPosition) {
              setState(() { _dropPosition = newPosition; });
            }

            final sourceNode = details.data.node;
            final targetNode = widget.node;
            final position = _dropPosition ?? DropPosition.inside;
            final status = stringifyMove(sourceNode, targetNode, position);
            state.setDragStatus(status);
          },
          builder: (context, candidateData, rejectedData) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LongPressDraggable<DragData>(
                      data: DragData(widget.node, widget.level),
                      feedback: Material(
                        elevation: 4,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          color: Theme.of(context).colorScheme.surface,
                          child: Text(widget.node.label),
                        ),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.5,
                        child: _buildNodeContent(context, widget.node, isExpanded, hasChildren, isSelected),
                      ),
                      child: _buildNodeContent(context, widget.node, isExpanded, hasChildren, isSelected),
                    ),
                    if (isExpanded && hasChildren)
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: children
                              .map((child) => TreeNodeWidget(
                                    node: child,
                                    level: widget.level + 1,
                                    tabController: widget.tabController,
                                    showToolbox: widget.showToolbox,
                                  ))
                              .toList(),
                        ),
                      ),
                  ],
                ),
                
                if (_dropPosition != null && candidateData.isNotEmpty) ...[
                  if (_dropPosition == DropPosition.before) ...[
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 2,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                  
                  if (_dropPosition == DropPosition.after) ...[
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 2,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                  
                  if (_dropPosition == DropPosition.inside) ...[
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ],
              ],
            );
          },
        );
      },
    );
  }
}