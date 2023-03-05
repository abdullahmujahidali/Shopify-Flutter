import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:random_string/random_string.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart' as apple;

import '../common/config.dart';
import '../common/constants.dart';
import '../data/boxes.dart';
import '../generated/l10n.dart';
import '../services/index.dart';
import 'entities/user.dart';

abstract class UserModelDelegate {
  void onLoaded(User? user);

  void onLoggedIn(User user);

  void onLogout(User? user);
}

class UserModel with ChangeNotifier {
  UserModel();

  final Services _service = Services();
  User? user;
  bool loggedIn = false;
  bool loading = false;
  UserModelDelegate? delegate;

  void updateUser(User newUser) {
    user = newUser;
    notifyListeners();
  }

  Future<String?> submitForgotPassword(
      {String? forgotPwLink, Map<String, dynamic>? data}) async {
    return await _service.api
        .submitForgotPassword(forgotPwLink: forgotPwLink, data: data);
  }

  /// Login by apple, This function only test on iPhone
  Future<void> loginApple({Function? success, Function? fail, context}) async {
    try {
      final result = await apple.TheAppleSignIn.performRequests([
        const apple.AppleIdRequest(
            requestedScopes: [apple.Scope.email, apple.Scope.fullName])
      ]);

      switch (result.status) {
        case apple.AuthorizationStatus.authorized:
          {
            user = await _service.api.loginApple(
                token: String.fromCharCodes(result.credential!.identityToken!),
                firstName: result.credential?.fullName?.givenName,
                lastName: result.credential?.fullName?.familyName);

            Services().firebase.loginFirebaseApple(
                  authorizationCode: result.credential!.authorizationCode!,
                  identityToken: result.credential!.identityToken!,
                );

            await saveUser(user);
            success!(user);

            notifyListeners();
          }
          break;

        case apple.AuthorizationStatus.error:
          fail!(S.of(context).error(result.error!));
          break;
        case apple.AuthorizationStatus.cancelled:
          fail!(S.of(context).loginCanceled);
          break;
      }
    } catch (err) {
      fail!(S.of(context).loginErrorServiceProvider(err.toString()));
    }
  }

  /// Login by Firebase phone
  Future<void> loginFirebaseSMS(
      {String? phoneNumber,
      required Function success,
      Function? fail,
      context}) async {
    try {
      user = await _service.api.loginSMS(token: phoneNumber);
      await saveUser(user);
      success(user);

      notifyListeners();
    } catch (err) {
      fail!(S.of(context).loginErrorServiceProvider(err.toString()));
    }
  }

  /// Login by Facebook
  Future<void> loginFB({Function? success, Function? fail, context}) async {
    try {
      final result = await FacebookAuth.instance.login();
      switch (result.status) {
        case LoginStatus.success:
          final accessToken = await FacebookAuth.instance.accessToken;

          Services().firebase.loginFirebaseFacebook(token: accessToken!.token);

          user = await _service.api.loginFacebook(token: accessToken.token);

          await saveUser(user);
          success!(user);
          break;
        case LoginStatus.cancelled:
          fail!(S.of(context).loginCanceled);
          break;
        default:
          fail!(result.message);
          break;
      }
      notifyListeners();
    } catch (err) {
      fail!(S.of(context).loginErrorServiceProvider(err.toString()));
    }
  }

  Future<void> loginGoogle({Function? success, Function? fail, context}) async {
    try {
      var googleSignIn = GoogleSignIn(scopes: ['email']);

      /// Need to disconnect or cannot login with another account.
      try {
        await googleSignIn.disconnect();
      } catch (_) {
        // ignore.
      }

      var res = await googleSignIn.signIn();

      if (res == null) {
        fail!(S.of(context).loginCanceled);
      } else {
        var auth = await res.authentication;
        Services().firebase.loginFirebaseGoogle(token: auth.accessToken);
        user = await _service.api.loginGoogle(token: auth.accessToken);
        await saveUser(user);
        success!(user);
        notifyListeners();
      }
    } catch (err, trace) {
      printError(err, trace);
      fail!(S.of(context).loginErrorServiceProvider(err.toString()));
    }
  }

  Future<void> saveUser(User? user) async {
    try {
      if (Services().firebase.isEnabled &&
          ServerConfig().typeName.isMultiVendor) {
        Services().firebase.saveUserToFirestore(user: user);
      }

      // save to Preference
      UserBox().isLoggedIn = true;
      loggedIn = true;

      // save the user Info as local storage
      UserBox().userInfo = user;
      delegate?.onLoaded(user);
    } catch (err) {
      printLog(err);
    }
  }

  Future<void> getUser() async {
    try {
      final localUser = UserBox().userInfo;
      if (localUser != null) {
        user = localUser;
        loggedIn = true;
        final userInfo = await _service.api.getUserInfo(user!.cookie);
        if (userInfo != null) {
          userInfo.isSocial = user!.isSocial;
          user = userInfo;
        }
        delegate?.onLoaded(user);
        notifyListeners();
      } else {
        if (kPaymentConfig.guestCheckout) {
          delegate?.onLoaded(User()..cookie = _getGenerateCookie());
        }
        notifyListeners();
      }
    } catch (err) {
      printLog(err);
    }
  }

  void setLoading(bool isLoading) {
    loading = isLoading;
    notifyListeners();
  }

  Future<void> setUser(User? user) async {
    if (user != null) {
      this.user = user;
      await saveUser(user);
      notifyListeners();
    }
  }

  Future<void> createUser({
    String? username,
    String? password,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    bool? isVendor,
    required Function success,
    Function? fail,
  }) async {
    try {
      loading = true;
      notifyListeners();
      Services().firebase.createUserWithEmailAndPassword(
          email: username!, password: password!);

      user = await _service.api.createUser(
        firstName: firstName,
        lastName: lastName,
        username: username,
        password: password,
        phoneNumber: phoneNumber,
        isVendor: isVendor ?? false,
      );
      await saveUser(user);
      success(user);

      loading = false;
      notifyListeners();
    } catch (err) {
      fail!(err.toString());
      loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    loggedIn = false;
    try {
      unawaited(Services().firebase.signOut());
      await FacebookAuth.instance.logOut();
    } catch (err) {
      printLog(err);
    }

    delegate?.onLogout(user);
    await _service.api.logout(user?.cookie);
    user = null;

    UserBox().cleanUpForLogout();
    notifyListeners();
  }

  Future<void> login({
    required String username,
    required String password,
    required Function(User user) success,
    required Function(String message) fail,
  }) async {
    try {
      loading = true;
      notifyListeners();
      user = await _service.api.login(
        username: username,
        password: password,
      );

      final userEmail =
          (user?.email?.isNotEmpty ?? false) ? user?.email : username;
      Services().firebase.loginFirebaseEmail(
            email: userEmail,
            password: password,
          );

      if (user == null) {
        throw 'Something went wrong!!!';
      }
      await saveUser(user);
      success(user!);
      loading = false;
      notifyListeners();
    } catch (err) {
      loading = false;
      fail(err.toString());
      notifyListeners();
    }
  }

  /// Use for generate fake cookie for guest check out
  String _getGenerateCookie() {
    var cookie = UserBox().userCookie;
    cookie ??= 'OCSESSID=${randomNumeric(30)}; PHPSESSID=${randomNumeric(30)}';
    UserBox().userCookie = cookie;
    return cookie;
  }
}
