import 'dart:io';
import 'package:flutter/material.dart';
import 'core/_.dart';

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

fn testWidget2() {
  Container {
    @render {
      Text { @render { "Test Widget 2" } }
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
            mainAxisAlignment: "center"
          }

          @render {
            Text { @render { \$message + " " + \$counter } }

            if (\$counter > 5) {
              Text { @render { "Counter is greater than 5".toUpperCase() } }
            } else {
              Text { @render { "Counter is less than 5" } }
            }

            Button {
              @on { tap: #increment(\$counter) }
              @render {
                Text {
                  @style {
                    if (\$counter > 5) {
                      color: "red"
                      fontSize: 20
                      fontWeight: "bold"
                    } else {
                      color: "blue"
                      fontSize: 16
                    }
                  }

                  @render { "Increment" }
                }
              }
            }

            Button {
              @on { tap: #decrement(\$counter) }
              @render { Text { @render { "Decrement" } } }
            }

            if (\$counter > 5) {
              testWidget()
            } else {
              testWidget2()
            }
          }
        }
      }
    }
  }
}
''';

class AddressForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const CoreBaseForm(
      id: 'address',
      child: Column(
        children: [
          CoreTextField(id: 'street'),
          CoreTextField(id: 'city'),
          CoreTextField(id: 'zipCode'),
        ],
      ),
    );
  }
}

class Country {
  final String code;
  final String name;
  
  const Country(this.code, this.name);
}

enum Status { active, pending, inactive }

class RegistrationForm extends StatefulWidget {
  @override
  RegistrationFormState createState() => RegistrationFormState();
}

class RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<CoreBaseFormState>();

  Future<void> _handleSubmit() async {
    if (_formKey.currentState != null) {
      await _formKey.currentState!.submitForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CoreBaseForm(
      key: _formKey,
      id: 'registration',
      initialValues: const {
        'username': '',
        // 'email': '', // Can be set, but not required
        // 'testStringEnum': null, // Can be set, but not required
        // 'testStringMultiEnum': null, // Can be set, but not required
        'address': {
          'street': '',
          'city': '',
          'zipCode': '',
        },
      },
      onSubmit: (values) async {
        print(jsonEncodeWithRules(values, {
          'TimeOfDay': (TimeOfDay time) => [time.hour, time.minute].map((e) => e.toString().padLeft(2, '0')).join(':'),
          '_File': (File file) => { 'path': file.path, 'size': file.lengthSync() },
          'Color': (Color color) => color.value.toRadixString(16).padLeft(8, '0'),
          'RangeValues': (RangeValues range) => [range.start, range.end],
        }));
      },
      onError: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $error")),
        );
      },
      child: Column(
        children: [
          const Text('Text'),
          const CoreTextField(
            id: 'username',
            initialValue: 'John Doe', // Will override the initial value from the form's initialValues
          ),
          const Text('Text2'),
          const CoreTextField( // String
            id: 'email',
          ),
          const Text('Float'),
          const CoreFloatField( // double
            id: 'testFloat',
            initialValue: 1.5,
          ),
          const Text('Bool'),
          const CoreBoolField(
            id: 'testBool',
            label: 'Agree to terms',
            initialValue: true,
          ),
          const Text('Date'),
          CoreDateField(
            id: 'birthDate',
            placeholder: 'Select a birth date',
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          ),
          const Text('Time'),
          CoreTimeField(
            id: 'birthTime',
            placeholder: 'Select a birth time',
            initialValue: TimeOfDay.now(),
          ),
          const Text('DateTime'),
          CoreDateTimeField(
            id: 'birthDateTime',
            placeholder: 'Select a birth date and time',
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          ),
          const Text('E-mail'),
          const CoreEmailField(
            id: 'email',
            label: 'E-mail',
            placeholder: 'Enter your e-mail',
            validate: false
          ),
          const Text('Password'),
          const CorePasswordField(
            id: 'password',
            label: 'Password',
            placeholder: 'Enter your password',
            showStrengthIndicator: true,
          ),
          const Text('Slider'),
          CoreSliderField(
            id: 'slider',
            valueLabel: (p0) => p0.toStringAsFixed(2),
          ),
          const Text('File'),
          const CoreFileField(
            id: 'file',
            acceptedType: CoreFileFieldFileType.any,
            placeholder: Text('Select a file'),
          ),
          const Text('Image'),
          const CoreImageField(
            id: 'image',
            allowMultiple: true,
          ),
          const Text('Range'),
          CoreRangeField(
            id: 'range',
            label: 'Color',
            showLabels: true,
            initialValue: const RangeValues(20, 80),
            valueLabel: (p0) => p0.toStringAsFixed(0),
          ),
          const Text('Color'),
          const CoreColorField(
            id: 'color',
            label: 'Color',
            showAlpha: false,
            presetColors: [
              Colors.red,
              Colors.green,
              Colors.blue,
              Colors.yellow,
              Colors.purple,
              Colors.cyan,
              Colors.black,
              Colors.white,
              Colors.transparent,
            ],
          ),
          const Text('Enum<Int>'),
          CoreEnumField<int>(
            id: 'numbers',
            options: const [1, 2, 3, 4, 5],
            labelBuilder: (value) => 'Number $value',
            placeholder: 'Select a number',
          ),
          const Text('Enum<String>'),
          CoreEnumField<String>(
            id: 'colors',
            options: const ['Red', 'Green', 'Blue'],
            placeholder: 'Select a color',
          ),
          const Text('Enum<Country>'),
          CoreEnumField<Country>(
            id: 'country',
            options: const [
              Country('US', 'United States'),
              Country('UK', 'United Kingdom'),
              Country('FR', 'France'),
            ],
            labelBuilder: (country) => country.name,
            placeholder: 'Select a country',
          ),
          const Text('MultiEnum<Int> (mode: string)'),
          CoreMultiEnumField<int>(
            id: 'multiNumbersString',
            options: const [1, 2, 3, 4, 5],
            labelBuilder: (value) => 'Option $value',
            placeholder: 'Select numbers',
            displayMode: CoreMultiEnumFieldDisplayMode.string,
          ),
          const Text('MultiEnum<Int> (mode: chips)'),
          CoreMultiEnumField<int>(
            id: 'multiNumbersChips',
            options: const [1, 2, 3, 4, 5],
            labelBuilder: (value) => 'Option $value',
            placeholder: 'Select numbers',
            displayMode: CoreMultiEnumFieldDisplayMode.chips,
          ),
          const Text('MultiEnum<Country> (mode: chips)'),
          CoreMultiEnumField<Country>(
            id: 'multiCountry',
            options: const [
              Country('US', 'United States'),
              Country('UK', 'United Kingdom'),
              Country('FR', 'France'),
            ],
            labelBuilder: (country) => country.name,
            placeholder: 'Select a country',
            displayMode: CoreMultiEnumFieldDisplayMode.chips,
          ),
          const Text('MultiEnum<Status>'),
          CoreMultiEnumField<Status>(
            id: 'statuses',
            options: Status.values,
            labelBuilder: (status) => status.name.toUpperCase(),
            placeholder: 'Select statuses',
          ),
          const Text('Map<String, String>'),
          CoreMapField<String, String>( // Map<K, V>
            id: 'testStringMap',
            initialValue: const {
              'key1': 'value1',
              'key2': 'value2',
            },
          ),
          const Text('Address'),
          AddressForm(),
          ElevatedButton(
            onPressed: _handleSubmit,
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

void main2() {
  runApp(MaterialApp(
    home: Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: RegistrationForm(),
        )
      )
    ),
  ));
}

// TODO: Reload button in ErrorHandlerWidget should also download the latest script
// TODO: maybe remove @style, use @props instead
// TODO: Page cannot have @state (Null check operator used on a null value)

void main() {
  // For direct source code
  // runApp(MaterialApp(
  //   home: Scaffold(
  //     body: FScriptRoot(
  //       initialSource: source,
  //       loadingBuilder: (message) => Center(
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             const CircularProgressIndicator(),
  //             const SizedBox(height: 16),
  //             Text(message),
  //           ],
  //         )
  //       ),
  //       errorBuilder: (error, stackTrace, onReload) => ErrorHandlerWidget(
  //         error: error,
  //         stackTrace: stackTrace?.toString(),
  //         onReload: onReload
  //       ),
  //     ),
  //   ),
  // ));

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return ErrorHandlerWidget(
      error: details.exception.toString(),
      stackTrace: details.stack.toString(),
      onReload: () => ScriptReloadService().reload(),
    );
  };

  runApp(MaterialApp(
    home: Scaffold(
      body: FScriptRoot(
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
  ));
}