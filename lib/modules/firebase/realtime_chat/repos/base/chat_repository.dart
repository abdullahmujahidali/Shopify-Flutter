import '../../models/entities/chat_message.dart';
import '../../models/entities/chat_room.dart';
import '../../models/entities/chat_user.dart';

abstract class ChatRepository {

  String? get pushToken;

  String get userEmail;

  Stream<String> get userEmailStream;

  Stream<List<ChatRoom>> getChatRooms(String email);

  Stream<ChatRoom> getChatRoom(String roomId);

  Stream<List<ChatMessage>> getConversation(String chatId);

  Future<void> sendChatMessage(
    String chatId,
    String sender,
    String receiver,
    String image,
    String message,
  );

  Future<void> updateTypingStatus(
    String chatId, {
    bool? isTyping,
    bool? isAdmin,
    String? senderEmail,
    List<ChatUser>? users,
  });

  Future<void> updateChatRoom(
    String chatId, {
    String? latestMessage,
    bool? isSeenByAdmin,
    int? receiverUnreadCountPlus,
    String? sender,
    bool? isAdminTyping,
    bool? isUserTyping,
    List<ChatUser>? users,
  });

  Future<void> deleteChatRoom(String chatId);

  Future<String> getChatRoomId(String senderEmail, String receiverEmail);
}
