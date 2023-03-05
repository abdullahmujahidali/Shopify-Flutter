import 'package:flutter/material.dart';

import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../models/entities/product.dart';

class ProductTitle extends StatelessWidget {
  final Product product;
  final bool hide;
  final TextStyle? style;
  final int? maxLines;

  const ProductTitle({
    Key? key,
    required this.product,
    this.style,
    required this.hide,
    this.maxLines = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (hide) {
      return const SizedBox();
    }

    var pinnedTag = '';
    if (kAdvanceConfig.pinnedProductTags.isNotEmpty) {
      for (var tag in product.tags) {
        if (kAdvanceConfig.pinnedProductTags.contains(tag.name) ||
            kAdvanceConfig.pinnedProductTags
                .contains(tag.name?.toLowerCase().trim()) ||
            kAdvanceConfig.pinnedProductTags.contains(tag.id)) {
          pinnedTag = tag.name ?? '';

          /// Only show first one tag.
          break;
        }
      }
    }

    return Text.rich(
      TextSpan(
        children: [
          if (pinnedTag.isNotEmpty)
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: style?.color ??
                        Theme.of(context).textTheme.titleMedium?.color ??
                        Theme.of(context).colorScheme.onBackground,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 2.0,
                  horizontal: 4.0,
                ),
                margin: const EdgeInsets.only(right: 4.0),
                child: Text(
                  pinnedTag.upperCaseFirstChar(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          TextSpan(
            text: '${product.name}\n',
          ),
        ],
      ),
      maxLines: maxLines ?? 2,
      style: style ??
          Theme.of(context).textTheme.titleMedium!.apply(
                fontSizeFactor: 0.9,
              ),
      strutStyle: const StrutStyle(
        forceStrutHeight: true,
      ),
    );
  }
}
