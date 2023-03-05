// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';

// import '../../common/constants.dart';
// import '../../models/entities/fstore_notification_item.dart';
// import '../../services/notification/notification_service.dart';

// class OneSignalNotificationService extends NotificationService {
//   final _instance = OneSignal.shared;
//   final String appID;

//   OneSignalNotificationService({required this.appID}) {
//     _instance.setAppId(appID);
//   }

//   @override
//   void disableNotification() {
//     _instance.disablePush(true);
//   }

//   @override
//   void enableNotification() {
//     _instance.disablePush(false);
//   }

//   @override
//   void init({
//     String? externalUserId,
//     required NotificationDelegate notificationDelegate,
//   }) {
//     _instance.setExternalUserId(externalUserId ?? '');
//     delegate = notificationDelegate;
//     _setupOnMessageOpenedApp();
//     _setupOnMessage();
//   }

//   void _setupOnMessageOpenedApp() {
//     _instance.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
//       final data = result.notification;
//       delegate.onMessageOpenedApp(FStoreNotificationItem(
//         id: data.notificationId,
//         title: data.title ?? '',
//         body: data.body ?? '',
//         additionalData: data.additionalData,
//         date: DateTime.now(),
//       ));
//     });
//   }

//   void _setupOnMessage() {
//     _instance.setNotificationWillShowInForegroundHandler(
//         (OSNotificationReceivedEvent result) {
//       final data = result.notification;
//       if (isAndroid) {
//         _instance.completeNotification(
//             result.notification.notificationId, false);
//         flutterLocalNotificationsPlugin.show(
//           data.hashCode,
//           data.title,
//           data.body,
//           NotificationDetails(
//             android: AndroidNotificationDetails(
//               channel.id,
//               channel.name,
//               channelDescription: channel.description,
//               icon: data.largeIcon ??
//                   data.smallIcon ??
//                   'ic_stat_onesignal_default',
//               // other properties...
//             ),
//             iOS: const DarwinNotificationDetails(),
//           ),
//           // payload: 'Notification'
//         );
//       } else {
//         /// When a notification arrives it will show right away if the app in the foreground
//         /// If the app is opening the notification will schedule 25 seconds to show
//         /// This statement makes the notification will show even when the app is opening
//         _instance.completeNotification(
//             result.notification.notificationId, true);
//       }
//       delegate.onMessage(FStoreNotificationItem(
//         id: data.notificationId,
//         title: data.title ?? '',
//         body: data.body ?? '',
//         additionalData: data.additionalData,
//         date: DateTime.now(),
//       ));
//     });
//   }

//   @override
//   void setExternalId(String? userId) async {
//     if (userId != null) {
//       await _instance.setExternalUserId(userId);
//     }
//   }

//   @override
//   void removeExternalId() async {
//     await _instance.removeExternalUserId();
//   }
// }
