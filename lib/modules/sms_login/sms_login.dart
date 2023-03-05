import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/error_codes/error_codes.dart';
import '../../../../generated/l10n.dart';
import '../../../../models/entities/user.dart';
import '../../models/entities/firebase_error_exception.dart';
import '../../widgets/common/loading_body.dart';
import 'sms_info.dart';
import 'sms_model.dart';
import 'v2/sms_input_phone_v2.dart';
import 'v2/sms_verify_v2.dart';

const _inputPhonePage = 0;
// const _verifyOTPPage = 1;
// const _completeInfoPage = 2;

class SMSLoginScreen extends StatelessWidget {
  final Function(User user) onSuccess;

  const SMSLoginScreen({Key? key, required this.onSuccess}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SMSModel>(
        create: (_) => SMSModel(),
        lazy: false,
        child: SMSIndex(
          onSuccess: onSuccess,
        ));
  }
}

class SMSIndex extends StatefulWidget {
  final Function(User user) onSuccess;

  const SMSIndex({Key? key, required this.onSuccess}) : super(key: key);

  @override
  State<SMSIndex> createState() => _SMSIndexState();
}

class _SMSIndexState extends State<SMSIndex> {
  final _pageController = PageController();

  void _goToPage(int index) {
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  void _showMessage(err) {
    if (err is ErrorType) {
      if (err == ErrorType.loginSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(err.getMessage(context)),
          duration: const Duration(seconds: 1),
        ));

        Future.delayed(const Duration(seconds: 3)).then((value) {
          Navigator.pop(context);
        });
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(err.getMessage(context)),
        duration: const Duration(seconds: 3),
      ));
      return;
    }

    if (err is FirebaseErrorException) {
      if (err.code == 'invalid-phone-number') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(S.of(context).invalidPhoneNumber),
          duration: const Duration(seconds: 3),
        ));
        return;
      }

      if (err.code == 'too-many-requests') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(S.of(context).requestTooMany),
          duration: const Duration(seconds: 3),
        ));
        return;
      }

      if (err.code == 'invalid-verification-code') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(S.of(context).invalidSMSCode),
          duration: const Duration(seconds: 3),
        ));
        return;
      }

      if (err.code == 'session-expired') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(S.of(context).smsCodeExpired),
          duration: const Duration(seconds: 3),
        ));
        return;
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(err.toString()),
      duration: const Duration(seconds: 5),
    ));
  }

  Future<void> verifyUser() async {
    final model = Provider.of<SMSModel>(context, listen: false);
    final isVerified = await model.smsVerify(_showMessage);
    if (isVerified) {
      final isUserExisted = await model.isPhoneNumberExisted();
      if (isUserExisted) {
        try {
          final user = await model.login();
          if (user != null) {
            widget.onSuccess(user);
          }
          return;
        } catch (e) {
          _showMessage(e);
          return;
        }
      }

      /// Go to info page
      _goToPage(2);
    }
  }

  Future<void> createAndLogin(data) async {
    final model = Provider.of<SMSModel>(context, listen: false);
    try {
      final user = await model.createUser(data);
      if (user != null) {
        _showMessage(ErrorType.registerSuccess);
        widget.onSuccess(user);
        return;
      }
    } catch (e) {
      _showMessage(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var canPop = ModalRoute.of(context)?.canPop ?? false;

    final model = Provider.of<SMSModel>(context, listen: false);
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: theme.colorScheme.background,
        elevation: 0.0,
        leading: AnimatedBuilder(
          animation: _pageController,
          builder: (context, child) {
            final index = _pageController.page ?? _inputPhonePage;
            if (index == _inputPhonePage) {
              if (!canPop) {
                return const SizedBox();
              }
              return BackButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
              );
            }
            return BackButton(
              onPressed: () {
                _pageController.animateToPage(
                  _inputPhonePage,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              },
            );
          },
        ),
      ),
      body: Selector<SMSModel, bool>(
        selector: (context, provider) =>
            provider.state == SMSModelState.loading,
        builder: (context, isLoading, child) {
          return LoadingBody(
            isLoading: isLoading,
            child: child!,
          );
        },
        child: ElevatedButtonTheme(
          data: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: [
              SMSInputPhoneV2(
                onCallBack: () {
                  model.sendOTP(
                    onPageChanged: () => _goToPage(1),
                    onMessage: _showMessage,
                    onVerify: verifyUser,
                  );
                },
              ),
              SMSVerifyV2(
                onCallBack: verifyUser,
                onResend: (startTimer) {
                  model.sendOTP(
                    onMessage: _showMessage,
                    onPageChanged: startTimer,
                    onVerify: verifyUser,
                  );
                },
              ),
              SMSInfo(
                onSuccess: (data) {
                  createAndLogin(data);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
