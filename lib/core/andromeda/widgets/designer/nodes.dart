import 'package:flutter/material.dart';
import 'package:andromeda/core/_.dart';

abstract class Node {
  String? _id;
  List<Node> _children = [];
  Node? parent;

  Node({
    List<Node>? children,
    this.parent
  }) {
    _id = uuidv4();
    _children = children ?? [];
    setParent(parent);
    setParentForChildren(_children);
  }

  String get id => _id ?? '';
  String get label => '';
  String get signature => '';
  Icon get icon => const Icon(Icons.fiber_manual_record);

  void setParent(Node? node) => parent = node;
  void setParentForChildren(List<Node>? children) => children?.forEach((child) => child.setParent(this));

  void addChild(Node node) {
    node.setParent(this);
    _children.add(node);
  }
  void removeChild(Node node) => _children.remove(node);
  void insertBefore(Node newNode, Node referenceNode) {
    final index = _children.indexOf(referenceNode);
    if (index != -1) {
      newNode.setParent(this);
      _children.insert(index, newNode);
    }
  }
  void insertAfter(Node newNode, Node referenceNode) {
    final index = _children.indexOf(referenceNode);
    if (index != -1) {
      newNode.setParent(this);
      _children.insert(index + 1, newNode);
    }
  }

  List<Node> get children => _children;
  List<Node> items() => children;
}

class CodeNode extends Node {
  String? code;

  CodeNode({
    this.code,
    super.parent,
  }) { setParent(parent); }

  @override
  String get label => code ?? '';

  @override
  String get signature => label;

  @override
  Icon get icon => const Icon(Icons.code);
}

class PropNode extends Node {
  List<Node>? props;

  PropNode({
    this.props,
    super.parent,
  }) : super(children: props ?? []);

  @override
  String get label => '@prop';

  @override
  String get signature => label;
}

class StyleNode extends Node {
  List<Node>? styles;

  StyleNode({
    this.styles,
    super.parent,
  }) : super(children: styles ?? []);

  @override
  String get label => '@style';

  @override
  String get signature => label;
}

class StateNode extends Node {
  List<Node>? states;

  StateNode({
    this.states,
    super.parent,
  }) : super(children: states ?? []);

  @override
  String get label => '@state';

  @override
  String get signature => label;
}

class EventNode extends Node {
  List<Node>? events;

  EventNode({
    this.events,
    super.parent,
  }) : super(children: events ?? []);

  @override
  String get label => '@event';

  @override
  String get signature => label;
}

class RenderNode extends Node {
  RenderNode({
    super.children,
    super.parent,
  });

  @override
  String get label => '@render';

  @override
  String get signature => label;
}

class FunctionNode extends Node {
  String? name;
  List<ParameterNode>? parameters;
  List<Node>? body;

  FunctionNode({
    this.name,
    this.parameters,
    this.body,
    super.parent,
  }) : super(children: [
    ...parameters ?? [],
    ...body ?? [],
  ]);

  List<ParameterNode> get parameterList => children.whereType<ParameterNode>().toList();
  List<Node> get bodyList => children.where((child) => child is! ParameterNode).toList();

  @override
  String get label => name ?? '';

  @override
  String get signature {
    bool hasParams = parameterList.isNotEmpty;
    final params = hasParams ? parameterList.map((p) => p.label).join(', ') : '';
    return hasParams ? '$name ($params)' : name ?? '';
  }

  String get lastStatement => body != null && body!.isNotEmpty ? body!.last.label : '';

  @override
  Icon get icon => const Icon(Icons.functions);

  @override
  List<Node> items() => bodyList;
}

enum ParameterType {
  null_,
  string,
  int_,
  double_,
  boolean,
  list,
  map,
  object
}

class ParameterNode extends Node {
  String name;
  dynamic value;
  ParameterType? valueType;

  ParameterNode({
    required this.name,
    this.value,
    this.valueType,
    super.parent,
  });

  String get valueTypeString {
    String? type = valueType?.name;
    if (type == null) return 'no value';
    if (type.endsWith('_')) type = type.substring(0, type.length - 1);
    return type;
  }

  @override
  String get label => name;
  
  @override
  String get signature => "$label = $value";
}

class ClassPropertyNode extends Node {
  String name;
  dynamic value;
  ParameterType? valueType;

  ClassPropertyNode({
    required this.name,
    this.value,
    this.valueType,
    super.parent,
  });

  String get valueTypeString {
    String? type = valueType?.name;
    if (type == null) return 'no value';
    if (type.endsWith('_')) type = type.substring(0, type.length - 1);
    return type;
  }

