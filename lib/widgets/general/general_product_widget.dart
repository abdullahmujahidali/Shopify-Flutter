

import 'package:flutter/material.dart';
import '../../common/config/models/general_setting_item.dart';
import '../../common/tools.dart';
import 'general_widget.dart';

class GeneralProductWidget extends StatelessWidget {
  final bool useTile;
  final Color? iconColor;
  final TextStyle? textStyle;
  final GeneralSettingItem? item;

  const GeneralProductWidget({
    required this.item,
    this.iconColor,
    this.textStyle,
    this.useTile = false,
  });

  @override
  Widget build(BuildContext context) {
    return GeneralWidget(
      item: item,
      useTile: useTile,
      iconColor: iconColor,
      textStyle: textStyle,
      onTap: () {
        if (item?.product != null) {
          NavigateTools.onTapNavigateOptions(context: context, config: {
            'product': item?.product,
          });
        }
      },
    );
  }
}