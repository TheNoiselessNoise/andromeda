import 'package:andromeda/core/language/lexer.dart';

import 'token.dart';
import 'ast.dart';

class ParserError extends Error {
  final String message;
  final Token token;

  ParserError(this.message, this.token);

  @override
  String toString() => "Error at '${token.lexeme}' (${token.line}:${token.column}): $message";
}

class Parser {
  static bool debugMe = false;
  static List<String> debugOnly = [];
  static List<String> debugExcept = ['consume', 'advance'];

  final List<Token> tokens;

  int current = 0;
  Set<String> definedFunctions = {};
  Set<String> definedClasses = {};

  Parser(this.tokens);

  debug(String title, [TokenType? tokenType]) {
    if (!debugMe) return;
    if (debugOnly.isNotEmpty && !debugOnly.contains(title)) return;
    if (debugExcept.isNotEmpty && debugExcept.contains(title)) return;
    tokenType ??= peek().type;
    if (tokenType == TokenType.identifier) {
      print("[$title] $tokenType (${peek().lexeme})");
    } else {
      print("[$title] $tokenType");
    }
  }

  bool isFunctionDefined(String name) => definedFunctions.contains(name);
  bool isClassDefined(String name) => definedClasses.contains(name);

  List<TopLevel> parse() {
    debug("parse");
    
    List<TopLevel> topLevelDecls = [];
    bool hasApp = false;

    while (!isAtEnd()) {
      if (match([TokenType.kApp])) {
        if (hasApp) throw ParserError("Only one App declaration is allowed.", previous());
        topLevelDecls.add(parseApp());
        hasApp = true;
      } else {
        topLevelDecls.add(parseTopLevelDeclaration());
      }
    }

    return topLevelDecls;
  }

  dynamic parseTopLevelDeclaration() {
    if (match([TokenType.kFn])) {
      return parseFunction();
    } else if (match([TokenType.kClass])) {
      return parseClass();
    } else if (match([TokenType.identifier])) {
      if (check(TokenType.leftParen) || check(TokenType.leftCurly)) {
        return parsePage();
      }
      return parseStatement();
    }

    throw ParserError("Expected class, function or component declaration.", peek());
  }

  bool isAtEnd() => peek().type == TokenType.eof;
  Token peek() => current >= tokens.length ? tokens.last : tokens[current];
  Token previous() => tokens[current - 1];
  Token next() => current + 1 < tokens.length ? tokens[current + 1] : tokens.last;
  Token advance() {
    debug("advance");
    
    if (!isAtEnd()) current++;
    return previous();
  }

  bool check(TokenType type) {
    if (isAtEnd()) return false;
    return peek().type == type;
  }

  bool checkNext(TokenType type) {
    if (current + 1 >= tokens.length) return false;
    return next().type == type;
  }

  Token consume(TokenType type, String message) {
    debug("consume", type);
    
    if (check(type)) return advance();
    print("Expected $type, but got ${peek().type}.");
    throw ParserError(message, peek());
  }

  Token consumeIdentifierWithKeywords(String message) {
    if (check(TokenType.identifier)) return advance();
    if (Lexer.isKeywordToken(peek().type)) return advance();
    throw ParserError(message, peek());
  }

  bool match(List<TokenType> types) {
    for (TokenType type in types) {
      if (check(type)) {
        advance();
        return true;
      }
    }
    return false;
  }

  PagesBlock parsePagesBlock() {
    debug("parsePagesBlock");

    consume(TokenType.leftCurly, "Expected '{' after @pages declaration.");

    List<FPage> pages = [];

    while (!check(TokenType.rightCurly) && !isAtEnd()) {
      if (match([TokenType.identifier])) {
        if (check(TokenType.leftParen) || check(TokenType.leftCurly)) {
          pages.add(parsePage());
        }
      }
    }

    consume(TokenType.rightCurly, "Expected '}' after @pages block.");

    return PagesBlock(pages);
  }

