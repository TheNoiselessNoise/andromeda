enum TokenType {
  // Basic types
  number, // 123, -123, 123.45, -123.45
  string, // "abc", "a\"b", "a\\b", "a\nb", "a\0b"
  bTrue, // true
  bFalse, // false
  bNull, // null
  identifier, // App, Component, render, state...
  variable, // $something, $something_else
  builtin, // #log, #navigate, #api_entity_list...

  // Operators
  plus, // +
  minus, // -
  multiply, // *
  divide, // /

  // Comparison
  equals, // ==
  notEquals, // !=
  less, // <
  lessEquals, // <=
  greater, // >
  greaterEquals, // >=

  // Logical
  and, // &&
  or, // ||
  not, // !

  // Keywords
  kIf, // if
  kElif, // elif
  kElse, // else
  kForeach, // foreach
  kFrom, // from
  kTo, // to
  kTil, // til
  kStep, // step
  kFor, // for
  kIn, // in
  kClass, // class
  kExtends, // extends
  kWidgetState, // $state
  kFn, // fn
  kApp, // App

  kOn, // @on
  kStyle, // @style
  kState, // @state
  kRender, // @render

  at, // @
  hash, // #

  // Syntax
  leftParen, // (
  rightParen, // )
  leftCurly, // {
  rightCurly, // }
  leftBracket, // [
  rightBracket, // ]
  colon, // :
  comma, // ,
  dot, // .
  nullCoalescing, // ??

  assign, // =
  eof, // End of file
}

class Token {
  final TokenType type;
  final String lexeme;
  final Object? literal;
  final int line;
  final int column;

  Token(this.type, this.lexeme, this.literal, this.line, this.column);

  static variable(String lexeme) {
    return Token(TokenType.variable, lexeme, null, 0, 0);
  }

  @override
  String toString() => lexeme;
}