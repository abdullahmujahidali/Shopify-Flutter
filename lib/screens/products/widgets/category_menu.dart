import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/config.dart';
import '../../../generated/l10n.dart';
import '../../../models/index.dart';
import 'item_category.dart';

class ProductCategoryMenu extends StatefulWidget {
  final bool enableSearchHistory;
  final bool imageLayout;
  final String? newCategoryId;
  final Function(String?)? onTap;

  const ProductCategoryMenu({
    super.key,
    this.enableSearchHistory = false,
    this.imageLayout = false,
    this.newCategoryId,
    this.onTap,
  });

  @override
  StateProductCategoryMenu createState() => StateProductCategoryMenu();
}

class StateProductCategoryMenu extends State<ProductCategoryMenu> {
  bool get categoryImageMenu => kAdvanceConfig.categoryImageMenu;

  Widget renderListCategories(List<Category> categories) {
    var categoryMenu = categoryImageMenu;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      color: Theme.of(context).colorScheme.background,
      constraints: const BoxConstraints(minHeight: 50),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              categories.length,
              (index) {
                var category = categories[index];
                return ItemCategory(
                  categoryId: category.id,
                  categoryName: category.name!,
                  categoryImage: categoryMenu && widget.imageLayout
                      ? category.image
                      : null,
                  newCategoryId: widget.newCategoryId,
                  onTap: widget.onTap,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.enableSearchHistory) {
      return const SizedBox(width: double.infinity);
    }

    return Consumer<CategoryModel>(builder: (context, categoryModel, child) {
      var parentCategoryId = widget.newCategoryId;

      parentCategoryId =
          getParentCategories(categoryModel.categories, parentCategoryId) ??
              parentCategoryId;
      var parentCategory =
          categoryModel.categoryList[parentCategoryId.toString()]?.copyWith() ??
              Category(subCategories: [], id: parentCategoryId);
      parentCategory.name = S.of(context).seeAll;
      final listSubCategory =
          getSubCategories(categoryModel.categories, parentCategoryId)!;
      if (categoryModel.isLoading) {
        return Center(child: kLoadingWidget(context));
      }
      if (listSubCategory.length < 2) {
        return const SizedBox(width: double.infinity);
      }
      listSubCategory.insert(0, parentCategory);
      return renderListCategories(listSubCategory);
    });
  }

  String? getParentCategories(List<Category>? categories, id) {
    for (var item in (categories ?? <Category>[])) {
      if (item.id == id) {
        return (item.parent == null || item.isRoot) ? null : item.parent;
      }
    }
    return null;
  }

  List<Category>? getSubCategories(categories, id) {
    return categories.where((o) => o.parent == id).toList();
  }
}
