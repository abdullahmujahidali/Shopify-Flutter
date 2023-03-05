import 'package:flutter/material.dart';

import '../../../../../common/constants.dart';
import '../../../../../common/tools.dart';
import '../../../../../routes/flux_navigate.dart';
import '../../../../../screens/blog/index.dart';

class PinterestCard extends StatelessWidget {
  final Blog item;
  final List<Blog> listBlog;
  final width;
  final marginRight;
  final kSize size;
  final bool isHero;
  final bool showCart;
  final bool showHeart;
  final bool showOnlyImage;

  const PinterestCard({
    required this.item,
    required this.listBlog,
    this.width,
    this.size = kSize.medium,
    this.isHero = false,
    this.showHeart = true,
    this.showCart = false,
    this.showOnlyImage = false,
    this.marginRight = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    void onTapProduct() {
      if (item.imageFeature == '') return;

      FluxNavigate.pushNamed(
        RouteList.detailBlog,
        arguments: BlogDetailArguments(
          blog: item,
          listBlog: listBlog,
        ),
      );
    }

    return GestureDetector(
      onTap: onTapProduct,
      child: Container(
        color: Theme.of(context).cardColor,
        margin: const EdgeInsets.all(5),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ImageResize(
                  url: item.imageFeature,
                  width: width,
                  size: kSize.medium,
                ),
              ],
            ),
            if (!showOnlyImage)
              Container(
                width: width,
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(
                    top: 10, left: 8, right: 8, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 10.0),
                    Text(
                      item.title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      item.date,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.5),
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
