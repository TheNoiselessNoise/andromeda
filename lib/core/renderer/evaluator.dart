import 'package:andromeda/core/_.dart';

class ExpressionEvaluator implements ExpressionVisitor<dynamic>, StatementVisitor<dynamic> {
  final ScopedEnvironment environment;
  final Map<String, FClass> classes;
  final Map<String, FFunction> functions;
  final Future<dynamic> Function(String, List<dynamic>) onBuiltin;
  final WidgetInstance? widgetContext;
  final AppState? appState;

  static bool debugMe = false;
  // static List<String> debugOnly = [
  //   'visitStateVariableAssignment',
  //   'visitStateVariableExpression',
  //   'visitVariableDeclaration',
  //   'visitAssignExpression',
  //   'visitAssignmentStatement'
  // ];
  static List<String> debugOnly = [];
  static List<String> debugExcept = [];

  ExpressionEvaluator(
    Environment initialEnv,
    this.classes,
    this.functions,
    this.onBuiltin, [
    this.widgetContext,
    this.appState
  ]) : environment = ScopedEnvironment(initialEnv);

  ExpressionEvaluator.withScope(
    this.environment,
    this.classes,
    this.functions,
    this.onBuiltin, [
      this.widgetContext,
      this.appState
    ]
  );

  ExpressionEvaluator newEvaluator(Environment env, [WidgetInstance? newWidgetContext]) {
    return ExpressionEvaluator(env, classes, functions, onBuiltin, newWidgetContext ?? widgetContext, appState);
  }

  debug(String title, [dynamic xp]) {
    if (!debugMe) return;
    if (debugOnly.isNotEmpty && !debugOnly.contains(title)) return;
    if (debugExcept.isNotEmpty && debugExcept.contains(title)) return;
    if (xp != null) {
      print("@@ [$title] ${xp.runtimeType}"); 
    } else {
      print("@@ [$title]");
    }
  }

  @override
  Future<dynamic> visitBinaryExpression(BinaryExpression expr) async {
    debug('visitBinaryExpression', expr);

    final left = await _evaluate(expr.left);
    final right = await _evaluate(expr.right);

    switch (expr.operator.type) {
      case TokenType.plus:
        if (left is String || right is String) {
          return left.toString() + right.toString();
        }
        if (left is num && right is num) {
          return left + right;
        }
        String leftString = left?.toString() ?? 'null';
        String rightString = right?.toString() ?? 'null';
        return leftString + rightString;
      case TokenType.minus:
        _assertNumbers(left, right, expr.operator.lexeme);
        return (left as num) - (right as num);
      case TokenType.multiply:
        _assertNumbers(left, right, expr.operator.lexeme);
        return (left as num) * (right as num);
      case TokenType.divide:
        _assertNumbers(left, right, expr.operator.lexeme);
        return (left as num) / (right as num);
      case TokenType.equals:
        return left == right;
      case TokenType.notEquals:
        return left != right;
      case TokenType.less:
        _assertNumbers(left, right, expr.operator.lexeme);
        return (left as num) < (right as num);
      case TokenType.lessEquals:
        _assertNumbers(left, right, expr.operator.lexeme);
        return (left as num) <= (right as num);
      case TokenType.greater:
        _assertNumbers(left, right, expr.operator.lexeme);
        return (left as num) > (right as num);
      case TokenType.greaterEquals:
        _assertNumbers(left, right, expr.operator.lexeme);
        return (left as num) >= (right as num);
      case TokenType.nullCoalescing:
        return left ?? right;
      default:
        throw Exception("Unknown operator ${expr.operator.lexeme}");
    }
  }

  void _assertNumbers(dynamic left, dynamic right, String operator) {
    if (left is! num || right is! num) {
      throw Exception(
        "Operator '$operator' requires number operands, got ${left.runtimeType} and ${right.runtimeType}"
      );
    }
  }

  @override
  Future<dynamic> visitUnaryExpression(UnaryExpression expr) async {
    debug('visitUnaryExpression', expr);

    final right = await _evaluate(expr.right);

    switch (expr.operator.type) {
      case TokenType.minus:
        return -(right as num);
      case TokenType.not:
        return !right;
      default:
        throw Exception("Unknown operator ${expr.operator.lexeme}");
    }
  }

  @override
  Future<dynamic> visitLiteralExpression(LiteralExpression expr) async {
    debug('visitLiteralExpression', expr);

    return expr.value;
  }

