import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../models/category/category_model.dart';
import '../../../models/index.dart' show BackDropArguments, Category;
import '../../../routes/flux_navigate.dart';
import '../../../widgets/common/parallax_image.dart';
import '../../base_screen.dart';
import '../../index.dart';

class ParallaxCategories extends StatefulWidget {
  static const String type = 'parallax';

  const ParallaxCategories();

  @override
  BaseScreen<ParallaxCategories> createState() => _StateCardCategories();
}

class _StateCardCategories extends BaseScreen<ParallaxCategories> {
  void navigateToBackDrop(Category category) {
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
    return Consumer<CategoryModel>(
      builder: (context, provider, child) {
        final categories = provider.rootCategories ?? <Category>[];
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: List.generate(
              categories.length,
              (index) {
                var category = categories[index];
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
                  child: ParallaxImage(
                    image: category.image ?? '',
                    name: category.name ?? '',
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
