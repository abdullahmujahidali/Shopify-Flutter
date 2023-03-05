import 'package:flutter/material.dart';

import '../../common/tools.dart';
import '../../models/index.dart' show Blog;
import '../../modules/dynamic_layout/index.dart';
import '../html/index.dart';

class BlogCard extends StatelessWidget {
  final Blog? item;
  final width;
  final margin;
  final kSize size;
  final height;
  final VoidCallback onTap;
  final BlogConfig? config;

  const BlogCard({
    this.item,
    this.width,
    this.size = kSize.medium,
    this.height,
    this.margin = 5.0,
    required this.onTap,
    this.config,
  });

  Widget getImageFeature(double imageWidth, {double? imageHeight}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        child: ImageResize(
          url: item!.imageFeature,
          width: imageWidth,
          height: height ?? imageHeight ?? width * 0.60,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget renderAuthor() {
    return Row(
      children: [
        const Icon(Icons.drive_file_rename_outline_outlined,
            color: Colors.white, size: 12),
        const SizedBox(width: 2),
        Text(
          item!.author,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = Tools.isTablet(MediaQuery.of(context));
    final blogConfig = config ?? BlogConfig.empty();
    var titleFontSize = isTablet ? 20.0 : 14.0;
    var maxWidth = width;
    if (blogConfig.cardDesign == BlogCardType.background) {
      titleFontSize = titleFontSize * maxWidth / 150;
      var isSmallSize = titleFontSize < 14.0;
      if (isSmallSize) titleFontSize = 14.0;

      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: blogConfig.hMargin,
          vertical: blogConfig.vMargin,
        ),
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: [
              getImageFeature(maxWidth, imageHeight: maxWidth),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                width: maxWidth,
                height: maxWidth,
              ),
              Container(
                width: maxWidth,
                height: maxWidth,
                padding: EdgeInsets.symmetric(
                    horizontal: isSmallSize ? 5.0 : 10.0,
                    vertical: isSmallSize ? 5.0 : 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      item!.title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    if (!isSmallSize) ...[
                      SizedBox(
                        height: 50,
                        child: HtmlWidget(
                          item!.subTitle,
                          textStyle: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item!.date,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        if (!isSmallSize) renderAuthor(),
                      ],
                    ),
                    if (isSmallSize) renderAuthor(),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: blogConfig.hMargin,
        vertical: blogConfig.vMargin,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          getImageFeature(maxWidth),
          Container(
            width: maxWidth,
            padding:
                const EdgeInsets.only(top: 10, left: 8, right: 8, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item!.title,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  item!.date,
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
