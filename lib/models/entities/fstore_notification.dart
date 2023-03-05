import 'fstore_notification_item.dart';

class FStoreNotification {
  final bool enable;
  List<FStoreNotificationItem> listNotification = <FStoreNotificationItem>[];

  FStoreNotification.init(
    this.enable, {
    List<FStoreNotificationItem>? list,
  }) {
    if (list != null) {
      listNotification = list;
    }
  }

  FStoreNotification copyWith({
    bool? enable,
    List<FStoreNotificationItem>? listNotification,
  }) {
    return FStoreNotification.init(
      enable ?? this.enable,
      list: List.from(listNotification ?? this.listNotification),
    );
  }

  factory FStoreNotification.fromJson(Map json) {
    var listNotification = <FStoreNotificationItem>[];
    if (json['listNotification'] != null) {
      listNotification = List.from(json['listNotification']).map((json) {
        return FStoreNotificationItem.fromJson(json);
      }).toList();
    }
    return FStoreNotification.init(
      json['enable'] ?? true,
      list: listNotification,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enable': enable,
      'listNotification': listNotification.map((e) => e.toJson()).toList(),
    };
  }
}
