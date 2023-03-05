import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import '../../../../models/entities/firebase_error_exception.dart';
import '../../../../models/entities/user.dart' as entities;
import '../../firebase_auth_service.dart';
import 'entities/firebase_exception.dart';
import 'extensions/firebase_user_extention.dart';

class FirebaseAuthServiceImpl extends FirebaseAuthService {
  final _auth = FirebaseAuth.instance;

  @override
  void deleteAccount() {
    _auth.currentUser?.delete();
  }

  @override
  void loginFirebaseApple({authorizationCode, identityToken}) async {
    final AuthCredential credential = OAuthProvider('apple.com').credential(
      accessToken: String.fromCharCodes(authorizationCode),
      idToken: String.fromCharCodes(identityToken),
    );
    await _auth.signInWithCredential(credential);
  }

  @override
  void loginFirebaseFacebook({token}) async {
    AuthCredential credential = FacebookAuthProvider.credential(token);
    await _auth.signInWithCredential(credential);
  }

  @override
  void loginFirebaseGoogle({token}) async {
    AuthCredential credential =
        GoogleAuthProvider.credential(accessToken: token);
    await _auth.signInWithCredential(credential);
  }

  @override
  void loginFirebaseEmail({email, password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (err) {
      /// In case this user was registered on web
      /// so Firebase user was not created.
      if (err is FirebaseAuthException && err.code == 'user-not-found') {
        /// Create Firebase user automatically.
        /// createUserWithEmailAndPassword will auto sign in after success.
        /// No need to call signInWithEmailAndPassword again.
        await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }

      /// Ignore other cases.
    }
  }

  @override
  Future<entities.User?>? loginFirebaseCredential({credential}) async {
    try {
      return (await _auth.signInWithCredential(credential)).user?.toEntityApp();
    } on FirebaseAuthException catch (err) {
      throw err.toEntityApp();
    }
  }

  @override
  PhoneAuthCredential getFirebaseCredential({verificationId, smsCode}) {
    try {
      return PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
    } on FirebaseAuthException catch (err) {
      throw err.toEntityApp();
    }
  }

  @override
  StreamController<PhoneAuthCredential> getFirebaseStream() {
    return StreamController<PhoneAuthCredential>.broadcast();
  }

  @override
  Future<void> verifyPhoneNumber({
    phoneNumber,
    codeAutoRetrievalTimeout,
    codeSent,
    required void Function(String?) verificationCompleted,
    void Function(FirebaseErrorException error)? verificationFailed,
    forceResendingToken,
    Duration? timeout,
  }) async {
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber!,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        codeSent: codeSent,
        timeout: timeout ?? const Duration(seconds: 120),
        verificationCompleted: (phoneAuthCredential) {
          verificationCompleted(phoneAuthCredential.smsCode);
        },
        verificationFailed: (error) =>
            verificationFailed?.call(error.toEntityApp()),
        forceResendingToken: forceResendingToken);
  }

  @override
  void createUserWithEmailAndPassword({email, password}) {
    _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  void signOut() {
    _auth.signOut();
  }
}
