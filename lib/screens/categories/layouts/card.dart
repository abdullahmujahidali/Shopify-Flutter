import 'package:flutter/material.dart';
import 'package:inspireui/inspireui.dart' show Skeleton;
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../generated/l10n.dart';
import '../../../models/category/category_model.dart';
import '../../../models/index.dart' show BackDropArguments, Category;
import '../../../routes/flux_navigate.dart';
import '../../../widgets/common/index.dart';
import '../../../widgets/common/parallax_image.dart';
import '../../../widgets/common/refresh_scroll_physics.dart';
import '../../index.dart';

class CardCategories extends StatefulWidget {
  static const String type = 'card';
  final bool enableParallax;
  final double? parallaxImageRatio;
  final ScrollController? scrollController;

  const CardCategories({
    required this.enableParallax,
    this.parallaxImageRatio,
    this.scrollController,
  });

  @override
  BaseScreen<CardCategories> createState() => _StateCardCategories();
}

class _StateCardCategories extends BaseScreen<CardCategories> {
  late final ScrollController _scrollController =
      widget.scrollController ?? ScrollController();

  CategoryModel get categoryModel =>
      Provider.of<CategoryModel>(context, listen: false);

  bool hasChildren(id) {
    return categoryModel.categories!
        .where((o) => o.parent == id)
        .toList()
        .isNotEmpty;
  }

  List<Category> getSubCategories(id) {
    return categoryModel.getCategory(parentId: id) ?? <Category>[];
  }

  void navigateToBackDrop(Category category) {
    FluxNavigate.pushNamed(
      RouteList.backdrop,
      arguments: BackDropArguments(
        cateId: category.id,
        cateName: category.name,
      ),
    );
  }

