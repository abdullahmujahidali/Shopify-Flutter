import 'package:flutter/material.dart';

import '../../../widgets/common/flux_image.dart';
import '../config/banner_config.dart';

class BannerHorizontal extends StatelessWidget {
  final BannerConfig config;
  final Function onTap;
  const BannerHorizontal({
    required this.config,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var height = config.height != null ? config.height!  * MediaQuery.of(context).size.height : null;
    return Container(
      margin: EdgeInsets.only(
        left: config.marginLeft,
        right: config.marginRight,
        top: config.marginTop,
        bottom: config.marginBottom,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            config.items.length,
            (index) => Container(
              height: height,
              padding: EdgeInsets.symmetric(
                horizontal: config.items[index].padding ?? 0.0,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  config.items[index].radius ?? 0.0,
                ),
                child: InkWell(
                  onTap: () => onTap(config.items[index].jsonData),
                  child: FluxImage(
                    imageUrl: config.items[index].image,
                    fit: config.fit,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
