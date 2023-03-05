import 'dart:convert';

import 'package:timeago/timeago.dart' as timeago;

class FStoreNotificationItem {
  final String id;
  final String title;
  final String body;
  final bool seen;
  final Map? additionalData;
  final DateTime? date;

  const FStoreNotificationItem({
    required this.id,
    required this.title,
    required this.body,
    this.additionalData,
    this.seen = false,
    required this.date,
  });

  String get displayDate {
    final date = this.date;
    if (date == null) return '';
    // final dateDiff = DateTime.now().difference(date);
    return timeago.format(date);
  }

  String? get dynamicLink => additionalData?['dynamic_link'];

  String? get image => additionalData?['image'];

  factory FStoreNotificationItem.fromJson(Map json) {
    return FStoreNotificationItem(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      additionalData: json['additionalData'],
      date: DateTime.tryParse(json['date']),
    );
  }

  FStoreNotificationItem copyWith({
    String? id,
    String? title,
    String? body,
    bool? seen,
    Map? additionalData,
    DateTime? date,
  }) {
    return FStoreNotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      seen: seen ?? this.seen,
      body: body ?? this.body,
      additionalData: Map<String, dynamic>.from(
          jsonDecode(jsonEncode(additionalData ?? this.additionalData ?? {}))),
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toJson() {
    final val = <String, dynamic>{};

    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        val[key] = value;
      }
    }

    writeNotNull('id', id);
    writeNotNull('title', title);
    writeNotNull('body', body);
    writeNotNull('seen', seen);
    writeNotNull('additionalData', additionalData);
    writeNotNull('date', date.toString());
    return val;
  }
}