  ChildList getChildCategoryList(category) {
    return ChildList(
      children: [
        GestureDetector(
          onTap: () => navigateToBackDrop(category),
          child: SubItem(
            category,
            seeAll: S.of(context).seeAll,
          ),
        ),
        for (var category in getSubCategories(category.id))
          Parent(
            callback: (isSelected) {
              if (getSubCategories(category.id).isEmpty) {
                navigateToBackDrop(category);
              }
            },
            parent: SubItem(category),
            childList: ChildList(
              children: [
                for (var cate in getSubCategories(category.id))
                  Parent(
                    callback: (isSelected) {
                      if (getSubCategories(cate.id).isEmpty) {
                        FluxNavigate.pushNamed(
                          RouteList.backdrop,
                          arguments: BackDropArguments(
                            cateId: cate.id,
                            cateName: cate.name,
                          ),
                        );
                      }
                    },
                    parent: SubItem(cate, level: 1),
                    childList: ChildList(
                      children: [
                        for (var cate in getSubCategories(cate.id))
                          Parent(
                            callback: (isSelected) {
                              FluxNavigate.pushNamed(
                                RouteList.backdrop,
                                arguments: BackDropArguments(
                                  cateId: cate.id,
                                  cateName: cate.name,
                                ),
                              );
                            },
                            parent: SubItem(cate, level: 2),
                            childList: const ChildList(children: []),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (kEnableLargeCategories) {
      return PagingList<CategoryModel, Category>(
        lengthLoadingWidget: 6,
        loadingWidget: const _CardSkeleton(),
        itemBuilder: (_, category, index) {
          return _CategoryCardItem(
            category,
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
            enableParallax: widget.enableParallax,
            parallaxImageRatio: widget.parallaxImageRatio,
          );
        },
      );
    }

    return Consumer<CategoryModel>(
      builder: (context, provider, child) {
        if (provider.isFirstLoad) {
          return ListView.builder(
            itemBuilder: (_, __) => const _CardSkeleton(),
            itemCount: 8,
          );
        }

        var categories = provider.rootCategories ?? <Category>[];
        if (categories.isEmpty) {
          categories = provider.categories!;
        }

        if (categories.isEmpty) {
          return Center(
            child: Text(S.of(context).noData),
          );
        }

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(vertical: 8),
          physics: const RefreshScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: categories.length,
          itemBuilder: (_, index) {
            final category = categories[index];
            return Parent(
              parent: _CategoryCardItem(
                category,
                onTap: hasChildren(category.id)
                    ? null
                    : () {
                        FluxNavigate.pushNamed(
                          RouteList.backdrop,
                          arguments: BackDropArguments(
                            cateId: category.id,
                            cateName: category.name,
                          ),
                        );
                      },
                enableParallax: widget.enableParallax,
                parallaxImageRatio: widget.parallaxImageRatio,
              ),
              childList: getChildCategoryList(category),
            );
          },
        );
      },
    );
  }
}

class _CategoryCardItem extends StatelessWidget {
  final Category category;
  final bool enableParallax;
  final double? parallaxImageRatio;
  final VoidCallback? onTap;

  const _CategoryCardItem(
    this.category, {
    this.enableParallax = false,
    this.parallaxImageRatio,
    this.onTap,
  });

  /// Render category Image support caching on ios/android
  /// also fix loading on Web
  Widget renderCategoryImage(maxWidth) {
    final image = category.image ?? '';
    if (image.isEmpty) return const SizedBox();

    var imageProxy = '$kImageProxy${maxWidth}x,q30/';

    if (image.contains('http') && kIsWeb) {
      return FadeInImage.memoryNetwork(
        image: '$imageProxy$image',
        fit: BoxFit.cover,
        width: maxWidth,
        height: maxWidth * 0.35,
        placeholder: kTransparentImage,
      );
    }

    return FluxImage(
      imageUrl: category.image!,
      fit: BoxFit.cover,
      width: maxWidth,
      height: maxWidth * 0.35,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (enableParallax) {
            return Container(
              height: constraints.maxWidth * 0.35,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 10, right: 10),
              margin: const EdgeInsets.only(bottom: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: ParallaxImage(
                  image: category.image ?? '',
                  name: category.name ?? '',
                  ratio: 2.2,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fitWidth,
                ),
              ),
            );
          }

          return Container(
            height: constraints.maxWidth * 0.35,
            padding: const EdgeInsets.only(left: 10, right: 10),
            margin: const EdgeInsets.only(bottom: 10),
            child: Stack(
              children: <Widget>[
                ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                    child: renderCategoryImage(constraints.maxWidth)),
                Container(
                  width: constraints.maxWidth,
                  height: constraints.maxWidth * 0.35,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(0, 0, 0, 0.3),
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                  child: SizedBox(
                    width: constraints.maxWidth /
                        (2 / (screenSize.height / constraints.maxWidth)),
                    height: constraints.maxWidth * 0.35,
                    child: Center(
                      child: Text(
                        category.name?.toUpperCase() ?? '',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CardSkeleton extends StatelessWidget {
  const _CardSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: constraints.maxWidth * 0.35,
          padding: const EdgeInsets.only(left: 10, right: 10),
          margin: const EdgeInsets.only(bottom: 10),
          child: const Skeleton(
            width: double.infinity,
            height: double.infinity,
          ),
        );
      },
    );
  }
}

class SubItem extends StatelessWidget {
  final Category category;
  final String seeAll;
  final int level;

  const SubItem(this.category, {this.seeAll = '', this.level = 0});

  void showProductList() {
    FluxNavigate.pushNamed(
      RouteList.backdrop,
      arguments: BackDropArguments(
        cateId: category.id,
        cateName: category.name,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return SizedBox(
      width: screenSize.width,
      child: FittedBox(
        fit: BoxFit.cover,
        child: Container(
          width:
              screenSize.width / (2 / (screenSize.height / screenSize.width)),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                width: 0.5,
                color: Theme.of(context)
                    .colorScheme
                    .secondary
                    .withOpacity(level == 0 && seeAll == '' ? 0.2 : 0),
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 5),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: <Widget>[
              const SizedBox(width: 15.0),
              for (int i = 1; i <= level; i++)
                Container(
                  width: 10.0,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1.5,
                        color: Theme.of(context).primaryColor.withOpacity(0.4),
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: Text(
                  seeAll != '' ? seeAll : category.name!,
                  style: const TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
              if ((category.totalProduct ?? 0) > 0)
                GestureDetector(
                  onTap: showProductList,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: Text(
                      S.of(context).nItems(category.totalProduct.toString()),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                  ),
                ),
              IconButton(
                icon: const Icon(Icons.keyboard_arrow_right),
                onPressed: showProductList,
              )
            ],
          ),
        ),
      ),
    );
  }
}
