import 'token.dart';
import '../renderer/environment.dart';

abstract class Expr {
  // Visitor pattern
}

class Binary extends Expr {
  final Expr left;
  final Token operator;
  final Expr right;

  Binary(this.left, this.operator, this.right);
}

class Variable extends Expr {
  final Token name;

  Variable(this.name);
}

class Parameter {
  final Token name;
  final Expression? defaultValue;

  Parameter(this.name, this.defaultValue);

  @override
  String toString() {
    if (defaultValue != null) {
      return '${name.lexeme} = ${defaultValue.toString()}';
    }

    return name.lexeme;
  }
}

abstract class ExpressionVisitor<T> {
  Future<T> visitBinaryExpression(BinaryExpression expr);
  Future<T> visitUnaryExpression(UnaryExpression expr);
  Future<T> visitLiteralExpression(LiteralExpression expr);
  Future<T> visitListLiteral(ListLiteral expr);
  Future<T> visitMapLiteral(MapLiteral expr);
  Future<T> visitIndexAccess(IndexAccess expr);
  Future<T> visitIndexAssignment(IndexAssignment expr);
  Future<T> visitVariableExpression(VariableExpression expr);
  Future<T> visitAssignExpression(AssignExpression expr);
  Future<T> visitGroupingExpression(GroupingExpression expr);
  Future<T> visitBlockExpression(BlockExpression expr);
  Future<T> visitPropBlockExpression(PropBlockExpression expr);
  Future<T> visitBuiltinCallExpression(BuiltinCallExpression expr);
  Future<T> visitFFunctionCall(FFunctionCall expr);
  Future<T> visitFMethodCall(FMethodCall expr);
  Future<T> visitClassMethodCall(ClassMethodCall expr);
  Future<T> visitClassPropertyAccess(ClassPropertyAccess expr);
  Future<T> visitClassPropertyAssignment(ClassPropertyAssignment expr);
  Future<T> visitClassInstantiation(ClassInstantiation stmt);
  Future<T> visitFWIdgetExpression(FWidgetExpression stmt);
  Future<T> visitAnonymousFunction(AnonymousFunction expr);
  Future<T> visitCallExpression(CallExpression expr);
  Future<T> visitFunctionReferenceExpression(FunctionReferenceExpression expr);
}

abstract class Expression {
  // Visitor pattern
  Future<T> accept<T>(ExpressionVisitor<T> visitor);
}

class FunctionReferenceExpression extends Expression {
  final Token name;

  FunctionReferenceExpression(this.name);

  @override
  Future<T> accept<T>(ExpressionVisitor<T> visitor) => visitor.visitFunctionReferenceExpression(this);

  @override
  String toString() => name.lexeme;
}

class BinaryExpression extends Expression {
  final Expression left;
  final Token operator;
  final Expression right;

  BinaryExpression(this.left, this.operator, this.right);

  @override
  Future<T> accept<T>(ExpressionVisitor<T> visitor) => visitor.visitBinaryExpression(this);

  @override
  String toString() => '($left ${operator.lexeme} $right)';
}

class UnaryExpression extends Expression {
  final Token operator;
  final Expression right;

  UnaryExpression(this.operator, this.right);

  @override
  Future<T> accept<T>(ExpressionVisitor<T> visitor) => visitor.visitUnaryExpression(this);

  @override
  String toString() => '(${operator.lexeme} $right)';
}

class LiteralExpression extends Expression {
  final Object? value; // null, bool, int, double, String

  LiteralExpression(this.value);

  @override
  Future<T> accept<T>(ExpressionVisitor<T> visitor) => visitor.visitLiteralExpression(this);

  @override
  String toString() => value is String ? '"$value"' : value.toString();
}

class ListLiteral extends Expression {
  final List<Expression> elements;

  ListLiteral(this.elements);

  @override
  Future<T> accept<T>(ExpressionVisitor<T> visitor) => visitor.visitListLiteral(this);

  @override
  String toString() => '[${elements.join(", ")}]';
}

class MapLiteral extends Expression {
  final List<FMapEntry> entries;

  MapLiteral(this.entries);

  @override
  Future<T> accept<T>(ExpressionVisitor<T> visitor) => visitor.visitMapLiteral(this);

