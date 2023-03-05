import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../models/entities/index.dart' show AddonsOption;
import '../../models/index.dart' show AppModel, Product, ProductVariation;
import '../../services/index.dart';
import 'action_button_mixin.dart';
import 'widgets/quantity_selection.dart';

class ShoppingCartRow extends StatelessWidget with ActionButtonMixin {
  const ShoppingCartRow({
    required this.product,
    required this.quantity,
    this.onRemove,
    this.onChangeQuantity,
    this.variation,
    this.options,
    this.addonsOptions,
  });

  final Product? product;
  final List<AddonsOption>? addonsOptions;
  final ProductVariation? variation;
  final Map? options;
  final int? quantity;
  final Function? onChangeQuantity;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    var currency = Provider.of<AppModel>(context).currency;
    final currencyRate = Provider.of<AppModel>(context).currencyRate;

    final price = Services().widget.getPriceItemInCart(
        product!, variation, currencyRate, currency,
        selectedOptions: addonsOptions);
    final imageFeature = (variation?.imageFeature?.isNotEmpty ?? false)
        ? variation!.imageFeature
        : product!.imageFeature;
    var maxQuantity = kCartDetail['maxAllowQuantity'] ?? 100;
    var totalQuantity = variation != null
        ? (variation!.stockQuantity ?? maxQuantity)
        : (product!.stockQuantity ?? maxQuantity);
    var limitQuantity =
        totalQuantity > maxQuantity ? maxQuantity : totalQuantity;

    var theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Row(
              key: ValueKey(product!.id),
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (onRemove != null)
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: onRemove,
                  ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => onTapProduct(context, product: product!),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: constraints.maxWidth * 0.25,
                          height: constraints.maxWidth * 0.3,
                          child: ImageResize(url: imageFeature),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product!.name!,
                                  style: TextStyle(
                                    color: theme.colorScheme.secondary,
                                  ),
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  price!,
                                  style: TextStyle(
                                      color: theme.colorScheme.secondary,
                                      fontSize: 14),
                                ),
                                const SizedBox(height: 10),
                                if (product!.options != null && options != null)
                                  Services()
                                      .widget
                                      .renderOptionsCartItem(product!, options),
                                if (variation != null)
                                  Services().widget.renderVariantCartItem(
                                      context, variation!, options),
                                if (addonsOptions?.isNotEmpty ?? false)
                                  Services().widget.renderAddonsOptionsCartItem(
                                      context, addonsOptions),
                                if (kProductDetail.showStockQuantity)
                                  QuantitySelection(
                                    enabled: onChangeQuantity != null,
                                    width: 60,
                                    height: 32,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    limitSelectQuantity: limitQuantity,
                                    value: quantity,
                                    onChanged: onChangeQuantity,
                                    useNewDesign: false,
                                  ),
                                if (product?.store != null &&
                                    (product?.store?.name != null &&
                                        product!.store!.name!
                                            .trim()
                                            .isNotEmpty))
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Text(
                                      product!.store!.name!,
                                      style: TextStyle(
                                          color: theme.colorScheme.secondary,
                                          fontSize: 12),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
              ],
            ),
            const SizedBox(height: 10.0),
            const Divider(color: kGrey200, height: 1),
            const SizedBox(height: 10.0),
          ],
        );
      },
    );
  }
}