  @override
  String get label => name;

  @override
  String get signature => "$label = $value";
}

class ClassMethodNode extends FunctionNode {
  ClassMethodNode({
    super.name,
    super.parameters,
    super.body,
    super.parent,
  });

  @override
  Icon get icon => const Icon(Icons.last_page);
}

class ClassNode extends Node {
  String name;
  String? extendsClass;
  List<ClassPropertyNode>? properties;
  List<ClassMethodNode>? methods;

  ClassNode({
    required this.name,
    this.extendsClass,
    this.properties,
    this.methods,
    super.parent,
  }) : super(children: [
    ...properties ?? [],
    ...methods ?? [],
  ]);

  List<ClassPropertyNode> get propertyList => properties ?? [];
  List<ClassMethodNode> get methodList => methods ?? [];

  @override
  String get label => name;

  @override
  String get signature => label;

  @override
  Icon get icon => const Icon(Icons.class_);
}

class AppNode extends Node {
  String title;
  List<PageNode>? pages;

  AppNode({
    required this.title,
    this.pages,
  }) : super(children: pages ?? []);

  List<PageNode> get pageList => List<PageNode>.from(children);

  @override
  String get label => title;

  @override
  String get signature => label;

  @override
  Icon get icon => const Icon(Icons.developer_board);
}

class PageNode extends Node {
  String name;
  Node? child;

  PageNode({
    required this.name,
    this.child,
  }) : super(children: child != null ? [child] : []);

  @override
  String get label => name;

  @override
  String get signature => label;

  @override
  Icon get icon => const Icon(Icons.web);
}

class WidgetNode extends Node {
  String name;

  WidgetNode({
    required this.name,
    super.children,
  });

  @override
  String get label => name;

  @override
  String get signature => label;

  @override
  Icon get icon => const Icon(Icons.widgets);
}

class WidgetNodeWithChild extends WidgetNode {
  Node? child;

  WidgetNodeWithChild({
    required super.name,
    this.child,
  }) : super(children: child != null ? [child] : []);
}

class WidgetNodeWithChildren extends WidgetNode {
  WidgetNodeWithChildren({
    required super.name,
    super.children,
  });
}

// import 'package:andromeda/core/_.dart';

// abstract class Node {
//   final String id;
//   Node? parent;

//   Node({this.parent}) : id = uuidv4();

//   String get label => '';
//   String get signature => '';

//   void setParent(Node? node) => parent = this;
//   void setParentForChildren(List<Node>? children) => children?.forEach((child) => child.setParent(this));

//   List<Node> items();
// }

// class CodeNode extends Node {
//   String? code;

//   CodeNode({
//     this.code,
//     super.parent,
//   }) { setParent(parent); }

//   @override
//   String get label => code ?? '';

//   @override
//   String get signature => label;

//   @override
//   List<Node> items() => [];
// }

// class PropNode extends Node {
//   List<Node>? props;

//   PropNode({
//     this.props,
//     super.parent,
//   }) { setParentForChildren(props); }

//   @override
//   String get label => '@prop';

//   @override
//   String get signature => label;

//   @override
//   List<Node> items() => props ?? [];
// }

// class StyleNode extends Node {
//   List<Node>? styles;

//   StyleNode({
//     this.styles,
//     super.parent,
//   }) { setParentForChildren(styles); }

//   @override
//   String get label => '@style';

//   @override
//   String get signature => label;

//   @override
//   List<Node> items() => styles ?? [];
// }

// class StateNode extends Node {
//   List<Node>? states;

//   StateNode({
//     this.states,
//     super.parent,
//   }) { setParentForChildren(states); }

//   @override
//   String get label => '@state';

//   @override
//   String get signature => label;

//   @override
//   List<Node> items() => states ?? [];
// }

// class EventNode extends Node {
//   List<Node>? events;

//   EventNode({
//     this.events,
//     super.parent,
//   }) { setParentForChildren(events); }

//   @override
//   String get label => '@event';

//   @override
//   String get signature => label;

//   @override
//   List<Node> items() => events ?? [];
// }

// class RenderNode extends Node {
//   List<Node>? children;

//   RenderNode({
//     this.children,
//     super.parent,
//   }) { setParentForChildren(children); }

//   @override
//   String get label => '@render';

//   @override
//   String get signature => label;

//   @override
//   List<Node> items() => children ?? [];
// }

// class FunctionNode extends Node {
//   String? name;
//   List<ParameterNode>? parameters;
//   List<Node>? body;

