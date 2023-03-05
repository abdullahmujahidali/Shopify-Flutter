import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../generated/l10n.dart';
import '../../models/index.dart';
import '../../services/services.dart';
import '../../widgets/common/flux_image.dart';
import '../../widgets/common/login_animation.dart';

class VerifyCode extends StatefulWidget {
  final String? phoneNumber;
  final String? verId;
  final Stream? verifySuccessStream;
  final int? resendToken;
  final Function(String, User)? callback;

  const VerifyCode(
      {this.verId,
      this.phoneNumber,
      this.verifySuccessStream,
      this.resendToken,
      this.callback});

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode>
    with TickerProviderStateMixin, CodeAutoFill {
  late AnimationController _loginButtonController;
  bool isLoading = false;

  final TextEditingController _pinCodeController = TextEditingController();

  bool hasError = false;
  String currentText = '';
  var onTapRecognizer;
  int? _resendToken;
  String? _verId;

  @override
  void codeUpdated() {
    if (mounted && code != null && code!.isNotEmpty) {
      _loginSMS(code, context);
      setState(() {});
      Tools.hideKeyboard(context);
    }
  }

  Future<void> _verifySuccessStreamListener(credential) async {
    _pinCodeController.text = credential.smsCode!;
    Tools.hideKeyboard(context);
  }

  @override
  void initState() {
    super.initState();
    _resendToken = widget.resendToken;
    _verId = widget.verId;
    widget.verifySuccessStream?.listen(_verifySuccessStreamListener);

    listenForCode();

    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        _playAnimation();
        Future autoRetrieve(String verId) {
          return _stopAnimation();
        }

        Future smsCodeSent(String verId, [int? forceCodeResend]) {
          _resendToken = forceCodeResend;
          _verId = verId;
          return _stopAnimation();
        }

        void verifyFailed(exception) {
          _stopAnimation();
          _failMessage(exception.toString(), context);
        }

        Services().firebase.verifyPhoneNumber(
              phoneNumber: widget.phoneNumber,
              codeAutoRetrievalTimeout: autoRetrieve,
              codeSent: smsCodeSent,
              verificationCompleted: (credential) {},
              forceResendingToken: _resendToken,
              verificationFailed: verifyFailed,
            );
      };

    _loginButtonController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    widget.verifySuccessStream?.listen(null);
    _loginButtonController.dispose();
    _pinCodeController.dispose();
    cancel();
    super.dispose();
  }

  Future _playAnimation() async {
    try {
      setState(() {
        isLoading = true;
      });
      await _loginButtonController.forward();
    } on TickerCanceled {
      printLog('[_playAnimation] error');
    }
  }

  Future _stopAnimation() async {
    try {
      await _loginButtonController.reverse();
      setState(() {
        isLoading = false;
      });
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

  void _loginSMS(smsCode, context) async {
    await _playAnimation();
    try {
      final credential = Services().firebase.getFirebaseCredential(
            verificationId: _verId!,
            smsCode: smsCode,
          );
      await _signInWithCredential(credential);
    } catch (e) {
      await _stopAnimation();
      _failMessage(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appModel = Provider.of<AppModel>(context, listen: true);
    final themeConfig = appModel.themeConfig;

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
                            ? ' ${widget.phoneNumber?.replaceAll('+', '')}+'
                            : ' +${widget.phoneNumber?.replaceAll('+', '')}',
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
                    if (value.length == 6) _loginSMS(value, context);
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
                    _loginSMS(_pinCodeController.text, context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signInWithCredential(credential) async {
    final user = await Services()
        .firebase
        .loginFirebaseCredential(credential: credential);
    if (user != null) {
      if (widget.callback != null) {
        await _stopAnimation();
        widget.callback!(_pinCodeController.text, user);
        Navigator.pop(context);
      } else {
        await Provider.of<UserModel>(context, listen: false).loginFirebaseSMS(
          phoneNumber: user.phoneNumber!.replaceAll('+', ''),
          success: (user) {
            _stopAnimation();
            NavigateTools.navigateAfterLogin(user, context);
          },
          fail: (message) {
            _stopAnimation();
            _failMessage(message, context);
          },
        );
      }
    } else {
      await _stopAnimation();
      _failMessage(S.of(context).invalidSMSCode, context);
    }
  }
}
