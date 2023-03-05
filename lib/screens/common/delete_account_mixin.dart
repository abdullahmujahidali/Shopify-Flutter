import 'package:flutter/cupertino.dart';

import '../../generated/l10n.dart';

mixin DeleteAccountMixin {
  Future<bool> showConfirmDeleteAccountDialog(BuildContext context) async {
    return await showCupertinoDialog(
          context: context,
          barrierDismissible: false,
          useRootNavigator: false,
          builder: (ctx) => CupertinoAlertDialog(
            title: Text(S.current.deleteAccount),
            content: Text(S.current.areYouSureDeleteAccount),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: Text(S.current.ok),
              ),
              CupertinoDialogAction(
                isDefaultAction: false,
                isDestructiveAction: false,
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(S.current.cancel),
              )
            ],
          ),
        ) ??
        false;
  }
}
