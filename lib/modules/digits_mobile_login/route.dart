import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../screens/login_sms/login_sms_viewmodel.dart';
import '../../services/services.dart';
import 'views/digits_mobile_login_screen.dart';
import 'views/digits_mobile_login_sign_up_screen.dart';

class DigitsMobileLoginRoute {
  static dynamic getRoutesWithSettings(RouteSettings settings) {
    final routes = {
      RouteList.digitsMobileLoginSignUp: (context) =>
          const DigitsMobileLoginSignUpScreen(),
      RouteList.digitsMobileLogin: (context) =>
          ChangeNotifierProvider<LoginSmsViewModel>(
            create: (_) => LoginSmsViewModel(Services().firebase),
            child: const DigitsMobileLoginScreen(),
          ),
    };
    return routes;
  }

  static Widget errorPage(String title) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Text(title),
        ),
      );
}
