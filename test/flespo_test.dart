import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:andromeda/core/_.dart';

MaterialApp createApp(String source) {
  return MaterialApp(
    home: Scaffold(
      body: FScriptRoot(
        initialSource: source,
        loadingBuilder: (message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(message),
            ],
          )
        ),
        errorBuilder: (error, stackTrace, onReload) => ErrorHandlerWidget(
          error: error,
          stackTrace: stackTrace?.toString(),
          onReload: onReload
        ),
      ),
    ),
  );
}

class AndromedaTester {
  final WidgetTester tester;

  AndromedaTester(this.tester);

  Future<void> pumpApp(String source) async {
    await tester.pumpWidget(createApp(source));
    await tester.pumpAndSettle();
  }

  Future<void> elevatedButton(String text) async {
    await tester.tap(find.widgetWithText(ElevatedButton, text));
    await tester.pumpAndSettle();
  }

  Future<void> expectText(String text) async {
    expect(find.text(text), findsOneWidget);
  }
}

class AndromedaTest {
  final String title;
  final String source;
  final Function(AndromedaTester) test;

  AndromedaTest(this.title, this.source, this.test);

  void run() {
    testWidgets(title, (WidgetTester tester) async {
      final andromedaTester = AndromedaTester(tester);
      await andromedaTester.pumpApp(source);
      await test(andromedaTester);
    });
  }
}

void main() {

  final tests = [
    AndromedaTest('Hello World',
      '''
      SomePage { @render { Text { @props { text: "Hello, World!" } } } }
      ''',
      (tester) async {
        await tester.expectText('Hello, World!');
      }
    ),
    AndromedaTest('State Change',
      '''
      SomePage {
        @render {
          Column {
            @state { \$count = 0 }

            @render {
              ElevatedButton {
                @event { onPressed: #{ #\$count = #\$count + 1 } }
                @render { Text { @props { text: "Click me" } } }
              }
              Text { @props { text: "Count: " + #\$count } } 
            }
          }
        }
      }
      ''',
      (tester) async {
        await tester.expectText('Count: 0.0');
        await tester.elevatedButton('Click me');
        await tester.expectText('Count: 1.0');
      }
    ),
    AndromedaTest('For Loop inside @render',
      '''
      SomePage {
        @render {
          Column {
            @render {
              for (\$i from 0 til 5) {
                Text { @props { text: "Count: " + \$i } } 
              }
            }
          }
        }
      }
      ''',
      (tester) async {
        for (int i = 0; i < 5; i++) {
          await tester.expectText('Count: ${i.toDouble().toString()}');
        }
      }
    ),
    AndromedaTest('For Loop inside @render with @state',
      '''
      SomePage {
        @render {
          Column {
            @state { \$count = 5 }

            @render {
              for (\$i from 0 til #\$count) {
                Text { @props { text: "Count: " + \$i } } 
              }
            }
          }
        }
      }
      ''',
      (tester) async {
        for (int i = 0; i < 5; i++) {
          await tester.expectText('Count: ${i.toDouble().toString()}');
        }
      }
    ),
    AndromedaTest('Reevaluation on rerender with @state',
      '''
      SomePage {
        @render {
          Column {
            @state { \$count = 2 }

            @render {
              for (\$i from 0 til #\$count) {
                Text { @props { text: "Count: " + \$i } } 
              }

              ElevatedButton {
                @event { onPressed: #{ #\$count = #\$count + 1 } }
                @render { Text { @props { text: "Click me" } } }
              }
            }
          }
        }
      }
      ''',
      (tester) async {
        for (int i = 0; i < 2; i++) {
          await tester.expectText('Count: ${i.toDouble().toString()}');
        }

        await tester.elevatedButton('Click me');
        await tester.elevatedButton('Click me');
        await tester.elevatedButton('Click me');

        for (int i = 0; i < 5; i++) {
          await tester.expectText('Count: ${i.toDouble().toString()}');
        }
      }
    ),
  ];

  for (final test in tests) {
    test.run();
  }
}