  @override
  String toString() => '{${entries.join(", ")}}';
}

class IndexAccess extends Expression {
  final Expression object;
  final Expression index;

  IndexAccess(this.object, this.index);

  @override
  Future<T> accept<T>(ExpressionVisitor<T> visitor) => visitor.visitIndexAccess(this);

  @override
  String toString() => '$object[$index]';
}

class IndexAssignment extends Expression {
  final Expression object;
  final Expression index;
  final Expression value;

  IndexAssignment(this.object, this.index, this.value);

  @override
  Future<T> accept<T>(ExpressionVisitor<T> visitor) => visitor.visitIndexAssignment(this);

  @override
  String toString() => '$object[$index] = $value';
}

class FMapEntry {
  final Expression key;
  final Expression value;

  FMapEntry(this.key, this.value);

  @override
  String toString() => '$key: $value';
}

class VariableExpression extends Expression {
  final Token name;

  VariableExpression(this.name);

  @override
  Future<T> accept<T>(ExpressionVisitor<T> visitor) => visitor.visitVariableExpression(this);

  @override
  String toString() => name.lexeme;
}

class AssignExpression extends Expression {
  final Token name;
  final Expression value;

  AssignExpression(this.name, this.value);

  @override
  Future<T> accept<T>(ExpressionVisitor<T> visitor) => visitor.visitAssignExpression(this);

  @override
  String toString() => '($name = $value)';
}

class GroupingExpression extends Expression {
  final Expression expression;

  GroupingExpression(this.expression);

  @override
  Future<T> accept<T>(ExpressionVisitor<T> visitor) => visitor.visitGroupingExpression(this);

  @override
  String toString() => '($expression)';
}

abstract class StatementVisitor<T> {
  Future<T> visitExpressionStatement(ExpressionStatement stmt);
  Future<T> visitVariableDeclaration(VariableDeclaration stmt);
  Future<T> visitAssignmentStatement(AssignmentStatement stmt);
  Future<T> visitBlockStatement(BlockStatement stmt);
  Future<T> visitIfStatement(IfStatement stmt);
  Future<T> visitForEachStatement(ForEachStatement stmt);
  Future<T> visitForLoopStatement(ForLoopStatement stmt);
  Future<T> visitStateBlock(StateBlock stmt);
  Future<T> visitReactStateBlock(ReactStateBlock stmt);
  Future<T> visitStateVariableDeclaration(StateVariableDeclaration stmt);
  Future<T> visitPropStatement(PropStatement stmt);
  Future<T> visitRenderWidgetStatement(RenderWidgetStatement stmt);
  Future<T> visitClassDeclaration(ClassDeclaration stmt);
  Future<T> visitLoadingBlock(LoadingBlock stmt);
  Future<T> visitAnimationBlock(AnimationBlock stmt);
  Future<T> visitRenderBlock(RenderBlock stmt);
  Future<T> visitReactStatement(ReactStatement stmt);
  Future<T> visitConditionBlock(ConditionBlock stmt);
  Future<T> visitConditionRenderBlock(ConditionRenderBlock stmt);
  Future<T> visitReactAppBlock(ReactAppBlock stmt);
  Future<T> visitReactParentBlock(ReactParentBlock stmt);
}

abstract class Statement {
  // Visitor pattern
  Future<T> accept<T>(StatementVisitor<T> visitor);
}

class ExpressionStatement extends Statement {
  final Expression expression;

  ExpressionStatement(this.expression);

  @override
  Future<T> accept<T>(StatementVisitor<T> visitor) => visitor.visitExpressionStatement(this);

  @override
  String toString() => expression.toString();
}

class VariableDeclaration extends Statement {
  final Token name;
  final Expression? initializer;

  VariableDeclaration(this.name, this.initializer);

  @override
  Future<T> accept<T>(StatementVisitor<T> visitor) => visitor.visitVariableDeclaration(this);

  @override
  String toString() => initializer != null ? '$name = $initializer' : '$name';
}

class AssignmentStatement extends Statement {
  final Token name;
  final Expression value;

  AssignmentStatement(this.name, this.value);

