import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/config.dart';
import '../../../generated/l10n.dart';
import '../../../models/index.dart'
    show Category, CategoryModel;
import '../../../modules/dynamic_layout/index.dart';
import '../../../widgets/common/paging_list.dart';
import '../widgets/fetch_product_layout.dart';

class SideMenuCategories extends StatefulWidget {
  static const String type = 'sideMenu';

  const SideMenuCategories();

  @override
  State<StatefulWidget> createState() => SideMenuCategoriesState();
}

class SideMenuCategoriesState extends State<SideMenuCategories> {
  ValueNotifier<int> selectedIndex = ValueNotifier(0);

  CategoryModel get categoryModel =>
      Provider.of<CategoryModel>(context, listen: false);

  List<Category> getSubCategories(id) {
    return categoryModel.getCategory(parentId: id) ?? <Category>[];
  }

  @override
  void dispose() {
    selectedIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryModel>(
      builder: (context, provider, child) {
        if (provider.isFirstLoad) {
          return Center(
            child: kLoadingWidget(context),
          );
        }

        final categories =
            provider.rootCategories ?? provider.categories ?? <Category>[];

        if (categories.isEmpty) {
          return Center(
            child: Text(S.of(context).noData),
          );
        }

        return Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: ValueListenableBuilder<int>(
                valueListenable: selectedIndex,
                builder: (context, currentIndex, child) {
                  return PagingList<CategoryModel, Category>(
                    selectorData: (model) =>
                        model.rootCategories ?? <Category>[],
                    itemBuilder: (context, category, index) {
                      return _CategoryName(
                        onTap: () => selectedIndex.value = index,
                        isSelected: selectedIndex.value == index,
                        category: category,
                      );
                    },
                  );
                },
              ),
            ),
            Expanded(
              flex: 6,
              child: ValueListenableBuilder<int>(
                valueListenable: selectedIndex,
                builder: (context, index, child) {
                   var category =
                    categories.length > index
                        ? categories[index]
                        : null;
                  return FetchProductLayout(
                    key: ValueKey(category.toString()),
                    category: category,
                    subCategories: getSubCategories(category?.id),
                    padding: 4.0,
                    layout: 'list',
                    ratioProductImage: ProductConfig.empty().imageRatio,
                  );
                },
              ),
            )
          ],
        );
      },
    );
  }
}

class _CategoryName extends StatelessWidget {
  const _CategoryName({
    Key? key,
    this.onTap,
    required this.isSelected,
    required this.category,
  }) : super(key: key);

  final VoidCallback? onTap;
  final Category category;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 15,
          bottom: 15,
          left: 4,
          right: 4,
        ),
        child: Center(
          child: Text(
            category.displayName.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              color:
                  isSelected ? theme.primaryColor : theme.colorScheme.secondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