  @override
  Future<dynamic> visitIndexAccess(IndexAccess expr) async {
    debug('visitIndexAccess', expr);

    final object = await _evaluate(expr.object);
    final index = await _evaluate(expr.index);

    if (object is List) {
      if (index is! int) {
        throw Exception("List index must be an integer, got ${index.runtimeType}");
      }
      if (index < 0 || index >= object.length) {
        throw Exception("List index out of bounds: $index (length: ${object.length})");
      }
      return object[index];
    }

    if (object is Map) {
      return object[index];
    }

    throw Exception("Cannot index into type of ${object.runtimeType}");
  }

  @override
  Future<dynamic> visitIndexAssignment(IndexAssignment expr) async {
    debug('visitIndexAssignment', expr);

    final object = await _evaluate(expr.object);
    final index = await _evaluate(expr.index);
    final value = await _evaluate(expr.value);

    if (object is List) {
      if (index is! int) {
        throw Exception("List index must be an integer, got ${index.runtimeType}");
      }
      if (index < 0 || index >= object.length) {
        throw Exception("List index out of bounds: $index (length: ${object.length})");
      }
      object[index] = value;
      return value;
    }

    if (object is Map) {
      object[index] = value;
      return value;
    }

    throw Exception("Cannot assign to index of type ${object.runtimeType}");
  }

  @override
  Future<dynamic> visitListLiteral(ListLiteral expr) async {
    debug('visitListLiteral', expr);

    return await Future.wait(expr.elements.map(_evaluate).toList());
  }

  @override
  Future<dynamic> visitMapLiteral(MapLiteral expr) async {
    debug('visitMapLiteral', expr);

    Map<dynamic, dynamic> map = {};
    for (var entry in expr.entries) {
      var key = await _evaluate(entry.key);
      var value = await _evaluate(entry.value);
      map[key] = value;
    }
    return map;
  }

  @override
  Future<dynamic> visitFWIdgetExpression(FWidgetExpression expr) async {
    debug('visitFWIdgetExpression', expr);

    return expr.widget;
  }

  @override
  Future<dynamic> visitVariableExpression(VariableExpression expr) async {
    debug('visitVariableExpression', expr);

    if (expr.name.type == TokenType.kWidgetState) {
      if (widgetContext?.state == null) {
        throw Exception("Cannot access \$state outside of widget context");
      }

      return widgetContext!.state;
    }

    String varName = expr.name.lexeme;

    if (appState?.hasVar(varName) ?? false) return appState!.getVar(varName);

    final state = widgetContext?.findStateForVariable(varName);
    if (state?.hasStateVar(varName) ?? false) return state!.getStateVar(varName);

    return environment.get(expr.name);
  }

  @override
  Future<String> visitReactStatement(ReactStatement stmt) async {
    debug('visitReactStatement', stmt);

    return stmt.expr.name.lexeme;
  }

  @override
  Future<dynamic> visitAssignExpression(AssignExpression expr) async {
    debug('visitAssignExpression', expr);

    final value = await _evaluate(expr.value);

    String varName = expr.name.lexeme;

    if (appState != null && appState!.hasVar(varName)) {
      appState!.setVar(varName, value);
      return value;
    }
    
    if (widgetContext?.state?.hasStateVar(varName) ?? false) {
      widgetContext!.state!.setStateVar(varName, value);
      return value;
    }

    if (environment.has(varName)) {
      environment.assign(varName, value);
    } else {
      environment.define(varName, value);
    }

    return value;
  }

  @override
  Future<dynamic> visitFFunctionCall(FFunctionCall expr) async {
    debug('visitFFunctionCall', expr);

    final function = functions[expr.name.lexeme];
    if (function == null) {
      throw Exception("Undefined function '${expr.name.lexeme}'");
    }

    return await environment.withScope((functionEnv) async {
      for (var i = 0; i < function.params.length; i++) {
        final param = function.params[i];
        final arg = i < expr.arguments.length ? 
          await _evaluate(expr.arguments[i]) : 
          await _evaluate(param.defaultValue!);
        functionEnv.define(param.name.lexeme, arg);
      }

      final functionEvaluator = newEvaluator(functionEnv, widgetContext);
      return await functionEvaluator._evaluateBlock(function.body);
    });
  }