  @override
  Future<T> accept<T>(StatementVisitor<T> visitor) => visitor.visitAssignmentStatement(this);

  @override
  String toString() => '$name = $value';
}

class Block {
  List<Statement> statements;

  Block(this.statements);

  @override
  String toString() {
    final stmtStr = statements.map((s) => s.toString()).join('\n');
    return '{\n$stmtStr\n}';
  }
}

class BasePropBlock extends Block {
  final String type;

  BasePropBlock(super.statements, [this.type = ""]);

  @override
  String toString() {
    final stmtStr = statements.map((s) => s.toString()).join('\n');
    return '@$type {\n$stmtStr\n}';
  }
}

class StyleBlock extends BasePropBlock {
  StyleBlock(List<Statement> statements) : super(statements, 'style');
}

class PropBlock extends BasePropBlock {
  PropBlock(List<Statement> statements) : super(statements, 'prop');
}

class BaseRenderBlock extends Block {
  final String type;

  BaseRenderBlock(super.statements, [this.type = ""]);

  @override
  String toString() {
    final stmtStr = statements.map((s) => s.toString()).join('\n');
    return '@$type {\n$stmtStr\n}';
  }
}

class LoadingBlock extends BaseRenderBlock {
  LoadingBlock(List<Statement> statements) : super(statements, 'loading');

  Future<T> accept<T>(StatementVisitor<T> visitor) => visitor.visitLoadingBlock(this);
}

class AnimationBlock extends BaseRenderBlock {
  AnimationBlock(List<Statement> statements) : super(statements, 'animation');

  Future<T> accept<T>(StatementVisitor<T> visitor) => visitor.visitAnimationBlock(this);
}

class RenderBlock extends BaseRenderBlock {
  RenderBlock(List<Statement> statements) : super(statements, 'render');

  Future<T> accept<T>(StatementVisitor<T> visitor) => visitor.visitRenderBlock(this);
}

class ConditionRenderBlock extends BaseRenderBlock {
  ConditionRenderBlock(List<Statement> statements) : super(statements, 'conditionRender');

  Future<T> accept<T>(StatementVisitor<T> visitor) => visitor.visitConditionRenderBlock(this);
}

class BaseStateBlock extends Block {
  final String type;

  BaseStateBlock(super.statements, [this.type = ""]);

  @override
  String toString() {
    final stmtStr = statements.map((s) => s.toString()).join('\n');
    return '@$type {\n$stmtStr\n}';
  }
}

class StateBlock extends BaseStateBlock {
  StateBlock(List<Statement> statements) : super(statements, 'state');

  Future<T> accept<T>(StatementVisitor<T> visitor) => visitor.visitStateBlock(this);
}

class ReactStateBlock extends BaseStateBlock {
  ReactStateBlock(List<Statement> statements) : super(statements, 'reactState');

  Future<T> accept<T>(StatementVisitor<T> visitor) => visitor.visitReactStateBlock(this);
}

class BlockStatement extends Statement {
  final Block block;

  BlockStatement(this.block);

  @override
  Future<T> accept<T>(StatementVisitor<T> visitor) => visitor.visitBlockStatement(this);

  @override
  String toString() {
    return block.toString();
  }
}

class IfStatement extends Statement {
  final Expression condition;
  final Block thenBranch;
  final List<ElifBranch> elifBranches;
  final Block? elseBranch;

  IfStatement(this.condition, this.thenBranch, this.elifBranches, this.elseBranch);

  @override
  Future<T> accept<T>(StatementVisitor<T> visitor) => visitor.visitIfStatement(this);

  @override
  String toString() {
    final elifs = elifBranches.map((e) => 'elif ${e.condition} ${e.block}').join(' ');
    final elseStr = elseBranch != null ? ' else $elseBranch' : '';
    return 'if ($condition) $thenBranch$elifs$elseStr';
  }
}

class ElifBranch {
  final Expression condition;
  final Block block;

  ElifBranch(this.condition, this.block);

  @override
  String toString() => 'elif $condition $block';
}

class ForEachStatement extends Statement {
  final Token variable;
  final Expression iterable;
  final Statement body;

  ForEachStatement(this.variable, this.iterable, this.body);

