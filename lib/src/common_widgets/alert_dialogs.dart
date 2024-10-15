import 'dart:io';

import '../localization/string_hardcoded.dart';
import '../routing/app_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const kDialogDefaultKey = Key('dialog-default-key');

/// Generic function to show a platform-aware Material or Cupertino dialog
Future<bool?> showAlertDialog({
  required BuildContext context,
  required String title,
  String? content,
  String? cancelActionText,
  String defaultActionText = 'OK',
}) async {
  return showDialog(
    context: context,
    // * Only make the dialog dismissible if there is a cancel button
    barrierDismissible: cancelActionText != null,
    // * AlertDialog.adaptive was added in Flutter 3.13
    builder: (context) => Consumer(builder: (_, ref, __) {
      final goRouter = ref.read(goRouterProvider);

      return AlertDialog.adaptive(
        title: Text(title),
        content: content != null ? Text(content) : null,
        // * Use [TextButton] or [CupertinoDialogAction] depending on the platform
        actions: kIsWeb || !Platform.isIOS
            ? <Widget>[
                if (cancelActionText != null)
                  TextButton(
                    child: Text(cancelActionText),
                    onPressed: () => goRouter.pop(false),
                  ),
                TextButton(
                  key: kDialogDefaultKey,
                  child: Text(defaultActionText),
                  onPressed: () => goRouter.pop(true),
                ),
              ]
            : <Widget>[
                if (cancelActionText != null)
                  CupertinoDialogAction(
                    child: Text(cancelActionText),
                    onPressed: () => goRouter.pop(false),
                  ),
                CupertinoDialogAction(
                  key: kDialogDefaultKey,
                  child: Text(defaultActionText),
                  onPressed: () => goRouter.pop(true),
                ),
              ],
      );
    }),
  );
}

/// Generic function to show a platform-aware Material or Cupertino error dialog
Future<void> showExceptionAlertDialog({
  required BuildContext context,
  required String title,
  required dynamic exception,
}) =>
    showAlertDialog(
      context: context,
      title: title,
      content: exception.toString(),
      defaultActionText: 'OK'.hardcoded,
    );

Future<void> showNotImplementedAlertDialog({required BuildContext context}) =>
    showAlertDialog(
      context: context,
      title: 'Not implemented'.hardcoded,
    );
