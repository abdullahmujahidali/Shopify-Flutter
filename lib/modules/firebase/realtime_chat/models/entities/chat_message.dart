import '../../constants/keys.dart';

class ChatMessage {
  final String image;
  final String sender;
  final String receiver;
  final DateTime createdAt;
  final String text;

  ChatMessage({
    this.image = '',
    this.sender = '',
    this.receiver = '',
    required this.createdAt,
    this.text = '',
  });

  factory ChatMessage.fromJson(Map json) => ChatMessage(
        image: json[kFirestoreFieldImage] ?? '',
        sender: json[kFirestoreFieldSender] ?? '',
        receiver: json[kFirestoreFieldReceiver] ?? '',
        createdAt: DateTime.tryParse('${json[kFirestoreFieldCreatedAt]}') ??
            DateTime.now(),
        text: json[kFirestoreFieldText] ?? '',
      );

  Map<String, dynamic> toJson() => {
        kFirestoreFieldImage: image,
        kFirestoreFieldSender: sender,
        kFirestoreFieldReceiver: receiver,
        kFirestoreFieldCreatedAt: createdAt.toUtc().toIso8601String(),
        kFirestoreFieldText: text,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessage &&
          runtimeType == other.runtimeType &&
          image == other.image &&
          sender == other.sender &&
          receiver == other.receiver &&
          createdAt == other.createdAt &&
          text == other.text;

  @override
  int get hashCode =>
      image.hashCode ^
      sender.hashCode ^
      createdAt.hashCode ^
      text.hashCode ^
      receiver.hashCode;
}
