import 'package:firebase_auth/firebase_auth.dart' as firebase;

import '../../../../../models/entities/user.dart';

class UserAuthAdaptiveFirebase extends User {
  final firebase.User userFirebase;

  UserAuthAdaptiveFirebase(this.userFirebase)
      : super.init(
          id: userFirebase.uid,
          email: userFirebase.email,
          nicename: userFirebase.displayName,
          userUrl: userFirebase.photoURL,
          phoneNumber: userFirebase.phoneNumber,
          picture: userFirebase.photoURL,
        );

  @override
  Future<String> getIdToken([bool forceRefresh = false]) {
    return userFirebase.getIdToken(forceRefresh);
  }
}
