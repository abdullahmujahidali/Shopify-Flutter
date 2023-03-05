import 'package:flutter/material.dart';

import '../../common/config/models/general_setting_item.dart';
import '../../common/tools.dart';
import '../../generated/l10n.dart';

class GeneralTitleWidget extends StatelessWidget {
  final double itemPadding;
  final GeneralSettingItem? item;
  const GeneralTitleWidget({this.item, this.itemPadding = 15.0});

  @override
  Widget build(BuildContext context) {
    var title = item?.title ?? S.of(context).dataEmpty;
    var fontSize = item?.fontSize ?? 16.0;
    var titleColor =
        item?.titleColor != null ? HexColor(item!.titleColor) : null;
    var enableDivider = item?.enableDivider ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (enableDivider)
          Container(
            width: MediaQuery.of(context).size.width,
            height: 15.0,
            color: Theme.of(context).primaryColorLight,
          ),
        Padding(
          padding: EdgeInsets.only(
              left: itemPadding,
              right: itemPadding,
              top: item?.padding.top ?? itemPadding,
              bottom: item?.padding.bottom ?? itemPadding),
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: titleColor ?? Theme.of(context).colorScheme.secondary,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ],
    );
  }
}
