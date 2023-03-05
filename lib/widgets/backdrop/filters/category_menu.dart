import 'package:flutter/material.dart';
import 'package:inspireui/widgets/expandable/expansion_widget.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../generated/l10n.dart';
import '../../../models/index.dart'
    show BlogModel, Category, CategoryModel, ProductModel;
import '../../common/tree_view.dart';
import 'category_item.dart';

class CategoryMenu extends StatefulWidget {
  final Function(Category category) onFilter;
  final bool isUseBlog;

  const CategoryMenu({
    Key? key,
    required this.onFilter,
    this.isUseBlog = false,
  }) : super(key: key);

  @override
  State<CategoryMenu> createState() => _CategoryTreeState();
}

class _CategoryTreeState extends State<CategoryMenu> {
  CategoryModel get category => Provider.of<CategoryModel>(context);

  String? get categoryId => Provider.of<ProductModel>(context).categoryId;

  String _categoryId = '0';

  // Store category id from parent to children
  List<String?> selectedCategoryTree = [];

  @override
  void initState() {
    _categoryId =
        Provider.of<ProductModel>(context, listen: false).categoryId.toString();
    super.initState();
  }

  bool hasChildren(categories, id) {
    if (categories == null) return false;

    return categories.where((o) => o.parent == id).isNotEmpty;
  }

  List<Category> getSubCategories(categories, id) {
    if (categories == null) return [];

    if (id == null) {
      return categories.where((item) => item.isRoot == true).toList();
    }

    return categories.where((o) => o.parent == id).toList();
  }

  void onTap(Category category) {
    final id = category.id.toString();
    if (id == _categoryId) {
      widget.onFilter(Category(id: kEmptyCategoryID, subCategories: []));
      selectedCategoryTree.clear();
      setState(() => _categoryId = kEmptyCategoryID);
      return;
    }

    var indexOfCate = selectedCategoryTree.indexOf(category.parent);
    if (indexOfCate != -1) {
      selectedCategoryTree.removeRange(
          indexOfCate, selectedCategoryTree.length);
    } else {
      selectedCategoryTree.clear();
    }
    widget.onFilter(category);
    setState(() => _categoryId = id);
  }

  List<Parent> _getCategoryItems(
    List<Category>? categories, {
    String? id,
    required Function onFilter,
    int level = 1,
  }) {
    var subTree = <Parent>[];

    for (var category in getSubCategories(categories, id)) {
      var subCategories = _getCategoryItems(
        categories,
        id: category.id,
        onFilter: widget.onFilter,
        level: level + 1,
      );

      if (category.id == _categoryId ||
          selectedCategoryTree.contains(category.id)) {
        selectedCategoryTree.insert(0, category.parent);
      }

      subTree.add(Parent(
        parent: CategoryItem(
          category,
          hasChild: hasChildren(categories, category.id),
          isSelected: category.id == _categoryId,
          isParentOfSelected: selectedCategoryTree.contains(category.id),
          onTap: () => onTap(category),
          level: level,
        ),
        childList: ChildList(
          children: [
            if (hasChildren(categories, category.id))
              CategoryItem(
                category,
                isParent: true,
                isSelected: category.id == _categoryId,
                onTap: () => onTap(category),
                level: level + 1,
              ),
            ...subCategories,
          ],
        ),
      ));
    }

    return subTree;
  }

  Widget getTreeView({required List<Category> categories}) {
    return TreeView(
      parentList: _getCategoryItems(
        categories,
        onFilter: widget.onFilter,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionWidget(
      showDivider: true,
      padding: const EdgeInsets.only(
        left: 15,
        right: 15,
        top: 15,
        bottom: 5,
      ),
      title: Text(
        S.of(context).byCategory,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w700,
            ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: widget.isUseBlog
              ? Selector<BlogModel, List<Category>>(
                  builder: (context, categories, child) => getTreeView(
                    categories: categories,
                  ),
                  selector: (_, model) => model.categories,
                )
              : Selector<CategoryModel, List<Category>>(
                  builder: (context, categories, child) => getTreeView(
                    categories: categories,
                  ),
                  selector: (_, model) => model.categories ?? [],
                ),
        ),
      ],
    );
  }
}
