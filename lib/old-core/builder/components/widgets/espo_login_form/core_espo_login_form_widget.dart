import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

class CoreEspoLoginFormWidget extends CoreBaseForm {
  const CoreEspoLoginFormWidget({
    super.key,
    super.onSubmit,
    super.builder,
    super.initialValues
  });

  @override
  EspoLoginFormState createState() => EspoLoginFormState();
}

class EspoLoginFormState extends CoreBaseFormState {
  late bool passwordVisibility;

  @override
  void initState() {
    super.initState();
    passwordVisibility = false;
  }

  @override
  Widget? buildForm(formKey, context, formState) {
    // TODO: this is a workaround for the error messages of the form fields not translating
    // NOTE: but can't be used normally because it validates the form on every build
    //       meaning that the error messages (if any) will be shown even on the first load
    formKey.currentState?.validate();

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 32, 16, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          color: Colors.black,
                          size: 64,
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                            child: EspoVarcharField(
                              id: 'username',
                              required: true,
                              initialValue: getInitialValue('username'),
                              options: CoreFieldOptions(
                                label: I18n.text('login-label-username'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Icon(
                          Icons.key,
                          color: Colors.black,
                          size: 64,
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                            child: EspoPasswordField(
                              id: 'password',
                              required: true,
                              initialValue: getInitialValue('password'),
                              options: CoreFieldOptions(
                                label: I18n.text('login-label-password'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 16),
                      child: EspoTextButton(
                        onPressed: (state) {
                          formState.submit();
                        },
                        child: Center(
                          child: I18n.text('login-button-login')
                        ),
                      )
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}