  FApp parseApp() {
    debug("parseApp");

    Token name = previous();

    consume(TokenType.leftCurly, "Expected '{' after App declaration.");

    ConfigBlock? configBlock;
    StateBlock? stateBlock;
    PagesBlock? pagesBlock;

    while (!check(TokenType.rightCurly) && !isAtEnd()) {
      if (!match([TokenType.at])) {
        throw ParserError("Expected '@' before block type.", peek());
      }

      Token blockType = consume(TokenType.identifier, "Expected block type after @");

      switch (blockType.lexeme) {
        case 'state':
          if (stateBlock != null) {
            throw ParserError("State block already defined.", blockType);
          }
          stateBlock = StateBlock(parseBlock("@state", stateContext: true).statements);
          break;
        case 'config':
          if (configBlock != null) {
            throw ParserError("Config block already defined.", blockType);
          }
          configBlock = ConfigBlock(parseBlock("@props", propsContext: true).statements);
          break;
        case 'pages':
          if (pagesBlock != null) {
            throw ParserError("Pages block already defined.", blockType);
          }
          pagesBlock = parsePagesBlock();
          break;
        default:
          throw ParserError("Unknown block type '$blockType'", blockType);
      }
    }

    consume(TokenType.rightCurly, "Expected '}' after App block.");

    return FApp(name, configBlock, stateBlock, pagesBlock);
  }

  Statement parseStatement({
    bool stateContext = false
  }) {
    debug("parseStatement");

    if (check(TokenType.identifier)) {
      if (checkNext(TokenType.leftCurly)) {
        advance();
        return RenderWidgetStatement(parseWidget());
      } else if (check(TokenType.colon)) {
        return parsePropStatement();
      } else if (check(TokenType.leftParen)) {
        return parseExpressionStatement();
      }
    }

    if (match([TokenType.kIf])) {
      return parseIfStatement();
    }

    if (match([TokenType.kFor])) {
      return parseForLoopStatement();
    }
    
    if (match([TokenType.kForeach])) {
      return parseForEachStatement();
    }

    if (check(TokenType.variable)) {
      if (checkNext(TokenType.assign)) {
        if (stateContext) {
          return parseStateVariableDeclaration();
        }

        return parseVariableDeclaration();
      }

      return parseExpressionStatement();
    }

    if (check(TokenType.leftCurly)) {
      return BlockStatement(parseBlock('statement', stateContext: stateContext));
    }
    
    return parseExpressionStatement();
  }

  IfStatement parseIfStatement() {
    debug("parseIfStatement");

    consume(TokenType.leftParen, "Expected '(' after 'if'.");
    Expression condition = parseExpression();
    consume(TokenType.rightParen, "Expected ')' after if condition.");

    Block thenBranch = parseBlock("if condition");

    List<ElifBranch> elifBranches = [];
    Block? elseBranch;

    while (match([TokenType.kElif])) {
      consume(TokenType.leftParen, "Expected '(' after 'elif'.");
      Expression elifCondition = parseExpression();
      consume(TokenType.rightParen, "Expected ')' after elif condition.");

      Block elifBlock = parseBlock('elif branch');
      elifBranches.add(ElifBranch(elifCondition, elifBlock));
    }

    if (match([TokenType.kElse])) {
      elseBranch = parseBlock('else branch');
    }

    return IfStatement(condition, thenBranch, elifBranches, elseBranch);
  }

  ForLoopStatement parseForLoopStatement() {
    debug("parseForLoopStatement");

    consume(TokenType.leftParen, "Expected '(' after 'for'.");

    Token variable = consume(TokenType.variable, "Expected variable name after 'for'.");

    consume(TokenType.kFrom, "Expected 'from' after for variable.");

    Expression from = parseExpression();

    bool inclusive = true;
    if (check(TokenType.kTo)) {
      consume(TokenType.kTo, "Expected 'to' after for from.");
    } else if (check(TokenType.kTil)) {
      inclusive = false;
      consume(TokenType.kTil, "Expected 'til' after for from.");
    } else {
      throw ParserError("Expected 'to' or 'til' after for from.", peek());
    }

    Expression to = parseExpression();

    Expression? step;
    if (match([TokenType.kStep])) {
      step = parseExpression();
    }

    consume(TokenType.rightParen, "Expected ')' after for range.");

    Block body = parseBlock('for loop');

    return ForLoopStatement(variable, from, to, step, inclusive, body);
  }

