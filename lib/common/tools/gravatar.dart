import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto;

String getGravatarUrl(
  String email, {
  int size = 30,
}) {
  final emailSanitized = email.trim().toLowerCase();
  final md5 = crypto.md5.convert(utf8.encode(emailSanitized)).toString();
  return 'https://www.gravatar.com/avatar/$md5?s=$size&d=retro';
}
