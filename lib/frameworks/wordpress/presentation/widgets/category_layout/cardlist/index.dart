import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../common/config.dart';
import '../../../../../../generated/l10n.dart';
import '../../../../../../models/index.dart';

import 'menu_card.dart';

class HorizonMenu extends StatefulWidget {
  static const String type = 'animation';

  final ScrollController? scrollController;

  const HorizonMenu({
    this.scrollController,
  });

  @override
  State<HorizonMenu> createState() => _StateHorizonMenu();
}

class _StateHorizonMenu extends State<HorizonMenu> {
  @override
  void initState() {
    super.initState();
  }

  List<Category> getCategory(List<Category> categories) {
    return categories.where((item) => item.parent.toString() == '0').toList();
  }

  List<Category>? getChildrenOfCategory(
      List<Category> categories, Category category) {
    var children = categories
        .where((o) => o.parent.toString() == category.id.toString())
        .toList();
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryModel>(
      builder: (context, value, child) {
        if (value.isFirstLoad) {
          return kLoadingWidget(context);
        }
        var categories = value.categories;
        if (categories?.isEmpty ?? true) {
          return Center(
            child: Text(S.of(context).noData),
          );
        }
        var parentCategories = getCategory(categories ?? []);

        return ListView.builder(
          controller: widget.scrollController,
          itemCount: parentCategories.length,
          itemBuilder: (context, index) => MenuCard(
            getChildrenOfCategory(categories ?? [], parentCategories[index]) ??
                [],
            parentCategories[index],
          ),
        );
      },
    );
  }
}