  @override
  Future<T> accept<T>(StatementVisitor<T> visitor) => visitor.visitForEachStatement(this);

  @override
  String toString() => 'for ($variable in $iterable) $body';
}

class ForLoopStatement extends Statement {
  final Token variable;
  final Expression from;
  final Expression to;
  final Expression? step;
  final bool inclusive;
  final Block body;

  ForLoopStatement(
    this.variable,
    this.from,
    this.to,
    this.step,
    this.inclusive,
    this.body
  );

  @override
  Future<T> accept<T>(StatementVisitor<T> visitor) => visitor.visitForLoopStatement(this);

  @override
  String toString() => 'for ($variable from $from to $to${step != null ? ' step $step' : ''}) $body';
}

abstract class TopLevel {
  // Visitor pattern
}

class FApp extends TopLevel {
  final Token name;
  final ConfigBlock? configBlock;
  final StateBlock? stateBlock;
  final PagesBlock? pagesBlock;

  FApp(this.name, this.configBlock, this.stateBlock, this.pagesBlock);

  ConfigBlock get config => configBlock ?? ConfigBlock([]);
  StateBlock get state => stateBlock ?? StateBlock([]);
  PagesBlock get pages => pagesBlock ?? PagesBlock([]);

  @override
  String toString() {
    return 'App {\n$configBlock\n$pagesBlock\n}';
  }
}

class FAppBlock extends Block {
  final Map<String, Block> sections; // 'config', 'pages', ...

  FAppBlock(this.sections) : super([]);

  @override
  String toString() {
    final sectionStr = sections.entries.map((e) => '@${e.key} {\n ${e.value.toString()}\n}').join('\n');
    return '{\n$sectionStr\n}';
  }
}

class ConfigBlock extends BasePropBlock {
  ConfigBlock(super.statements);

  @override
  String toString() {
    final stmtStr = statements.map((s) => s.toString()).join('\n');
    return '@config {\n$stmtStr\n}';
  }
}

class PagesBlock extends Block {
  List<FPage> pages;

  PagesBlock(this.pages) : super([]);

  @override
  String toString() {
    final pagesStr = pages.map((s) => s.toString()).join('\n');
    return '@pages {\n$pagesStr\n}';
  }
}

class ConditionBlock extends Block {
  ConditionBlock(super.statements);

  Future<T> accept<T>(StatementVisitor<T> visitor) => visitor.visitConditionBlock(this);

  @override
  String toString() {
    final stmtStr = statements.map((s) => s.toString()).join('\n');
    return '@condition {\n$stmtStr\n}';
  }
}

class FPage extends TopLevel {
  final Token name;
  final List<Parameter> params;
  StateBlock? stateBlock;
  StyleBlock? styleBlock;
  RenderBlock? renderBlock;
  EventBlock? eventBlock;

  FPage(this.name, this.params, this.stateBlock, this.styleBlock, this.renderBlock, this.eventBlock);

  List<Statement>? get stateStatements => stateBlock?.statements;
  List<Statement>? get styleStatements => styleBlock?.statements;
  List<Statement>? get renderStatements => renderBlock?.statements;
  List<Statement>? get eventStatements => eventBlock?.statements;

  StateBlock get state => stateBlock ?? StateBlock([]);
  StyleBlock get style => styleBlock ?? StyleBlock([]);
  RenderBlock get render => renderBlock ?? RenderBlock([]);
  EventBlock get event => eventBlock ?? EventBlock({});

  @override
  String toString() {
    final paramStr = params.isEmpty ? '' : '(${params.join(', ')})';
    List<Block?> blocks = [stateBlock, styleBlock, renderBlock];
    final blockStr = blocks.map((b) => b != null ? '$b' : '').join('\n');
    return '${name.lexeme}$paramStr {\n$blockStr\n}';
  }
}

class FClass extends TopLevel {
  final Token name;
  final Token? superclass;
  final List<ClassMember> members;
  final Environment? environment;

  FClass(this.name, this.superclass, this.members, [this.environment]);

  ClassProperty? getProperty(String name) {
    for (final member in members) {
      if (member is ClassProperty && member.name.lexeme == name) {
        return member;
      }
    }
    return null;
  }

