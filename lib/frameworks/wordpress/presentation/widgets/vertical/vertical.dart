import 'package:flutter/material.dart';

import '../../../../../common/constants.dart';
import '../../../../../models/entities/index.dart';
import '../../../../../modules/dynamic_layout/config/blog_config.dart';
import '../../../../../modules/dynamic_layout/helper/header_view.dart';
import '../../../../../modules/dynamic_layout/helper/helper.dart';
import '../../../../../routes/flux_navigate.dart';
import 'menu_layout.dart';
import 'pinterest_layout.dart';
import 'vertical_layout.dart';

class VerticalLayout extends StatefulWidget {
  final Map<String, dynamic> config;

  const VerticalLayout({required this.config, Key? key}) : super(key: key);

  @override
  State<VerticalLayout> createState() => _VerticalLayoutState();
}

class _VerticalLayoutState extends State<VerticalLayout> {
  BlogConfig get blogConfig => BlogConfig.fromJson(widget.config);

  Widget renderLayout() {
    switch (blogConfig.layout) {
      case Layout.menu:
        return const MenuLayout();
      case Layout.pinterest:
        return PinterestLayout(config: blogConfig);
      default:
        return VerticalViewLayout(config: blogConfig);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        if (blogConfig.name?.isNotEmpty ?? false)
          SliverToBoxAdapter(
            child: HeaderView(
              headerText: blogConfig.name,
              showSeeAll: true,
              callback: () => FluxNavigate.pushNamed(
                RouteList.backdrop,
                arguments: BackDropArguments(
                  config: blogConfig.toJson(),
                ),
              ),
            ),
          ),
        renderLayout(),
      ],
    );
  }
}
