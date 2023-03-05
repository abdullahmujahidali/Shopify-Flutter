import '../../models/index.dart' show User;

class ChatArguments {
  final User? senderUser;
  final String? receiverEmail;
  final String? receiverName;

  ChatArguments({
    required this.senderUser,
    required this.receiverEmail,
    required this.receiverName,
  });
}