  ForEachStatement parseForEachStatement() {
    debug("parseForEachStatement");

    consume(TokenType.leftParen, "Expected '(' after 'foreach'.");

    Token variable = consume(TokenType.variable, "Expected variable name after 'foreach'.");
    consume(TokenType.kIn, "Expected 'in' after foreach variable.");

    Expression iterable = parseExpression();

    consume(TokenType.rightParen, "Expected ')' after foreach iterable.");

    Statement body = parseStatement();

    return ForEachStatement(variable, iterable, body);
  }

  StateVariableDeclaration parseStateVariableDeclaration() {
    debug("parseStateVariableDeclaration");

    Token name = consume(TokenType.variable, "Expected variable name.");

    Expression? initializer;
    if (match([TokenType.assign])) {
      initializer = parseExpression();
    }

    return StateVariableDeclaration(name, initializer);
  }

  VariableDeclaration parseVariableDeclaration() {
    debug("parseVariableDeclaration");

    Token name = consume(TokenType.variable, "Expected variable name.");

    Expression? initializer;
    if (match([TokenType.assign])) {
      initializer = parseExpression();
    }

    return VariableDeclaration(name, initializer);
  }

  Block parseBlock(String context, {
    bool stateContext = false,
    bool propsContext = false,
    bool eatLeftCurly = true,
    bool eatRightCurly = true
  }) {
    debug("parseBlock");

    List<Statement> statements = [];

    if (eatLeftCurly) consume(TokenType.leftCurly, "Expected '{' after $context.");

    while (!check(TokenType.rightCurly) && !isAtEnd()) {
      bool isPropIdentifier = check(TokenType.identifier) || Lexer.isKeywordToken(peek().type);

      if (propsContext && isPropIdentifier && checkNext(TokenType.colon)) {
        statements.add(parsePropStatement());
      } else {
        statements.add(parseStatement(
          stateContext: stateContext
        ));
      }
    }

    if (eatRightCurly) consume(TokenType.rightCurly, "Expected '}' after $context block.");

    return Block(statements);
  }

  ExpressionStatement parseExpressionStatement() {
    debug("parseExpressionStatement");

    return ExpressionStatement(parseExpression());
  }

  Expression parseExpression() {
    debug("parseExpression");

    return parseAssignment();
  }

  ClassMethodCall parseMethodCall(Expression base) {
    debug("parseMethodCall");

    Token method = consume(TokenType.identifier, "Expected method name after '.'");
    List<Expression> arguments = parseArguments("method name");

    return ClassMethodCall(base, method, arguments);
  }

  Expression parseAssignment() {
    debug("parseAssignment");
    Expression expr = parseLogicalOr();

    if (match([TokenType.assign])) {
      Token equals = previous();
      Expression value = parseAssignment();

      if (expr is VariableExpression) {
        return AssignExpression(expr.name, value);
      } 
      else if (expr is ClassPropertyAccess) {
        return ClassPropertyAssignment(expr.object, expr.property, value);
      }

      throw ParserError("Invalid assignment target (${expr.runtimeType}).", equals);
    }

    return expr;
  }

  Expression parsePropertyAccess() {
    debug("parsePropertyAccess");
    Expression expr = parsePrimary();

    while (true) {
      if (match([TokenType.dot])) {
        if (check(TokenType.variable)) {
          Token property = consume(TokenType.variable, "Expected property name after '.'");
          expr = ClassPropertyAccess(expr, property);
        } else if (check(TokenType.identifier)) {
          expr = parseMethodCall(expr);
        } else {
          throw ParserError("Expected method call or property access after '.'", peek());
        }
      } else if (check(TokenType.leftParen)) {
        List<Expression> arguments = parseArguments("anonymous call");
        expr = CallExpression(expr, arguments);
      } else if (check(TokenType.leftBracket)) {
        Expression index = parseExpression();
        consume(TokenType.rightBracket, "Expected ']' after index.");

        if (check(TokenType.assign)) {
          advance();

          Expression value = parseExpression();
          expr = IndexAssignment(expr, index, value);
        } else {
          expr = IndexAccess(expr, index);
        }
      } else {
        break;
      }
    }

    return expr;
  }

  Expression parseLogicalOr() {
    debug("parseLogicalOr");

    Expression expression = parseLogicalAnd();

    while (match([TokenType.or, TokenType.nullCoalescing])) {
      Token operator = previous();
      Expression right = parseLogicalAnd();
      expression = BinaryExpression(expression, operator, right);
    }

    return expression;
  }

