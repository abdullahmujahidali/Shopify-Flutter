import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';

import '../data/boxes.dart';
import '../services/dependency_injection.dart';
import '../services/notification/notification_service.dart';
import 'entities/fstore_notification.dart';
import 'entities/fstore_notification_item.dart';

class NotificationModel extends ChangeNotifier {
  final _service = injector<NotificationService>();
  FStoreNotification _fStoreNotification = FStoreNotification.init(true);

  bool get enable => _fStoreNotification.enable;

  UnmodifiableListView<FStoreNotificationItem> get listNotification =>
      UnmodifiableListView(_fStoreNotification.listNotification);

  int get unreadCount =>
      _fStoreNotification.listNotification.where((item) => !item.seen).length;

  NotificationModel() {
    _loadData();
  }

  Future<void> _loadData() async {
    final data = UserBox().notification;
    if (data != null) {
      _fStoreNotification = data;
    }
    if (!(await _service.isGranted())) {
      disableNotification();
    }
  }

  void markAsRead(String notificationId) {
    _setStatusMessage(notificationId: notificationId, seen: true);
  }

  void markAsUnread(String notificationId) {
    _setStatusMessage(notificationId: notificationId, seen: false);
  }

  void removeMessage(String notificationId) {
    final notifications = _fStoreNotification.listNotification;
    notifications.removeWhere((element) => element.id == notificationId);
    _fStoreNotification.copyWith(listNotification: notifications);
    notifyListeners();
    _saveDataToLocal();
  }

  void removeAllMessages() {
    _fStoreNotification = _fStoreNotification.copyWith(listNotification: []);
    notifyListeners();
    _saveDataToLocal();
  }

  void saveMessage(FStoreNotificationItem item) {
    final notifications = _fStoreNotification.listNotification;
    final isExist = notifications.any((element) => element.id == item.id);
    if (isExist) return;
    notifications.add(item);
    _fStoreNotification =
        _fStoreNotification.copyWith(listNotification: notifications);
    notifyListeners();
    _saveDataToLocal();
  }

  Future<void> checkGranted() async {
    final isGranted = await _service.isGranted();
    if (isGranted != enable) {
      if (isGranted) {
        await enableNotification();
      } else {
        disableNotification();
      }
    }
  }

  Future<void> enableNotification() async {
    if (!(await _service.isGranted())) {
      final granted = await _service.requestPermission();
      if (!granted) {
        return;
      }
    }
    _fStoreNotification = _fStoreNotification.copyWith(enable: true);
    _service.enableNotification();
    notifyListeners();
    unawaited(_saveDataToLocal());
  }

  void disableNotification() {
    _fStoreNotification = _fStoreNotification.copyWith(enable: false);
    _service.disableNotification();
    _saveDataToLocal();
    notifyListeners();
  }

  void _setStatusMessage({required String notificationId, required bool seen}) {
    final notifications = _fStoreNotification.listNotification;
    var index =
        notifications.indexWhere((element) => element.id == notificationId);
    final item = notifications[index];
    notifications[index] = item.copyWith(seen: seen);
    _fStoreNotification =
        _fStoreNotification.copyWith(listNotification: notifications);
    notifyListeners();
    _saveDataToLocal();
  }

  Future<void> _saveDataToLocal() async {
    UserBox().notification = _fStoreNotification;
  }
}
