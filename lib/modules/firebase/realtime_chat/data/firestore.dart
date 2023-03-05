import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../data/boxes.dart';
import '../constants/keys.dart';
import '../models/entities/chat_message.dart';
import '../models/entities/chat_room.dart';
import '../models/entities/chat_user.dart';

class FirestoreChat {
  static Stream<QuerySnapshot<ChatRoom>> getChatRooms(
    FirebaseFirestore instance,
  ) {
    return instance
        .collection(kFirestoreCollectionChatRooms)
        .withConverter<ChatRoom>(
          fromFirestore: (snapshot, _) => ChatRoom.fromJson(
            snapshot.id,
            snapshot.data() ?? {},
          ),
          toFirestore: (item, _) => item.toJson(),
        )
        .orderBy(kFirestoreFieldCreatedAt, descending: true)
        .snapshots();
  }

  static Stream<DocumentSnapshot<ChatRoom>> getChatRoom(
    FirebaseFirestore instance,
    String roomId,
  ) {
    return instance
        .collection(kFirestoreCollectionChatRooms)
        .doc(roomId)
        .withConverter<ChatRoom>(
          fromFirestore: (snapshot, _) {
            return ChatRoom.fromJson(
              snapshot.id,
              snapshot.data() ?? {},
            );
          },
          toFirestore: (item, _) => item.toJson(),
        )
        .snapshots();
  }

  static Stream<QuerySnapshot<ChatMessage>> getConversation(
      FirebaseFirestore instance, String chatId) {
    return instance
        .collection(kFirestoreCollectionChatRooms)
        .doc(chatId)
        .collection(kFirestoreCollectionChatScreen)
        .orderBy(
          kFirestoreFieldCreatedAt,
          descending: true,
        )
        .withConverter<ChatMessage>(
          fromFirestore: (snapshot, _) => ChatMessage.fromJson(
            snapshot.data() ?? {},
          ),
          toFirestore: (chatMessage, _) => chatMessage.toJson(),
        )
        .snapshots();
  }

  static Future<DocumentReference<ChatMessage>> sendChatMessage(
    FirebaseFirestore instance,
    String chatId,
    String sender,
    String receiver,
    String image,
    String message,
  ) async {
    return instance
        .collection(kFirestoreCollectionChatRooms)
        .doc(chatId)
        .collection(kFirestoreCollectionChatScreen)
        .withConverter<ChatMessage>(
          fromFirestore: (snapshot, _) => ChatMessage.fromJson(
            snapshot.data() ?? {},
          ),
          toFirestore: (chatMessage, _) => chatMessage.toJson(),
        )
        .add(
          ChatMessage(
            createdAt: DateTime.now(),
            sender: sender,
            image: image,
            text: message,
            receiver: receiver,
          ),
        );
  }

  static Future<void> updateTypingStatus(
    FirebaseFirestore instance,
    String chatId, {
    bool? isTyping = false,
    bool? isAdmin = false,
    String? senderEmail,
    List<ChatUser>? users,
    String? pushToken,
  }) async {
    return updateChatRoom(
      instance,
      chatId,
      isAdminTyping: isAdmin == true ? isTyping : null,
      isUserTyping: isAdmin == false ? isTyping : null,
      isSeenByAdmin: isAdmin == true ? true : null,
      senderEmail: senderEmail,
      users: users?.map(
        (user) {
          if (user.email == senderEmail) {
            return user.copyWith(
              lastActive: DateTime.now(),
            );
          }
          return user;
        },
      ).toList(),
    );
  }