//   FunctionNode({
//     this.name,
//     this.parameters,
//     this.body,
//     super.parent,
//   }) {
//     setParentForChildren(parameters);
//     setParentForChildren(body);
//   }

//   List<ParameterNode> get parameterList => parameters ?? [];
//   List<Node> get bodyList => body ?? [];

//   @override
//   String get label => name ?? '';

//   @override
//   String get signature {
//     bool hasParams = parameters != null && parameters!.isNotEmpty;
//     final params = hasParams ? parameters!.map((p) => p.label).join(', ') : '';
//     return params.isNotEmpty ? '$name ($params)' : name ?? '';
//   }

//   String get lastStatement => body != null && body!.isNotEmpty ? body!.last.label : '';

//   @override
//   List<Node> items() => body ?? [];
// }

// enum ParameterType {
//   null_,
//   string,
//   int_,
//   double_,
//   boolean,
//   list,
//   map,
//   object
// }

// class ParameterNode extends Node {
//   String name;
//   dynamic value;
//   ParameterType? valueType;

//   ParameterNode({
//     required this.name,
//     this.value,
//     this.valueType,
//     super.parent,
//   }) { setParent(parent); }

//   String get valueTypeString {
//     String? type = valueType?.name;
//     if (type == null) return 'no value';
//     if (type.endsWith('_')) type = type.substring(0, type.length - 1);
//     return type;
//   }

//   @override
//   String get label => name;
  
//   @override
//   String get signature => "$label = $value";

//   @override
//   List<Node> items() => [];
// }

// class ClassPropertyNode extends Node {
//   String name;
//   dynamic value;
//   ParameterType? valueType;

//   ClassPropertyNode({
//     required this.name,
//     this.value,
//     this.valueType,
//     super.parent,
//   }) { setParent(parent); }

//   String get valueTypeString {
//     String? type = valueType?.name;
//     if (type == null) return 'no value';
//     if (type.endsWith('_')) type = type.substring(0, type.length - 1);
//     return type;
//   }

//   @override
//   String get label => name;

//   @override
//   String get signature => "$label = $value";

//   @override
//   List<Node> items() => [];
// }

// class ClassMethodNode extends FunctionNode {
//   ClassMethodNode({
//     super.name,
//     super.parameters,
//     super.body,
//     super.parent,
//   });
// }

// class ClassNode extends Node {
//   String name;
//   String? extendsClass;
//   List<ClassPropertyNode>? properties;
//   List<ClassMethodNode>? methods;

//   ClassNode({
//     required this.name,
//     this.extendsClass,
//     this.properties,
//     this.methods,
//     super.parent,
//   }) {
//     setParentForChildren(properties);
//     setParentForChildren(methods);
//   }

//   List<ClassPropertyNode> get propertyList => properties ?? [];
//   List<ClassMethodNode> get methodList => methods ?? [];

//   @override
//   String get label => name;

//   @override
//   String get signature => label;

//   @override
//   List<Node> items() => [
//     ...properties ?? [],
//     ...methods ?? [],
//   ];
// }

// class AppNode extends Node {
//   String title;
//   List<PageNode>? pages;

//   AppNode({
//     required this.title,
//     this.pages,
//   }) { setParentForChildren(pages); }

//   List<PageNode> get pageList => pages ?? [];

//   @override
//   String get label => title;

//   @override
//   String get signature => label;

//   @override
//   List<Node> items() => pages ?? [];
// }

// class PageNode extends Node {
//   String name;
//   Node? child;

//   PageNode({
//     required this.name,
//     this.child,
//   }) { setParent(child); }

//   @override
//   String get label => name;

//   @override
//   String get signature => label;

//   @override
//   List<Node> items() => child != null ? [child!] : [];
// }

// class WidgetNode extends Node {
//   String name;

//   WidgetNode({
//     required this.name,
//   });

//   @override
//   String get label => name;

//   @override
//   String get signature => label;

//   @override
//   List<Node> items() => [];
// }

// class WidgetNodeWithChild extends WidgetNode {
//   Node? child;

//   WidgetNodeWithChild({
//     required super.name,
//     this.child,
//   }) { setParent(child); }

//   @override
//   List<Node> items() => child != null ? [child!] : [];
// }

// class WidgetNodeWithChildren extends WidgetNode {
//   List<Node>? children;

//   WidgetNodeWithChildren({
//     required super.name,
//     this.children,
//   }) { setParentForChildren(children); }

//   @override
//   List<Node> items() => children ?? [];
// }