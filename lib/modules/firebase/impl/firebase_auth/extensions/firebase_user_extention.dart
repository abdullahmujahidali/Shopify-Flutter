import 'package:firebase_auth/firebase_auth.dart';

import '../entities/user_auth_adaptive.dart';

extension FirebaseUserExtension on User {
  UserAuthAdaptiveFirebase toEntityApp() {
    return UserAuthAdaptiveFirebase(this);
  }
}
