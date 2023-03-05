import 'package:flutter/material.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../services/service_config.dart';
import 'apple_sign_in_button.dart';
import 'facebook_sign_in_button.dart';
import 'google_sign_in_button.dart';
import 'sms_sign_in_button.dart';

class SocialLoginButtonRow extends StatefulWidget {
  final VoidCallback? onApplePressed;
  final VoidCallback? onFacebookPressed;
  final VoidCallback? onGooglePressed;
  final VoidCallback? onSmsPressed;

  const SocialLoginButtonRow({
    super.key,
    this.onApplePressed,
    this.onFacebookPressed,
    this.onGooglePressed,
    this.onSmsPressed,
  });

  @override
  State<SocialLoginButtonRow> createState() => _SocialLoginButtonRowState();
}

class _SocialLoginButtonRowState extends State<SocialLoginButtonRow> {
  bool get defaultAppleLoginAvailable => isIos || ServerConfig().isBuilder;
  late bool _isAppleLoginAvailable = defaultAppleLoginAvailable;

  /// Check if Apple login is available then update the [_isCheckingAppleLoginAvailability] to false.
  /// to enable tap on the Apple login button.
  late bool _isCheckingAppleLoginAvailability = defaultAppleLoginAvailable;

  /// Show the Apple login button if enabled
  /// in [kLoginSetting.showAppleLogin] config
  /// and the Apple login is available.
  bool get showAppleButton =>
      kLoginSetting.showAppleLogin &&
      (_isCheckingAppleLoginAvailability || _isAppleLoginAvailable);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then((_) async {
      if (_isCheckingAppleLoginAvailability) {
        try {
          _isAppleLoginAvailable =
              ServerConfig().isBuilder || (await TheAppleSignIn.isAvailable());

          _isCheckingAppleLoginAvailability = false;
          if (mounted) {
            setState(() {});
          }
        } catch (err, trace) {
          printError(err, trace, '[SocialLoginButtonRow] initState error');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const horizontalPadding = 16.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
          width: showAppleButton ? 50 + horizontalPadding * 2 : 0,
          height: showAppleButton ? 50 : 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: horizontalPadding,
            ),
            child: SignInButtonApple(
              enabled: !_isCheckingAppleLoginAvailability,
              onPressed: () => widget.onApplePressed?.call(),
            ),
          ),
        ),
        if (kLoginSetting.showFacebook)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: horizontalPadding,
            ),
            child: SignInButtonFacebook(
              onPressed: () => widget.onFacebookPressed?.call(),
            ),
          ),
        if (kLoginSetting.showGoogleLogin)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: horizontalPadding,
            ),
            child: SignInButtonGoogle(
              onPressed: () => widget.onGooglePressed?.call(),
            ),
          ),
        if (kLoginSetting.showSMSLogin)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: horizontalPadding,
            ),
            child: SignInButtonSms(
              onPressed: () => widget.onSmsPressed?.call(),
            ),
          ),
      ],
    );
  }
}
