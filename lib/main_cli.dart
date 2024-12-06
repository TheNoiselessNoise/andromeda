import 'core/language/lexer.dart';
import 'core/language/parser.dart';

String source = '''
fn greet(\$name, \$greeting = "Hello") {
  \$greeting + " " + \$name
}

fn testWidget() {
  Container {
    @render {
      Text { @render { "Test Widget" } }
    }
  }
}

SomePage {
  @state { 
    \$counter = 0
    \$message = greet("World")
  }

  @render {
    Center {
      @render {
        Column {
          @style {
            if (\$counter > 5) {
              mainAxisAlignment: "start"
            } else {
              mainAxisAlignment: "center"
            }
          }

          @render {
            Text { @render { \$message + " " + \$counter } }

            if (\$counter > 5) {
              Text { @render { "Counter is greater than 5".method() } }
            } else {
              Text { @render { "Counter is less than 5" } }
            }

            Button {
              @on { tap: #increment(\$counter) }
              @render { Text { @render { "Increment" } } }
            }

            testWidget()
          }
        }
      }
    }
  }
}
''';

void main() {
  final lexer = Lexer(source);
  final tokens = lexer.scanTokens();
  for (var token in tokens) {
    print("${token.type} ${token.lexeme} ${token.literal} ${token.line}:${token.column}");
  }
  final parser = Parser(tokens);
  final ast = parser.parse();
  for (var statement in ast) {
    print(statement);
  }
}