  Expression parseLogicalAnd() {
    debug("parseLogicalAnd");

    Expression expression = parseEquality();

    while (match([TokenType.and])) {
      Token operator = previous();
      Expression right = parseEquality();
      expression = BinaryExpression(expression, operator, right);
    }

    return expression;
  }

  Expression parseEquality() {
    debug("parseEquality");

    Expression expression = parseComparison();

    while (match([TokenType.equals, TokenType.notEquals])) {
      Token operator = previous();
      Expression right = parseComparison();
      expression = BinaryExpression(expression, operator, right);
    }

    return expression;
  }

  Expression parseComparison() {
    debug("parseComparison");

    Expression expression = parseTerm();

    while (match([
      TokenType.less,
      TokenType.lessEquals,
      TokenType.greater,
      TokenType.greaterEquals
    ])) {
      Token operator = previous();
      Expression right = parseTerm();
      expression = BinaryExpression(expression, operator, right);
    }

    return expression;
  }

  Expression parseTerm() {
    debug("parseTerm");

    Expression expression = parseFactor();

    while (match([TokenType.plus, TokenType.minus])) {
      Token operator = previous();
      Expression right = parseFactor();
      expression = BinaryExpression(expression, operator, right);
    }

    return expression;
  }

  Expression parseFactor() {
    debug("parseFactor");

    Expression expression = parseUnary();

    while (match([TokenType.multiply, TokenType.divide])) {
      Token operator = previous();
      Expression right = parseUnary();
      expression = BinaryExpression(expression, operator, right);
    }

    return expression;
  }

  Expression parseUnary() {
    debug("parseUnary");

    if (match([TokenType.not, TokenType.minus])) {
      Token operator = previous();
      Expression right = parseUnary();
      return UnaryExpression(operator, right);
    }

    return parsePropertyAccess();
  }

  List<Parameter> parseParameters(String context, {
    bool eatLeftParen = true,
    bool eatRightParen = true
  }) {
    debug("parseParameters");

    List<Parameter> parameters = [];

    // early return if no parameters (no parentheses required)
    if (check(TokenType.leftCurly)) return parameters;

    if (eatLeftParen) consume(TokenType.leftParen, "Expected '(' after $context.");

    if (!check(TokenType.rightParen)) {
      do {
        parameters.add(parseParameter());
      } while (match([TokenType.comma]));
    }

    if (eatRightParen) consume(TokenType.rightParen, "Expected ')' after parameters.");

    return parameters;
  }

  List<Expression> parseArguments(String context) {
    debug("parseArguments");

    List<Expression> arguments = [];

    if (check(TokenType.leftCurly)) return arguments;

    consume(TokenType.leftParen, "Expected '(' after $context.");

    if (!check(TokenType.rightParen)) {
      do {
        arguments.add(parseExpression());
      } while (match([TokenType.comma]));
    }

    consume(TokenType.rightParen, "Expected ')' after arguments.");

    return arguments;
  }

  FFunctionCall parseFunctionCall(Token name) {
    debug("parseFunctionCall");

    return FFunctionCall(name, parseArguments('function name'));
  }

  ClassInstantiation parseClassInstantiation(Token name) {
    debug("parseClassInstantiation");

    return ClassInstantiation(name, parseArguments('class name'));
  }

  ListLiteral parseListLiteral() {
    debug("parseListLiteral");

    List<Expression> elements = [];

    if (!check(TokenType.rightBracket)) {
      do {
        elements.add(parseExpression());
      } while (match([TokenType.comma]));
    }

    consume(TokenType.rightBracket, "Expected ']' after list elements.");

    return ListLiteral(elements);
  }

  MapLiteral parseMapLiteral() {
    debug("parseMapLiteral");

    List<FMapEntry> entries = [];

    consume(TokenType.leftCurly, "Expected '{' before map entries.");

    if (!check(TokenType.rightCurly)) {
      do {
        Expression key = parseExpression();
        consume(TokenType.colon, "Expected ':' after map key.");
        Expression value = parseExpression();
        entries.add(FMapEntry(key, value));
      } while (match([TokenType.comma]));
    }

    consume(TokenType.rightCurly, "Expected '}' after map entries.");

    return MapLiteral(entries);
  }

