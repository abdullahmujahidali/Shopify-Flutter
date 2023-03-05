import 'package:collection/collection.dart';

import '../../constants/keys.dart';
import 'chat_user.dart';

class ChatRoom {
  final String id;
  final DateTime createdAt;
  final bool isSeenByAdmin;
  final String latestMessage;
  final bool adminTyping;
  final bool userTyping;
  final List<ChatUser> users;

  ChatRoom(
    this.id, {
    this.adminTyping = false,
    required this.createdAt,
    this.isSeenByAdmin = false,
    this.latestMessage = '',
    this.userTyping = false,
    this.users = const [],
  });

  factory ChatRoom.fromJson(String id, Map json) {
    return ChatRoom(
      id,
      adminTyping: json[kFirestoreFieldAdminTyping] ?? false,
      createdAt: DateTime.tryParse('${json[kFirestoreFieldCreatedAt]}') ??
          DateTime.now(),
      isSeenByAdmin: json[kFirestoreFieldIsSeenByAdmin] ?? false,
      latestMessage: json[kFirestoreFieldLatestMessage] ?? '',
      userTyping: json[kFirestoreFieldUserTyping] ?? false,
      users: List<Map<String, dynamic>>.from(json[kFirestoreFieldUsers])
          .map((e) => ChatUser.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        kFirestoreFieldAdminTyping: adminTyping,
        kFirestoreFieldCreatedAt: createdAt.toIso8601String(),
        kFirestoreFieldIsSeenByAdmin: isSeenByAdmin,
        kFirestoreFieldLatestMessage: latestMessage,
        kFirestoreFieldUserTyping: userTyping,
        kFirestoreFieldUsers: users.map((e) => e.toJson()).toList(),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatRoom &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          adminTyping == other.adminTyping &&
          createdAt == other.createdAt &&
          isSeenByAdmin == other.isSeenByAdmin &&
          latestMessage == other.latestMessage &&
          userTyping == other.userTyping &&
          users == other.users;

  @override
  int get hashCode =>
      id.hashCode ^
      adminTyping.hashCode ^
      createdAt.hashCode ^
      isSeenByAdmin.hashCode ^
      latestMessage.hashCode ^
      userTyping.hashCode ^
      users.hashCode;
}

extension ChatRoomExtension on ChatRoom {
  ChatUser? getOtherUser(String currentUserEmail) {
    if (currentUserEmail.isEmpty) {
      throw ArgumentError('currentUserEmail cannot be empty');
    }
    return users.firstWhereOrNull(
      (e) {
        return e.email != currentUserEmail;
      },
    );
  }
}
