import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/config.dart';
import '../../../../models/index.dart' show Category, CategoryModel;

class FilterSearchCategory extends StatefulWidget {
  final Function(List<Category>, String)? onSelect;
  final List<Category>? listSelected;

  const FilterSearchCategory({
    this.onSelect,
    this.listSelected,
  });

  @override
  State<FilterSearchCategory> createState() => _FilterSearchCategoryState();
}

class _FilterSearchCategoryState extends State<FilterSearchCategory> {
  List<Category> _listSelect = [];

  bool checkAttributeSelected(String? name) {
    return _listSelect.any((element) => name == element.name);
  }

  void _onTapCategory(Category category) {
    var isFound = checkAttributeSelected(category.name);

    _listSelect.clear();
    if (!isFound) {
      _listSelect.add(category);
    }

    widget.onSelect!(_listSelect, 'categories');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _listSelect = widget.listSelected!.toList();
  }

  @override
  Widget build(BuildContext context) {
    var categories = Provider.of<CategoryModel>(context);

    Color getColorSelectTextButton(bool isSelected) =>
        isSelected ? Colors.white : Theme.of(context).colorScheme.secondary;

    Color getColorSelectBackgroundButton(bool isSelected) => isSelected
        ? Theme.of(context).primaryColor
        : Theme.of(context).primaryColorLight;

    return ListenableProvider.value(
      value: categories,
      child: Consumer<CategoryModel>(builder: (context, value, child) {
        if (value.isLoading) {
          return Center(child: kLoadingWidget(context));
        }
        return SizedBox(
          height: 80,
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(width: 30),
                  ...List.generate(
                    value.categories!.length,
                    (int index) {
                      if (value.categories![index].parent == '0') {
                        return GestureDetector(
                          onTap: () {
                            _onTapCategory(value.categories![index]);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 15),
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 20,
                            ),
                            decoration: BoxDecoration(
                              color: getColorSelectBackgroundButton(
                                checkAttributeSelected(
                                  value.categories![index].name,
                                ),
                              ),
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                            child: Text(
                              value.categories![index].name.toString(),
                              style: TextStyle(
                                fontSize: 17,
                                color: getColorSelectTextButton(
                                  checkAttributeSelected(
                                    value.categories![index].name,
                                  ),
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
