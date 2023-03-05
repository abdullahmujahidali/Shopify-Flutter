import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:inspireui/utils/logs.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../../common/tools/navigate_tools.dart';
import '../../../common/tools/tools.dart';
import '../../../generated/l10n.dart';
import '../../../models/app_model.dart';
import '../../../models/user_model.dart';
import '../../../widgets/common/flux_image.dart';
import '../../../widgets/common/login_animation.dart';
import '../services/index.dart';

class DigitsMobileVerifyArgs {
  const DigitsMobileVerifyArgs(
      {this.username,
      this.email,
      this.countryCode,
      this.mobile,
      required this.isRegister});

  final String? username;
  final String? email;
  final String? countryCode;
  final String? mobile;
  final bool isRegister;
}

class DigitsMobileVerifyScreen extends StatefulWidget {
  final DigitsMobileVerifyArgs? args;

  const DigitsMobileVerifyScreen({this.args});

  @override
  State<DigitsMobileVerifyScreen> createState() =>
      _DigitsMobileVerifyScreenState();
}

class _DigitsMobileVerifyScreenState extends State<DigitsMobileVerifyScreen>
    with TickerProviderStateMixin, CodeAutoFill {
  late AnimationController _loginButtonController;

  final TextEditingController _pinCodeController = TextEditingController();

  final _services = DigitsMobileLoginServices();

  bool hasError = false;
  String currentText = '';
  var onTapRecognizer;

  @override
  void codeUpdated() {
    if (mounted && code != null && code!.isNotEmpty) {
      _verify(code!, context);
      setState(() {});
      Tools.hideKeyboard(context);
    }
  }

  @override
  void initState() {
    super.initState();
    listenForCode();

    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () async {
        try {
          await _playAnimation();
          await _services.resendOTP(
              countryCode: widget.args?.countryCode,
              mobile: widget.args?.mobile,
              forRegister: widget.args?.isRegister ?? true);
          await _stopAnimation();
        } catch (e) {
          await _stopAnimation();
          _failMessage(e.toString(), context);
        }
      };

    _loginButtonController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _loginButtonController.dispose();
    _pinCodeController.dispose();
    cancel();
    super.dispose();
  }

  Future _playAnimation() async {
    try {
      await _loginButtonController.forward();
    } on TickerCanceled {
      printLog('[_playAnimation] error');
    }
  }

  Future _stopAnimation() async {
    try {
      await _loginButtonController.reverse();
    } on TickerCanceled {
      printLog('[_stopAnimation] error');
    }
  }

  void _failMessage(message, context) {
    /// Showing Error messageSnackBarDemo
    /// Ability so close message
    // var _message = message;
    // if (kReleaseMode) {
    //   _message = S.of(context).UserNameInCorrect;
    // }

    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 30),
      action: SnackBarAction(
        label: S.of(context).close,
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final appModel = Provider.of<AppModel>(context, listen: true);
    final themeConfig = appModel.themeConfig;
    final phoneNumber =
        ((widget.args?.countryCode ?? '') + (widget.args?.mobile ?? ''));
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          S.of(context).verifySMSCode,
          style: TextStyle(
            fontSize: 16.0,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 100),
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        height: 40.0,
                        child: FluxImage(imageUrl: themeConfig.logo)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                S.of(context).phoneNumberVerification,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: RichText(
                  text: TextSpan(
                    text: S.of(context).enterSendedCode,
                    children: [
                      TextSpan(
                        text: Tools.isRTL(context)
                            ? ' ${phoneNumber.replaceAll('+', '')}+'
                            : ' +${phoneNumber.replaceAll('+', '')}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 15,
                            ),
                      ),
                    ],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color
                              ?.withOpacity(0.54),
                          fontSize: 15,
                        ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: PinCodeTextField(
                  appContext: context,
                  controller: _pinCodeController,
                  keyboardType: TextInputType.number,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.underline,
                    borderWidth: 2,
                    activeFillColor: Theme.of(context).colorScheme.background,
                    disabledColor: Theme.of(context).disabledColor,
                  ),
                  length: 6,
                  cursorHeight: 30,
                  autoFocus: true,
                  obscuringCharacter: '*',
                  textStyle:
                      Theme.of(context).primaryTextTheme.displaySmall!.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                  animationType: AnimationType.scale,
                  hapticFeedbackTypes: HapticFeedbackTypes.light,
                  useHapticFeedback: true,
                  autoDisposeControllers: false,
                  animationDuration: const Duration(milliseconds: 300),
                  onChanged: (value) {
                    if (value.length == 6) _verify(value, context);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              // error showing widget
              child: Text(
                hasError ? S.of(context).pleasefillUpAllCellsProperly : '',
                style: TextStyle(color: Colors.red.shade300, fontSize: 15),
              ),
            ),
            const SizedBox(height: 20),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: S.of(context).didntReceiveCode,
                  style: const TextStyle(fontSize: 15),
                  children: [
                    TextSpan(
                        text: S.of(context).resend,
                        recognizer: onTapRecognizer,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ))
                  ]),
            ),
            const SizedBox(height: 14),
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 30,
              ),
              child: StaggerAnimation(
                titleButton: S.of(context).verifySMSCode,
                buttonController:
                    _loginButtonController.view as AnimationController,
                onTap: () {
                  if (_pinCodeController.text.trim().length == 6) {
                    _verify(_pinCodeController.text, context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _verify(String smsCode, BuildContext context) async {
    try {
      await _playAnimation();
      final loggedInUser = widget.args?.isRegister == true
          ? await _services.signUp(
              username: widget.args?.username ?? '',
              email: widget.args?.email ?? '',
              countryCode: widget.args?.countryCode ?? '',
              mobile: widget.args?.mobile ?? '',
              otp: smsCode)
          : await _services.login(
              countryCode: widget.args?.countryCode ?? '',
              mobile: widget.args?.mobile ?? '',
              otp: smsCode);
      await Provider.of<UserModel>(context, listen: false)
          .setUser(loggedInUser);
      await _stopAnimation();
      NavigateTools.navigateAfterLogin(loggedInUser, context);
    } catch (e) {
      await _stopAnimation();
      _failMessage(e.toString(), context);
    }
  }
}