  Expression parsePrimary() {
    debug("parsePrimary");

    if (match([TokenType.bFalse])) return LiteralExpression(false);
    if (match([TokenType.bTrue])) return LiteralExpression(true);
    if (match([TokenType.bNull])) return LiteralExpression(null);
    if (match([TokenType.number, TokenType.string])) return LiteralExpression(previous().literal);
    if (match([TokenType.variable])) return VariableExpression(previous());
    if (match([TokenType.kWidgetState])) return VariableExpression(previous());

    if (match([TokenType.leftBracket])) {
      return parseListLiteral();
    }

    if (check(TokenType.leftCurly) && !checkNext(TokenType.at)) {
      return parseMapLiteral();
    }

    if (check(TokenType.at) && checkNext(TokenType.leftCurly)) {
      advance();
      final propsBlock = PropsBlock(parseBlock("@props", propsContext: true).statements);
      return PropsBlockExpression(propsBlock);
    }
    
    if (match([TokenType.kFn])) {
      if (check(TokenType.identifier)) {
        throw ParserError("Anonymous functions cannot have names.", peek());
      } else {
        return parseAnonymousFunction();
      }
    }

    if (match([TokenType.identifier])) {
      Token name = previous();

      if (check(TokenType.leftCurly) || check(TokenType.leftParen)) {
        if (check(TokenType.leftCurly)) {
          return FWidgetExpression(parseWidget());
        }

        if (check(TokenType.leftParen)) {
          if (isFunctionDefined(name.lexeme)) {
            return parseFunctionCall(name);
          }

          if (isClassDefined(name.lexeme)) {
            return parseClassInstantiation(name);
          }
        }

        throw ParserError("Undefined function or class '${name.lexeme}'", name);
      }

      if (isFunctionDefined(name.lexeme)) {
        return FunctionReferenceExpression(name);
      }

      return VariableExpression(name);
    }

    if (match([TokenType.leftParen])) {
      Expression expression = parseExpression();
      consume(TokenType.rightParen, "Expected ')' after expression.");
      return GroupingExpression(expression);
    }

    if (match([TokenType.builtin])) {
      Token name = previous();
      return BuiltinCallExpression(name, parseArguments('builtin function'));
    }

    throw ParserError("Expected expression.", peek());
  }

  Expression parseCall(Expression callee) {
    debug("parseCall");

    while (true) {
      if (match([TokenType.leftParen])) {
        callee = finishCall(callee);
      } else {
        break;
      }
    }

    return callee;
  }

  Expression finishCall(Expression callee) {
    debug("finishCall");

    List<Expression> arguments = parseArguments('function call');
    
    if (callee is VariableExpression) {
      if (isFunctionDefined(callee.name.lexeme)) {
        return FFunctionCall(callee.name, arguments);
      }
    }

    return CallExpression(callee, arguments);
  }

  AnonymousFunction parseAnonymousFunction() {
    debug("parseAnonymousFunction");

    List<Parameter> parameters = parseParameters('anonymous function');

    Block body = parseBlock('anonymous function');

    return AnonymousFunction(parameters, body);
  }

  FPage parsePage() {
    debug("parsePage");

    Token name = previous();

    List<Parameter> parameters = parseParameters('page declaration');

    consume(TokenType.leftCurly, "Expected '{' after page declaration.");

    StateBlock? stateBlock;
    StyleBlock? styleBlock;
    RenderBlock? renderBlock;
    EventBlock? eventBlock;

    while (!check(TokenType.rightCurly) && !isAtEnd()) {
      if (match([TokenType.at])) {
        Token blockType = consume(TokenType.identifier, "Expected block type after @.");

        switch (blockType.lexeme) {
          case 'state':
            if (stateBlock != null) {
              throw ParserError("State block already defined.", blockType);
            }
            stateBlock = StateBlock(parseBlock("@state", stateContext: true).statements);
            break;
          case 'render':
            if (renderBlock != null) {
              throw ParserError("Render block already defined.", blockType);
            }
            renderBlock = RenderBlock(parseBlock("@render").statements);
            break;
          case 'style':
            if (styleBlock != null) {
              throw ParserError("Style block already defined.", blockType);
            }
            styleBlock = StyleBlock(parseBlock("@style", propsContext: true).statements);
            break;
          case 'event':
            if (eventBlock != null) {
              throw ParserError("On block already defined.", blockType);
            }
            eventBlock = parseEventBlock();
            break;
          default:
            throw ParserError("Unknown block type '${blockType.lexeme}'", blockType);
        }
      } else {
        throw ParserError("Expected section type.", peek());
      }
    }

    consume(TokenType.rightCurly, "Expected '}' after page body.");
    return FPage(name, parameters, stateBlock, styleBlock, renderBlock, eventBlock);
  }

