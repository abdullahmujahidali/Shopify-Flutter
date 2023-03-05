import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../common/tools/tools.dart';
import '../../generated/l10n.dart';
import '../../models/index.dart';
import '../../services/chat/constants/enums.dart';
import '../../services/service_config.dart';
import '../../services/services.dart';
import '../../widgets/common/flux_image.dart';
import '../../widgets/common/webview.dart';
import 'chat_screen.dart';

class ChatMixin {
  late List<Map> options;

  List<CupertinoActionSheetAction> getListAction({
    required BuildContext popupContext,
    required BuildContext context,
    storeArguments,
  }) {
    var listWidget = <CupertinoActionSheetAction>[];

    for (var i = 0; i < options.length; i++) {
      if (Services()
          .chatServices
          .supportChatProviders
          .keys
          .map((e) => e.toString())
          .contains(options[i]['app'])) {
        if (Services()
                .chatServices
                .supportChatProviders['${options[i]['app']}'.toChatProviders()]
                ?.enable ??
            false) {
          listWidget.add(
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.of(popupContext).pop();
                await Future.delayed(const Duration(milliseconds: 300), () {});
                await Services()
                    .chatServices
                    .showChatScreen('${options[i]['app']}'.toChatProviders());
              },
              child: buildItemAction(
                option: options[i],
                context: context,
              ),
            ),
          );
        }
        continue;
      }
      switch (options[i]['app']) {
        case 'firebase':
          if (Services().firebase.isEnabled || ServerConfig().isBuilder) {
            listWidget.add(
              CupertinoActionSheetAction(
                onPressed: () async {
                  Navigator.of(popupContext).pop();
                  await Future.delayed(
                      const Duration(milliseconds: 300), () {});
                  final userModel =
                      Provider.of<UserModel>(context, listen: false);
                  if (userModel.user == null) {
                    await Navigator.of(context).pushNamed(RouteList.login);
                    return;
                  }
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChatScreen()),
                  );
                },
                child: buildItemAction(
                  option: options[i],
                  context: context,
                ),
              ),
            );
            break;
          }
          continue;
        case 'store':
          if ((kConfigChat['UseRealtimeChat'] ?? false) &&
              Services().firebase.isEnabled) {
            listWidget.add(
              CupertinoActionSheetAction(
                onPressed: () async {
                  Navigator.of(popupContext).pop();
                  await Future.delayed(
                      const Duration(milliseconds: 300), () {});
                  await Navigator.of(context).pushNamed(
                    RouteList.vendorChat,
                    arguments: storeArguments,
                  );
                },
                child: buildItemAction(
                  option: options[i],
                  context: context,
                ),
              ),
            );
            break;
          }
          continue;
        default:
          listWidget.add(
            buildActionSheetItem(
              option: options[i],
              popupContext: popupContext,
              context: context,
            ),
          );
      }
    }

    return listWidget;
  }

  CupertinoActionSheetAction buildActionSheetItem({
    required Map option,
    required BuildContext popupContext,
    required BuildContext context,
  }) {
    final url = Tools.prepareURL(option['app']);

    return CupertinoActionSheetAction(
      onPressed: () async {
        Navigator.of(popupContext).pop();
        await Future.delayed(const Duration(milliseconds: 300), () {});

        if (url != null) {
          try {
            if (Tools.needToOpenExternalApp(url)) {
              await Tools.launchURL(url);
            } else {
              openChatWebview(url: url, context: context);
            }
            return;
          } catch (e) {
            printError(e);
          }
        }

        final snackBar = SnackBar(
          content: Text(
            S.of(context).canNotLaunch,
          ),
          action: SnackBarAction(
            label: S.of(context).undo,
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: buildItemAction(
        option: option,
        context: context,
      ),
    );
  }

  Widget buildItemAction({
    required Map option,
    required BuildContext context,
  }) {
    final iconData = option['iconData'];
    String imageData = option['imageData'] ?? '';
    final description = option['description'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (imageData.isNotEmpty)
          FluxImage(imageUrl: imageData, width: 24, fit: BoxFit.contain),
        if (imageData.isEmpty)
          Icon(
            iconData,
            size: 24,
            color: Theme.of(context).primaryColor,
          ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            description,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
          ),
        ),
      ],
    );
  }

  void openChatWebview({
    String? url,
    required BuildContext context,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => WebView(
          url: url!,
          appBar: AppBar(
            title: Text(S.of(context).message),
            centerTitle: true,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            elevation: 0.0,
          ),
        ),
      ),
    );
  }

  Future showActionSheet({
    required BuildContext context,
    storeArguments,
  }) {
    return showCupertinoModalPopup(
      context: context,
      barrierDismissible: true,
      useRootNavigator: true,
      builder: (popupContext) => CupertinoActionSheet(
        actions: getListAction(
          popupContext: popupContext,
          storeArguments: storeArguments,
          context: context,
        ),
        cancelButton: CupertinoActionSheetAction(
          onPressed: Navigator.of(popupContext).pop,
          isDestructiveAction: true,
          child: Text(S.of(context).cancel),
        ),
      ),
    );
  }
}
