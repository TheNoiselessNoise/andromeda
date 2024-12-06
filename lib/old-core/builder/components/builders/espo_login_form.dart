import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

class EspoLoginFormWidgetBuilder {
  static Widget buildCoreEspoLoginForm(BuildContext context, JsonC component, ParentContext parentContext) {
    JsonEspoLoginFormInfo elfInfo = component.info.espoLoginFormInfo;

    return CoreEspoLoginFormWidget(
      onSubmit: (state) async {
        CoreDialog.titledLoading(context, "Přihlašování...");

        EspoLoginData loginData = EspoLoginData(
          username: state.formData['username'],
          password: state.formData['password']
        );

        LoginResult result = await EspoLoginUser.requestLogin(loginData);

        if (result == LoginResult.failed) {
          if (context.mounted) {
            CoreNavigator.popLast(context);
            CoreSnackbar.basic(context, "Přihlášení se nezdařilo");
          }
          return;
        }

        if (context.mounted && result == LoginResult.success) {
          CoreNavigator.popLast(context);
          CoreSnackbar.basic(context, "Přihlášení proběhlo úspěšně");
          ActionBuilder.call(context, elfInfo.onLoggedIn, parentContext);
        }
      },
    );
  }
}