  Parameter parseParameter() {
    debug("parseParameter");

    Token name = consume(TokenType.variable, "Expected parameter name.");

    Expression? defaultValue;
    if (match([TokenType.assign])) {
      defaultValue = parseExpression();
    }

    return Parameter(name, defaultValue);
  }

  PropStatement parsePropStatement() {
    debug("parsePropStatement");

    Token name = consumeIdentifierWithKeywords("Expected property name");
    consume(TokenType.colon, "Expected ':' after property name");
    Expression value = parseExpression();
    return PropStatement(name.lexeme, value);
  }
  
  BaseReactBlock parseReactBlock(String context) {
    debug("parseReactBlock");

    consume(TokenType.leftCurly, "Expected '{' after $context");

    List<ReactStatement> stateVariableStatements = [];

    while (!check(TokenType.rightCurly) && !isAtEnd()) {
      if (match([TokenType.variable])) {
        VariableExpression stateVariable = VariableExpression(previous());
        stateVariableStatements.add(ReactStatement(stateVariable));
      }
    }

    consume(TokenType.rightCurly, "Expected '}' after $context block");

    return BaseReactBlock(stateVariableStatements);
  }

  EventBlock parseEventBlock() {
    debug("parseEventBlock");

    consume(TokenType.leftCurly, "Expected '{' after @on");
    
    Map<String, Expression> handlers = {};
    
    do {
      Token event = consume(TokenType.identifier, "Expected event name");
      consume(TokenType.colon, "Expected ':' after event name");
      Expression handler = parseExpression();
      
      handlers[event.lexeme] = handler;
      
      if (check(TokenType.rightCurly)) break;

    } while (!isAtEnd());
    
    consume(TokenType.rightCurly, "Expected '}' after on block");
    return EventBlock(handlers);
  }

