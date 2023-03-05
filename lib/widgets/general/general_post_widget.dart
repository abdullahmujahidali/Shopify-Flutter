import 'package:flutter/material.dart';
import 'package:inspireui/icons/icon_picker.dart';

import '../../common/config/models/general_setting_item.dart';
import '../../common/constants.dart';
import '../../generated/l10n.dart';
import '../../screens/posts/post_screen.dart';

class GeneralPostWidget extends StatelessWidget {
  final bool useTile;
  final Color? iconColor;
  final TextStyle? textStyle;
  final GeneralSettingItem? item;

  const GeneralPostWidget({
    required this.item,
    this.iconColor,
    this.textStyle,
    this.useTile = false,
  });

  @override
  Widget build(BuildContext context) {
    var icon = Icons.error;
    String title;
    Widget trailing;
    Function() onTap = () {};
    title = item?.title ?? S.of(context).dataEmpty;
    trailing = const Icon(Icons.arrow_forward_ios, size: 18, color: kGrey600);
    if (item != null) {
      icon = iconPicker(item!.icon, item!.iconFontFamily) ?? Icons.error;
      onTap = () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PostScreen(pageId: item!.pageId, pageTitle: title),
          ),
        );
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
  }
}
