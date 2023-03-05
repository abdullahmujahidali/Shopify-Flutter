import 'package:timeago/timeago.dart' as timeago;

import '../../../../../data/boxes.dart';
import '../../../../../generated/l10n.dart';
import '../../constants/keys.dart';

class ChatUser {
  final String email;
  final String name;
  final int unread;
  final DateTime lastActive;
  final String languageCode;
  final String pushToken;

  ChatUser({
    this.email = '',
    this.name = '',
    this.unread = 0,
    required this.lastActive,
    this.languageCode = '',
    this.pushToken = '',
  });

  factory ChatUser.fromJson(Map json) => ChatUser(
        email: json[kFirestoreFieldEmail] ?? '',
        name: json[kFirestoreFieldName] ?? '',
        unread: json[kFirestoreFieldUnread] ?? 0,
        lastActive: DateTime.tryParse('${json[kFirestoreFieldLastActive]}') ??
            DateTime(0),
        languageCode: json[kFirestoreFieldLanguageCode] ?? '',
        pushToken: json[kFirestoreFieldPushToken] ?? '',
      );

  Map<String, dynamic> toJson() => {
        kFirestoreFieldEmail: email,
        kFirestoreFieldName: name,
        kFirestoreFieldUnread: unread,
        kFirestoreFieldLastActive: lastActive.toIso8601String(),
        kFirestoreFieldLanguageCode: languageCode,
        kFirestoreFieldPushToken: pushToken,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatUser &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          name == other.name &&
          unread == other.unread &&
          languageCode == other.languageCode &&
          pushToken == other.pushToken &&
          lastActive == other.lastActive;

  @override
  int get hashCode =>
      email.hashCode ^
      name.hashCode ^
      unread.hashCode ^
      lastActive.hashCode ^
      languageCode.hashCode ^
      languageCode.hashCode;

  ChatUser copyWith({
    String? email,
    String? name,
    int? unread,
    DateTime? lastActive,
    String? languageCode,
    String? pushToken,
  }) {
    return ChatUser(
      email: email ?? this.email,
      name: name ?? this.name,
      unread: unread ?? this.unread,
      lastActive: lastActive ?? this.lastActive,
      languageCode: languageCode ?? this.languageCode,
      pushToken: pushToken ?? this.pushToken,
    );
  }
}

extension ChatUserExtension on ChatUser {
  String get displayName => name.isNotEmpty ? name : email;

  String get displayUnread => unread > 0 ? '$unread' : '';

  bool get isActive => lastActive.toLocal().isAfter(
        DateTime.now().subtract(
          const Duration(minutes: 5),
        ),
      );

  bool get isLongTimeAgo => lastActive.toLocal().isBefore(
        DateTime.now().subtract(
          const Duration(days: 1),
        ),
      );

  bool get isActiveNa => lastActive.millisecondsSinceEpoch <= 0;

  String displayLastActive(S locale) {
    if (isActive) {
      return locale.activeNow;
    }
    if (isLongTimeAgo) {
      return locale.activeLongAgo;
    }
    return locale.activeFor(timeago.format(
      lastActive,
      locale: SettingsBox().languageCode,
    ));
  }
}
