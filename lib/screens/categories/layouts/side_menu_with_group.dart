import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../generated/l10n.dart';
import '../../../models/category/category_model.dart';
import '../../../models/entities/index.dart';
import '../../../routes/flux_navigate.dart';
import '../../../services/services.dart';
import '../../../widgets/common/paging_list.dart';

class SideMenuGroupCategories extends StatefulWidget {
  static const String type = 'sideMenuWithGroup';

  final Map<String, dynamic>? icons;

  const SideMenuGroupCategories({this.icons});

  @override
  State<StatefulWidget> createState() => SideMenuGroupCategoriesState();
}

class SideMenuGroupCategoriesState extends State<SideMenuGroupCategories> {
  int selectedIndex = 0;

  CategoryModel get categoryModel =>
      Provider.of<CategoryModel>(context, listen: false);

  List<Category> getSubCategories(id) {
    return categoryModel.categories!.where((o) => o.parent == id).toList();
  }

  Map<String, dynamic> getListIcons(List<Category> categories) {
    var icons = <String?, dynamic>{};
    for (var cat in categories) {
      if (cat.image != null && cat.image!.isNotEmpty) {
        icons[cat.id] = cat.image;
      }
    }
    return Map<String, dynamic>.from(icons);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<CategoryModel>(
      builder: (context, provider, child) {
        if (provider.isFirstLoad) {
          return Container(
            child: kLoadingWidget(context),
          );
        }

        final categories = provider.rootCategories ?? <Category>[];

        if (categories.isEmpty) {
          return Center(
            child: Text(S.of(context).noData),
          );
        }

        var icons = getListIcons(categories);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: PagingList<CategoryModel, Category>(
                selectorData: (_) => categories,
                itemBuilder: (context, category, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6.0,
                        vertical: 20.0,
                      ),
                      decoration: BoxDecoration(
                        color: selectedIndex == index
                            ? theme.primaryColorLight
                            : Colors.transparent,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(2),
                          bottomRight: Radius.circular(2),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 4.0,
                          left: 6,
                        ),
                        child: AnimatedDefaultTextStyle(
                          style: selectedIndex == index
                              ? TextStyle(
                                  fontSize: 12,
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.w600,
                                )
                              : TextStyle(
                                  fontSize: 12,
                                  color: theme.colorScheme.secondary,
                                ),
                          maxLines: 2,
                          softWrap: true,
                          duration: const Duration(milliseconds: 200),
                          child: Text(categories[index].name ?? ''),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 7,
              child: Builder(builder: (context) {
                var category = categories.length > selectedIndex
                    ? categories[selectedIndex]
                    : null;
                return GridSubCategory(
                  getSubCategories(category?.id),
                  key: Key('${category?.toString()}'),
                  parentCategory: category,
                  parentCategoryImage:
                      kGridIconsCategories[category?.id ?? ''] ??
                          icons[category?.id],
                  icons: icons,
                );
              }),
            ),
          ],
        );
      },
    );
  }
}

class GridSubCategory extends StatefulWidget {
  final List<Category> categories;
  final Map<String, dynamic>? icons;

  final Category? parentCategory;
  final String? parentCategoryImage;

  const GridSubCategory(
    this.categories, {
    this.icons,
    this.parentCategory,
    this.parentCategoryImage,
    Key? key,
  }) : super(key: key);

  @override
  State<GridSubCategory> createState() => _StateGridSubCategory();
}

class _StateGridSubCategory extends State<GridSubCategory> {
  @override
  Widget build(BuildContext context) {
    final categories = widget.categories;

    // ignore: unnecessary_null_comparison
    if (categories == null) {
      return Container(
        child: kLoadingWidget(context),
      );
    }

    if (categories.isEmpty && widget.parentCategory != null) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: Theme.of(context).primaryColorLight,
        ),
        padding: const EdgeInsets.only(top: 20.0, left: 10.0),
        child: Services().widget.renderHorizontalListItem({
          'category': widget.parentCategory!.id,
          'name': widget.parentCategory!.name,
          'rows': 2,
        }),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.only(top: 10.0, left: 10.0),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: List<Widget>.generate(
                categories.length,
                (i) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Services().widget.renderHorizontalListItem({
                      'category': categories[i].id,
                      'name': categories[i].name,
                      'rows': 2,
                    }),
                  );
                },
              )..insertAll(
                  0,
                  [
                    if ((widget.parentCategoryImage != null &&
                            widget.parentCategoryImage!.isNotEmpty) &&
                        (categories.isEmpty))
                      Container(
                        margin: const EdgeInsets.only(top: 8.0),
                        padding: const EdgeInsets.all(4.0),
                        alignment: Alignment.centerRight,
                        child: InkResponse(
                          onTap: _seeAllProduct,
                          child: Text(
                            S.of(context).seeAll,
                            style: TextStyle(
                              fontSize: kIsWeb ? 18 : 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                    if ((widget.parentCategoryImage == null ||
                            widget.parentCategoryImage!.isEmpty) &&
                        (categories.isEmpty))
                      SizedBox(
                        height: constraints.maxHeight,
                        child: Center(
                          child: InkResponse(
                            onTap: _seeAllProduct,
                            child: Text(
                              S.of(context).seeAll,
                              style: TextStyle(
                                fontSize: kIsWeb ? 18 : 14,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
            ),
          ),
        );
      },
    );
  }

  void _seeAllProduct() {
    FluxNavigate.pushNamed(
      RouteList.backdrop,
      arguments: BackDropArguments(
        cateId: widget.parentCategory!.id,
        cateName: widget.parentCategory!.name,
      ),
    );
  }
}