  ClassMethod? getMethod(String name) {
    for (final member in members) {
      if (member is ClassMethod && member.name.lexeme == name) {
        return member;
      }
    }
    return null;
  }

  @override
  String toString() {
    final superStr = superclass != null ? ' extends ${superclass!.lexeme}' : '';
    final memberStr = members.map((m) => m.toString()).join('\n');
    return 'class ${name.lexeme}$superStr {\n$memberStr\n}';
  }
}

abstract class ClassMember {}

class ClassProperty extends ClassMember {
  final Token name;
  final Expression? initializer;

  ClassProperty(this.name, this.initializer);

  @override
  String toString() => initializer != null ? '${name.lexeme} = $initializer' : '${name.lexeme}';
}

class ClassMethod extends ClassMember {
  final Token name;
  final List<Parameter> parameters;
  final Block body;

  ClassMethod(this.name, this.parameters, this.body);

  @override
  String toString() {
    final paramStr = parameters.map((p) => p.toString()).join(', ');
    return 'fn ${name.lexeme}($paramStr) {\n$body\n}';
  }
}

class StateVariableDeclaration extends Statement {
  final Token name;
  final Expression? initializer;

  StateVariableDeclaration(this.name, this.initializer);

  @override
  Future<T> accept<T>(StatementVisitor<T> visitor) => visitor.visitStateVariableDeclaration(this);

  @override
  String toString() => '$name = $initializer';
}

class PropStatement extends Statement {
  final String property;
  final Expression value;

  PropStatement(this.property, this.value);

  @override
  Future<T> accept<T>(StatementVisitor<T> visitor) => visitor.visitPropStatement(this);

  @override
  String toString() => '$property: $value';
}

class RenderWidgetStatement extends Statement {
  final FWidget widget;

  RenderWidgetStatement(this.widget);

  @override
  Future<T> accept<T>(StatementVisitor<T> visitor) => visitor.visitRenderWidgetStatement(this);

  @override
  String toString() => widget.toString();
}

class EventBlock extends Block {
  final Map<String, Expression> handlers;

  EventBlock(this.handlers): super([]);

  @override
  String toString() {
    final handlerStr = handlers.entries.map((e) => '${e.key}: ${e.value}').join('\n');
    return '{\n$handlerStr\n}';
  }
}

class ReactStatement extends Statement {
  final VariableExpression expr;

  ReactStatement(this.expr);

  @override
  Future<T> accept<T>(StatementVisitor<T> visitor) => visitor.visitReactStatement(this);

  @override
  String toString() => expr.toString();
}

class BaseReactBlock extends Block {
  final String type;

  BaseReactBlock(super.statements, [this.type = ""]);

  @override
  String toString() {
    final stmtStr = statements.map((s) => s.toString()).join('\n');
    return '@$type {\n$stmtStr\n}';
  }
}

class ReactAppBlock extends BaseReactBlock {
  ReactAppBlock(List<Statement> statements) : super(statements, 'react');

  Future<T> accept<T>(StatementVisitor<T> visitor) => visitor.visitReactAppBlock(this);
}

class ReactParentBlock extends BaseReactBlock {
  ReactParentBlock(List<Statement> statements) : super(statements, 'reactParent');

  Future<T> accept<T>(StatementVisitor<T> visitor) => visitor.visitReactParentBlock(this);
}

class FWidgetExpression extends Expression {
  final FWidget widget;

  FWidgetExpression(this.widget);

  @override
  Future<T> accept<T>(ExpressionVisitor<T> visitor) => visitor.visitFWIdgetExpression(this);
}

class FWidget {
  final String type;
  
  final ConditionBlock? conditionBlock;
  final ConditionRenderBlock? conditionRenderBlock;
  final LoadingBlock? loadingBlock;
  final AnimationBlock? animationBlock;
  final StateBlock? stateBlock;
  final ReactStateBlock? reactStateBlock;
  final PropBlock? propBlock;
  final StyleBlock? styleBlock;
  final RenderBlock? renderBlock;
  final EventBlock? eventBlock;
  final ReactAppBlock? reactAppBlock;
  final ReactParentBlock? reactParentBlock;

