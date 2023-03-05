import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../../../../services/base_firebase_services.dart';
import '../../../../services/services.dart';
import '../data/firestore.dart';
import '../models/entities/chat_message.dart';
import '../models/entities/chat_room.dart';
import '../models/entities/chat_user.dart';
import 'base/chat_repository.dart';

class FirestoreChatRepository implements ChatRepository {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final BaseFirebaseServices _firebaseServices = Services().firebase;

  final String _email;

  FirestoreChatRepository(this._email) {
    _firebaseServices.getMessagingToken().then((token) {
      _pushToken = token;
    });
  }

  String? _pushToken;

  @override
  String? get pushToken => _pushToken;

  @override
  String get userEmail => _email;

  @override
  Stream<String> get userEmailStream => _auth.authStateChanges().transform(
        StreamTransformer.fromHandlers(
          handleData: (auth.User? user, EventSink<String> sink) {
            sink.add(user?.email ?? '');
          },
        ),
      );

  @override
  Stream<List<ChatRoom>> getChatRooms(String email) {
    return FirestoreChat.getChatRooms(_firestore).map((snapshot) {
      return snapshot.docs
          .map<ChatRoom?>((doc) {
            /// Check if email is a member of the chat room.
            if (!doc.id.contains(email)) {
              return null;
            }
            return doc.data();
          })
          .whereType<ChatRoom>()
          .toList();
    });
  }

  @override
  Stream<ChatRoom> getChatRoom(String roomId) {
    return FirestoreChat.getChatRoom(_firestore, roomId).map((snapshot) {
      return snapshot.data()!;
    });
  }

  @override
  Stream<List<ChatMessage>> getConversation(String chatId) {
    return FirestoreChat.getConversation(_firestore, chatId).map((snapshot) {
      return snapshot.docs.map<ChatMessage>((doc) {
        return doc.data();
      }).toList();
    });
  }

  @override
  Future<void> sendChatMessage(
    String chatId,
    String sender,
    String receiver,
    String image,
    String message,
  ) async {
    await FirestoreChat.sendChatMessage(
      _firestore,
      chatId,
      sender,
      receiver,
      image,
      message,
    );
  }

  @override
  Future<void> updateTypingStatus(
    String chatId, {
    bool? isTyping,
    bool? isAdmin,
    String? senderEmail,
    List<ChatUser>? users,
  }) async {
    await FirestoreChat.updateTypingStatus(
      _firestore,
      chatId,
      isTyping: isTyping,
      isAdmin: isAdmin,
      senderEmail: senderEmail,
      users: users,
    );
  }

  @override
  Future<void> updateChatRoom(
    String chatId, {
    String? latestMessage,
    bool? isSeenByAdmin,
    int? receiverUnreadCountPlus,
    String? sender,
    bool? isAdminTyping,
    bool? isUserTyping,
    List<ChatUser>? users,
  }) async {
    await FirestoreChat.updateChatRoom(
      _firestore,
      chatId,
      isAdminTyping: isAdminTyping,
      isUserTyping: isUserTyping,
      latestMessage: latestMessage,
      isSeenByAdmin: isSeenByAdmin,
      receiverUnreadCountPlus: receiverUnreadCountPlus,
      senderEmail: sender,
      users: users,
      pushToken: pushToken,
    );
  }

  Future<void> reset() async {
    await _auth.signOut();
  }

  @override
  Future<void> deleteChatRoom(String chatId) async {
    await FirestoreChat.deleteChatRoom(_firestore, chatId);
  }

  @override
  Future<String> getChatRoomId(String senderEmail, String receiverEmail) {
    return FirestoreChat.getChatRoomId(
      _firestore,
      senderEmail,
      receiverEmail,
    );
  }
}
