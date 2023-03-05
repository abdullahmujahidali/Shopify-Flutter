import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../generated/l10n.dart';
import '../../models/index.dart' show FStoreNotificationItem;
import '../../models/notification_model.dart';
import '../../modules/firebase/firebase_service.dart';
import '../../screens/common/app_bar_mixin.dart';
import '../../widgets/common/flux_image.dart';

class NotificationScreen extends StatefulWidget {
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with AppBarMixin {
  final scrollController = ScrollController();

  NotificationModel get notificationModel => context.read<NotificationModel>();

  @override
  void initState() {
    screenScrollController = scrollController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return renderScaffold(
      routeName: RouteList.notify,
      secondAppBar: AppBar(
        title: Text(
          S.of(context).listMessages,
          style: const TextStyle(color: Colors.white),
        ),
        leading: Center(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Selector<NotificationModel,
          UnmodifiableListView<FStoreNotificationItem>>(
        selector: (context, notificationModel) =>
            UnmodifiableListView(notificationModel.listNotification.reversed),
        shouldRebuild: (oldList, newList) {
          /// When a new notification arrive then scroll to top
          if (newList.length > oldList.length) {
            scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.bounceIn,
            );
          }
          return oldList != newList;
        },
        builder: (context, notifications, child) {
          if (notifications.isEmpty) {
            return Center(
              child: Text(S.of(context).noData),
            );
          }

          return ListView.builder(
            itemCount: notifications.length,
            controller: scrollController,
            itemBuilder: (context, index) {
              final notificationItem = notifications[index];
              return Dismissible(
                key: Key(notificationItem.id),
                onDismissed: (direction) {
                  if (direction == DismissDirection.endToStart) {
                    notificationModel.removeMessage(notificationItem.id);
                  }
                },
                confirmDismiss: (DismissDirection direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    handleMessage(notificationItem);
                    return false;
                  }
                  return confirmDeleteMessage();
                },
                background: Container(
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    notificationItem.seen
                        ? S.of(context).markAsUnread
                        : S.of(context).markAsRead,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                secondaryBackground: Container(
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    S.of(context).delete,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                child: Card(
                  margin: const EdgeInsets.all(4),
                  child: ListTile(
                    onTap: () {
                      onTapMessage(notificationItem);
                      notificationModel.markAsRead(notificationItem.id);
                    },
                    title: Text(
                      notificationItem.title,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Text(
                            notificationItem.body,
                            maxLines: 2,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.8),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Text(
                          notificationItem.displayDate,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.5),
                          ),
                        )
                      ],
                    ),
                    leading: notificationItem.image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(4.0),
                            child: FluxImage(
                              imageUrl: notificationItem.image!,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(
                            Icons.notifications_none,
                            size: 30,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    trailing: notificationItem.seen
                        ? null
                        : Icon(
                            Icons.circle,
                            color: Theme.of(context).primaryColor,
                          ),
                    isThreeLine: true,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void handleMessage(FStoreNotificationItem notificationItem) {
    if (notificationItem.seen) {
      notificationModel.markAsUnread(notificationItem.id);
    } else {
      notificationModel.markAsRead(notificationItem.id);
    }
  }

  Future<bool> confirmDeleteMessage() async {
    return await showDialog(
          context: context,
          builder: (BuildContext ctx) {
            return AlertDialog(
              title: Text(S.of(context).confirm),
              content: Text(S.of(context).confirmDeleteItem),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: Text(
                    S.of(context).delete,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text(S.of(context).cancel),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  void onTapMessage(FStoreNotificationItem data) async {
    final url = data.dynamicLink;
    if (url != null) {
      await FirebaseServices().dynamicLinks?.handleDynamicLink(url, context);
      return;
    }
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Container(
          alignment: Alignment.topLeft,
          child: const Icon(
            Icons.notifications_none,
            color: Colors.greenAccent,
            size: 40,
          ),
        ),
        content: SizedBox(
          height: MediaQuery.of(context).size.width * 0.5,
          child: Column(
            children: <Widget>[
              Text(
                data.title,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20.0),
              Text(
                data.body,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 16),
              )
            ],
          ),
        ),
      ),
    );
  }
}
