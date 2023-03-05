abstract class ChatService {
  bool get enable => false;

  Future<void> init();

  void dispose();

  Future<void> showChatScreen();

  Future<void> changeLanguage(String? langCode);

  Future<void> logout();
}