  @override
  Future<dynamic> visitFMethodCall(FMethodCall expr) async {
    debug('visitFMethodCall', expr);

    final object = await _evaluate(expr.object);
    final method = expr.method.lexeme;
    final arguments = await Future.wait(expr.arguments.map(_evaluate).toList());

    if (object is String) {
      switch (method) {
        case 'toUpperCase':
          return object.toUpperCase();
        case 'toLowerCase':
          return object.toLowerCase();
        case 'trim':
          return object.trim();
        case 'substring':
          if (arguments.length == 1) {
            return object.substring(arguments[0] as int);
          } else if (arguments.length == 2) {
            return object.substring(arguments[0] as int, arguments[1] as int);
          }
          throw Exception("substring() expects 1 or 2 arguments, got ${arguments.length}");
        default:
          throw Exception("Unknown method '$method' for String");
      }
    }

    if (object is List) {
      switch (method) {
        case 'length':
          return object.length;
        case 'first':
          return object.first;
        case 'last':
          return object.last;
        case 'isEmpty':
          return object.isEmpty;
        case 'isNotEmpty':
          return object.isNotEmpty;
        case 'contains':
          if (arguments.isEmpty) {
            throw Exception("contains() requires 1 argument");
          }
          return object.contains(arguments.first);
        case 'push':
          if (arguments.isEmpty) throw Exception("push() requires at least 1 argument");
          if (arguments.length == 1) {
            object.add(arguments.first);
          } else {
            object.addAll(arguments);
          }
          return null;
        case 'pop':
          return object.removeLast();
        default:
          throw Exception("Unknown method '$method' for List");
      }
    }

    if (object is AndromedaBaseWrapper) return await object.callMethod(method, arguments);
    if (object is AndromedaWidgetState) return await object.callMethod(method, arguments);

    throw Exception("Method calls not supported for ${object.runtimeType}");
  }

  @override
  Future<dynamic> visitBlockExpression(BlockExpression expr) async {
    debug('visitBlockExpression', expr);

    return await _evaluateBlock(expr.body);
  }

  @override
  Future<dynamic> visitConditionBlock(ConditionBlock expr) async {
    debug('visitConditionBlock', expr);

    return await _evaluateBlock(expr);
  }

  @override
  Future<dynamic> visitStateBlock(StateBlock expr) async {
    debug('visitStateBlock', expr);

    return await evaluateStateBlock(expr);
  }

  @override
  Future<dynamic> visitReactStateBlock(ReactStateBlock expr) async {
    debug('visitStateBlock', expr);

    return await evaluateStateBlock(expr);
  }

  @override
  Future<dynamic> visitReactAppBlock(ReactAppBlock expr) async {
    debug('visitStateBlock', expr);

    return await evaluateReactBlock(expr);
  }

  @override
  Future<dynamic> visitReactParentBlock(ReactParentBlock expr) async {
    debug('visitStateBlock', expr);

    return await evaluateReactBlock(expr);
  }

  @override
  Future<dynamic> visitLoadingBlock(LoadingBlock expr) async {
    debug('visitLoadingBlock', expr);

    return await evaluateRenderBlock(expr);
  }

  @override
  Future<dynamic> visitAnimationBlock(AnimationBlock expr) async {
    debug('visitAnimationBlock', expr);

    return await evaluateRenderBlock(expr);
  }

  @override
  Future<dynamic> visitConditionRenderBlock(ConditionRenderBlock expr) async {
    debug('visitConditionRenderBlock', expr);

    return await evaluateRenderBlock(expr);
  }

  @override
  Future<dynamic> visitPropsBlockExpression(PropsBlockExpression expr) async {
    debug('visitPropsBlockExpression', expr);

    return await evaluatePropsBlock(expr.block);
  }

  @override
  Future<dynamic> visitRenderBlock(RenderBlock expr) async {
    debug('visitRenderBlock', expr);

    return await evaluateRenderBlock(expr);
  }

  @override
  Future<dynamic> visitBuiltinCallExpression(BuiltinCallExpression expr) async {
    debug('visitBuiltinCallExpression', expr);

    final args = await Future.wait(expr.arguments.map(_evaluate).toList());
    return await onBuiltin(expr.name.lexeme, args);
  }

  @override
  Future<dynamic> visitGroupingExpression(GroupingExpression expr) async {
    debug('visitGroupingExpression', expr);

    return await _evaluate(expr.expression);
  }

