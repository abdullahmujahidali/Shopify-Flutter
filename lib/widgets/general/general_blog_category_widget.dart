import 'package:flutter/material.dart';

import '../../common/config/models/general_setting_item.dart';
import '../../common/tools.dart';
import 'general_widget.dart';

class GeneralBlogCategoryWidget extends StatelessWidget {
  final bool useTile;
  final Color? iconColor;
  final TextStyle? textStyle;
  final GeneralSettingItem? item;

  const GeneralBlogCategoryWidget({
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
        if (item?.blogCategory != null) {
          NavigateTools.onTapNavigateOptions(context: context, config: {
            'blog_category': item?.blogCategory,
          });
        }
      },
    );
  }
}
