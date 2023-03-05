import 'package:flutter/material.dart';
import 'package:html/parser.dart';

import '../../../../../common/constants.dart';
import '../../../../../common/tools/image_tools.dart';
import '../../../../../screens/blog/index.dart';

class PostView extends StatelessWidget {
  final List<Blog>? blogs;
  final int? index;
  final double? width;
  final String? type;
  final double? imageBorder;
  final String? locale;

  const PostView({
    this.blogs,
    this.index,
    this.width,
    this.type,
    this.imageBorder = 4,
    this.locale = 'en',
  });

  @override
  Widget build(BuildContext context) {
    var imageWidth = (width == null) ? 150.0 : width;
    var titleFontSize = imageWidth! / 10;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            RouteList.detailBlog,
            arguments: BlogDetailArguments(
              blog: blogs![index ?? 0],
              listBlog: blogs,
            ),
          );
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(imageBorder!),
                ),
                child: ImageResize(
                  url: blogs![index!].imageFeature,
                  width: imageWidth,
                  height: imageWidth,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      blogs![index!].title,
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: imageWidth / 35,
                    ),
                    Text(
                      blogs![index!].date,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    blogs![index!].excerpt == 'Loading...'
                        ? Text(blogs![index!].excerpt)
                        : Text(
                            parse(blogs![index!].excerpt).documentElement!.text,
                            maxLines: 3,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontSize: 13.0,
                                    height: 1.4,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                          ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
