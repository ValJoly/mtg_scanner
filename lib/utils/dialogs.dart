// will be used to create dialogs for the app and replace the current dialog implementation in the app.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mtg_scanner/pages/dialog_page.dart';

class Dialogs {
  static DialogPage customDialog(
      {String title = 'Erreur',
      String message = 'Une erreur est survenue',
      String buttonText = 'OK',
      Function? onPressed}) {
    return DialogPage(
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              if (onPressed != null) {
                onPressed();
              } else {
                context.pop();
              }
            },
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}
