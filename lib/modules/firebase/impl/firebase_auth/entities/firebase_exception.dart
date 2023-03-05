import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../models/entities/firebase_error_exception.dart';

extension FirebaseAuthExceptionExt on FirebaseAuthException {
  FirebaseErrorException toEntityApp() {
    return FirebaseErrorException(
      code: code,
      plugin: plugin,
      message: message,
      email: email,
      phoneNumber: phoneNumber,
      tenantId: tenantId,
    );
  }
}
