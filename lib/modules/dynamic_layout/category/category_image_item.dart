import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../common/tools.dart';
import '../../../generated/l10n.dart';
import '../../../models/category/category_model.dart';
import '../../../models/entities/back_drop_arguments.dart';
import '../../../routes/flux_navigate.dart';
import '../../../widgets/common/flux_image.dart';
import '../config/index.dart';
import 'common_item_extension.dart';

/// The category icon circle list
class CategoryImageItem extends StatelessWidget {
  final CategoryItemConfig config;
  final products;
  final width;
  final height;
  final CommonItemConfig commonConfig;

  const CategoryImageItem({
    required this.config,
    this.products,
    this.width,
    this.height,
    required this.commonConfig,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final itemWidth = width ?? screenSize.width / 3;
    final categoryList = Provider.of<CategoryModel>(context).categoryList;

    final id = config.category.toString();
    final name = categoryList[id] != null ? categoryList[id]!.name : '';
    final image = categoryList[id] != null ? categoryList[id]!.image : '';
    final total =
        categoryList[id] != null ? categoryList[id]!.totalProduct : '';

    final imageWidget = config.image != null
        ? FluxImage(
            imageUrl: config.image!,
            fit: commonConfig.boxFit,
          )
        : null;
    final border = commonConfig.enableBorder ? (commonConfig.border ?? 0.5) : 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, left: 5.0),
      child: GestureDetector(
        onTap: () {
          FluxNavigate.pushNamed(
            RouteList.backdrop,
            arguments: BackDropArguments(
              config: config.toJson(),
              cateName: name,
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
              border: border > 0
                  ? Border.all(
                      color: HexColor(
                        '5F${kNameToHex['grey']!}',
                      ),
                      width: border.toDouble(),
                    )
                  : null,
              borderRadius: border > 0
                  ? const BorderRadius.all(Radius.circular(5.0))
                  : null,
              boxShadow: [
                if (commonConfig.boxShadow != null)
                  BoxShadow(
                    blurRadius: commonConfig.boxShadow!.blurRadius,
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(commonConfig.boxShadow!.colorOpacity),
                    offset: Offset(
                        commonConfig.boxShadow!.x, commonConfig.boxShadow!.y),
                  )
              ]),
          width: itemWidth,
          height: height ?? 180.0,
          padding: EdgeInsets.symmetric(
            horizontal: commonConfig.paddingX,
            vertical: commonConfig.paddingY,
          ),
          margin: EdgeInsets.symmetric(
            horizontal: commonConfig.marginX,
            vertical: commonConfig.marginY,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  width: itemWidth,
                  decoration: commonConfig.imageDecoration,
                  padding: EdgeInsets.all(commonConfig.imageSpacing),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(commonConfig.radius ?? 0.0),
                    child: imageWidget ??
                        ImageResize(
                          url: image,
                          fit: commonConfig.boxFit,
                          isResize: true,
                          size: kSize.small,
                        ),
                  ),
                ),
              ),
              Align(
                alignment: commonConfig.alignment,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    crossAxisAlignment: [
                      Alignment.center,
                      Alignment.topCenter,
                      Alignment.bottomCenter
                    ].contains(commonConfig.alignment)
                        ? CrossAxisAlignment.center
                        : CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (config.showText ?? false) ...[
                        const SizedBox(height: 8),
                        Text(
                          config.name ?? config.title ?? name!,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontSize: commonConfig.labelFontSize,
                                  ),
                        ),
                      ],
                      if (config.showDescription) ...[
                        const SizedBox(height: 4),
                        Text(
                          config.description ??
                              S.of(context).totalProducts('$total'),
                          style: const TextStyle(
                            fontSize: 9,
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
