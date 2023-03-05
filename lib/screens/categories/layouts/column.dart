import 'package:flutter/cupertino.dart';
import 'package:inspireui/inspireui.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../generated/l10n.dart';
import '../../../models/index.dart'
    show BackDropArguments, Category, CategoryModel;
import '../../../routes/flux_navigate.dart';
import '../../../widgets/common/paging_mixin.dart';
import '../../../widgets/common/refresh_scroll_physics.dart';
import '../widgets/category_column_item.dart';

const _kCrossAxisCount = 3;

const _kDefaultGridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: _kCrossAxisCount,
  mainAxisSpacing: 4.0,
  crossAxisSpacing: 4.0,
  childAspectRatio: 0.75,
);

class ColumnCategories extends StatefulWidget {
  static const String type = 'column';

  final ScrollController? scrollController;

  const ColumnCategories({
    this.scrollController,
  });

  @override
  State<ColumnCategories> createState() {
    return _ColumnCategoriesState();
  }
}

class _ColumnCategoriesState extends State<ColumnCategories> with PagingMixin {
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
                        gridDelegate: _kDefaultGridDelegate,
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return const Skeleton(
                              width: double.infinity,
                              height: double.infinity,
                            );
                          },
                          childCount: _kCrossAxisCount * 4,
                        ),
                      )
                    : SliverGrid(
                        gridDelegate: _kDefaultGridDelegate,
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
                                FluxNavigate.pushNamed(
                                  RouteList.backdrop,
                                  arguments: BackDropArguments(
                                    cateId: category.id,
                                    cateName: category.name,
                                  ),
                                );
                              },
                              child: CategoryColumnItem(category),
                            );
                          },
                          childCount: data.length +
                              (data.length % _kCrossAxisCount == 0
                                  ? _kCrossAxisCount
                                  : _kCrossAxisCount -
                                      (data.length % _kCrossAxisCount)),
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

// EdgeInsets _edgeInsetsForIndex(int index) {
//   if (index % 2 == 0) {
//     return const EdgeInsets.only(
//         top: 4.0, left: 8.0, right: 4.0, bottom: 4.0);
//   } else {
//     return const EdgeInsets.only(
//         top: 4.0, left: 4.0, right: 8.0, bottom: 4.0);
//   }
// }
}
