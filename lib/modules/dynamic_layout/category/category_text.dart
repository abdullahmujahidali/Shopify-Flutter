import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../config/category_config.dart';
import '../config/category_item_config.dart';
import 'category_text_item.dart';

const _defaultSeparateWidth = 24.0;

class CategoryTexts extends StatelessWidget {
  final CategoryConfig config;
  final int crossAxisCount;
  final Function onShowProductList;
  final Map<String?, String?> listCategoryName;

  const CategoryTexts({
    required this.config,
    required this.listCategoryName,
    required this.onShowProductList,
    this.crossAxisCount = 5,
    Key? key,
  }) : super(key: key);

  String _getCategoryName({required CategoryItemConfig item}) {
    if (config.commonItemConfig.hideTitle) {
      return '';
    }
    String? name;

    /// not using the config Title from json
    if (!item.keepDefaultTitle && listCategoryName.isNotEmpty) {
      name = listCategoryName[item.category.toString()];
    } else {
      name = item.title;
    }
    return name ?? '';
  }

  @override
  Widget build(BuildContext context) {
    var numberItemOnScreen = config.columns ?? crossAxisCount;
    numberItemOnScreen = getValueForScreenType(
      context: context,
      mobile: numberItemOnScreen,
      tablet: numberItemOnScreen + 3,
      desktop: numberItemOnScreen + 8,
    );

    var items = <Widget>[];

    for (var item in config.items) {
      var name = _getCategoryName(item: item);

      items.add(
        CategoryTextItem(
          onTap: () => onShowProductList(item),
          name: name,
          commonConfig: config.commonItemConfig,
        ),
      );
    }

    if (config.wrap == false && items.isNotEmpty) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(
          left: config.marginLeft,
          right: config.marginRight,
          top: config.marginTop,
          bottom: config.marginBottom,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items.expand((element) {
            return [
              element,
              ScreenTypeLayout(
                mobile: const SizedBox(width: _defaultSeparateWidth),
                tablet: const SizedBox(width: _defaultSeparateWidth + 12),
                desktop: const SizedBox(width: _defaultSeparateWidth + 24),
              ),
            ];
          }).toList()
            ..removeLast(),
        ),
      );
    }

    return Container(
      color: Theme.of(context).colorScheme.background,
      width: MediaQuery.of(context).size.width,
      child: Container(
          margin: EdgeInsets.only(
            left: config.marginLeft,
            right: config.marginRight,
            top: config.marginTop,
            bottom: config.marginBottom,
          ),
          child: Wrap(
            spacing: config.commonItemConfig.marginX,
            runSpacing: config.commonItemConfig.marginY,
            children: List.generate(items.length, (i) => items[i]),
          )),
    );
  }
}
