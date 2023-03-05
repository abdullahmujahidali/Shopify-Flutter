import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../common/config.dart';
import '../constants/enums.dart';
import '../repos/base/chat_repository.dart';
import 'entities/chat_message.dart';
import 'entities/chat_room.dart';

class ChatViewModel extends ChangeNotifier {
  final RealtimeChatType _type;

  final String _receiverName;
  final String _receiverEmail;

  ChatViewModel(
    this._type,
    this._receiverName,
    this._receiverEmail,
  );

  ChatRepository? _repository;

  late String _senderEmail;

  bool get isAdminOrVendor =>
      _senderEmail == Configurations.adminEmail ||
      _type == RealtimeChatType.vendorToCustomers ||
      _type == RealtimeChatType.adminToCustomers;

  RealtimeChatType get type => _type;

  String get senderEmail => _senderEmail;

  String get receiverName => _receiverName;

  String get receiverEmail => _receiverEmail;

  StreamSubscription<String>? _authSubscription;

  bool get isAuthenticated => _senderEmail.isNotEmpty;

  bool get isInitialized => _repository != null;

  Stream<List<ChatRoom>> _chatRooms = const Stream.empty();

  Stream<List<ChatRoom>> get chatRooms => _chatRooms;

  String? _selectedChatRoomId;

  String? get selectedChatRoomId => _selectedChatRoomId;

  set selectedChatRoomId(String? value) {
    _selectedChatRoomId = value;
    notifyListeners();
  }

  ChatRoom? _selectedChatRoom;

  void setSelectedChatRoom(ChatRoom? value) {
    _selectedChatRoom = value;
  }

  Stream<ChatRoom> get selectedChatRoomStream => _selectedChatRoomId != null
      ? _repository!.getChatRoom(
          _selectedChatRoomId!,
        )
      : const Stream.empty();

  Future<void> init(ChatRepository repository) async {
    _repository = repository;

    _senderEmail = _repository!.userEmail;

    if (_type == RealtimeChatType.adminToCustomers ||
        _type == RealtimeChatType.vendorToCustomers) {
      _chatRooms = getChatRoomsStream();
    } else {
      _selectedChatRoomId = await _repository?.getChatRoomId(
        _senderEmail,
        _receiverEmail,
      );
    }
    notifyListeners();

    _authSubscription = repository.userEmailStream.listen((email) {
      if (email.isNotEmpty && email != _senderEmail) {
        _senderEmail = email;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  bool get enableRealtimeChat => kConfigChat['UseRealtimeChat'] == true;

  Stream<List<ChatRoom>> getChatRoomsStream() {
    return _repository!.getChatRooms(senderEmail);
  }

  Stream<List<ChatMessage>> getChatConversation(String chatId) {
    return _repository!.getConversation(chatId);
  }

  Future<void> sendChatMessage(
    String chatId,
    String image,
    String message,
  ) async {
    final sender = _senderEmail;
    final msg = image.isNotEmpty ? '$sender has sent an image.' : message;
    final receiver = _selectedChatRoom?.getOtherUser(sender)?.email ?? '';
    await _repository!.sendChatMessage(
      chatId,
      sender,
      receiver,
      image,
      msg,
    );
    await _repository!.updateChatRoom(
      chatId,
      latestMessage: msg,
      receiverUnreadCountPlus: 1,
      sender: sender,
      users: _selectedChatRoom?.users,
      isAdminTyping: isAdminOrVendor ? false : null,
      isUserTyping: isAdminOrVendor ? null : false,
    );
  }

  Future<void> updateTypingStatus(String chatId, bool status) async {
    switch (_type) {
      case RealtimeChatType.adminToCustomers:
      case RealtimeChatType.vendorToCustomers:
        await _repository!.updateTypingStatus(
          chatId,
          isTyping: status,
          isAdmin: true,
          senderEmail: _senderEmail,
          users: _selectedChatRoom?.users,
        );
        break;
      case RealtimeChatType.customerToAdmin:
      case RealtimeChatType.customerToVendor:
        await _repository!.updateTypingStatus(
          chatId,
          isTyping: status,
          isAdmin: false,
          senderEmail: _senderEmail,
          users: _selectedChatRoom?.users,
        );
        break;
    }
  }
}
