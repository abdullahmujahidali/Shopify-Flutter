import 'chat_service.dart';

class ChatServiceImpl implements ChatService {
  @override
  bool get enable => false;

  @override
  Future<void> init() async {}

  @override
  void dispose() {}

  @override
  Future<void> showChatScreen() async {}

  @override
  Future<void> changeLanguage(String? langCode) async {}

  @override
  Future<void> logout() async {}
}
