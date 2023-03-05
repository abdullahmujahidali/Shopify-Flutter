import 'package:flutter/cupertino.dart';

import '../../generated/l10n.dart';

enum ErrorType {
  loginFailed,
  loginSuccess,
  loginInvalid,
  loginCancelled,
  updateFailed,
  updateSuccess,
  registerSuccess,
  registerFailed,
  missingLoginCredential,
  registrationUnderReview,
}

extension ErrorTypeShowError on ErrorType {
  String getMessage(BuildContext context) {
    switch (this) {
      case ErrorType.loginFailed:
        return S.of(context).loginFailed;
      case ErrorType.loginSuccess:
        return S.of(context).loginSuccess;
      case ErrorType.loginInvalid:
        return S.of(context).loginInvalid;
      case ErrorType.loginCancelled:
        return S.of(context).loginCanceled;
      case ErrorType.updateFailed:
        return S.of(context).updateFailed;
      case ErrorType.updateSuccess:
        return S.of(context).updateSuccess;
      case ErrorType.registerSuccess:
        return S.of(context).registerSuccess;
      case ErrorType.registerFailed:
        return S.of(context).registerFailed;
      case ErrorType.missingLoginCredential:
        return S.of(context).usernameAndPasswordRequired;
      case ErrorType.registrationUnderReview:
        return S.of(context).yourAccountIsUnderReview;
    }
  }
}