  @override
  Future<dynamic> visitExpressionStatement(ExpressionStatement stmt) async {
    debug('visitExpressionStatement', stmt);

    return await _evaluate(stmt.expression);
  }

  @override
  Future<dynamic> visitVariableDeclaration(VariableDeclaration stmt) async {
    debug('visitVariableDeclaration', stmt);

    String varName = stmt.name.lexeme;
    dynamic value = await _evaluate(stmt.initializer);

    if (appState?.hasVar(varName) ?? false) {
      appState!.setVar(varName, value);
      return value;
    }

    final state = widgetContext?.findStateForVariable(varName);
    if (state?.hasStateVar(varName) ?? false) {
      state!.setStateVar(varName, value);
      return value;
    }

    environment.define(stmt.name.lexeme, value);

    return value;
  }

  @override
  Future<dynamic> visitAssignmentStatement(AssignmentStatement stmt) async {
    debug('visitAssignmentStatement', stmt);

    dynamic value = await _evaluate(stmt.value);
    environment.assign(stmt.name.lexeme, value);
    return value;
  }

  @override
  Future<dynamic> visitBlockStatement(BlockStatement stmt) async {
    debug('visitBlockStatement', stmt);

    dynamic lastValue;
    for (var statement in stmt.block.statements) {
      lastValue = await _evaluate(statement);
    }
    return lastValue;
  }

  @override
  Future<dynamic> visitIfStatement(IfStatement stmt) async {
    debug('visitIfStatement', stmt);

    return await environment.withScope((ifEnv) async {
      if ((await _evaluate(stmt.condition)) as bool) {
        return await _evaluateBlock(stmt.thenBranch);
      }

      for (var elifBranch in stmt.elifBranches) {
        if ((await _evaluate(elifBranch.condition)) as bool) {
          return await _evaluateBlock(elifBranch.block);
        }
      }

      if (stmt.elseBranch != null) {
        return await _evaluateBlock(stmt.elseBranch!);
      }

      return null;
    });
  }

  @override
  Future<dynamic> visitForEachStatement(ForEachStatement stmt) async {
    debug('visitForEachStatement', stmt);

    List<dynamic> results = [];
    dynamic iterable = await _evaluate(stmt.iterable);

    for (var item in iterable) {
      environment.define(stmt.variable.lexeme, item);
      dynamic result = await _evaluate(stmt);
      results.addAll(result is List ? result : [result]);
    }

    return results;
  }

  @override
  Future<dynamic> visitForLoopStatement(ForLoopStatement stmt) async {
    debug('visitForLoopStatement', stmt);

    List<dynamic> results = [];
    
    final varName = stmt.variable.lexeme;
    final fromValue = await _evaluate(stmt.from) as num;
    final toValue = await _evaluate(stmt.to) as num;
    final stepValue = stmt.step != null ? await _evaluate(stmt.step!) as num : 1;

    return await environment.withScope((loopEnv) async {
      loopEnv.define(varName, fromValue);

      while (true) {
        final currentValue = loopEnv.get(stmt.variable) as num;
        
        if (stmt.inclusive) {
          if (stepValue > 0 && currentValue > toValue) break;
          if (stepValue < 0 && currentValue < toValue) break;
        } else {
          if (stepValue > 0 && currentValue >= toValue) break;
          if (stepValue < 0 && currentValue <= toValue) break;
        }

        dynamic result = await _evaluateBlock(stmt.body);
        result = await evaluateWidgetUpdate(result);
        results.addAll(result is List ? result : [result]);

        final oldValue = loopEnv.get(stmt.variable) as num;
        loopEnv.assign(varName, oldValue + stepValue);
      }

      return results;
    });
  }

  @override
  Future<dynamic> visitStateVariableDeclaration(StateVariableDeclaration stmt) async {
    debug('visitStateVariableDeclaration', stmt);

    String varName = stmt.name.lexeme;
    dynamic value = await _evaluate(stmt.initializer);

    if (widgetContext?.state != null) {
      widgetContext!.state!.setStateVar(varName, value);
    }

    environment.define(varName, value);
    return null;
  }

  @override
  Future<dynamic> visitPropStatement(PropStatement stmt) async {
    debug('visitPropStatement', stmt);

    return {stmt.property: await _evaluate(stmt.value)};
  }

  @override
  Future<dynamic> visitRenderWidgetStatement(RenderWidgetStatement stmt) async {
    debug('visitRenderWidgetStatement', stmt);

    return stmt.widget;
  }

