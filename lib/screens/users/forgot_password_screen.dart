import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../../services/index.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordScreen> {
  final TextEditingController forgotPasswordController =
      TextEditingController();

  bool isSubmitting = false;

  void onSubmitPassword(BuildContext context) async {
    var currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    var userName = forgotPasswordController.text;
    if (userName.isEmpty) {
      final snackBar = SnackBar(
        content: Text(S.of(context).emptyUsername),
        duration: const Duration(seconds: 3),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      return;
    }
    setState(() {
      isSubmitting = true;
    });

    try {
      await Services().widget.resetPassword(context, userName);
      setState(() {
        isSubmitting = false;
      });
    } catch (e) {
      setState(() {
        isSubmitting = false;
      });
      final snackBar = SnackBar(
        content: Text(e.toString()),
        duration: const Duration(seconds: 3),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void dispose() {
    forgotPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Builder(
        builder: (context) => SafeArea(
          child: Container(
            alignment: Alignment.center,
            width:
                screenSize.width / (2 / (screenSize.height / screenSize.width)),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    S.of(context).resetYourPassword,
                    style: TextStyle(
                        fontSize: 30.0, color: Theme.of(context).primaryColor),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  const Icon(
                    Icons.vpn_key,
                    color: Colors.orangeAccent,
                    size: 70.0,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    autocorrect: false,
                    controller: forgotPasswordController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: S.of(context).yourUsernameEmail,
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  InkWell(
                    onTap: () =>
                        isSubmitting ? null : onSubmitPassword(context),
                    child: Container(
                      height: 50.0,
                      width: 200.0,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25.0)),
                      ),
                      child: Center(
                        child: Text(
                          isSubmitting
                              ? S.of(context).loading
                              : S.of(context).getPasswordLink,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
