import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';
import '../../../models/entities/index.dart' show Product;
import '../../../models/index.dart' show ProductModel;
import '../../../widgets/common/expansion_info.dart';

class ProductTag extends StatelessWidget {
  final Product? product;

  const ProductTag(this.product);

  @override
  Widget build(BuildContext context) {
    if (product!.tags.isEmpty) {
      return const SizedBox();
    }

    return ExpansionInfo(
      expand: true,
      title: S.of(context).tags,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(bottom: 10),
          child: Wrap(
            children: List.generate(product!.tags.length, (index) {
              final tag = product!.tags[index];
              return TextButton(
                onPressed: () {
                  ProductModel.showList(
                    tag: '${tag.id}',
                  );
                },
                child: Text(
                  ' #${tag.name!.toUpperCase()} ',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              );
            }),
          ),
        )
      ],
    );
  }
}
