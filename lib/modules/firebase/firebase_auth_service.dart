import 'dart:async';

import '../../models/entities/firebase_error_exception.dart';
import '../../models/entities/user.dart';

class FirebaseAuthService {
  void deleteAccount() {}

  void loginFirebaseApple({authorizationCode, identityToken}) {}

  void loginFirebaseFacebook({token}) {}

  void loginFirebaseGoogle({token}) {}

  void loginFirebaseEmail({email, password}) {}

  Future<User?>? loginFirebaseCredential({credential}) => null;

  dynamic getFirebaseCredential({verificationId, smsCode}) => null;

  StreamController<dynamic>? getFirebaseStream() => null;

  Future<void> verifyPhoneNumber({
    phoneNumber,
    codeAutoRetrievalTimeout,
    codeSent,
    required void Function(String?) verificationCompleted,
    void Function(FirebaseErrorException error)? verificationFailed,
    forceResendingToken,
    Duration? timeout,
  }) async {}

  void createUserWithEmailAndPassword({email, password}) {}

  void signOut() {}
}
