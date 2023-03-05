import 'package:flutter/material.dart';

import '../../common/constants.dart';
import '../../models/index.dart' show Product;
import '../../modules/dynamic_layout/config/product_config.dart';
import '../../services/services.dart';

class ListCard extends StatelessWidget {
  final List<Product>? data;
  final String? id;
  final width;

  const ListCard({this.data, this.id, this.width});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double widthVal = kIsWeb ? width / 2 : width;

        return SizedBox(
          height: widthVal * 0.4 + 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            key: ObjectKey(id),
            itemBuilder: (context, index) {
              return Services().widget.renderProductCardView(
                    item: data![index],
                    width: widthVal * 0.33,
                    config: ProductConfig.empty(),
                    ratioProductImage: ProductConfig.empty().imageRatio,
                  );
            },
            itemCount: data!.length,
          ),
        );
      },
    );
  }
}
