import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inspireui/inspireui.dart';
import 'package:provider/provider.dart';

import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../models/category/list_category_model.dart';
import '../../../models/entities/back_drop_arguments.dart';
import '../../../routes/flux_navigate.dart';
import '../../../widgets/common/refresh_scroll_physics.dart';
import '../../../widgets/common/sliver_empty_data.dart';
import '../../categories/widgets/category_column_item.dart';
import '../models/subcategory_model.dart';

const _crossAxisCount = 3;

const _gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: _crossAxisCount,
  mainAxisSpacing: 8,
  crossAxisSpacing: 8,
);

class SubcategoryArguments {
  final String parentId;
  final String? categoryName;
  final int level;

  const SubcategoryArguments({
    required this.parentId,
    this.categoryName,
    this.level = 2,
  });
}

class SubcategoryScreen extends StatefulWidget {
  final String? categoryName;
  final int level;

  const SubcategoryScreen({Key? key, this.categoryName, required this.level})
      : super(key: key);

  @override
  State<SubcategoryScreen> createState() => _SubcategoryScreenState();
}

class _SubcategoryScreenState extends State<SubcategoryScreen> {
  final _scrollController = ScrollController();

  ListCategoryModel get _listSubcategoryModel =>
      Provider.of<ListCategoryModel>(context, listen: false);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.extentBefore > 200 &&
        _scrollController.position.extentAfter < 500) {
      _listSubcategoryModel.getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ListCategoryModel>(
      builder: (context, listSubcategoryModel, child) {
        final showLoadingWidget = _scrollController.hasClients
            ? listSubcategoryModel.isLoading &&
                _scrollController.position.extentBefore > 200
            : false;

        return Scaffold(
          body: CustomScrollView(
            controller: _scrollController,
            physics: const RefreshScrollPhysics(),
            slivers: [
              Consumer<SubcategoryModel>(
                builder: (context, subcategoryModel, child) {
                  Widget title = const Align(
                    alignment: Alignment.centerLeft,
                    child: Skeleton(width: 120, height: 38),
                  );

                  final categoryName = widget.categoryName ??
                      subcategoryModel.parentCategory?.name;
                  if (categoryName != null) {
                    title = Text(categoryName);
                  }

                  return CupertinoSliverNavigationBar(largeTitle: title);
                },
              ),
              CupertinoSliverRefreshControl(
                onRefresh: _listSubcategoryModel.refresh,
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: Consumer<ListCategoryModel>(
                  builder: (context, listSubcategoryModel, child) {
                    final listSubcategory = listSubcategoryModel.data;
                    if (listSubcategoryModel.isFirstLoad) {
                      return _buildLoading();
                    }

                    if (listSubcategory.isEmpty) {
                      return const SliverEmptyData();
                    }

                    return SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final category = listSubcategory[index];
                          return GestureDetector(
                            onTap: () {
                              if ((category.hasChildren ?? false) &&
                                  widget.level <
                                      kAdvanceConfig.categoryConfig.deepLevel) {
                                FluxNavigate.pushNamed(
                                  RouteList.subCategories,
                                  arguments: SubcategoryArguments(
                                    parentId: category.id!.toString(),
                                    categoryName: category.name,
                                    level: widget.level + 1,
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
                            child: CategoryColumnItem(category),
                          );
                        },
                        childCount: listSubcategory.length,
                      ),
                      gridDelegate: _gridDelegate,
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: AnimatedSwitcher(
                  transitionBuilder: (child, animation) {
                    final offsetAnimation = Tween<Offset>(
                      begin: const Offset(0.0, 0.5),
                      end: const Offset(0.0, 0.0),
                    ).animate(animation);
                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                  duration: const Duration(milliseconds: 300),
                  child: showLoadingWidget
                      ? const Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: CircularProgressIndicator(),
                        )
                      : const SizedBox(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoading({int length = 6}) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return const Skeleton();
        },
        childCount: length,
      ),
      gridDelegate: _gridDelegate,
    );
  }
}
