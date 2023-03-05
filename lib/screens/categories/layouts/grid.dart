import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inspireui/icons/icon_picker.dart';
import 'package:inspireui/widgets/skeleton_widget/skeleton_widget.dart';
import 'package:provider/provider.dart';

import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../generated/l10n.dart';
import '../../../models/entities/index.dart';
import '../../../models/index.dart' show AppModel, Category, CategoryModel;
import '../../../routes/flux_navigate.dart';
import '../../../widgets/common/flux_image.dart';
import '../../../widgets/common/paging_mixin.dart';
import '../../../widgets/common/refresh_scroll_physics.dart';
import '../../subcategories/views/subcategories_screen.dart';

class GridCategory extends StatefulWidget {
  static const String type = 'grid';

  final ScrollController? scrollController;

  const GridCategory({
    this.scrollController,
  });

  @override
  State<GridCategory> createState() => _StateGridCategory();
}

class _StateGridCategory extends State<GridCategory> with PagingMixin {
  Widget renderIcon(String categoryId, Map icons) {
    var icon = icons[categoryId];
    if (icon is Map) {
      return Icon(iconPicker(icon['name'], icon['fontFamily']), size: 30);
    }
    if (icon is String) {
      return FluxImage(
        imageUrl: icon,
        width: 35,
        height: 35,
      );
    }
    return const Icon(Icons.category, size: 30);
  }

  int get gridCount => kAdvanceConfig.gridCount;

  CategoryModel get categoryModel =>
      Provider.of<CategoryModel>(context, listen: false);

  @override
  late final ScrollController scrollController = widget.scrollController ?? ScrollController();

  @override
  Future<void> getData() {
    return categoryModel.getData();
  }

  @override
  Widget build(BuildContext context) {
    var categoriesIcons =
        Provider.of<AppModel>(context, listen: true).categoriesIcons;
    var icons = categoriesIcons ?? kGridIconsCategories;

    return Stack(
      children: [
        Consumer<CategoryModel>(
          builder: (context, model, child) {
            final data = model.categories ?? <Category>[];
            return CustomScrollView(
              controller: scrollController,
              physics: const RefreshScrollPhysics(),
              slivers: [
                CupertinoSliverRefreshControl(
                  onRefresh: () async {
                    await model.refresh();
                  },
                ),
                model.isFirstLoad
                    ? SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: gridCount,
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                          childAspectRatio: 1.0,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return const Skeleton(
                              width: double.infinity,
                              height: double.infinity,
                            );
                          },
                          childCount: gridCount * 6,
                        ),
                      )
                    : SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: kAdvanceConfig.gridCount,
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                          childAspectRatio: 1.0,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            if (index >= data.length) {
                              if (model.isLoadMore) {
                                if (!model.hasNext) {
                                  return Center(
                                      child: Text(S.of(context).noData));
                                }
                                return const Skeleton(
                                  width: double.infinity,
                                  height: double.infinity,
                                );
                              }
                              return const SizedBox();
                            }
                            final category = data[index];
                            return GestureDetector(
                              onTap: () {
                                if (category.hasChildren ?? false) {
                                  FluxNavigate.pushNamed(
                                    RouteList.subCategories,
                                    arguments: SubcategoryArguments(
                                      parentId: category.id!.toString(),
                                      categoryName: category.name,
                                    ),
                                  );
                                  return;
                                }
                                FluxNavigate.pushNamed(
                                  RouteList.backdrop,
                                  arguments: BackDropArguments(
                                    cateId: category.id,
                                    cateName: category.name,
                                  ),
                                );
                              },
                              child: LayoutBuilder(
                                  builder: (context, constraints) {
                                return Container(
                                  width: constraints.maxWidth,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 10,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Column(
                                      children: <Widget>[
                                        renderIcon(category.id!, icons),
                                        const SizedBox(height: 8.0),
                                        Text(
                                          category.name!,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            );
                          },
                          childCount: data.length +
                              (data.length % gridCount == 0
                                  ? gridCount
                                  : gridCount - (data.length % gridCount)),
                        ),
                      ),
              ],
            );
          },
        ),
        scrollToTopButton,
      ],
    );
  }
}
