import 'package:flutter/material.dart';
import 'package:inspireui/icons/icon_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/config.dart';
import '../../common/config/models/general_setting_item.dart';
import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../generated/l10n.dart';
import '../../models/user_model.dart';
import '../../routes/flux_navigate.dart';
import '../common/webview.dart';

class GeneralWebWidget extends StatelessWidget {
  final bool useTile;
  final Color? iconColor;
  final TextStyle? textStyle;
  final GeneralSettingItem? item;

  const GeneralWebWidget({
    required this.item,
    this.iconColor,
    this.textStyle,
    this.useTile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<UserModel, bool>(
      selector: (context, model) => model.loggedIn,
      shouldRebuild: (previous, next) => previous != next,
      builder: (context, value, child) {
        var user = Provider.of<UserModel>(context, listen: false).user;
        var icon = Icons.error;
        String title;
        Widget trailing;
        Function() onTap = () {};
        title = item?.title ?? S.of(context).dataEmpty;
        trailing =
            const Icon(Icons.arrow_forward_ios, size: 18, color: kGrey600);
        var webUrl = item?.webUrl;
        if (item?.requiredLogin ?? false) {
          if (!value) return const SizedBox();
          var base64Str = EncodeUtils.encodeCookie(user!.cookie!);
          webUrl = '$webUrl?cookie=$base64Str';
        }

        if (item != null) {
          icon = iconPicker(item!.icon, item!.iconFontFamily) ?? Icons.error;
          onTap = () {
            if (item?.webViewMode ?? false) {
              FluxNavigate.push(
                MaterialPageRoute(
                  builder: (context) => WebView(
                    url: webUrl,
                    title: title,
                    enableBackward: item?.enableBackward ?? false,
                    enableForward: item?.enableForward ?? false,
                    enableClose: item?.enableClose ?? false,
                    script: (item?.script?.isEmptyOrNull ?? true)
                        ? kAdvanceConfig.webViewScript
                        : item?.script ?? '',
                  ),
                ),
              );
            } else {
              Tools.launchURL(
                webUrl,
                mode: LaunchMode.externalApplication,
              );
            }
          };
        }
        if (useTile) {
          return ListTile(
            leading: Icon(
              icon,
              color: iconColor,
            ),
            title: Text(
              title,
              style: textStyle,
            ),
            onTap: onTap,
          );
        }

        return Column(
          children: [
            Card(
              margin: const EdgeInsets.only(bottom: 2.0),
              elevation: 0,
              child: ListTile(
                leading: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 24,
                ),
                title: Text(
                  title,
                  style: const TextStyle(fontSize: 16),
                ),
                trailing: trailing,
                onTap: onTap,
              ),
            ),
            const Divider(
              color: Colors.black12,
              height: 1.0,
              indent: 75,
              //endIndent: 20,
            ),
          ],
        );
      },
    );
  }
}
