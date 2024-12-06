import 'dart:io';
import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class TestingPageTwo extends CoreBaseStatefulWidget {
  const TestingPageTwo({super.key});

  @override
  CoreBaseState createState() => TestingPageTwoState();
}

class TestingPageTwoState extends CoreBaseState<TestingPageTwo> {
  late WebSocketChannel channel;

  @override
  void initState() {
    super.initState();
    channel = WebSocketChannel.connect(Uri.parse(AppConfig.wsUrl));
  }

  @override
  AppBar? buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: const Text("Testing"),
    );
  }

  @override
  Widget buildContent(BuildContext context) {
    return SafeArea(
      top: true,
      child: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: channel.stream,
              builder: (context, snapshot) {
                return Text(snapshot.hasData ? '${snapshot.data}' : '');
              },
            ),
            EspoTextButton(
              onPressed: (state) async {
              },
              child: const Center(
                child: Text('TEST')
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: CoreEspoLoginFormWidget(
                  onSubmit: (formState) {
                    CoreToast.show('Form submitted');
                  },
                )
            ),
            CoreEspoLoginFormWidget(
              onSubmit: (formState) {
                log(formState.formData);
              },
              builder: (formKey, context, formState) {
                return Column(
                  children: [
                    const Center(child: Text('Phone')),
                    Row(
                      children: [
                        Expanded(
                            child: EspoPhoneField(
                              id: 'phone',
                              initialValue: EspoPhone(
                                countryCode: '420',
                                number: '123456789',
                              ),
                              options: const CoreFieldOptions(
                                label: Text('Phone'),
                              ),
                            )
                        ),
                      ],
                    ),
                    const Center(child: Text('Slider')),
                    const Row(
                      children: [
                        Expanded(
                            child: EspoSliderField(
                              id: 'slider',
                              initialValue: 50,
                              options: CoreFieldOptions(
                                label: Text('Slider'),
                              ),
                            )
                        ),
                      ],
                    ),
                    const Center(child: Text('Range')),
                    const Row(
                      children: [
                        Expanded(
                            child: EspoRangeField(
                              id: 'range',
                              initialValue: RangeValues(0, 100),
                              options: CoreFieldOptions(
                                label: Text('Range'),
                              ),
                            )
                        ),
                      ],
                    ),
                    const Center(child: Text('Multi Enum')),
                    Row(
                      children: [
                        Expanded(
                            child: EspoMultiEnumField<int>(
                              id: 'multi-enum',
                              items: const [0, 10, 100, 1000],
                              itemLabelBuilder: (item) => Text(NumberFormat.simpleCurrency().format(item)),
                              options: const CoreFieldOptions(
                                label: Text('Multi Enum'),
                              ),
                              // dropdownWidget: const Padding(
                              //   padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                              //   child: Text('Multi Enum'),
                              // ),
                            )
                        ),
                      ],
                    ),
                    const Center(child: Text('Enum')),
                    Row(
                      children: [
                        Expanded(
                            child: EspoEnumField<int>(
                              id: 'enum',
                              items: const [0, 10, 100, 1000],
                              itemLabelBuilder: (item) => Text(NumberFormat.simpleCurrency().format(item)),
                              options: const CoreFieldOptions(
                                label: Text('Enum'),
                              ),
                            )
                        ),
                      ],
                    ),
                    const Center(child: Text('Password')),
                    const Row(
                      children: [
                        Expanded(
                            child: EspoPasswordField(
                              id: 'password',
                              initialValue: 'password',
                              options: CoreFieldOptions(
                                label: Text('Password'),
                              ),
                            )
                        ),
                      ],
                    ),
                    const Center(child: Text('Address')),
                    const Row(
                      children: [
                        Expanded(
                            child: EspoAddressField(
                              id: 'address',
                              initialValue: EspoAddress(
                                city: 'City',
                                country: 'Country',
                                postalCode: '12345',
                                state: 'State',
                                street: 'Street',
                              ),
                              options: CoreFieldOptions(
                                label: Text('Address'),
                              ),
                            )
                        ),
                      ],
                    ),
                    const Center(child: Text('DateTime')),
                    Row(
                      children: [
                        Expanded(
                            child: EspoDateTimeField(
                              id: 'time',
                              initialValue: DateTime.now(),
                              options: const CoreFieldOptions(
                                label: Text('DateTime'),
                              ),
                            )
                        ),
                      ],
                    ),
                    const Center(child: Text('Date')),
                    Row(
                      children: [
                        Expanded(
                            child: EspoDateField(
                              id: 'date',
                              initialValue: DateTime.now(),
                              options: const CoreFieldOptions(
                                label: Text('Date'),
                              ),
                            )
                        ),
                      ],
                    ),
                    const Center(child: Text('Time')),
                    Row(
                      children: [
                        Expanded(
                            child: EspoTimeField(
                              id: 'time',
                              initialValue: DateTime.now(),
                              options: const CoreFieldOptions(
                                label: Text('Time'),
                              ),
                            )
                        ),
                      ],
                    ),
                    const Center(child: Text('Int')),
                    const Row(
                      children: [
                        Expanded(
                            child: EspoIntField(
                              id: 'int',
                              initialValue: 123,
                              options: CoreFieldOptions(
                                label: Text('Int'),
                              ),
                            )
                        ),
                      ],
                    ),
                    const Center(child: Text('Float')),
                    const Row(
                      children: [
                        Expanded(
                            child: EspoFloatField(
                              id: 'float',
                              initialValue: 123.45,
                              options: CoreFieldOptions(
                                label: Text('Float'),
                              ),
                            )
                        ),
                      ],
                    ),
                    const Center(child: Text('Text')),
                    const Row(
                      children: [
                        Expanded(
                            child: EspoTextField(
                              id: 'text',
                              initialValue: 'Some very looooooooooooooooooooong text loooool',
                              options: CoreFieldOptions(
                                label: Text('Text'),
                              ),
                            )
                        ),
                      ],
                    ),
                    const Center(child: Text('Bool')),
                    const Row(
                      children: [
                        Expanded(
                            child: EspoBoolField(
                              id: 'bool',
                              showAsCheckbox: true,
                              options: CoreFieldOptions(
                                label: Text('Bool'),
                              ),
                            )
                        ),
                      ],
                    ),
                    const Center(child: Text('Email')),
                    const Row(
                      children: [
                        Expanded(
                            child: EspoEmailField(
                              id: 'email',
                              initialValue: 'name@domain.cz',
                              options: CoreFieldOptions(
                                label: Text('Email'),
                              ),
                            )
                        ),
                      ],
                    ),
                    const Center(child: Text('File/s')),
                    Row(
                      children: [
                        Expanded(
                            child: EspoFileField(
                              id: 'file',
                              initialValue: [
                                File('file1.pdf'),
                                File('file2.zip'),
                              ],
                              options: const CoreFieldOptions(
                                label: Text('File/s'),
                              ),
                            )
                        ),
                      ],
                    ),
                    const Center(child: Text('Varchar')),
                    const Row(
                      children: [
                        Expanded(
                          child: EspoVarcharField(
                            id: 'first_name',
                            initialValue: 'John',
                            required: true,
                            options: CoreFieldOptions(
                              label: Text('First Name'),
                            ),
                          ),
                        ),
                        Expanded(
                          child: EspoVarcharField(
                            id: 'last_name',
                            initialValue: 'Doe',
                            required: true,
                            options: CoreFieldOptions(
                              label: Text('Last Name'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Center(child: Text('Image/s')),
                    const Row(
                      children: [
                        Expanded(
                          child: EspoImageField(
                            id: 'logo',
                            assetPath: ResourceImage.appLogo,
                            options: CoreFieldOptions(
                              label: Text('Image/s'),
                            ),
                          )
                        ),
                      ],
                    ),
                    const Center(child: Text('MultiSelectDropDownField')),
                    Row(
                      children: [
                        Expanded(
                          child: MultiSelectDropDownField<String>(
                            id: 'multi-select-dropdown',
                            required: true,
                            selectOptions: const {
                              'TEST 1': 'item1',
                              'TEST 2': 'item2',
                              'TEST 3': 'item3',
                            },
                            options: const CoreFieldOptions(
                              label: Text('MultiSelectDropDownField'),
                            ),
                          )
                        )
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        formState.submit();
                      },
                      child: const Text('Submit')
                    )
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // if (!isLoggedIn) {
    //   return const Center(child: CircularProgressIndicator());
    // }
    return super.build(context);
  }
}