  @override
  Future<dynamic> visitClassInstantiation(ClassInstantiation expr) async {
    debug('visitClassInstantiation', expr);

    final klass = classes[expr.name.lexeme];
    if (klass == null) {
      throw Exception("Undefined class '${expr.name.lexeme}'");
    }

    return await environment.withScope((instanceEnv) async {
      final instance = ClassInstance(klass, instanceEnv);

      if (klass.superclass != null) {
        // final parentClass = environment.get(klass.superclass!) as FClass;
        final parentInstance = await visitClassInstantiation(
          ClassInstantiation(
            klass.superclass!,
            []
          )
        ) as ClassInstance;

        instance.parent = parentInstance;
        instanceEnv.define('\$parent', parentInstance);
      }

      instanceEnv.define('\$this', instance);

      for (final member in klass.members) {
        if (member is ClassProperty) {
          final value = await _evaluate(member.initializer);
          instanceEnv.define(member.name.lexeme, value);
        }
      }

      // Evaluate arguments and bind to parameters
      final constructor = klass.getMethod('_init');
      if (constructor != null) {
        for (var i = 0; i < constructor.parameters.length; i++) {
          final param = constructor.parameters[i];
          final arg = i < expr.arguments.length ? await _evaluate(expr.arguments[i]) : await _evaluate(param.defaultValue);
          instanceEnv.define(param.name.lexeme, arg);
        }
      }

      // Create new evaluator for class scope
      final constructorEvaluator = newEvaluator(instanceEnv, widgetContext);

      // Evaluate constructor body
      if (constructor != null) {
        await constructorEvaluator._evaluateBlock(constructor.body);
      }

      return instance;
    });
  }

  @override
  Future<dynamic> visitClassDeclaration(ClassDeclaration stmt) async {
    debug('visitClassDeclaration', stmt);

    final superclass = stmt.superclass != null ? environment.get(stmt.superclass!) : null;

    return await environment.withScope((classEnv) async {
      for (final member in stmt.members) {
        if (member is ClassProperty) {
          final value = await _evaluate(member.initializer);
          classEnv.define(member.name.lexeme, value);
        } else if (member is ClassMethod) {
          final method = FFunction(member.name, member.parameters, member.body);
          classEnv.define(member.name.lexeme, method);
        }
      }

      final klass = FClass(stmt.name, superclass, stmt.members, classEnv);
      environment.define(stmt.name.lexeme, klass);

      // Call the constructor if it exists
      await _callConstructor(klass);

      return null;
    });
  }

  Future<void> _callConstructor(FClass klass) async {
    FClass? currentClass = klass;
    while (currentClass != null) {
      try {
        final constructor = currentClass.getMethod('_init');
        if (constructor == null) return;
        final constructorEnv = Environment(currentClass.environment);
        final constructorEvaluator = newEvaluator(constructorEnv, widgetContext);
        await constructorEvaluator._evaluateBlock(constructor.body);
        break;
      } catch (e) {
        if (currentClass.superclass != null) {
          currentClass = environment.get(currentClass.superclass!) as FClass;
        } else {
          currentClass = null;
        }
      }
    }
  }

  @override
  Future<dynamic> visitClassPropertyAccess(ClassPropertyAccess expr) async {
    debug('visitClassPropertyAccess', expr);

    final object = await _evaluate(expr.object);
    
    if (object is ClassInstance) return await object.getProperty(expr.property.lexeme);
    if (object is AndromedaWidgetState) return await object.getProperty(expr.property.lexeme);

    throw Exception("Property access '${expr.property.lexeme}' not supported for ${object.runtimeType}");
  }

  @override
  Future<dynamic> visitClassPropertyAssignment(ClassPropertyAssignment expr) async {
    debug('visitClassPropertyAssignment', expr);

    final object = await _evaluate(expr.object);
    final value = await _evaluate(expr.value);

    if (object is ClassInstance) {
      await object.setProperty(expr.property.lexeme, value);
      return value;
    }

    if (object is AndromedaWidgetState) {
      await object.setProperty(expr.property.lexeme, value);
      return value;
    }

    throw Exception("Property assignment '${expr.property.lexeme}' not supported for ${object.runtimeType}");
  }

