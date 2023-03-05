class VendorNotification {
  VendorNotification({
    this.id,
    this.message,
    this.messageType,
    this.created,
  });

  String? id;
  String? message;
  String? messageType;
  DateTime? created;

  factory VendorNotification.fromMap(Map json) =>
      VendorNotification(
        id: json['ID'],
        message: json['message'],
        messageType: json['message_type'],
        created: DateTime.parse(json['created']),
      );

  Map<String, dynamic> toMap() => {
        'ID': id,
        'message': message,
        'message_type': messageType,
        'created': created!.toIso8601String(),
      };
}