  const FWidget(
    this.type, {
    this.conditionBlock,
    this.conditionRenderBlock,
    this.loadingBlock,
    this.animationBlock,
    this.stateBlock,
    this.reactStateBlock,
    this.propBlock,
    this.styleBlock,
    this.renderBlock,
    this.eventBlock,
    this.reactAppBlock,
    this.reactParentBlock,
  });

  ConditionBlock get condition => conditionBlock ?? ConditionBlock([]);
  ConditionRenderBlock get conditionRender => conditionRenderBlock ?? ConditionRenderBlock([]);
  LoadingBlock get loading => loadingBlock ?? LoadingBlock([]);
  AnimationBlock get animation => animationBlock ?? AnimationBlock([]);
  StateBlock get state => stateBlock ?? StateBlock([]);
  ReactStateBlock get reactState => reactStateBlock ?? ReactStateBlock([]);
  PropBlock get prop => propBlock ?? PropBlock([]);
  StyleBlock get style => styleBlock ?? StyleBlock([]);
  RenderBlock get render => renderBlock ?? RenderBlock([]);
  EventBlock get event => eventBlock ?? EventBlock({});
  ReactAppBlock get reactApp => reactAppBlock ?? ReactAppBlock([]);
  ReactParentBlock get reactParent => reactParentBlock ?? ReactParentBlock([]);

  bool get hasLoading => loading.statements.isNotEmpty;
  bool get hasAnimation => animation.statements.isNotEmpty;

  @override
  String toString() {
    String str = type;
    
    List<Block?> blocks = [
      conditionBlock, conditionRender,
      loadingBlock, animationBlock,
      stateBlock, reactStateBlock,
      propBlock, styleBlock, renderBlock, eventBlock,
      reactAppBlock, reactParentBlock,
    ];

    for (Block? block in blocks) {
      if (block != null) {
        str += ' $block';
      }
    }

    return "$type {\n$str\n}";
  }

  FWidget copyWith({
    String? type,
    ConditionBlock? conditionBlock,
    ConditionRenderBlock? conditionRenderBlock,
    LoadingBlock? loadingBlock,
    AnimationBlock? animationBlock,
    StateBlock? stateBlock,
    ReactStateBlock? reactStateBlock,
    PropBlock? propBlock,
    StyleBlock? styleBlock,
    RenderBlock? renderBlock,
    EventBlock? eventBlock,
    ReactAppBlock? reactAppBlock,
    ReactParentBlock? reactParentBlock,
  }) {
    return FWidget(
      type ?? this.type,
      conditionBlock: conditionBlock ?? this.conditionBlock,
      conditionRenderBlock: conditionRenderBlock ?? this.conditionRenderBlock,
      loadingBlock: loadingBlock ?? this.loadingBlock,
      animationBlock: animationBlock ?? this.animationBlock,
      stateBlock: stateBlock ?? this.stateBlock,
      reactStateBlock: reactStateBlock ?? this.reactStateBlock,
      propBlock: propBlock ?? this.propBlock,
      styleBlock: styleBlock ?? this.styleBlock,
      renderBlock: renderBlock ?? this.renderBlock,
      eventBlock: eventBlock ?? this.eventBlock,
      reactAppBlock: reactAppBlock ?? this.reactAppBlock,
      reactParentBlock: reactParentBlock ?? this.reactParentBlock,
    );
  }
}

class AnonymousFunction extends Expression {
  final List<Parameter> parameters;
  final Block body;

  AnonymousFunction(this.parameters, this.body);

  @override
  Future<T> accept<T>(ExpressionVisitor<T> visitor) => visitor.visitAnonymousFunction(this);

  @override
  String toString() {
    final paramStr = parameters.map((p) => p.toString()).join(', ');
    return 'fn ($paramStr) {\n$body\n}';
  }
}

class CallExpression extends Expression {
  final Expression callee;
  final List<Expression> arguments;

  CallExpression(this.callee, this.arguments);

  @override
  Future<T> accept<T>(ExpressionVisitor<T> visitor) => visitor.visitCallExpression(this);

  @override
  String toString() {
    final argStr = arguments.map((a) => a.toString()).join(', ');
    return '$callee ($argStr)';
  }
}

class BlockExpression extends Expression {
  final Block body;

