import 'package:flutter/material.dart';
import 'package:andromeda/core/_.dart';

class DragData {
  final Node node;
  final int sourceIndex;

  const DragData(this.node, this.sourceIndex);
}

enum DropPosition {
  before,
  after,
  inside,
}

class AndromedaDesignerState extends ChangeNotifier {
  TreeViewModel? _currentView;
  Node? _selectedNode;
  String? _currentDragStatus;
  final Set<String> _expandedNodes = {'root'};
  final List<FunctionNode> functionNodes;
  final List<ClassNode> classNodes;
  final AppNode appNode;

  TreeViewModel? get currentView => _currentView;
  Node? get selectedNode => _selectedNode;
  String? get currentDragStatus => _currentDragStatus;
  Set<String> get expandedNodes => _expandedNodes;

  ClassMethodNode? getClassConstructor(ClassNode cls) {
    for (ClassMethodNode method in cls.methods ?? []) {
      if (method.name == '_init') {
        return method;
      }
    }

    if (cls.extendsClass != null) {
      for (ClassNode parent in classNodes) {
        if (parent.name == cls.extendsClass) {
          return getClassConstructor(parent);
        }
      }
    }

    return null;
  }

  AndromedaDesignerState({required SAppConfig app}) 
      : functionNodes = [
          FunctionNode(
            name: 'SomeFunction',
            body: [
              CodeNode(code: 'print("Hello, World! 1");'),
              CodeNode(code: 'print("Hello, World! 2");'),
              CodeNode(code: 'print("Hello, World! 3");'),
              CodeNode(code: 'print("Hello, World! 4");'),
              CodeNode(code: 'print("Hello, World! 5");'),
            ],
          ),
          FunctionNode(
            name: 'AnotherFunction',
            parameters: [
              ParameterNode(name: 'a'),
              ParameterNode(name: 'b'),
            ],
            body: [
              CodeNode(code: 'print("Hello, World! 1");'),
              CodeNode(code: 'print("Hello, World! 2");'),
              CodeNode(code: 'print("Hello, World! 3");'),
              CodeNode(code: 'print("Hello, World! 4");'),
              CodeNode(code: 'print("Hello, World! 5");'),
            ],
          )
        ],
        classNodes = [
          ClassNode(
            name: 'SomeClass',
            properties: [
              ClassPropertyNode(name: 'property1', value: '"value1"', valueType: ParameterType.string),
              ClassPropertyNode(name: 'property2', value: '2', valueType: ParameterType.int_),
            ],
            methods: [
              ClassMethodNode(
                name: 'someMethod',
                parameters: [
                  ParameterNode(name: 'a'),
                  ParameterNode(name: 'b'),
                ],
                body: [
                  CodeNode(code: 'print("Hello, World! 1");'),
                  CodeNode(code: 'print("Hello, World! 2");'),
                  CodeNode(code: 'print("Hello, World! 3");'),
                  CodeNode(code: 'print("Hello, World! 4");'),
                  CodeNode(code: 'print("Hello, World! 5");'),
                ],
              ),
            ],
          ),
          ClassNode(
            name: 'SomeClass2',
            properties: [
              ClassPropertyNode(name: 'property1', value: '"value1"', valueType: ParameterType.string),
              ClassPropertyNode(name: 'property2', value: '2.00', valueType: ParameterType.double_),
            ],
            methods: [
              ClassMethodNode(
                name: '_init',
                parameters: [
                  ParameterNode(name: 'a'),
                  ParameterNode(name: 'b'),
                ],
                body: [
                  CodeNode(code: 'print("Hello, World! 1");'),
                  CodeNode(code: 'print("Hello, World! 2");'),
                  CodeNode(code: 'print("Hello, World! 3");'),
                  CodeNode(code: 'print("Hello, World! 4");'),
                  CodeNode(code: 'print("Hello, World! 5");'),
                ],
              ),
            ],
          )
        ],
        appNode = AppNode(
          title: app.label,
          pages: [
            PageNode(
              name: 'SomePage',
              child: WidgetNodeWithChildren(
                name: 'Column',
                children: [
                  WidgetNode(name: 'Text'),
                  WidgetNode(name: 'Button'),
                ],
              ),
            )
          ]
        );

  void switchView(TreeViewModel view) {
    _currentView = view;
    notifyListeners();
  }

  void setDragStatus(String? status) {
    _currentDragStatus = status;
    notifyListeners();
  }

  void setNodeCode(String value) {
    if (_selectedNode is CodeNode) {
      (_selectedNode as CodeNode).code = value;
      notifyListeners();
    }
  }

  void removeChild(Node child) {
    _selectedNode?.removeChild(child);
    notifyListeners();
  }

  void addChild(Node child) {
    _selectedNode?.addChild(child);
    notifyListeners();
  }

  String _generateNewParamName(List<String> existingNames) {
    int i = 1;
    while (existingNames.contains('param$i')) { i++; }
    return 'param$i';
  }

  void addNodeParameter() {
    if (_selectedNode is FunctionNode) {
      List<String> existingNames = (_selectedNode as FunctionNode).parameterList.map((e) => e.name).toList();
      addChild(ParameterNode(name: _generateNewParamName(existingNames)));
    }

    if (_selectedNode is ClassMethodNode) {
      List<String> existingNames = (_selectedNode as ClassMethodNode).parameterList.map((e) => e.name).toList();
      addChild(ParameterNode(name: _generateNewParamName(existingNames)));
    }
  }

  void moveNode(Node node, Node target, DropPosition position) {
    node.parent?.removeChild(node);

    switch (position) {
      case DropPosition.before:
        target.parent?.insertBefore(node, target);
        break;
      case DropPosition.after:
        target.parent?.insertAfter(node, target);
        break;
      case DropPosition.inside:
        if (!expandedNodes.contains(target.id)) {
          toggleExpandNode(target.id);
        }
        target.addChild(node);
        break;
      default: throw Exception('Invalid drop position: $position');
    }

    notifyListeners();
  }

  void toggleExpandNode(String nodeId) {
    if (_expandedNodes.contains(nodeId)) {
      _expandedNodes.remove(nodeId);
    } else {
      _expandedNodes.add(nodeId);
    }
    notifyListeners();
  }

  void toggleExpandFullNode(Node node, [bool isChild = false]) {
    if (_expandedNodes.contains(node.id)) {
      _expandedNodes.remove(node.id);
    } else {
      _expandedNodes.add(node.id);
    }

    for (final child in node.children) {
      toggleExpandFullNode(child, true);
    }

    if (!isChild) {
      notifyListeners();
    }
  }

  void toggleSelectNode(Node node) {
    if (_selectedNode == node) {
      _selectedNode = null;
    } else {
      _selectedNode = node;
    }
    notifyListeners();
  }
}

enum ViewType {
  app,
  page,
  class_,
  function,
}

class TreeViewModel {
  final ViewType type;
  final String title;
  final Node node;

  TreeViewModel({
    required this.type,
    required this.title,
    required this.node,
  });
}