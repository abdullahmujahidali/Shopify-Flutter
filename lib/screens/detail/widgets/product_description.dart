import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/config.dart';
import '../../../generated/l10n.dart';
import '../../../models/brand_layout_model.dart';
import '../../../models/entities/brand.dart';
import '../../../models/index.dart' show Product;
import '../../../services/index.dart';
import '../../../widgets/common/index.dart';
import 'additional_information.dart';

class ProductDescription extends StatelessWidget {
  final Product? product;

  const ProductDescription(this.product);

  bool get enableBrand => kProductDetail.showBrand;

  Brand? get brand {
    if (product?.brands.isNotEmpty ?? false) {
      return product?.brands.first;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 15),
        if (product!.description != null && product!.description!.isNotEmpty)
          ExpansionInfo(
            title: S.of(context).description,
            expand: true,
            children: <Widget>[
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Services()
                    .widget
                    .renderProductDescription(context, product!.description!),
              ),
              const SizedBox(height: 20),
            ],
          ),
        if (enableBrand) ...[
          buildBrand(context),
        ],
        if (product!.infors.isNotEmpty)
          ExpansionInfo(
            expand: true,
            title: S.of(context).additionalInformation,
            children: <Widget>[
              AdditionalInformation(
                listInfo: product!.infors,
              ),
            ],
          ),
      ],
    );
  }

  Widget buildBrand(context) {
    final brand = this.brand;
    if (brand == null) {
      return const SizedBox();
    }
    return Selector<BrandLayoutModel, Brand?>(
      selector: (BuildContext context, _) => _.brands.firstWhere(
        (item) => item.id == brand.id,
        orElse: () => brand,
      ),
      builder: (BuildContext context, Brand? brand, _) {
        if (brand == null) {
          return const SizedBox();
        }
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  S.of(context).brand,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              if (brand.image?.isNotEmpty ?? true)
                FluxImage(
                  imageUrl: brand.image ?? '',
                  fit: BoxFit.cover,
                  height: 56.0,
                ),
              if (brand.image?.isEmpty ?? true)
                Text(
                  brand.name ?? '',
                  textAlign: TextAlign.left,
                ),
            ],
          ),
        );
      },
    );
  }
}
