import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart' as config;
import '../../common/constants.dart';
import '../../common/tools/tools.dart';
import '../../generated/l10n.dart';
import '../../models/user_model.dart';
import '../../services/chat/constants/enums.dart';
import '../../services/index.dart';
import 'chat_mixin.dart';
import 'chat_screen.dart';
import 'scale_animation_mixin.dart';

class BottomSheetSmartChat extends StatefulWidget {
  final EdgeInsets? margin;
  final List<Map>? options;

  const BottomSheetSmartChat({this.margin, this.options});

  @override
  State<BottomSheetSmartChat> createState() => _BottomSheetSmartChatState();
}

class _BottomSheetSmartChatState extends State<BottomSheetSmartChat>
    with ChatMixin, ScaleAnimationMixin, SingleTickerProviderStateMixin {
  List<Map> get optionData => widget.options ?? config.smartChat;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then((_) {
      if (mounted) {
        options = getSmartChatOptions();
      }
    });
  }

  IconButton getIconButton(
      IconData? iconData, double iconSize, Color iconColor, String? appUrl) {
    return IconButton(
      icon: Icon(
        iconData,
        size: iconSize,
        color: iconColor,
      ),
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

  List<Map> getSmartChatOptions() {
    final result = [];
    for (var i = 0; i < optionData.length; i++) {
      if (Services()
          .chatServices
          .supportChatProviders
          .keys
          .map((e) => e.toString())
          .contains(optionData[i]['app'])) {
        if (Services()
                .chatServices
                .supportChatProviders[
                    '${optionData[i]['app']}'.toChatProviders()]
                ?.enable ??
            false) {
          result.add({
            'app': optionData[i]['app'],
            'description': optionData[i]['description'] ?? '',
            'iconData': optionData[i]['iconData'],
            'imageData': optionData[i]['imageData'],
          });
        }
        continue;
      }

      switch (optionData[i]['app']) {
        case 'firebase':
          if (Services().firebase.isEnabled || ServerConfig().isBuilder) {
            result.add({
              'app': 'firebase',
              'description': optionData[i]['description'] ?? S.of(context).chat,
              'iconData': optionData[i]['iconData'],
              'imageData': optionData[i]['imageData'],
            });
          }
          continue;
        default:
          result.add({
            'app': optionData[i]['app'],
            'description': optionData[i]['description'] ?? '',
            'iconData': optionData[i]['iconData'],
            'imageData': optionData[i]['imageData'],
          });
      }
    }
    return List<Map>.from(result);
  }

  @override
  Widget build(BuildContext context) {
    printLog('[build SmartChat]');

    var list = getSmartChatOptions();
    if (list.isEmpty) return const SizedBox();

    if (list.length == 1) {
      final option = optionData[0];
      final iconButton = getIconButton(
        option['iconData'],
        28,
        Theme.of(context).primaryColorLight,
        option['app'],
      );
      return Align(
        alignment:
            Tools.isRTL(context) ? Alignment.bottomLeft : Alignment.bottomRight,
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

    return Align(
      alignment:
          Tools.isRTL(context) ? Alignment.bottomLeft : Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: ScaleTransition(
          scale: scaleAnimation,
          alignment: Alignment.center,
          child: FloatingActionButton(
            heroTag: null,
            backgroundColor: Theme.of(context).colorScheme.background,
            onPressed: () async {
              if (scaleAnimationController.isCompleted) {
                Future.delayed(Duration.zero, scaleAnimationController.reverse);
                await Future.delayed(const Duration(milliseconds: 80), () {});
                await showActionSheet(context: context);
                await scaleAnimationController.forward();
              }
            },
            child: Icon(
              Icons.chat_rounded,
              color: Theme.of(context).primaryColor,
              size: 35,
            ),
          ),
        ),
      ),
    );
  }

  @override
  TickerProvider get vsync => this;
}
