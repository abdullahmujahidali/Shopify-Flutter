import 'package:flutter/material.dart';
import 'package:inspireui/inspireui.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../models/category/detail_category_model.dart';
import '../../../models/category/list_category_model.dart';
import '../../../models/entities/back_drop_arguments.dart';
import '../../../models/entities/category.dart';
import '../../../routes/flux_navigate.dart';
import '../../../widgets/common/index.dart';
import '../../subcategories/views/subcategories_screen.dart';

class ListCategory extends StatefulWidget {
  final Category category;

  const ListCategory({Key? key, required this.category}) : super(key: key);

  @override
  State<ListCategory> createState() => _ListCategoryState();
}

class _ListCategoryState extends State<ListCategory>
    with AutomaticKeepAliveClientMixin<ListCategory> {
  final _cache = <int, DetailCategoryModel>{};

  void showProductList(Category category, bool hasChildren) {
    if (hasChildren) {
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
  }

  void onRefresh() {
    for (var model in _cache.values) {
      model.refresh();
    }
  }

  @override
  void dispose() {
    for (var model in _cache.values) {
      model.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PagingList<ListCategoryModel, Category>(
      header: Builder(builder: (context) {
        final imageUrl = widget.category.image;
        if (imageUrl?.isEmpty ?? true) {
          return const SizedBox();
        }
        return FluxImage(
          imageUrl: imageUrl!,
          height: 200,
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
        );
      }),
      // autoInitData: false,
      loadingWidget: const _CategorySkeleton(),
      lengthLoadingWidget: 8,
      onRefresh: onRefresh,
      itemBuilder: (context, item, index) {
        if (_cache[index] == null) {
          final model = DetailCategoryModel(category: item)..initData();
          _cache[index] = model;
        }
        return ChangeNotifierProvider.value(
          value: _cache[index]!,
          child: Consumer<DetailCategoryModel>(
            builder: (context, model, child) {
              final value = model.totalProduct;
              return Column(
                children: [
                  ListTile(
                    title: Text(item.displayName),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    subtitle: model.isLoading
                        ? const Align(
                            alignment: Alignment.centerLeft,
                            child: Skeleton(
                              width: 50,
                              height: 13,
                            ),
                          )
                        : value > 0
                            ? Text('$value items')
                            : null,
                    onTap: () =>
                        showProductList(item, model.hasChildren ?? false),
                  ),
                  const Divider(height: 1),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _CategorySkeleton extends StatelessWidget {
  const _CategorySkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0).copyWith(left: 16, right: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Skeleton(
            width: 220,
            height: 20,
          ),
          Spacer(),
          Skeleton(
            width: 60,
            height: 20,
          ),
          SizedBox(
            width: 12,
          ),
          Skeleton(
            width: 30,
            height: 20,
          ),
        ],
      ),
    );
  }
}
