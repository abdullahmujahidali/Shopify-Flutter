import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../common/tools/navigate_tools.dart';
import '../../data/boxes.dart';
import '../../generated/l10n.dart';
import '../../models/notification_model.dart';
import '../../services/services.dart';
import '../common/permission_request_mixin.dart';

class NotificationRequestScreen extends StatefulWidget {
  const NotificationRequestScreen({Key? key}) : super(key: key);

  @override
  State<NotificationRequestScreen> createState() =>
      _NotificationRequestScreenState();
}

class _NotificationRequestScreenState extends State<NotificationRequestScreen>
    with PermissionRequestMixin {
  NotificationModel get _notificationModel => context.read<NotificationModel>();

  @override
  IconData get permissionIcon => CupertinoIcons.bell_fill;

  @override
  String get permissionRequestTitle => S.of(context).notifyLatestOffer;

  @override
  String get permissionRequestSubtitle =>
      S.of(context).weWillSendYouNotification;

  @override
  Future<void> onAcceptPermission() async {
    await _notificationModel.enableNotification();
    _gotoNextScreen();
  }

  @override
  Future<void> onDeclinePermission() async {
    _notificationModel.disableNotification();
    _gotoNextScreen();
  }

  void _gotoNextScreen() {
    SettingsBox().hasFinishedOnboarding = true;
    if (Services().widget.isRequiredLogin) {
      NavigateTools.navigateToLogin(
        context,
        replacement: true,
      );
      return;
    }
    if (kAdvanceConfig.gdprConfig.showPrivacyPolicyFirstTime) {
      Navigator.of(context).pushReplacementNamed(
        RouteList.privacyTerms,
      );
    } else {
      Navigator.of(context).pushReplacementNamed(RouteList.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    permissionIcon,
                    size: 48,
                    color: Colors.amber,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    S.of(context).getNotified,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    permissionRequestSubtitle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                flex: 3,
                child: Lottie.asset(
                  'assets/images/get_notified.json',
                  alignment: Alignment.center,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  TextButton(
                    onPressed: onDeclinePermission,
                    child: Text(S.of(context).skip),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: onAcceptPermission,
                    child: Text(
                      S.of(context).imIn,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