  @override
  Future<dynamic> visitClassMethodCall(ClassMethodCall expr) async {
    debug('visitClassMethodCall', expr);

    final object = await _evaluate(expr.object);

    if (object is! ClassInstance) {
      return await visitFMethodCall(FMethodCall(expr.object, expr.method, expr.arguments));
    }

    final method = object.getMethod(expr.method.lexeme);

    if (method == null) {
      throw Exception("Undefined method '${expr.method.lexeme}' for class ${object.getName()}");
    }

    final arguments = await Future.wait(expr.arguments.map(_evaluate).toList());

    final methodEnv = Environment(object.environment);
    methodEnv.define('\$this', object);

    if (object.parent != null) {
      methodEnv.define('\$parent', object.parent);
    }

    for (var i = 0; i < method.parameters.length; i++) {
      final param = method.parameters[i];
      final arg = i < arguments.length ? arguments[i] : await _evaluate(param.defaultValue);
      methodEnv.define(param.name.lexeme, arg);
    }

    final methodEvaluator = newEvaluator(methodEnv, widgetContext);
    return await methodEvaluator._evaluateBlock(method.body);
  }

  @override
  Future<dynamic> visitCallExpression(CallExpression expr) async {
    debug('visitCallExpression', expr);

    final callee = await _evaluate(expr.callee);
    if (callee is! Function) {
      throw Exception("Can only call functions and classes");
    }

    final a = await Future.wait(expr.arguments.map(_evaluate).toList());

    return await callee(a);
  }

  @override
  Future<dynamic> visitFunctionReferenceExpression(FunctionReferenceExpression expr) async {
    debug('visitFunctionReferenceExpression', expr);

    final function = functions[expr.name.lexeme];
    if (function == null) {
      throw Exception("Undefined function '${expr.name.lexeme}'");
    }

    return await environment.withScope((functionEnv) async {
      if (function.params.isEmpty) {
        return () async {
          widgetContext?.state?.beginUpdate();

          dynamic result;
          try {
            result = await _evaluateBlock(function.body);
          } catch (e) {
            rethrow;
          } finally {
            widgetContext?.state?.endUpdate();
          }

          return result;
        };
      }

      return (List<dynamic> args) async {
        final functionEvaluator = newEvaluator(functionEnv, widgetContext);

        for (var i = 0; i < function.params.length; i++) {
          final param = function.params[i];
          final arg = i < args.length ? args[i] : await _evaluate(param.defaultValue);
          functionEnv.define(param.name.lexeme, arg);
        }

        widgetContext?.state?.beginUpdate();

        dynamic result;
        try {
          result = await functionEvaluator._evaluateBlock(function.body);
        } catch (e) {
          rethrow;
        } finally {
          widgetContext?.state?.endUpdate();
        }

        return result;
      };
    });
  }

  @override
  Future<dynamic> visitAnonymousFunction(AnonymousFunction expr) async {
    debug('visitAnonymousFunction', expr);

    return await environment.withScope((functionEnv) async {
      if (expr.parameters.isEmpty) {
        return () async {
          widgetContext?.state?.beginUpdate();

          final functionEvaluator = newEvaluator(functionEnv, widgetContext);

          dynamic result;
          try {
            result = await functionEvaluator._evaluateBlock(expr.body);
          } catch (e) {
            rethrow;
          } finally {
            widgetContext?.state?.endUpdate();
          }

          return result;
        };
      }

      return (List<dynamic> args) async {
        for (var i = 0; i < expr.parameters.length; i++) {
          final param = expr.parameters[i];
          final arg = i < args.length ? args[i] : await _evaluate(param.defaultValue);
          functionEnv.define(param.name.lexeme, arg);
        }

        final functionEvaluator = newEvaluator(functionEnv, widgetContext);

        widgetContext?.state?.beginUpdate();

        dynamic result;
        try {
          result = await functionEvaluator._evaluateBlock(expr.body);
        } catch (e) {
          rethrow;
        } finally {
          widgetContext?.state?.endUpdate();
        }

        return result;
      };
    });
  }

  Future<Map<String, dynamic>> evaluateConfigBlock(ConfigBlock block) async {
    debug('evaluateConfigBlock', block);

    return await evaluatePropsBlock(PropsBlock(block.statements));
  }

