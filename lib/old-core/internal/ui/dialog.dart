import 'package:flutter/material.dart';
import 'package:andromeda/old-core/core.dart';

enum TitledLoadingDialogDirection {
  top,
  left,
  right,
  bottom
}

class CoreDialog {
  static void loading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
              ],
            ),
          )
        );
      }
    );
  }

  static void titleTextWidgetsWithActions(BuildContext context, {
    Widget title = const Text('Title'),
    Widget content = const Text('Text'),
    List<Widget> actions = const [],
    bool? dismissible
  }) {
    showDialog(
      context: context,
      barrierDismissible: dismissible ?? true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title,
          content: content,
          actions: actions,
        );
      }
    );
  }

  static void titleTextWidgets(BuildContext context, {
    Widget title = const Text('Title'),
    Widget content = const Text('Text'),
    bool? dismissible
  }) {
    showDialog(
      context: context,
      barrierDismissible: dismissible ?? true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title,
          content: content,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      }
    );
  }

  static void titleTextString(BuildContext context, {
    String title = 'Title',
    String content = 'Text',
    bool? dismissible
  }) {
    titleTextWidgets(context,
      title: Text(title),
      content: Text(content),
      dismissible: dismissible
    );
  }

  static void titledLoading(BuildContext context, String title, {
    TitledLoadingDialogDirection direction = TitledLoadingDialogDirection.bottom
  }) {
    // Default: left
    Widget dialogContent = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(width: 20.0),
        Text(title)
      ],
    );

    if (direction == TitledLoadingDialogDirection.top) {
      dialogContent = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 20.0),
          Text(title)
        ],
      );
    } else if (direction == TitledLoadingDialogDirection.right) {
      dialogContent = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title),
          const SizedBox(width: 20.0),
          const CircularProgressIndicator(),
        ],
      );
    } else if (direction == TitledLoadingDialogDirection.bottom) {
      dialogContent = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title),
          const SizedBox(height: 20.0),
          const CircularProgressIndicator(),
        ],
      );
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: dialogContent,
              )
          );
        }
    );
  }

  static void translatedTitledLoading(BuildContext context, String key, {
    TitledLoadingDialogDirection direction = TitledLoadingDialogDirection.bottom
  }) {
    titledLoading(context, I18n.translate(key), direction: direction);
  }
}
