import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../../models/entities/index.dart' show Product;
import '../../../models/index.dart' show ProductModel;
import '../../../widgets/common/expansion_info.dart';

class ProductDetailCategories extends StatelessWidget {
  final Product? product;

  const ProductDetailCategories(this.product);

  @override
  Widget build(BuildContext context) {
    if (product!.categories.isEmpty) {
      return const SizedBox();
    }
    return ExpansionInfo(
      expand: true,
      title: S.of(context).categories,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(bottom: 10),
          child: Wrap(
            children: List.generate(
              product!.distinctCategories.length,
              (index) {
                final category = product!.categories[index];
                return TextButton(
                  onPressed: () {
                    ProductModel.showList(
                      cateName: category.name,
                      cateId: category.id,
                    );
                  },
                  child: Text(
                    ' ${category.name?.toUpperCase()}  ',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