  Future<Map<String, dynamic>> evaluatePropsBlock(BasePropsBlock block) async {
    debug('evaluatePropsBlock', block);

    Map<String, dynamic> props = {};
    
    for (var stmt in block.statements) {
      if (stmt is PropStatement) {
        props[stmt.property] = await _evaluate(stmt.value);
      } else if (stmt is IfStatement) {
        if ((await _evaluate(stmt.condition)) as bool) {
          for (var s in stmt.thenBranch.statements) {
            if (s is PropStatement) {
              props[s.property] = await _evaluate(s.value);
            }
          }
        } else if (stmt.elseBranch != null) {
          for (var s in stmt.elseBranch!.statements) {
            if (s is PropStatement) {
              props[s.property] = await _evaluate(s.value);
            }
          }
        }
      }
    }
    
    return props;
  }

  Future<bool> evaluateConditionBlock(ConditionBlock block) async {
    debug('evaluateConditionBlock', block);

    dynamic result = await _evaluateBlock(block);

    if (result == null) return true;
    if (result is bool) return result;
    if (result is num) return result != 0;
    if (result is String) return result.isNotEmpty;
    if (result is List) return result.isNotEmpty;
    if (result is Map) return result.isNotEmpty;

    // TODO: maybe add method onCondition() to the wrappers
    throw Exception("${result.runtimeType} cannot be used as a condition");
  }

  Future<dynamic> evaluateConditionRenderBlock(ConditionRenderBlock block) async {
    debug('evaluateConditionRenderBlock', block);

    return await _evaluateBlock(block);
  }

  Future<Map<String, dynamic>> evaluateStateBlock(BaseStateBlock block) async {
    debug('evaluateStateBlock', block);

    Map<String, dynamic> state = {};
    for (var stmt in block.statements) {
      if (stmt is StateVariableDeclaration) {
        state[stmt.name.lexeme] = await _evaluate(stmt.initializer);
      }
    }
    return state;
  }

  Future<Map<String, dynamic>> evaluateEventBlock(EventBlock block) async {
    debug('evaluateEventBlock', block);

    Map<String, dynamic> handlers = {};
    for (var entry in block.handlers.entries) {
      final result = await _evaluate(entry.value);
      if (result is Function) handlers[entry.key] = result;
    }
    return handlers;
  }

  Future<List<String>> evaluateReactBlock(BaseReactBlock block) async {
    debug('evaluateReactBlock', block);

    List<String> signals = [];
    for (var stmt in block.statements) {
      if (stmt is ReactStatement) {
        signals.add(stmt.expr.name.lexeme);
      }
    }
    return signals;
  }
  
  Future<dynamic> _evaluateBlock(Block block) async {
    debug('evaluateBlock', block);

    return await environment.withScope((blockEnv) async {
      widgetContext?.state?.beginUpdate();
      
      try {
        dynamic lastValue;
        for (final stmt in block.statements) {
          lastValue = await _evaluate(stmt);
        }
        return lastValue;
      } catch (e) {
        rethrow;
      } finally {
        widgetContext?.state?.endUpdate();
      }
    });
  }

  Future<List<AndromedaWidget>> evaluateRenderBlock(BaseRenderBlock block) async {
    debug('evaluateRenderBlock', block);

    return await environment.withScope((renderEnv) async {
      List<AndromedaWidget> widgets = [];

      for (var stmt in block.statements) {
        dynamic result = await _evaluate(stmt);
        
        if (result is List) {
          for (var item in result) {
            if (item is FWidget) {
              widgets.add(AndromedaConverter.widget(
                fwidget: item,
                parentInstance: widgetContext!,
                environment: environment.current,
                evaluator: this,
              ));
            }
          }
        } else if (result is FWidget) {
          widgets.add(AndromedaConverter.widget(
            fwidget: result,
            parentInstance: widgetContext!,
            environment: environment.current,
            evaluator: this,
          ));
        }
      }

      return widgets;
    });
  }

  Future<dynamic> evaluateWidgetUpdate(dynamic result) async {
    debug('evaluateWidgetUpdate', result);

    if (result is FWidget) {
      final evaluatedProps = await evaluatePropsBlock(result.props);

      final newProps = evaluatedProps.entries.map((entry) {
        return PropStatement(entry.key, LiteralExpression(entry.value));
      }).toList();

      return result.copyWith(
        propsBlock: PropsBlock(newProps)
      );
    }

    if (result is List) {
      return await Future.wait(result.map(evaluateWidgetUpdate).toList());
    }

    return result;
  }

  Future<dynamic> _evaluate(dynamic expr) async {
    if (expr is Statement) return await expr.accept(this);
    if (expr is Expression) return await expr.accept(this);
    return expr;
  }
}