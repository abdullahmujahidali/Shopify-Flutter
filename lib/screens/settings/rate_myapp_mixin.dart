import 'package:flutter/material.dart';
import 'package:rate_my_app/rate_my_app.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../generated/l10n.dart';

mixin RateMyAppMixin<T extends StatefulWidget> on State<T> {
  final _rateMyApp = RateMyApp(
    // rate app on store
    minDays: 7,
    minLaunches: 10,
    remindDays: 7,
    remindLaunches: 10,
    googlePlayIdentifier: kStoreIdentifier['android'],
    appStoreIdentifier: kStoreIdentifier['ios'],
  );

  void showRateMyApp() {
    _rateMyApp.showRateDialog(
      context,
      title: S.of(context).rateTheApp,
      // The dialog title.
      message: S.of(context).rateThisAppDescription,
      // The dialog message.
      rateButton: S.of(context).rate.toUpperCase(),
      // The dialog 'rate' button text.
      noButton: S.of(context).noThanks.toUpperCase(),
      // The dialog 'no' button text.
      laterButton: S.of(context).maybeLater.toUpperCase(),
      // The dialog 'later' button text.
      listener: (button) {
        // The button click listener (useful if you want to cancel the click event).
        switch (button) {
          case RateMyAppDialogButton.rate:
            break;
          case RateMyAppDialogButton.later:
            break;
          case RateMyAppDialogButton.no:
            break;
        }

        return true; // Return false if you want to cancel the click event.
      },
      // Set to false if you want to show the native Apple app rating dialog on iOS.
      dialogStyle: const DialogStyle(),
      // Custom dialog styles.
      // Called when the user dismissed the dialog (either by taping outside or by pressing the 'back' button).
      // actionsBuilder: (_) => [], // This one allows you to use your own buttons.
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.endOfFrame.then((_) async {
      if (mounted) {
        await _rateMyApp.init();

        if (isMobile && !kStoreIdentifier['disable']) {
          // state of rating the app
          if (_rateMyApp.shouldOpenDialog) {
            showRateMyApp();
          }
        }
      }
    });
  }
}
