import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../generated/l10n.dart';
import '../../models/index.dart' show AppModel;
import '../../services/index.dart';
import '../common/app_bar_mixin.dart';
import 'layouts/card.dart';
import 'layouts/column.dart';
import 'layouts/grid.dart';
import 'layouts/multi_level.dart';
import 'layouts/parallax.dart';
import 'layouts/side_menu.dart';
import 'layouts/side_menu_with_group.dart';
import 'layouts/side_menu_with_sub.dart';
import 'layouts/sub.dart';

class CategoriesScreen extends StatefulWidget {
  final bool showSearch;
  final bool enableParallax;
  final double? parallaxImageRatio;

  const CategoriesScreen({
    Key? key,
    this.showSearch = true,
    this.enableParallax = false,
    this.parallaxImageRatio,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CategoriesScreenState();
  }
}

class CategoriesScreenState extends State<CategoriesScreen>
    with
        AutomaticKeepAliveClientMixin,
        SingleTickerProviderStateMixin,
        AppBarMixin {
  @override
  bool get wantKeepAlive => true;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    screenScrollController = _scrollController;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final appModel = Provider.of<AppModel>(context);
    final categoryLayout = appModel.categoryLayout;
    // final categoryLayout = 'sideMenuWithGroup';
    return renderScaffold(
      routeName: RouteList.category,
      backgroundColor: Theme.of(context).colorScheme.background,
      child: [
        GridCategory.type,
        ColumnCategories.type,
        SideMenuCategories.type,
        SubCategories
            .type, // Not support enableLargeCategory (pls check again, I think it works)
        SideMenuSubCategories.type, // Not support enableLargeCategory
        SideMenuGroupCategories.type,
        ParallaxCategories
            .type, // Not support enableLargeCategory (pls check again, I think it works)
        CardCategories.type,
        MultiLevelCategories.type, // Only work for enableLargeCategory
      ].contains(categoryLayout)
          ? Column(
              children: <Widget>[
                HeaderCategory(showSearch: widget.showSearch),
                Expanded(
                  child: renderCategories(
                    categoryLayout,
                    widget.enableParallax,
                    widget.parallaxImageRatio,
                    _scrollController,
                  ),
                )
              ],
            )
          : renderCategories(
              categoryLayout,
              widget.enableParallax,
              widget.parallaxImageRatio,
              _scrollController,
            ),
    );
  }

  Widget renderCategories(
      String layout, bool enableParallax, double? parallaxImageRatio,
      [ScrollController? scrollController]) {
    return Services().widget.renderCategoryLayout(
          layout: layout,
          enableParallax: enableParallax,
          parallaxImageRatio: parallaxImageRatio,
          scrollController: scrollController,
        );
  }
}

class HeaderCategory extends StatelessWidget {
  const HeaderCategory({Key? key, required this.showSearch}) : super(key: key);
  final bool showSearch;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SizedBox(
      width: screenSize.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (ModalRoute.of(context)?.canPop ?? false)
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(
                  Icons.arrow_back_ios,
                ),
              ),
            ),
          Padding(
            padding:
                const EdgeInsets.only(top: 10, left: 10, bottom: 10, right: 10),
            child: Text(
              S.of(context).category,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          if (showSearch)
            IconButton(
              icon: Icon(
                CupertinoIcons.search,
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.6),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(RouteList.categorySearch);
              },
            ),
        ],
      ),
    );
  }
}
