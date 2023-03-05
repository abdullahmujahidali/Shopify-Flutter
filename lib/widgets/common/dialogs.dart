import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';

Future<dynamic> showDialogNotInternet(BuildContext context) {
  return showDialog(
    context: context,
    builder: (subContext) {
      return CupertinoAlertDialog(
        title: Center(
          child: Row(
            children: <Widget>[
              const Icon(
                Icons.warning,
              ),
              Text(S.of(context).noInternetConnection),
            ],
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(S.of(context).pleaseCheckInternet),
        ),
      );
    },
  );
}

Future<dynamic> showDialogNewAppConfig(BuildContext context,
    {Function? onNext}) {
  return showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(S.of(context).newAppConfig),
      content: Text(S.of(context).seeNewAppConfig),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            onNext?.call();
            Navigator.of(dialogContext).pop(true);
          },
          child: Text(S.of(context).ok),
        ),
      ],
    ),
  );
}
