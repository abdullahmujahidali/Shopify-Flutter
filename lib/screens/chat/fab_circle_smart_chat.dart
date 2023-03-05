import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart' as config;
import '../../common/constants.dart';
import '../../common/tools/tools.dart';
import '../../generated/l10n.dart';
import '../../models/user_model.dart';
import '../../services/chat/constants/enums.dart';
import '../../services/service_config.dart';
import '../../services/services.dart';
import '../../widgets/common/flux_image.dart';
import 'chat_mixin.dart';
import 'chat_screen.dart';
import 'fab_circle_menu.dart';

class FabCircleSmartChat extends StatefulWidget {
  final EdgeInsets? margin;
  final List<Map>? options;

  const FabCircleSmartChat({this.margin, this.options});

  @override
  State<FabCircleSmartChat> createState() => _FabCircleSmartChatState();
}

class _FabCircleSmartChatState extends State<FabCircleSmartChat>
    with ChatMixin {
  @override
  List<Map> get options => widget.options ?? config.smartChat;

  IconButton getIconButton(
    IconData? iconData,
    double iconSize,
    Color iconColor,
    String? appUrl,
    String? imageData,
  ) {
    return IconButton(
      icon: (imageData?.isNotEmpty ?? false)
          ? FluxImage(imageUrl: imageData!, width: 35, fit: BoxFit.contain)
          : iconData != null
              ? Icon(
                  iconData,
                  size: iconSize,
                  color: iconColor,
                )
              : const SizedBox(),
      onPressed: () async {
        if ((config.kConfigChat['UseRealtimeChat'] ?? false) &&
                Services().firebase.isEnabled ||
            ServerConfig().isBuilder) {
          final userModel = Provider.of<UserModel>(context, listen: false);
          if (userModel.user == null) {
            await Navigator.of(context).pushNamed(RouteList.login);
            return;
          }
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ChatScreen(),
            ),
          );
          return;
        }

        if (Services()
            .chatServices
            .supportChatProviders
            .keys
            .map((e) => e.toString())
            .contains(appUrl)) {
          await Services()
              .chatServices
              .showChatScreen(appUrl.toChatProviders());
          return;
        }

        final url = Tools.prepareURL(appUrl);
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
    );
  }

  List<IconButton> getFabIconButton() {
    if (!Services().firebase.isEnabled) {
      options.removeWhere((element) => element.containsKey('firebase'));
    }

    Services().chatServices.supportChatProviders.forEach((key, provider) {
      if (provider.enable == false) {
        options.removeWhere((element) => element.containsKey(key.toString()));
      }
    });

    return options
        .map((option) => getIconButton(
              option['iconData'],
              35,
              Theme.of(context).primaryColorLight,
              option['app'],
              option['imageData'],
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    var list = getFabIconButton();
    if (list.isEmpty) return const SizedBox();

    if (list.length == 1) {
      final option = options[0];
      final iconButton = getIconButton(
        option['iconData'],
        28,
        Theme.of(context).primaryColorLight,
        option['app'],
        option['imageData'],
      );
      return Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FloatingActionButton(
            onPressed: () {},
            heroTag: null,
            backgroundColor: Theme.of(context).primaryColor,
            child: iconButton,
          ),
        ),
      );
    }

    return SizedBox(
      width: screenSize.width,
      height: screenSize.height,
      child: FabCircularMenu(
        fabOpenIcon: const Icon(Icons.chat, color: Colors.white),
        ringColor: Theme.of(context).primaryColor,
        ringWidth: 100.0,
        ringDiameter: 250.0,
        fabMargin: widget.margin ?? const EdgeInsets.only(bottom: 0),
        options: list,
        child: const SizedBox(),
      ),
    );
  }
}