  FWidget parseWidget() {
    debug("parseWidget");

    Token name = previous();

    ConditionBlock? conditionBlock;
    ConditionRenderBlock? conditionRenderBlock;
    LoadingBlock? loadingBlock;
    AnimationBlock? animationBlock;
    StateBlock? stateBlock;
    ReactStateBlock? reactStateBlock;
    PropsBlock? propsBlock;
    StyleBlock? styleBlock;
    RenderBlock? renderBlock;
    EventBlock? eventBlock;
    ReactAppBlock? reactAppBlock;
    ReactParentBlock? reactParentBlock;

    consume(TokenType.leftCurly, "Expected '{' after widget name");

    while (!check(TokenType.rightCurly) && !isAtEnd()) {
      if (!match([TokenType.at])) {
        throw ParserError("Expected '@' before block type.", peek());
      }

      Token blockType = consume(TokenType.identifier, "Expected block type after @");

      switch (blockType.lexeme) {
        case 'condition':
          if (conditionBlock != null) {
            throw ParserError("Condition block already defined.", blockType);
          }
          conditionBlock = ConditionBlock(parseBlock("@condition").statements);
          break;
        case 'conditionRender':
          if (conditionRenderBlock != null) {
            throw ParserError("Condition render block already defined.", blockType);
          }
          conditionRenderBlock = ConditionRenderBlock(parseBlock("@conditionRender").statements);
          break;
        case 'loading':
          if (loadingBlock != null) {
            throw ParserError("Loading block already defined.", blockType);
          }
          loadingBlock = LoadingBlock(parseBlock("@loading").statements);
        case 'animation':
          if (animationBlock != null) {
            throw ParserError("Animation block already defined.", blockType);
          }
          animationBlock = AnimationBlock(parseBlock("@animation").statements);
        case 'state':
          if (stateBlock != null) {
            throw ParserError("State block already defined.", blockType);
          }
          stateBlock = StateBlock(parseBlock("@state", stateContext: true).statements);
          break;
        case 'reactState':
          if (reactStateBlock != null) {
            throw ParserError("React state block already defined.", blockType);
          }
          reactStateBlock = ReactStateBlock(parseBlock("@reactState", stateContext: true).statements);
        case 'props':
          if (propsBlock != null) {
            throw ParserError("Props block already defined.", blockType);
          }
          propsBlock = PropsBlock(parseBlock("@props", propsContext: true).statements);
          break;
        case 'style':
          if (styleBlock != null) {
            throw ParserError("Style block already defined.", blockType);
          }
          styleBlock = StyleBlock(parseBlock("@style", propsContext: true).statements);
          break;
        case 'render':
          if (renderBlock != null) {
            throw ParserError("Render block already defined.", blockType);
          }
          renderBlock = RenderBlock(parseBlock("@render").statements);
          break;
        case 'event':
          if (eventBlock != null) {
            throw ParserError("Event block already defined.", blockType);
          }
          eventBlock = parseEventBlock();
          break;
        case 'reactApp':
          if (reactAppBlock != null) {
            throw ParserError("React block already defined.", blockType);
          }
          reactAppBlock = ReactAppBlock(parseReactBlock("@react").statements);
          break;
        case 'reactParent':
          if (reactParentBlock != null) {
            throw ParserError("React parent block already defined.", blockType);
          }
          reactParentBlock = ReactParentBlock(parseReactBlock("@reactParent").statements);
          break;
        default:
          throw ParserError("Unknown block type '${blockType.lexeme}'", blockType);
      }
    }

    consume(TokenType.rightCurly, "Expected '}' after widget block.");

    return FWidget(
      name.lexeme,
      conditionBlock: conditionBlock,
      conditionRenderBlock: conditionRenderBlock,
      loadingBlock: loadingBlock,
      animationBlock: animationBlock,
      stateBlock: stateBlock,
      reactStateBlock: reactStateBlock,
      propsBlock: propsBlock,
      styleBlock: styleBlock,
      renderBlock: renderBlock,
      eventBlock: eventBlock,
      reactAppBlock: reactAppBlock,
      reactParentBlock: reactParentBlock
    );
  }

  FFunction parseFunction() {
    debug("parseFunction");

    Token name = consume(TokenType.identifier, "Expected function name after 'fn'");

    if (isFunctionDefined(name.lexeme)) {
      throw ParserError("Function '${name.lexeme}' already defined.", name);
    } else {
      definedFunctions.add(name.lexeme);
    }

    List<Parameter> parameters = parseParameters('function declaration');
    Block body = parseBlock('function body');
    
    return FFunction(name, parameters, body);
  }

  FClass parseClass() {
    debug("parseClass");

    Token name = consume(TokenType.identifier, "Expected class name after 'class'");

    if (isClassDefined(name.lexeme)) {
      throw ParserError("Class '${name.lexeme}' already defined.", name);
    } else {
      definedClasses.add(name.lexeme);
    }

    Token? superclass;
    if (match([TokenType.kExtends])) {
      superclass = consume(TokenType.identifier, "Expected superclass name after 'extends'");
    }

    consume(TokenType.leftCurly, "Expected '{' after class declaration");

    List<ClassMember> members = [];
    while (!check(TokenType.rightCurly) && !isAtEnd()) {
      members.add(parseClassMember());
    }

    consume(TokenType.rightCurly, "Expected '}' after class body");

    return FClass(name, superclass, members);
  }

  ClassMember parseClassMember() {
    if (match([TokenType.variable])) {
      return parseClassProperty();
    } else if (match([TokenType.kFn])) {
      return parseClassMethod();
    } else {
      throw ParserError("Expected property or method in class body.", peek());
    }
  }

  ClassProperty parseClassProperty() {
    Token name = previous();
    Expression? initializer;
    if (match([TokenType.assign])) {
      initializer = parseExpression();
    }
    return ClassProperty(name, initializer);
  }

  ClassMethod parseClassMethod() {
    Token name = consume(TokenType.identifier, "Expected function name after 'fn'");

    List<Parameter> parameters = parseParameters('method declaration');
    Block body = parseBlock('method body');
    
    return ClassMethod(name, parameters, body);
  }
}