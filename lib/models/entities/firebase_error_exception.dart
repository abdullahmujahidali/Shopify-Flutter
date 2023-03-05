class FirebaseErrorException {
  FirebaseErrorException({
    required this.code,
    this.message,
    this.email,
    this.phoneNumber,
    this.tenantId,
    this.plugin,
  });

  /// The email of the user's account used for sign-in/linking.
  final String? email;

  /// The phone number of the user's account used for sign-in/linking.
  final String? phoneNumber;

  /// The tenant ID being used for sign-in/linking.
  final String? tenantId;

  final String? plugin;

  /// The long form message of the exception.
  final String? message;

  /// The optional code to accommodate the message.
  ///
  /// Allows users to identify the exception from a short code-name, for example
  /// "no-app" is used when a user attempts to read a [FirebaseApp] which does
  /// not exist.
  final String code;

  @override
  String toString() {
    return message ?? code;
  }
}
