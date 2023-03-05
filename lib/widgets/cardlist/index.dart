import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/index.dart' show Category, CategoryModel;
import '../../screens/categories/categories_screen.dart';
import '../../services/index.dart';
import '../common/index.dart';
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
    Services().api.getCategoryWithCache();
    super.initState();
  }

  CategoryModel get categoryModel =>
      Provider.of<CategoryModel>(context, listen: false);

  List<Category> getChildrenOfCategory(Category category) {
    final children =
        categoryModel.getCategory(parentId: category.id!) ?? <Category>[];
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return PagingList<CategoryModel, Category>(
      scrollController: widget.scrollController,
      header: const HeaderCategory(
        showSearch: true,
      ),
      selectorData: (model) => model.rootCategories ?? <Category>[],
      itemBuilder: (p0, category, index) {
        return MenuCard(
          getChildrenOfCategory(category),
          category,
        );
      },
    );
  }
}