  BlockExpression(this.body);

  @override
  Future<T> accept<T>(ExpressionVisitor<T> visitor) => visitor.visitBlockExpression(this);
}

class PropBlockExpression extends Expression {
  final PropBlock block;

  PropBlockExpression(this.block);

  @override
  Future<T> accept<T>(ExpressionVisitor<T> visitor) => visitor.visitPropBlockExpression(this);
}

class BuiltinCallExpression extends Expression {
  final Token name;
  final List<Expression> arguments;

  BuiltinCallExpression(this.name, this.arguments);

  @override
  Future<T> accept<T>(ExpressionVisitor<T> visitor) => visitor.visitBuiltinCallExpression(this);

  @override
  String toString() {
    final argStr = arguments.map((a) => a.toString()).join(', ');
    return '${name.lexeme}($argStr)';
  }
}

class FFunction extends TopLevel {
  final Token name;
  final List<Parameter> params;
  final Block body;

  FFunction(this.name, this.params, this.body);

  @override
  String toString() {
    final paramStr = params.map((p) => p.toString()).join(', ');
    return 'fn ${name.lexeme}($paramStr) {\n$body\n}';
  }
}

class FFunctionCall extends Expression {
  final Token name;
  final List<Expression> arguments;

  FFunctionCall(this.name, this.arguments);

  @override
  Future<T> accept<T>(ExpressionVisitor<T> visitor) => visitor.visitFFunctionCall(this);

  @override
  String toString() {
    final argStr = arguments.map((a) => a.toString()).join(', ');
    return '${name.lexeme}($argStr)';
  }
}

class FMethodCall extends Expression {
  final Expression object;
  final Token method;
  final List<Expression> arguments;

  FMethodCall(this.object, this.method, this.arguments);

  @override
  Future<T> accept<T>(ExpressionVisitor<T> visitor) => visitor.visitFMethodCall(this);

  @override
  String toString() {
    final argStr = arguments.map((a) => a.toString()).join(', ');
    return '$object.${method.lexeme}($argStr)';
  }
}

class ClassInstantiation extends Expression {
  final Token name;
  final List<Expression> arguments;

  ClassInstantiation(this.name, this.arguments);

  @override
  Future<T> accept<T>(ExpressionVisitor<T> visitor) => visitor.visitClassInstantiation(this);

  @override
  String toString() {
    final argStr = arguments.map((a) => a.toString()).join(', ');
    return '${name.lexeme}($argStr)';
  }
}

class ClassDeclaration extends Statement {
  final Token name;
  final Token? superclass;
  final List<ClassMember> members;

  ClassDeclaration(this.name, this.superclass, this.members);

  @override
  Future<T> accept<T>(StatementVisitor<T> visitor) => visitor.visitClassDeclaration(this);

  @override
  String toString() {
    final superStr = superclass != null ? ' extends ${superclass!.lexeme}' : '';
    final memberStr = members.map((m) => m.toString()).join('\n');
    return 'class ${name.lexeme}$superStr {\n$memberStr\n}';
  }
}

class ClassPropertyAccess extends Expression {
  final Expression object;
  final Token property;

  ClassPropertyAccess(this.object, this.property);

  @override
  Future<T> accept<T>(ExpressionVisitor<T> visitor) => visitor.visitClassPropertyAccess(this);

  @override
  String toString() => '$object.${property.lexeme}';
}

class ClassPropertyAssignment extends Expression {
  final Expression object;
  final Token property;
  final Expression value;

  ClassPropertyAssignment(this.object, this.property, this.value);

  @override
  Future<T> accept<T>(ExpressionVisitor<T> visitor) => visitor.visitClassPropertyAssignment(this);

  @override
  String toString() => '$object.${property.lexeme} = $value';
}

class ClassMethodCall extends Expression {
  final Expression object;
  final Token method;
  final List<Expression> arguments;

  ClassMethodCall(this.object, this.method, this.arguments);

  @override
  Future<T> accept<T>(ExpressionVisitor<T> visitor) => visitor.visitClassMethodCall(this);

  @override
  String toString() {
    final argStr = arguments.map((a) => a.toString()).join(', ');
    return '$object.${method.lexeme}($argStr)';
  }
}