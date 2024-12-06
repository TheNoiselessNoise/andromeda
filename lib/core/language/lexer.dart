// Lexer or Tokenizer for Andromeda language

import 'token.dart';

class Lexer {
  final String source;
  final List<Token> tokens = [];

  static const Map<String, TokenType> keywords = {
    'if': TokenType.kIf,
    'elif': TokenType.kElif,
    'else': TokenType.kElse,
    'foreach': TokenType.kForeach,
    'from': TokenType.kFrom,
    'to': TokenType.kTo,
    'til': TokenType.kTil,
    'step': TokenType.kStep,
    'for': TokenType.kFor,
    'in': TokenType.kIn,
    'true': TokenType.bTrue,
    'false': TokenType.bFalse,
    'null': TokenType.bNull,
    'fn': TokenType.kFn,
    'class': TokenType.kClass,
    'extends': TokenType.kExtends,
    'App': TokenType.kApp,
  };

  int start = 0;
  int current = 0;
  int line = 1;
  int column = 1;

  Lexer(this.source);

  List<Token> scanTokens() {
    while (!isAtEnd()) {
      start = current;
      scanToken();
    }

    tokens.add(Token(TokenType.eof, '', null, line, column));
    
    return tokens;
  }

  static bool isKeywordToken(TokenType type) {
    return type == TokenType.kIf ||
          type == TokenType.kElse ||
          type == TokenType.kForeach ||
          type == TokenType.kIn ||
          type == TokenType.kState ||
          type == TokenType.kRender ||
          type == TokenType.kApp ||
          type == TokenType.kFn ||
          type == TokenType.kClass ||
          type == TokenType.kFrom ||
          type == TokenType.kTo ||
          type == TokenType.kTil ||
          type == TokenType.kStep ||
          type == TokenType.kFor ||
          type == TokenType.kExtends;
  }

  void scanToken() {
    String c = advance();

    switch (c) {
      // Single character tokens
      case '(': addToken(TokenType.leftParen); break;
      case ')': addToken(TokenType.rightParen); break;
      case '{': addToken(TokenType.leftCurly); break;
      case '}': addToken(TokenType.rightCurly); break;
      case '[': addToken(TokenType.leftBracket); break;
      case ']': addToken(TokenType.rightBracket); break;
      case ':': addToken(TokenType.colon); break;
      case ',': addToken(TokenType.comma); break;
      case '.': addToken(TokenType.dot); break;
      case '-': addToken(TokenType.minus); break;
      case '+': addToken(TokenType.plus); break;
      case '*': addToken(TokenType.multiply); break;
      case '/':
        if (match('/')) {
          while (peek() != '\n' && !isAtEnd()) {
            advance();
          }
        } else {
          addToken(TokenType.divide);
        }
        break;
      case '@': addToken(TokenType.at); break;

      // Double character tokens
      case '=': addToken(match('=') ? TokenType.equals : TokenType.assign); break;
      case '!': addToken(match('=') ? TokenType.notEquals : TokenType.not); break;
      case '<': addToken(match('=') ? TokenType.lessEquals : TokenType.less); break;
      case '>': addToken(match('=') ? TokenType.greaterEquals : TokenType.greater); break;
      case '?':
        if (match('?')) {
          addToken(TokenType.nullCoalescing);
        } else {
          throw Exception('Unexpected character $c at $line:$column');
        }
        break;
        
      // Whitespace
      case ' ':	
      case '\r':
      case '\t':
        break;
      case '\n':
        line++;
        column = 1;
        break;
      case '"': string(); break;
      default:
        if (isDigit(c)) {
          number();
        } else if (isAlpha(c) || c == '\$' || c == '#') {
          identifier();
        } else {
          throw Exception('Unexpected character $c at $line:$column');
        }
    }
  }

  void identifier() {
    while (isAlphaNumeric(peek())) {
      advance();
    }

    String text = source.substring(start, current);

    // Keywords
    TokenType type = keywords[text] ?? TokenType.identifier;

    // Special cases
    if (text.startsWith('\$')) {
      if (text == '\$state') {
        type = TokenType.kWidgetState;
      } else {
        type = TokenType.variable;
      }
    } else if (text.startsWith('#')) {
      type = TokenType.builtin;
    }

    addToken(type);
  }

  void number() {
    while (isDigit(peek())) {
      advance();
    }

    if (peek() == '.' && isDigit(peekNext())) {
      advance();
      while (isDigit(peek())) {
        advance();
      }
    }

    addToken(TokenType.number, double.parse(source.substring(start, current)));
  }

  void string() {
    while (peek() != '"' && !isAtEnd()) {
      if (peek() == '\n') line++;
      advance();
    }

    if (isAtEnd()) {
      throw Exception('Unterminated string at line $line:$column');
    }

    advance();

    String value = source.substring(start + 1, current - 1);
    addToken(TokenType.string, value);
  }

  bool match(String expected) {
    if (isAtEnd()) return false;
    if (source[current] != expected) return false;

    current++;
    return true;
  }

  String peek() {
    // ignore: unnecessary_string_escapes
    if (isAtEnd()) return '\0';
    return source[current];
  }

  String peekNext() {
    // ignore: unnecessary_string_escapes
    if (current + 1 >= source.length) return '\0';
    return source[current + 1];
  }

  bool isAlpha(String c) {
    int code = c.codeUnitAt(0);
    return
      (code >= 'a'.codeUnitAt(0) && code <= 'z'.codeUnitAt(0)) ||
      (code >= 'A'.codeUnitAt(0) && code <= 'Z'.codeUnitAt(0)) || c == '_';
  }

  bool isAlphaNumeric(String c) {
    return isAlpha(c) || isDigit(c);
  }
  
  bool isDigit(String c) {
    int code = c.codeUnitAt(0);
    return code >= '0'.codeUnitAt(0) && code <= '9'.codeUnitAt(0);
  }

  bool isAtEnd() {
    return current >= source.length;
  }

  String advance() {
    current++;
    column++;
    return source[current - 1];
  }

  void addToken(TokenType type, [Object? literal]) {
    String text = source.substring(start, current);
    tokens.add(Token(type, text, literal, line, column));
  }
}