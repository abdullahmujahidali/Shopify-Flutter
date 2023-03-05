import 'package:flutter/material.dart';

import '../../../common/tools.dart';
import '../../../widgets/common/flux_image.dart';
import '../../../widgets/common/parallax_image.dart';
import '../config/banner_config.dart';

/// The Banner type to display the image
class BannerImageItem extends StatelessWidget {
  final BannerItemConfig config;
  final double? width;
  final double padding;
  final BoxFit? boxFit;
  final double radius;
  final double? height;
  final Function onTap;
  final bool enableParallax;
  final double parallaxImageRatio;

  const BannerImageItem({
    key,
    required this.config,
    required this.padding,
    this.width,
    this.boxFit,
    required this.radius,
    this.height,
    required this.onTap,
    this.enableParallax = false,
    this.parallaxImageRatio = 1.2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var paddingVal = config.padding ?? padding;
    var radiusVal = config.radius ?? radius;

    final screenSize = MediaQuery.of(context).size;
    final itemWidth = width ?? screenSize.width;

    return GestureDetector(
      onTap: () => config.button == null ? onTap(config.jsonData) : null,
      child: Container(
        width: itemWidth,
        height: height,
        constraints: const BoxConstraints(minHeight: 10.0),
        child: Stack(
          children: [
            if (enableParallax)
              ParallaxImage(
                image: config.image.toString(),
                ratio: parallaxImageRatio,
              ),
            if (!enableParallax)
              Padding(
                padding: EdgeInsets.only(left: paddingVal, right: paddingVal),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(radiusVal),
                  child: FluxImage(
                    imageUrl: config.image,
                    fit: boxFit ?? BoxFit.fitWidth,
                    width: itemWidth,
                    height: height,
                  ),
                ),
              ),
            if (config.description != null)
              Align(
                alignment: config.description?.alignment ?? Alignment.topCenter,
                child: Text(
                  config.description?.text ?? '',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: HexColor(config.description?.color),
                    fontSize: config.description?.fontSize,
                    fontFamily: config.description?.fontFamily,
                    shadows: <Shadow>[
                      if (config.description?.enableShadow ?? false)
                        const Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 3.0,
                          color: Colors.black,
                        ),
                    ],
                  ),
                ),
              ),
            if (config.title != null)
              Align(
                alignment: config.title?.alignment ?? Alignment.topCenter,
                child: Text(
                  config.title?.text ?? '',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: HexColor(config.title?.color),
                    fontSize: config.title?.fontSize,
                    fontFamily: config.title?.fontFamily,
                    fontWeight: FontWeight.bold,
                    shadows: <Shadow>[
                      if (config.title?.enableShadow ?? false)
                        const Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 3.0,
                          color: Colors.black,
                        ),
                    ],
                  ),
                ),
              ),
            if (config.button != null)
              Align(
                alignment: config.button?.alignment ?? Alignment.topCenter,
                child: InkWell(
                  onTap: () => onTap(config.jsonData),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                        color: HexColor(config.button?.backgroundColor),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      config.button?.text ?? '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: HexColor(config.button?.textColor),
                          fontSize: 16),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
