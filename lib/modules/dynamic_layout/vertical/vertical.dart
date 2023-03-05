import 'package:flutter/material.dart';

import '../config/product_config.dart';
import '../helper/helper.dart';
import 'menu_layout.dart';
import 'pinterest_layout.dart';
import 'vertical_layout.dart';
import 'vertical_layout_with_filter.dart';

class VerticalLayout extends StatelessWidget {
  final config;
  final bool enableScrollView;

  const VerticalLayout({this.config, Key? key, required this.enableScrollView})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var productConfig = ProductConfig.fromJson(config ?? {});
    switch (config['layout']) {
      case Layout.menu:
        return MenuLayout(config: productConfig);
      case Layout.pinterest:
        return PinterestLayout(config: productConfig);
      case Layout.columnsWithFilter:
        return VerticalViewLayoutWithFilter(config: productConfig);
      case Layout.card:
      case Layout.listTile:
      case Layout.list:
      case Layout.columns:
      default:
        return VerticalViewLayout(
            config: productConfig, enableScrollView: enableScrollView);
    }
  }
}
