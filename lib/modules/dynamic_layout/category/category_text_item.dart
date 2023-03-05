import 'package:flutter/material.dart';

import '../index.dart';

class CategoryTextItem extends StatelessWidget {
  final String? name;
  final Function? onTap;
  final CommonItemConfig commonConfig;

  const CategoryTextItem({
    this.name,
    this.onTap,
    required this.commonConfig,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: commonConfig.paddingY,
          vertical: commonConfig.paddingX,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight.withOpacity(0.9),
          boxShadow: [
            if (commonConfig.boxShadow != null)
              BoxShadow(
                blurRadius: commonConfig.boxShadow!.blurRadius,
                color: Theme.of(context)
                    .colorScheme
                    .secondary
                    .withOpacity(commonConfig.boxShadow!.colorOpacity),
                spreadRadius: commonConfig.boxShadow!.spreadRadius,
                offset: Offset(
                    commonConfig.boxShadow!.x, commonConfig.boxShadow!.y),
              )
          ],
          borderRadius: BorderRadius.circular(commonConfig.radius ?? 0.0),
        ),
        child: Text(
          name ?? '',
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.apply(fontSizeFactor: commonConfig.size ?? 1)
              .copyWith(fontSize: commonConfig.labelFontSize),
          maxLines: 2,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
