import 'package:flutter/material.dart';

import '../../common/config/models/general_setting_item.dart';
import '../../common/tools.dart';
import '../common/index.dart';

class GeneralBannerWidget extends StatelessWidget {
  final GeneralSettingItem? item;
  const GeneralBannerWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    var itemVal = item ?? GeneralSettingItem();
    var banner = itemVal.banner;
    var height = itemVal.bannerHeight.toDouble();
    if (banner == null) {
      return SizedBox(
        height: height,
      );
    }
    var tapConfig = {
      'product': itemVal.product,
      'category': itemVal.category,
      'url': itemVal.webViewMode ? itemVal.webUrl : null,
      'url_launch': itemVal.webViewMode ? null : itemVal.webUrl,
      'blog': itemVal.blog,
      'blog_category': itemVal.blogCategory,
    };
    tapConfig.removeWhere((key, value) => value == null);
    return InkWell(
      onTap: tapConfig.isNotEmpty
          ? () => NavigateTools.onTapNavigateOptions(
              config: tapConfig, context: context)
          : null,
      child: Container(
        width: double.infinity,
        height: height,
        margin: EdgeInsets.only(
          left: itemVal.padding.left,
          right: itemVal.padding.right,
        ),
        child: FluxImage(
          imageUrl: banner,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