  static Future initChatRoom(
    FirebaseFirestore instance,
    String chatId, {
    String? senderEmail,
    String? receiverEmail,
  }) async {
    final ref = getChatRoomReference(
      instance,
      chatId,
    );
    final snapshot = await ref.get();
    final shouldUpdateUsers = (snapshot.data()?.users.isEmpty ?? true) ||
        (snapshot.data()?.users.length ?? 0) < 2;
    if (!snapshot.exists || shouldUpdateUsers) {
      await ref.set(
        ChatRoom(
          chatId,
          createdAt: snapshot.data()?.createdAt ?? DateTime.now(),
          users:
              shouldUpdateUsers && senderEmail != null && receiverEmail != null
                  ? <ChatUser>[
                      ChatUser(
                        email: senderEmail,
                        lastActive: DateTime(0),
                      ),
                      ChatUser(
                        email: receiverEmail,
                        lastActive: DateTime(0),
                      ),
                    ]
                  : <ChatUser>[],
        ),
      );
    }
  }

  /// TODO: create chat room.
  static Future updateChatRoom(
    FirebaseFirestore instance,
    String chatId, {
    bool? isAdminTyping,
    bool? isUserTyping,
    String? latestMessage,
    bool? isSeenByAdmin,
    int? receiverUnreadCountPlus,
    String? senderName,
    String? senderEmail,
    String? receiver,
    List<ChatUser>? users,
    String? pushToken,
  }) async {
    await initChatRoom(instance, chatId);
    final newLangCode = SettingsBox().languageCode;
    return instance
        .collection(kFirestoreCollectionChatRooms)
        .doc(chatId)
        .update({
      if (isAdminTyping != null) kFirestoreFieldAdminTyping: isAdminTyping,
      if (latestMessage != null) kFirestoreFieldLatestMessage: latestMessage,
      if (isSeenByAdmin != null) kFirestoreFieldIsSeenByAdmin: isSeenByAdmin,
      kFirestoreFieldCreatedAt: DateTime.now().toUtc().toIso8601String(),
      if (users != null)
        kFirestoreFieldUsers: users.map((e) {
          if (e.email == senderEmail) {
            return e
                .copyWith(
                  lastActive: DateTime.now(),
                  unread: 0,
                  languageCode:
                      e.languageCode != newLangCode ? newLangCode : null,
                  pushToken: pushToken != null && e.pushToken != pushToken
                      ? pushToken
                      : null,
                )
                .toJson();
          } else {
            return e
                .copyWith(
                  unread: e.unread + (receiverUnreadCountPlus ?? 0),
                )
                .toJson();
          }
        }).toList(),
    });
  }

  static Future<void> deleteChatRoom(
      FirebaseFirestore instance, String chatId) async {
    /// Get all messages in the chat room.
    final allMessages = await instance
        .collection(kFirestoreCollectionChatRooms)
        .doc(chatId)
        .collection(kFirestoreCollectionChatScreen)
        .get();

    /// Delete all the chat room's messages.
    for (DocumentSnapshot document in allMessages.docs) {
      await document.reference.delete();
    }

    /// Delete the chat room.
    return instance
        .collection(kFirestoreCollectionChatRooms)
        .doc(chatId)
        .delete();
  }

  static Future<String> getChatRoomId(
    FirebaseFirestore instance,
    String senderEmail,
    String receiverEmail,
  ) async {
    var chatId = '$receiverEmail-$senderEmail';
    final snapshot = await getChatRoomReference(
      instance,
      chatId,
    ).get();

    if (!snapshot.exists) {
      chatId = '$senderEmail-$receiverEmail';
    }

    await initChatRoom(
      instance,
      chatId,
      senderEmail: senderEmail,
      receiverEmail: receiverEmail,
    );
    return chatId;
  }

  static DocumentReference<ChatRoom> getChatRoomReference(
    FirebaseFirestore instance,
    String roomId,
  ) {
    return instance
        .collection(kFirestoreCollectionChatRooms)
        .doc(roomId)
        .withConverter<ChatRoom>(
          fromFirestore: (snapshot, _) {
            if (!snapshot.exists) {}
            return ChatRoom.fromJson(
              snapshot.id,
              snapshot.data() ?? {},
            );
          },
          toFirestore: (item, _) => item.toJson(),
        );
  }
}
