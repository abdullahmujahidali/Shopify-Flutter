import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../common/tools.dart';
import '../../models/entities/blog.dart';
import '../../modules/dynamic_layout/config/blog_config.dart';
import '../common/flux_image.dart';

class BlogGridItem extends StatelessWidget {
  final Blog blog;
  final VoidCallback onTap;
  final double radius;
  final double innerPadding;
  final Color background;
  final Color itemBackgroundColor;
  final BlogConfig config;

  const BlogGridItem({
    required this.blog,
    required this.onTap,
    this.radius = 0.0,
    this.innerPadding = 0.0,
    this.background = Colors.transparent,
    this.itemBackgroundColor = Colors.transparent,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    var offSet = 11.0;
    if (config.hideComment && config.hideAuthor && config.hideComment) {
      offSet -= 11.0;
    }
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: getValueForScreenType<double>(
          context: context,
          mobile: 90 + innerPadding + offSet,
          tablet: 120 + innerPadding + offSet,
          desktop: 180 + innerPadding + offSet,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: 6,
            left: context.isRtl ? 16 : 0,
            right: context.isRtl ? 0 : 16,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              color: itemBackgroundColor,
            ),
            padding: EdgeInsets.all(innerPadding),
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        radius * 0.7,
                      ),
                      child: FluxImage(
                        imageUrl: blog.imageFeature,
                        fit: BoxFit.fitWidth,
                        // isVideo: blog.videoUrl.isNotEmpty,
                      ),
                    ),
                  ),
                  SizedBox(width: innerPadding),
                  Expanded(
                    flex: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (!config.hideTitle)
                          Text(
                            blog.title,
                            maxLines: 2,
                          ),
                        const SizedBox(height: 10),
                        Wrap(
                          children: [
                            if (!config.hideDate && blog.date.isNotEmpty)
                              Text(
                                blog.date,
                                style: TextStyle(
                                  fontSize: 11,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            if (!config.hideAuthor && blog.author.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(
                                    left: config.hideDate ? 0 : 8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      CupertinoIcons.person_alt,
                                      size: 11,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary
                                          .withOpacity(0.5),
                                    ),
                                    const SizedBox(width: 2.0),
                                    Text(
                                      blog.author,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (!config.hideComment)
                              Padding(
                                padding: EdgeInsets.only(
                                    left: (config.hideAuthor && config.hideDate)
                                        ? 0
                                        : 8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      CupertinoIcons.chat_bubble_text_fill,
                                      size: 11,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary
                                          .withOpacity(0.5),
                                    ),
                                    const SizedBox(width: 2.0),
                                    Text(
                                      '${blog.commentCount}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
